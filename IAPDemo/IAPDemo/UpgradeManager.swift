//
//  UpgradeManager.swift
//  IAPDemo
//
//  Created by Hesham Abd-Elmegid on 8/18/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import Foundation
import StoreKit

class UpgradeManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let sharedInstance = UpgradeManager()
    let productIdentifier = "com.careerfoundry.randomquotes.rwong.randomfamousquotes"
    typealias SuccessHandler = (_ succeeded: Bool) -> (Void)
    var upgradeCompletionHandler: SuccessHandler?
    var restoreCompletionHandler: SuccessHandler?
    var priceCompletionHandler: ((_ price: Float) -> Void)?
    var famousQuotesProduct: SKProduct?
    let userDefaultsKey = "HasUpgradedUserDefaultsKey"

    func hasUpgraded() -> Bool {
        return false
    }
    
    func upgrade(_ success: @escaping SuccessHandler) {
        
    }
    
    func restorePurchases(_ success: @escaping SuccessHandler) {
        
    }
    
    func priceForUpgrade(_ success: @escaping (_ price: Float) -> Void) {
        success(0.0)
        priceCompletionHandler = success
        
        let identifiers: Set<String> = [productIdentifier]
        let request = SKProductsRequest(productIdentifiers: identifiers)
        request.delegate = self
        request.start()
    }
    
    // MARK: SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    // MARK: SKProductsRequestDelegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        famousQuotesProduct = response.products.first
        
        if let price = famousQuotesProduct?.price {
            priceCompletionHandler?(Float(truncating: price))
        }
    }
}
