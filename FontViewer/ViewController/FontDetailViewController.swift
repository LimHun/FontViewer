//
//  FontDetailViewController.swift
//  FontViewer
//
//  Created by tunko on 2019/10/22.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit

class FontDetailViewController: UIViewController {
 
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var fontLabels : [UILabel] = []
    @IBOutlet weak var fontScale: UISegmentedControl!
    
    var fontName : String = ""
    
    var fontScaleValue : Int = 4
    
    var addStringCount : Int = 0
    var subStringCount : Int = 0
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
         
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        fontScale.addTarget(self, action: #selector(segconChanged(segcon:)), for: UIControl.Event.valueChanged)
 
        initLabel()
        
        self.navigationController?.navigationBar.topItem?.title = fontName
 
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        editLabel(text: textField.text!)
    }
    
    func initLabel()
    {
        var index : Int = 1
        for label in fontLabels
        {
            let size = CGFloat(8 + fontScaleValue * index)
            label.font = UIFont(name: fontName, size: size)
            index = index + 1
            label.text = "\(size):Text"
        }
    }
    
    func editLabel(text : String)
    {
        var index : Int = 1
        for label in fontLabels
        {
            let size = CGFloat(8 + fontScaleValue * index)
            label.font = UIFont(name: fontName, size: size)
            index = index + 1
            label.text = text
        }
    }
    
    func addIndexEditLabel()
    {
        var index : Int = 1
        for label in fontLabels
        {
            let size = CGFloat(8 + fontScaleValue * index)
            label.font = UIFont(name: fontName, size: size)
            index = index + 1
            label.text = "\(size):\(textField.text!)"
        }
    }
    
    @IBAction func actioninit(_ sender: Any) {
        initLabel()
        textField.text = ""
    }
    
    @IBAction func actionAddIndex(_ sender: Any) {
        addIndexEditLabel()
    }
    
    @objc func segconChanged(segcon: UISegmentedControl) {
        switch segcon.selectedSegmentIndex {
        case 0:
            print("x4")
            fontScaleValue = 4
            break
        case 1:
            print("x6")
            fontScaleValue = 6
            break
        default:
            break
        }
        
        initLabel()
    }
}

extension FontDetailViewController
{
    
}
