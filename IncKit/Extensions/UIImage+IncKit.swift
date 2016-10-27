//
//  UIImage+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Accelerate

public extension UIImage {
   public var correctlyOriented: UIImage? {
      guard imageOrientation != UIImageOrientation.up else { return self }
      
      UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
      
      self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
      let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return normalizedImage
   }
   
   public convenience init?(gradientColors colors: [UIColor], size: CGSize = CGSize(width: 1, height: 1)) {
      // start with a CAGradientLayer
      let gradientLayer = CAGradientLayer()
      gradientLayer.frame = CGRect(origin: .zero, size: size)
      
      // add colors as CGCologRef to a new array and calculate the distances
      var colorsRef : [CGColor] = []
      var locations : [NSNumber] = []
      
      for i in 0 ... colors.count-1 {
         colorsRef.append(colors[i].cgColor as CGColor)
         
         let floatValue = Float(i) / Float(colors.count)
         let number = NSNumber(floatLiteral: Double(floatValue))
         locations.append(number)
      }
      
      gradientLayer.colors = colorsRef
      gradientLayer.locations = locations
      
      // now build a UIImage from the gradient
      UIGraphicsBeginImageContext(gradientLayer.bounds.size)
      gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
      let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      // return the gradient image
      guard let cgImage = gradientImage?.cgImage else { return nil }
      self.init(cgImage: cgImage)
   }
   
   public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
      let rect = CGRect(origin: .zero, size: size)
      UIGraphicsBeginImageContextWithOptions(size, false, 0)
      
      color.setFill()
      UIRectFill(rect)
      
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      guard let cgImage = image?.cgImage else { return nil }
      self.init(cgImage: cgImage)
   }
	
	// MARK: - Effects
	public func applyTintEffectWithColor(tintColor: UIColor) -> UIImage? {
		let effectColorAlpha: CGFloat = 0.6
		var effectColor = tintColor
		
		let componentCount = tintColor.cgColor.numberOfComponents
		
		if componentCount == 2 {
			var b: CGFloat = 0
			if tintColor.getWhite(&b, alpha: nil) {
				effectColor = UIColor(white: b, alpha: effectColorAlpha)
			}
		} else {
			var red: CGFloat = 0
			var green: CGFloat = 0
			var blue: CGFloat = 0
			
			if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
				effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
			}
		}
		
		return applyBlur(withRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
	}
	
	public func applyBlur(withRadius radius: CGFloat, tintColor: UIColor? = nil, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
		// Check pre-conditions.
		if (size.width < 1 || size.height < 1) {
			print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
			return nil
		}
		if self.cgImage == nil {
			print("*** error: image must be backed by a CGImage: \(self)")
			return nil
		}
		if maskImage != nil && maskImage!.cgImage == nil {
			print("*** error: maskImage must be backed by a CGImage: \(maskImage)")
			return nil
		}
		
		let __FLT_EPSILON__ = CGFloat(FLT_EPSILON)
		let screenScale = UIScreen.main.scale
		let imageRect = CGRect(origin: CGPoint.zero, size: size)
		var effectImage = self
		
		let hasBlur = radius > __FLT_EPSILON__
		let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
		
		if hasBlur || hasSaturationChange {
			func createEffectBuffer(context: CGContext) -> vImage_Buffer {
				let data = context.data
				let width = vImagePixelCount(context.width)
				let height = vImagePixelCount(context.height)
				let rowBytes = context.bytesPerRow
				
				return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
			}
			
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			guard let effectInContext = UIGraphicsGetCurrentContext() else { return nil }
			
			effectInContext.scaleBy(x: 1.0, y: -1.0)
			effectInContext.translateBy(x: 0, y: -size.height)
			
			guard let cgImage = self.cgImage else { return nil }
			effectInContext.draw(cgImage, in: imageRect)
			
			var effectInBuffer = createEffectBuffer(context: effectInContext)
			
			
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			guard let effectOutContext = UIGraphicsGetCurrentContext() else { return nil }
			
			var effectOutBuffer = createEffectBuffer(context: effectOutContext)
			
			
			if hasBlur {
				// A description of how to compute the box kernel width from the Gaussian
				// radius (aka standard deviation) appears in the SVG spec:
				// http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
				//
				// For larger values of 's' (s >= 2.0), an approximation can be used: Three
				// successive box-blurs build a piece-wise quadratic convolution kernel, which
				// approximates the Gaussian kernel to within roughly 3%.
				//
				// let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
				//
				// ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
				//
				
				let inputRadius = radius * screenScale * 3.0
				var radius = UInt32(floor(inputRadius * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
				if radius % 2 != 1 {
					radius += 1 // force radius to be odd so that the three box-blur methodology works.
				}
				
				let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
				
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
			}
			
			var effectImageBuffersAreSwapped = false
			
			if hasSaturationChange {
				let s: CGFloat = saturationDeltaFactor
				let floatingPointSaturationMatrix: [CGFloat] = [
					0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
					0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
					0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
					0,                    0,                    0,  1
				]
				
				let divisor: CGFloat = 256
				let matrixSize = floatingPointSaturationMatrix.count
				var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
				
				for i: Int in 0 ..< matrixSize {
					saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
				}
				
				if hasBlur {
					vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
					effectImageBuffersAreSwapped = true
				} else {
					vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
				}
			}
			
			if !effectImageBuffersAreSwapped {
				guard let ei = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
				effectImage = ei
			}
			
			UIGraphicsEndImageContext()
			
			if effectImageBuffersAreSwapped {
				guard let ei = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
				effectImage = ei
			}
			
			UIGraphicsEndImageContext()
		}
		
		// Set up output context.
		UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
		guard let outputContext = UIGraphicsGetCurrentContext() else { return nil }
		outputContext.scaleBy(x: 1.0, y: -1.0)
		outputContext.translateBy(x: 0, y: -size.height)
		
		// Draw base image.
		guard let cgImage = cgImage else { return nil }
		outputContext.draw(cgImage, in: imageRect)
		
		// Draw effect image.
		if hasBlur {
			outputContext.saveGState()
			if let image = maskImage {
				guard let maskCGImage = image.cgImage else { return nil }
				outputContext.clip(to: imageRect, mask: maskCGImage)
			}
			
			guard let cgEffectImage = effectImage.cgImage else { return nil }
			outputContext.draw(cgEffectImage, in: imageRect)
			outputContext.restoreGState()
		}
		
		// Add in color tint.
		if let color = tintColor {
			outputContext.saveGState()
			outputContext.setFillColor(color.cgColor)
			outputContext.fill(imageRect)
			outputContext.restoreGState()
		}
		
		// Output image is ready.
		let outputImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return outputImage
	}
}
