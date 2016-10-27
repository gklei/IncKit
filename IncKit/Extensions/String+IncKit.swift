//
//  String+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension String {
	public var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let testCase = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return testCase.evaluate(with: self)
	}
	
	public var containsNumber: Bool {
		let numberRegEx = ".*[0-9]+.*"
		let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
		return testCase.evaluate(with: self)
	}
	
	public var isValidURL: Bool {
		guard let url = NSURL(string: self) else { return false }
		return UIApplication.shared.canOpenURL(url as URL)
	}
	
	public var trimmed: String {
		let whitespaceCharacters = NSCharacterSet.whitespacesAndNewlines
		return trimmingCharacters(in: whitespaceCharacters)
	}
	
	public func width(usingFont font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect,
		                                    options: .usesLineFragmentOrigin,
		                                    attributes: [NSFontAttributeName : font],
		                                    context: nil)
		return boundingBox.width
	}
}
