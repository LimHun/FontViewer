//
//  Toast.swift
//  FontViewer
//
//  Created by tunko on 2019/11/07.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum eToastPosition {
        case TOP
        case MIDDEL
        case BOTTOM
    }
    
    func showToast(message : String)
    {
        toast(message)
    }
    
    func showToast(message : String, fontName : String)
    {
        toast(message, fontName: fontName)
    }
    
    func showToast(message : String, fontName : String, fontSize : CGFloat)
    {
        toast(message, fontName: fontName, fontSize: fontSize)
    }
    
    private func toast(_ message : String, fontName : String = "", fontSize : CGFloat = 24, position : eToastPosition = .MIDDEL)
    {
        let font = UIFont(name: fontName, size: fontSize)
        let viewWidth : CGFloat = 320
        let viewHeight = message.heightWithConstrainedWidth(width: 320, font: font!) + 20
        
        var rect : CGRect = CGRect()
        switch position {
        case .TOP:
            rect = CGRect(x: (self.view.frame.size.width - viewWidth) / 2, y: 200, width: viewWidth, height: viewHeight)
            break
        case .MIDDEL:
            rect = CGRect(x: (self.view.frame.size.width - viewWidth) / 2, y: self.view.frame.size.height / 2, width: viewWidth, height: viewHeight)
            break
        case .BOTTOM:
            rect = CGRect(x: (self.view.frame.size.width - viewWidth) / 2, y: self.view.frame.size.height - 200, width: viewWidth, height: viewHeight)
            break
        }
        
        let toastLabel = UILabel(frame: rect)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = font
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

