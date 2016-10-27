//
//  ViewController.swift
//  IncKit
//
//  Created by gklei on 10/26/2016.
//  Copyright (c) 2016 gklei. All rights reserved.
//

import UIKit
import IncKit

class ViewController: UIViewController {
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      let alert = UIAlertController.accessDeniedAlert(reason: .photoLibrary)
      present(alert, animated: true, completion: nil)
      
      let color = UIColor(hexString: "#34dcf3")
      let color2 = UIColor(hexString: "523f2c")
      if let image = UIImage(gradientColors: [color, color2], size: view.bounds.size) {
         view.backgroundColor = UIColor(patternImage: image)
      }
   }
}

