//
//  AppInfoViewController.swift
//  FontViewer
//
//  Created by tunko on 2019/10/29.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit
import StoreKit

class AppInfoViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet var donationButton: UIView!
    
    let ProductID = "com.tunko.fontviewer.Sponsoring"
    let productIDs : [String] = ["com.tunko.fontviewer.SponsoringTest"]
      
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonView.layer.borderWidth = 0.5
        buttonView.layer.borderColor = UIColor.label.cgColor
        //donationButton.isHidden = true
        
        SKPaymentQueue.default().add(self)
    }
    
    @IBAction func actionDonation(_ sender: Any) {
        
        validate(productIdentifiers: productIDs)
        
//        if SKPaymentQueue.canMakePayments() {
//            let paymentRequest = SKMutablePayment()
//            paymentRequest.productIdentifier = ProductID
//            SKPaymentQueue.default().add(paymentRequest)
//        } else {
//            print("User unable to make payments")
//        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                // if item has beed purchased
                print("Transaction Successful")
            }
            else if transaction.transactionState == .failed {
                print("Transaction Failed")
            }
        }
    }
    
    var request: SKProductsRequest!
    
    func validate(productIdentifiers: [String]) {
         let productIdentifiers = Set(productIdentifiers)

         request = SKProductsRequest(productIdentifiers: productIdentifiers)
         request.delegate = self
         request.start()
    }

    var products = [SKProduct]()
    // SKProductsRequestDelegate protocol method.
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
           products = response.products
           // Custom method.
           //displayStore(products)
        }

        for invalidIdentifier in response.invalidProductIdentifiers {
           // Handle any invalid product identifiers as appropriate.
        }
    }
}

