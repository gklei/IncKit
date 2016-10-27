//
//  UIAlertController+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

extension Bundle {
   class func incKit_mainInfoDictionary(key: CFString) -> String? {
      return main.infoDictionary?[key as String] as? String
   }
   
   static var incKit_appDisplayName: String? {
      return incKit_mainInfoDictionary(key: kCFBundleNameKey)
   }
}

public extension UIAlertController {
   public enum AccessDeniedReason: String {
      case photoLibrary = "Photo Library"
      case microphone = "Microphone"
      case camera = "Camera"
   }
   
   public static func accessDeniedAlert(reason: AccessDeniedReason, message: String? = nil, cancelHandler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
      let appName = Bundle.incKit_appDisplayName ?? "this application"
      let alertController = UIAlertController(
         title: "\(appName) Needs \(reason.rawValue) Access",
         message: message ?? "Give \(appName) access by adjusting the permissions in the settings.",
         preferredStyle: .alert)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
      alertController.addAction(cancelAction)
      
      let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
         if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(url as URL)
         }
      }
      alertController.addAction(openAction)
      return alertController
   }
}
