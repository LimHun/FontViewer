//
//  AppInfoViewController.swift
//  FontViewer
//
//  Created by tunko on 2019/10/29.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit
import StoreKit

class AppInfoViewController: UIViewController, SKProductsRequestDelegate {
     
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet var donationButton: UIView!
    
    let ProductID = "com.tunko.fontviewer.Sponsoring"
    let productIDs : [String] = ["com.tunko.fontviewer.SponsoringTest"]
    
    let iapObserver = StoreObserver()
    var productRequest : SKProductsRequest?
    
    // 입력받은 상품 정보들을 저장하는 변수들
    var validProductArray = [SKProduct]()
      
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonView.layer.borderWidth = 0.5
        buttonView.layer.borderColor = UIColor.label.cgColor
        //donationButton.isHidden = true
        
        SKPaymentQueue.default().add(iapObserver)
        let pIDs = Set(["com.tunko.fontviewer.SponsoringTest"])
        productRequest = SKProductsRequest(productIdentifiers: pIDs)
        productRequest!.delegate = self
        
        productRequest!.start()
    }
    
    func canMakePayments()
    {
        if SKPaymentQueue.canMakePayments() {
            print("겔제 요청이 가능합니다.")
        } else {
            print("결제 요청이 불가능 합니다.")
        }
    }
    
    @IBAction func actionDonation(_ sender: Any)
    {
        canMakePayments()
        
        print("결제 요청")
        
        let payment = SKMutablePayment(product: validProductArray[0])
        SKPaymentQueue.default().add(payment)
        print("변화가 있나요?")
//        if SKPaymentQueue.canMakePayments() {
//            print("겔제 요청이 가능합니다.")
//            let paymentRequest = SKMutablePayment()
//            paymentRequest.productIdentifier = ProductID
//            SKPaymentQueue.default().add(paymentRequest)
//        } else {
//            print("결제 요청이 불가능 합니다.")
//        }
    }
    
    // 상품 정보를 받은 후 처리 메소드 입니다.
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("상품갯수 \(response.products.count)")
        print("확인하지 못한 상품 갯수 \(response.invalidProductIdentifiers.count)")
        
        for product in response.products {
            print("이름 : \(product.localizedTitle)\n가격:\(product.price)")
            validProductArray.append(product)
        }
    }
}

