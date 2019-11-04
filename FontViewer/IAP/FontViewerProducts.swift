//
//  FontViewerProducts.swift
//  FontViewer
//
//  Created by tunko on 2019/10/30.
//  Copyright © 2019 tunko. All rights reserved.
//

import Foundation

public struct FontViewerProducts {
    
    public static let SwiftShopping = "Donation"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [FontViewerProducts.SwiftShopping]
    
    public static let store = IAPHelper(productIds: FontViewerProducts.productIdentifiers)
    
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
