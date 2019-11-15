//
//  StoreObserver.swift
//  FontViewer
//
//  Created by tunko on 2019/11/15.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit
import StoreKit

class StoreObserver: NSObject, SKPaymentTransactionObserver {
    
    var purchased = [SKPaymentTransaction]()
    
    // 생성자를 위한 초기화 함수
    override init() {
        super.init()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                
            // 결제가 진행중인 경우
            case .purchasing:
                print("결제가 진행되고 있습니다.")
                break
            // 결제 창을 띄우는 데 실패한 경우
            case .deferred:
                print("아이폰이 잠기는 등의 이유로 결제 창을 띄우지 못했습니다.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            // 결제를 성공한 경우
            case .purchased:
                print("결제를 성공했습니다.")
                handlePurchased(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            // 결제를 실패한 경우
            case .failed:
                print("결제를 실패했습니다.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            // 결제를 검증을 하였습니다.
            case .restored:
                print("상품 검증을 했습니다.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            default:
                print("알 수 없는 오류가 발생되었습니다.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            }
        }
    }
    
    func handlePurchased(_ transaction : SKPaymentTransaction) {
        
        purchased.append(transaction)
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    
        print("영수증 주소 : \(Bundle.main.appStoreReceiptURL)")
        
        let receiptData = NSData(contentsOf: Bundle.main.appStoreReceiptURL!)
        
        print(receiptData)
        
        let receiptString = receiptData!.base64EncodedString(options: NSData.Base64EncodingOptions())
        
        print("구매 성공 트랜젝션 아이디 : \(transaction.transactionIdentifier!)")
        print("상품 아이디 : \(transaction.payment.productIdentifier)")
        print("구매 영수증 : \(receiptString)")
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }

}
