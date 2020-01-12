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

    @IBOutlet var textFieldBox: UIView!
    @IBOutlet var buttons : [UIButton] = []
    @IBOutlet var sliderValue: UILabel!
    @IBOutlet var menuSlider: UISlider!
    @IBOutlet var backGround: UIImageView!
    @IBOutlet var selectLabel: UILabel!
    @IBOutlet var inputViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet var editingViewHeight: NSLayoutConstraint!
    
    let picker = UIImagePickerController()
    let initMessage : String = "Hello. 안녕하세요^ㅡ^"
    var fontName : String = ""
    var fontSize : CGFloat = 0
    var fontContent : String = ""
    var foutColor : UIColor = UIColor()
    var width : CGFloat = 420
    var lineSpacing : CGFloat = 0
    var paragraph : Double = 0
    var location = CGPoint(x: 0, y: 0)
    let posX_gap : CGFloat = 50
    var pickedColor = #colorLiteral(red: 0.6813090444, green: 0.253660053, blue: 1, alpha: 1)
    
    var selectBtnIndex = -1
    
    struct sMenuButton {
        let imageOn : String
        let imageOff : String
        var state : Bool
        var button : UIButton?
    }
    
    var menus : [sMenuButton] = [
        sMenuButton(imageOn: "Screenshot", imageOff: "Screenshot", state : false),
        sMenuButton(imageOn: "IImage", imageOff: "IImage", state : false),
        sMenuButton(imageOn: "ImageOff", imageOff: "ImageOn", state : false),
        sMenuButton(imageOn: "Color", imageOff: "Color", state : false),
        sMenuButton(imageOn: "WidthActive", imageOff: "Width", state : false),
        sMenuButton(imageOn: "KerningActive", imageOff: "Kerning", state : false),
        sMenuButton(imageOn: "LineHeightActive", imageOff: "LineHeight", state : false),
        sMenuButton(imageOn: "FontSizeActive", imageOff: "FontSize", state : false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        showSlider(hidden: true)
        setkeyboard()
        setSelectLabel(initMessage)
    }
    
    func setUI()
    {
        for (index, btn) in buttons.enumerated() {
            menus[index].button = btn
            menus[index].button?.tag = index
            menus[index].button?.setImage(UIImage(named: menus[index].imageOff), for: .normal)
        }
        
        textFieldBox.layer.masksToBounds = true
        textFieldBox.layer.cornerRadius = 5
        
        menuSlider.setThumbImage(UIImage(), for: .normal)
        menuSlider.maximumTrackTintColor = UIColor(named: "Color/TextFieldPlaceHolder")
        menuSlider.minimumTrackTintColor = UIColor(named: "Color/TextFieldBackground")
        
        picker.delegate = self
        
        setSliderOption(min: 0, max: 10)
        
        // 뒤로가기 버튼 문구 수정
        self.navigationController?.navigationBar.topItem?.title = ""
        
        // 네비게이션 투명
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
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
    
    func showSlider(hidden : Bool) {
        
        menuSlider.isHidden = hidden
        sliderValue.isHidden = hidden
    }
    
    func setSliderOption(min : Float, max : Float) {
        
        menuSlider.minimumValue = min
        menuSlider.maximumValue = max
        menuSlider.value = Float((min + max) / 2)
        sliderValue.text = String(menuSlider.value)
    }
    
    @IBAction func actionUIBlind(_ sender: Any) {
    }
    
    @IBAction func actionLabelList(_ sender: Any) {
        self.performSegue(withIdentifier: "FontDetailTableViewController", sender: self)
    }
    
    @IBAction func change(_ sender: Any) {
        guard let slider = sender as? UISlider else {
            return
        }
        
        sliderValue.text = getSignificantDigits(value: slider.value, digit: 2)
        print("selectBtnIndex : \(selectBtnIndex)")
        if selectBtnIndex == 4 {
            let value = (sender as! UISlider).value
            let iValue = Int(value)

            width = CGFloat(iValue)
            self.selectLabel.frame.size.width = width
            self.selectLabel.frame.size.height = 700
            self.selectLabel.center = CGPoint(x: self.selectLabel.center.x, y: UIScreen.main.bounds.height/2)
        }
       
        if selectBtnIndex == 5 {
            let value = (sender as! UISlider).value
            paragraph = Double(value)

            selectLabel.setAttributeString(lineSpacing: lineSpacing, lineHeightMultiple: lineSpacing, kernValue: paragraph)
            self.selectLabel.frame.size.width = width
            self.selectLabel.frame.size.height = 700
            self.selectLabel.center = CGPoint(x: UIScreen.main.bounds.width/2 + posX_gap, y: UIScreen.main.bounds.height/2)
        }
       
        if selectBtnIndex == 6 {
            let value = (sender as! UISlider).value
            lineSpacing = CGFloat(value)
            selectLabel.setAttributeString(lineSpacing: 0, lineHeightMultiple: lineSpacing, kernValue: paragraph)
            self.selectLabel.frame.size.width = width
            self.selectLabel.frame.size.height = 700
            self.selectLabel.center = CGPoint(x: UIScreen.main.bounds.width/2 + posX_gap, y: UIScreen.main.bounds.height/2)
        }
       
        if selectBtnIndex == 7 {
            let value = (sender as! UISlider).value
            selectLabel.font = UIFont(name: fontName, size: CGFloat(value))
            selectLabel.setAttributeString(lineSpacing: 0, lineHeightMultiple: lineSpacing, kernValue: paragraph)
            self.selectLabel.frame.size.width = width
            self.selectLabel.frame.size.height = 700
            self.selectLabel.center = CGPoint(x: UIScreen.main.bounds.width/2 + posX_gap, y: UIScreen.main.bounds.height/2)
        }
    }
    
    // 자리수 자르기
    func getSignificantDigits(value : Float, digit : Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .floor         // 형식을 버림으로 지정
        numberFormatter.minimumSignificantDigits = digit  // 자르길 원하는 자릿수
        numberFormatter.maximumSignificantDigits = digit
        let newNum = numberFormatter.string(from: NSNumber(value: value)) // result 1.67
        return newNum!
    }
    
    func setMenuState(menuIndex : Int) {
        for (index, btn) in buttons.enumerated() {
            btn.setImage(UIImage(named: menus[index].imageOff), for: .normal)
            menus[index].state = false
            
            if index == menuIndex {
                btn.setImage(UIImage(named: menus[index].imageOn), for: .normal)
                menus[index].state = true
            }
        }
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        
        guard let btn = sender as? UIButton else {
            return
        }
                
        switch btn.tag {
        case 0:
            setMenuState(menuIndex: btn.tag)
            showSlider(hidden: true)
            
            let image = self.view.asImage()
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            break
        case 1:
            setMenuState(menuIndex: btn.tag)
            showSlider(hidden: true)
            openLibrary()
            break
        case 2:
            if backGround.image != nil {
                setMenuState(menuIndex: btn.tag)
                showSlider(hidden: true)
                backGround.isHidden = !backGround.isHidden
            } else {
                backGround.isHidden = !backGround.isHidden
            }
            break
        case 3:
            setMenuState(menuIndex: btn.tag)
            showSlider(hidden: true)
            
            let colorPickerController = DefaultColorPickerViewController()
            colorPickerController.delegate = self
            navigationController?.pushViewController(colorPickerController, animated: true)
            break
        case 4:
            setMenuState(menuIndex: btn.tag)
            showSlider(hidden: false)
            setSliderOption(min: 0, max: 400)
            break
        case 5:
            setMenuState(menuIndex: btn.tag)
            showSlider(hidden: false)
            setSliderOption(min: 0, max: 10)
            break
        case 6: // 행간
            setMenuState(menuIndex: btn.tag)
            showSlider(hidden: false)
            setSliderOption(min: 0.0001, max: 3)
            break
        case 7: // 글자 크기
            setMenuState(menuIndex: btn.tag)
            showSlider(hidden: false)
            setSliderOption(min: 8, max: 80)
            break
        default:
            break
        }
        
        selectBtnIndex = btn.tag
        print("btn tag : \(btn.tag)")
    }
    
    func setSelectLabel(_ text : String)
    {
        selectLabel.text = text
        selectLabel.font = UIFont(name: fontName, size: 12)
        selectLabel.setAttributeString(lineSpacing: lineSpacing, lineHeightMultiple: lineSpacing, kernValue: paragraph)
        selectLabel.frame.size.width = width
        selectLabel.frame.size.height = selectLabel.text!.heightWithConstrainedWidth(width: width, font: selectLabel.font)
        selectLabel.center = CGPoint(x: UIScreen.main.bounds.width/2 + posX_gap, y: UIScreen.main.bounds.height/2)
//        lineSpacingSlider.value = 0
//        lineSpacingLabel.text = "0"
//
//        paragraphSlider.value = 0
//        paragraphLabel.text = "0"

        width = 420
        lineSpacing = 0
        paragraph = 0
    }
    
    func getTouchPos(_ location : CGPoint) -> CGPoint
    {
        return location
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

        setSelectLabel(textView.text)

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
    }

    func setInputBoxButton(_ textView: UITextView)
    {

    }
    
    func captureScreen() -> UIImage? {
        guard let context = UIGraphicsGetCurrentContext() else { return .none }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {

        if error != nil {
            showToast(message: "다시 시도해주세요.", fontName: self.fontName)
        } else {
            showToast(message: "스크린샷이 저장되었습니다.", fontName: self.fontName)
        }
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

//
//    @IBOutlet var selectLabel: UILabel!
//    @IBOutlet var backGround: UIImageView!
//    @IBOutlet var stepper: UIStepper!
//    @IBOutlet var naviLabelSize: UILabel!
//    @IBOutlet var initButton: UIButton!
//    @IBOutlet var editTextView: UITextView!
//    @IBOutlet var editingViewHeight: NSLayoutConstraint!
//    @IBOutlet var inputViewBottomAnchor: NSLayoutConstraint!
//    @IBOutlet var slider: UISlider!
//    @IBOutlet var labelWidth: UILabel!
//    @IBOutlet var buttonHidden: UIBarButtonItem!
//    @IBOutlet var lineSpacingSlider: UISlider!
//    @IBOutlet var paragraphSlider: UISlider!
//    @IBOutlet var paragraphLabel: UILabel!
//    @IBOutlet var lineSpacingLabel: UILabel!
//
//    @IBOutlet var viewBox : [UIView] = []
//
//    let initMessage : String = "Hello. 안녕하세요^ㅡ^"
//    var fontName : String = ""
//    var fontSize : CGFloat = 0
//    var fontContent : String = ""
//    var foutColor : UIColor = UIColor()
//    var width : CGFloat = 420
//    var lineSpacing : CGFloat = 0
//    var paragraph : Double = 0
//
//    var location = CGPoint(x: 0, y: 0)
//
//    let posX_gap : CGFloat = 50
//
//    let picker = UIImagePickerController()
//
//    var pickedColor = #colorLiteral(red: 0.6813090444, green: 0.253660053, blue: 1, alpha: 1)
//
//    enum curserMode {
//        case left
//        case center
//        case right
//    }
//
//    var photoColor : [UIColor] = []
//
//    var cMode : curserMode = .left
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        hideKeyboardWhenTappedAround()
//
//        // 뒤로가기 버튼 문구 수정
//        self.navigationController?.navigationBar.topItem?.title = ""
//
//        // 네비게이션 투명
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController!.navigationBar.shadowImage = UIImage()
//        self.navigationController!.navigationBar.isTranslucent = true
//
//        selectLabel.font = UIFont(name: fontName, size: fontSize)
//        setSelectLabel(fontContent)
//
//        picker.delegate = self
//        editTextView.delegate = self
//
//        stepper.wraps = true
//        stepper.autorepeat = true
//        stepper.maximumValue = 400
//        stepper.minimumValue = 8
//        stepper.value = Double(fontSize)
//
//        let x : Float = Float(fontSize)
//        let y : Int = Int(x)
//        let z : String = String(y)
//        naviLabelSize.text = z
//
//        initButton.layer.masksToBounds = true
//        initButton.layer.cornerRadius = 5
//
//        slider.value = slider.maximumValue
//        labelWidth.text = String(Int(slider.maximumValue))
//        width = CGFloat(slider.maximumValue)
//
//        setLineSpacingSlider(fontSize)
//
//        setkeyboard()
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let fontDetailTableViewController = segue.destination as? FontDetailTableViewController {
//            fontDetailTableViewController.fontName = fontName
//        }
//    }
//
//    func setkeyboard()
//    {
//        self.hideKeyboardWhenTappedAround()
//
//        NotificationCenter.default.addObserver(self, selector:
//            #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification,
//                                             object: nil)
//        NotificationCenter.default.addObserver(self, selector:
//            #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification,
//                                             object: nil)
//    }
//
//    // Keyboard hide
//    @objc func keyboardWillHide(_ notification: Notification)
//    {
//        handleKeyboardIssue(notification: notification, isAppearing: false)
//
//        inputViewBottomAnchor.constant = 0
//    }
//
//    // Keyboard show
//    @objc func keyboardWillShow(_ notification: Notification)
//    {
//        handleKeyboardIssue(notification: notification, isAppearing: true)
//    }
//
//    fileprivate func handleKeyboardIssue(notification: Notification, isAppearing: Bool)
//    {
//        guard let userInfo = notification.userInfo as? [String:Any] else {return}
//        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
//        guard let keyboardShowAnimateDuartion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
//        let keyboardHeight = keyboardFrame.cgRectValue.height
//
//        let heightConstant = isAppearing ? keyboardHeight : 0
//        inputViewBottomAnchor.constant = heightConstant - 35
//        UIView.animate(withDuration: keyboardShowAnimateDuartion.doubleValue)
//        {
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    @objc func textFieldDidChange(_ textField: UITextField)
//    {
//        setSelectLabel(textField.text!)
//    }
//
//    func setSelectLabel(_ text : String)
//    {
//        selectLabel.text = text
//        selectLabel.setAttributeString(lineSpacing: lineSpacing, lineHeightMultiple: lineSpacing, kernValue: paragraph)
//        selectLabel.frame.size.width = width
//        selectLabel.frame.size.height = selectLabel.text!.heightWithConstrainedWidth(width: width, font: selectLabel.font)
//        selectLabel.center = CGPoint(x: UIScreen.main.bounds.width/2 + posX_gap, y: UIScreen.main.bounds.height/2)
//
//        lineSpacingSlider.value = 0
//        lineSpacingLabel.text = "0"
//
//        paragraphSlider.value = 0
//        paragraphLabel.text = "0"
//
//        width = 420
//        lineSpacing = 0
//        paragraph = 0
//    }
//
//    @IBAction func actionGoSizeList(_ sender: Any) {
//
//        self.performSegue(withIdentifier: "FontDetailTableViewController", sender: self)
//    }
//
//    @IBAction func actionCapture(_ sender: Any) {
//
//        let image = self.view.asImage()
//        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
//
//    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
//
//        if error != nil {
//            showToast(message: "다시 시도해주세요.", fontName: self.fontName)
//        } else {
//            showToast(message: "스크린샷이 저장되었습니다.", fontName: self.fontName)
//        }
//    }
//
//    func captureScreen() -> UIImage? {
//        guard let context = UIGraphicsGetCurrentContext() else { return .none }
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
//        view.layer.render(in: context)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//
//    // 행간 슬라이더 초기화
//    func setLineSpacingSlider(_ value : CGFloat)
//    {
//        lineSpacingSlider.minimumValue = 0.0001 // Float(value)
//        lineSpacingSlider.maximumValue = 3//Float(value * 1.5)
//        lineSpacingSlider.value = Float(value)
//        lineSpacingLabel.text = String(lineSpacingSlider.value)
//    }
//
//    @IBAction func actionOnOff(_ sender: Any) {
//
//        if buttonHidden.title!.elementsEqual(" ON ")
//        {
//            for view in viewBox {
//                view.isHidden = true
//            }
//            buttonHidden.title = "OFF"
//        }
//        else
//        {
//            for view in viewBox {
//                view.isHidden = false
//            }
//            buttonHidden.title = " ON "
//        }
//    }
//
//    @IBAction func actionGetPhoto(_ sender: Any) {
//
//        let alert =  UIAlertController(title: "글자가 들어갈 사진을 골라주세요 ^ㅡ^", message: "잘골라요!", preferredStyle: .actionSheet)
//
//        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
//            self.openLibrary()
//        }
//
//        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//
//        alert.addAction(library)
//        alert.addAction(cancel)
//
//        present(alert, animated: true, completion: nil)
//    }
//
//    @IBAction func sliderValueChanged(_ sender: Any) {
//        let value = (sender as! UISlider).value
//        let iValue = Int(value)
//        labelWidth.text = String(iValue)
//
//        width = CGFloat(iValue)
//        self.selectLabel.frame.size.width = width
//        self.selectLabel.frame.size.height = 700
//        self.selectLabel.center = CGPoint(x: self.selectLabel.center.x, y: UIScreen.main.bounds.height/2)
//    }
//
//    @IBAction func actionPhotoClear(_ sender: Any) {
//        backGround.image = nil
//    }
//
//    // 행간
//    @IBAction func actionLineSpacing(_ sender: Any) {
//        let value = (sender as! UISlider).value
//        lineSpacing = CGFloat(value)
//        lineSpacingLabel.text = String(value)
//
//        selectLabel.setAttributeString(lineSpacing: 0, lineHeightMultiple: lineSpacing, kernValue: paragraph)
//
//        self.selectLabel.frame.size.height = 700
//        self.selectLabel.center = CGPoint(x: UIScreen.main.bounds.width/2 + posX_gap, y: UIScreen.main.bounds.height/2)
//    }
//
//    // 자간
//    @IBAction func actionParagraph(_ sender: Any) {
//        let value = (sender as! UISlider).value
//        paragraph = Double(value)
//        paragraphLabel.text = String(value)
//
//        selectLabel.setAttributeString(lineSpacing: lineSpacing, lineHeightMultiple: lineSpacing, kernValue: paragraph)
//
//        self.selectLabel.frame.size.height = 700
//        self.selectLabel.center = CGPoint(x: UIScreen.main.bounds.width/2 + posX_gap, y: UIScreen.main.bounds.height/2)
//    }
//
//    @IBAction func actionStepperValueChanged(_ sender: UIStepper)
//    {
//        let size = CGFloat(sender.value)
//        fontSize = size
//        setLineSpacingSlider(size)
//
//        selectLabel.font = UIFont(name: fontName, size: fontSize)
//        setSelectLabel(selectLabel.text!)
//
//        let x : Float = Float(size)
//        let y : Int = Int(x)
//        let z : String = String(y)
//
//        naviLabelSize.text = z
//
//        self.selectLabel.frame.size.height = 700
//        self.selectLabel.center = CGPoint(x: UIScreen.main.bounds.width/2 + posX_gap, y: UIScreen.main.bounds.height/2)
//    }
//
//    @IBAction func actionInit(_ sender: Any)
//    {
//        selectLabel.text = initMessage
//        selectLabel.setAttributeString(lineSpacing: lineSpacing, lineHeightMultiple: lineSpacing, kernValue: paragraph)
//        selectLabel.frame.size.width = width
//        selectLabel.frame.size.height = 700
//        selectLabel.center = CGPoint(x: UIScreen.main.bounds.width/2 + posX_gap, y: UIScreen.main.bounds.height/2)
//
//        lineSpacingSlider.value = 0
//        lineSpacingLabel.text = "0"
//
//        paragraphSlider.value = 0
//        paragraphLabel.text = "0"
//
//        width = 420
//        lineSpacing = 0
//        paragraph = 0
//
//        editTextView.text = ""
//    }
//
//    func getTouchPos(_ location : CGPoint) -> CGPoint
//    {
//        if cMode == .left
//        {
//            return CGPoint(x: location.x + selectLabel.frame.width / 2 + posX_gap, y: location.y)
//        }
//        else if cMode == .right
//        {
//            return CGPoint(x: location.x - selectLabel.frame.width / 2 + posX_gap, y: location.y)
//        }
//        else
//        {
//            return location
//        }
//    }
//
//    var labelGap : CGPoint = CGPoint()
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        if let touch = touches.first {
//            print("\(touch)")
//            let touchLocation = touch.location(in: self.view)
//
//            labelGap = CGPoint(x: selectLabel.center.x - touchLocation.x, y: selectLabel.center.y - touchLocation.y)
//
//        }
//        super.touchesBegan(touches, with: event)
//
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//       if let touch = touches.first{
//            print("\(touch)")
//            let touchLocation = touch.location(in: self.view)
//
//            selectLabel.center = CGPoint(x: touchLocation.x + labelGap.x, y: touchLocation.y + labelGap.y)
//
//        }
//        super.touchesMoved(touches, with: event)
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first{
//            print("\(touch)")
//        }
//        super.touchesEnded(touches, with: event)
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesCancelled")
//    }
//
//    @IBAction func actionColor(_ sender: Any) {
//        let colorPickerController = DefaultColorPickerViewController()
//        colorPickerController.delegate = self
//        navigationController?.pushViewController(colorPickerController, animated: true)
//    }
//}
//
//extension SingleLabelViewController: ColorPickerDelegate {
//
//    func colorPicker(_: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
//        self.pickedColor = selectedColor
//        selectLabel.textColor = self.pickedColor
//    }
//
//    func colorPicker(_: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl) {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//

