//
//  AlertBox.swift
//  CheapMessengerAppV1
//
//  Created by Robert Wong on 9/30/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import Foundation
import UIKit

class AlertBox {
    
    struct alertBoxProperties {
        static let applicationName = "Messenger"
        static let applicationDismiss = "Ok"
    }
//    var applicationName: String = "Messenger"
//    var option: String = "Ok"
    
    class func sendAlert(boxMessage: String, presentingController: UIViewController) {
        let alertController = UIAlertController(title: alertBoxProperties.applicationName, message: boxMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alertBoxProperties.applicationDismiss, style: .default, handler: nil))
        presentingController.present(alertController, animated: true, completion: nil)
    }
}


//class AlertViews {
//    struct Properties {
//        static let applicationName = "Chatterbox"
//        static let dismissButton = "Dismiss"
//    }
//
//    class func showAlert(message: String, on presentingController: UIViewController) {
//        let alertController = UIAlertController(title: Properties.applicationName,
//                                                message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: Properties.dismissButton,
//                                                style: .default, handler: nil))
//        presentingController.present(alertController, animated: true, completion: nil)
//    }
//
//}

