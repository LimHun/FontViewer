//
//  SingleLabelViewController.swift
//  FontViewer
//
//  Created by tunko on 2019/10/25.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit
import FlexColorPicker

class SingleLabelViewController: UIViewController {

    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var naviLabelSize: UILabel!
    @IBOutlet weak var textField: UITextField!
   
    let initMessage : String = "뭐가좋을지몰라서다넣어봤어^ㅡ^"
    var fontName : String = ""
    var fontSize : CGFloat = 0
    var fontContent : String = ""
    var foutColor : UIColor = UIColor()
    
    var location = CGPoint(x: 0, y: 0)
    
    let picker = UIImagePickerController()
    
    var pickedColor = #colorLiteral(red: 0.6813090444, green: 0.253660053, blue: 1, alpha: 1)
    
    enum curserMode {
        case left
        case center
        case right
    }
    
    var photoColor : [UIColor] = []
    
    var cMode : curserMode = .left
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        hideKeyboardWhenTappedAround()
        
        // 뒤로가기 버튼 문구 수정
        self.navigationController?.navigationBar.topItem?.title = ""
        
        // 네비게이션 투명
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        selectLabel.font = UIFont(name: fontName, size: fontSize)
        selectLabel.text = fontContent
        selectLabel.sizeToFit()
        selectLabel.layoutIfNeeded()
        
        picker.delegate = self
        
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 400
        stepper.minimumValue = 8
        stepper.value = Double(fontSize)
        
        let x : Float = Float(fontSize)
        let y : Int = Int(x)
        let z : String = String(y)
        naviLabelSize.text = z
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        selectLabel.text = textField.text!
        selectLabel.sizeToFit()
        selectLabel.layoutIfNeeded()
    }
    
    @IBAction func actionGetPhoto(_ sender: Any) {
        
        let alert =  UIAlertController(title: "글자가 들어갈 사진을 골라주세요 ^ㅡ^", message: "잘골라요!", preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionPhotoClear(_ sender: Any) {
        backGround.image = nil
        //photoColor.removeAll()
    }
    
    @IBAction func actionSegmented(_ sender: Any) {
        if let segcon = sender as? UISegmentedControl {
            switch segcon.selectedSegmentIndex {
            case 0:
                cMode = .left
                break
            case 1:
                cMode = .center
                break
            case 2:
                cMode = .right
                break
            default:
                break
            }
        }
    }
    
    @IBAction func actionStepperValueChanged(_ sender: UIStepper) {
        print("sender\(sender.value)")
        let size = CGFloat(sender.value)
        
        selectLabel.font = UIFont(name: fontName, size: size)
        selectLabel.sizeToFit()
        selectLabel.layoutIfNeeded()
        
        let x : Float = Float(size)
        let y : Int = Int(x)
        let z : String = String(y)
        
        naviLabelSize.text = z
        
    }
    
    @IBAction func actionInit(_ sender: Any) {
        selectLabel.text = initMessage
        selectLabel.sizeToFit()
        selectLabel.layoutIfNeeded()
        textField.text = ""
    }
    
    func getTouchPos(_ location : CGPoint) -> CGPoint
    {
        if cMode == .left
        {
            return CGPoint(x: location.x + selectLabel.frame.width / 2, y: location.y)
        }
        else if cMode == .right
        {
            return CGPoint(x: location.x - selectLabel.frame.width / 2, y: location.y)
        }
        else
        {
            return location
        }
    }
        
    /*
    
     heading title2
     =
    */
    var labelGap : CGPoint = CGPoint()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if let touch = touches.first {
            print("\(touch)")
            let touchLocation = touch.location(in: self.view)
            
            labelGap = CGPoint(x: selectLabel.center.x - touchLocation.x, y: selectLabel.center.y - touchLocation.y)
            
            //selectLabel.center = getTouchPos(touchLocation)
        }
        super.touchesBegan(touches, with: event)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let touch = touches.first{
            print("\(touch)")
            let touchLocation = touch.location(in: self.view)
            
            selectLabel.center = CGPoint(x: touchLocation.x + labelGap.x, y: touchLocation.y + labelGap.y)

        }
        super.touchesMoved(touches, with: event)
    }
     
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            print("\(touch)")
        }
        super.touchesEnded(touches, with: event)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        if let touch = touches.first {
//            print("\(touch)")
//            let touchLocation = touch.location(in: self.view)
//            selectLabel.center = getTouchPos(touchLocation)
//        }
//        super.touchesBegan(touches, with: event)
//
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//       if let touch = touches.first{
//            print("\(touch)")
//            let touchLocation = touch.location(in: self.view)
//            selectLabel.center = getTouchPos(touchLocation)
//        }
//        super.touchesMoved(touches, with: event)
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first{
//            print("\(touch)")
//            let touchLocation = touch.location(in: self.view)
//            selectLabel.center = getTouchPos(touchLocation)
//        }
//        super.touchesEnded(touches, with: event)
//    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled")
    }
    
    @IBAction func actionColor(_ sender: Any) {
        let colorPickerController = DefaultColorPickerViewController()
        colorPickerController.delegate = self
        navigationController?.pushViewController(colorPickerController, animated: true)
    }
}

extension SingleLabelViewController: ColorPickerDelegate {

    func colorPicker(_: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
        self.pickedColor = selectedColor
        selectLabel.textColor = self.pickedColor
//        pickerColorPreview.backgroundColor = selectedColor
    }

    func colorPicker(_: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl) {
        navigationController?.popViewController(animated: true)
    }
}


extension SingleLabelViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func openLibrary()
    {
        picker.sourceType = .photoLibrary

        present(picker, animated: false, completion: nil)

    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
       
        if let image = info[.originalImage] as? UIImage {
            backGround.image = image
        }
        self.picker.dismiss(animated: true, completion: nil)
    } 
}
