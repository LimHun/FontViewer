//
//  AppInfoViewController.swift
//  FontViewer
//
//  Created by tunko on 2019/10/29.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {

    @IBOutlet weak var buttonView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonView.layer.borderWidth = 0.5
        buttonView.layer.borderColor = UIColor.label.cgColor
        
    }
    
    @IBAction func actionDonation(_ sender: Any) {
        FontViewerProducts.store.restorePurchases()
    }
}
