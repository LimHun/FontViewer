//
//  CustomSlider.swift
//  FontViewer
//
//  Created by tunko on 2020/01/12.
//  Copyright © 2020 tunko. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
 
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 10))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}
