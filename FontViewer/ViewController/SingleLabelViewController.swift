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
    @IBOutlet var showButton: UIBarButtonItem!
    @IBOutlet var listButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var uis : [UIView] = []
    
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
    var blindState : Bool = true
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fontDetailTableViewController = segue.destination as? FontDetailTableViewController {
            fontDetailTableViewController.fontName = fontName
        }
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
        textField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        
        setSliderOption(min: 0, max: 10)
        
        // 뒤로가기 버튼 문구 수정
        self.navigationController?.navigationBar.topItem?.title = ""
        
        // 네비게이션 투명
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController!.navigationBar.shadowImage = UIImage()
//        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    @objc func textChange()
    {
        if textField.text!.count == 0 {
            selectLabel.text = initMessage
        } else {
            selectLabel.text = textField.text
        }
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
        inputViewBottomAnchor.constant = -300
    }

    fileprivate func handleKeyboardIssue(notification: Notification, isAppearing: Bool)
    {
        guard let userInfo = notification.userInfo as? [String:Any] else {return}
        guard let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        guard let keyboardShowAnimateDuartion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
//        let keyboardHeight = keyboardFrame.cgRectValue.height

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
        
        if blindState {
            for view in uis {
                view.isHidden = true
            }
            listButton.image = nil
            listButton.title = ""
            
            showButton.image = UIImage(named: "iconShowOff")
            blindState = false
        } else {
            for view in uis {
                view.isHidden = false
            }
            listButton.image = UIImage(named: "iconTextlist")
            
            showButton.image = UIImage(named: "iconShowOn")
            blindState = true
        }
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
        case 3: // 글자 색 설정
            setMenuState(menuIndex: btn.tag)
            showSlider(hidden: true)
            
            let colorPickerController = DefaultColorPickerViewController()
            colorPickerController.delegate = self
            let navigationController = UINavigationController(rootViewController: colorPickerController)
            present(navigationController, animated: true, completion: nil)
            break
        case 4: // frame width
            setMenuState(menuIndex: btn.tag)
            showSlider(hidden: false)
            setSliderOption(min: 0, max: 400)
            break
        case 5: // 자간
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

        //editingViewHeight.constant = height
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
