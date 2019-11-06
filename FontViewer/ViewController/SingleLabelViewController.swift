//
//  SingleLabelViewController.swift
//  FontViewer
//
//  Created by tunko on 2019/10/25.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit
import FlexColorPicker
import AssetsLibrary
import UIKit
import Photos

class SingleLabelViewController: UIViewController {

    @IBOutlet var selectLabel: UILabel!
    @IBOutlet var backGround: UIImageView!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var naviLabelSize: UILabel!
    @IBOutlet var initButton: UIButton!
    @IBOutlet var editTextView: UITextView!
    @IBOutlet var editingViewHeight: NSLayoutConstraint!
    @IBOutlet var inputViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet var slider: UISlider!
    @IBOutlet var labelWidth: UILabel!
    @IBOutlet var buttonHidden: UIBarButtonItem!
    
    @IBOutlet var viewBox : [UIView] = []
    
    let initMessage : String = "뭐가좋을지몰라서다넣어봤어^ㅡ^"
    var fontName : String = ""
    var fontSize : CGFloat = 0
    var fontContent : String = ""
    var foutColor : UIColor = UIColor()
    var width : CGFloat = 0
    
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
        editTextView.delegate = self
        
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 400
        stepper.minimumValue = 8
        stepper.value = Double(fontSize)
        
        let x : Float = Float(fontSize)
        let y : Int = Int(x)
        let z : String = String(y)
        naviLabelSize.text = z
         
        initButton.layer.masksToBounds = true
        initButton.layer.cornerRadius = 5
        
        slider.value = slider.maximumValue
        labelWidth.text = String(Int(slider.maximumValue))
        width = CGFloat(slider.maximumValue)
        
        setkeyboard()
    }
    
    func setkeyboard()
    {
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification,
                                             object: nil)
    }
    
    // Keyboard hide
    @objc func keyboardWillHide(_ notification: Notification)
    {
        handleKeyboardIssue(notification: notification, isAppearing: false)
        
        inputViewBottomAnchor.constant = 0
    }
    
    // Keyboard show
    @objc func keyboardWillShow(_ notification: Notification)
    {
        handleKeyboardIssue(notification: notification, isAppearing: true)
    }
    
    fileprivate func handleKeyboardIssue(notification: Notification, isAppearing: Bool)
    {
        guard let userInfo = notification.userInfo as? [String:Any] else {return}
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        guard let keyboardShowAnimateDuartion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        let heightConstant = isAppearing ? keyboardHeight : 0
        inputViewBottomAnchor.constant = heightConstant - 35
        UIView.animate(withDuration: keyboardShowAnimateDuartion.doubleValue)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        selectLabel.text = textField.text!
        selectLabel.sizeToFit()
        selectLabel.layoutIfNeeded()
    }
     
    @IBAction func actionCapture(_ sender: Any) {
        
        let image = captureScreen()
        let a : PHPhotoLibrary = PHPhotoLibrary()
        a.savePhoto(image: image!, albumName: "FontViewer")
    }
    
    func captureScreen() -> UIImage? {
        guard let context = UIGraphicsGetCurrentContext() else { return .none }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @IBAction func actionOnOff(_ sender: Any) {
        
        if buttonHidden.title!.elementsEqual(" ON ")
        {
            for view in viewBox {
                view.isHidden = true
            }
            buttonHidden.title = "OFF"
        }
        else
        {
            for view in viewBox {
                view.isHidden = false
            }
            buttonHidden.title = " ON "
        }
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
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        let value = (sender as! UISlider).value
        let iValue = Int(value)
        labelWidth.text = String(iValue)
        
        width = CGFloat(iValue)
        selectLabel.frame.size.width = width
        selectLabel.sizeToFit()
        selectLabel.layoutIfNeeded()
    }
    
    @IBAction func actionPhotoClear(_ sender: Any) {
        backGround.image = nil
        //photoColor.removeAll()
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
         
    var labelGap : CGPoint = CGPoint()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if let touch = touches.first {
            print("\(touch)")
            let touchLocation = touch.location(in: self.view)
            
            labelGap = CGPoint(x: selectLabel.center.x - touchLocation.x, y: selectLabel.center.y - touchLocation.y)
             
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

extension SingleLabelViewController : UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if textView.text.count > 249
        {
            return false
        }
        
        textViewDidChange(textView)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        setInputBoxButton(textView)
        
        self.selectLabel.text = textView.text
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        var height = newSize.height
        if height < 40 {
            height = 40
        }
        
        editingViewHeight.constant = height
        self.selectLabel.frame.size.width = 320
        self.selectLabel.frame.size.height = selectLabel.text!.heightWithConstrainedWidth(width: 320, font: selectLabel.font)
         
    }
    
    func setInputBoxButton(_ textView: UITextView)
    {
        
    }
}

