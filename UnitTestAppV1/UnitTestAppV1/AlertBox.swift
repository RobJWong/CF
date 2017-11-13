//
//  AlertBox.swift
//  UnitTestAppV1
//
//  Created by Robert Wong on 11/4/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import Foundation
import UIKit

class AlertBox {
    
    struct alertBoxProperties {
        static let applicationName = "Alert"
        static let applicationDismiss = "Ok"
    }
    
    class func sendAlert(boxMessage: String, presentingController: UIViewController) {
        let alertController = UIAlertController(title: alertBoxProperties.applicationName, message: boxMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alertBoxProperties.applicationDismiss, style: .default, handler: nil))
        presentingController.present(alertController, animated: true, completion: nil)
    }
}
