//
//  FontDetailTableViewController.swift
//  FontViewer
//
//  Created by tunko on 2019/10/25.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit
import FlexColorPicker

class FontDetailTableViewController: UIViewController {

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    let initFontSize : CGFloat = 10
    let initMessage : String = "Hello. 안녕하세요^ㅡ^"
    let nibCellName : String = "FontTableViewCell"
    
    var fontSizeGap : Int = 1
    var fontName : String = ""
    
    var printText : String = ""
    var selectFontSize : CGFloat = 12
    var pickedColor : UIColor = .label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()

        // 뒤로가기 버튼 문구 수정
        self.navigationController?.navigationBar.topItem?.title = ""
 
        let cellNib = UINib.init(nibName: nibCellName, bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: nibCellName)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 6
        stepper.minimumValue = 1
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        printText = initMessage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidApperar")
        tableView.reloadData()
    }
    
    func getRowFontSize(_ indexPath : IndexPath) -> String
    {
        let value = Int(initFontSize) + (indexPath.row * fontSizeGap)
        return "\(value)"
    }
    
    func setContentTextSetting(_ indexPath : IndexPath, _ label : UILabel) {
        let size = CGFloat(Int(initFontSize) + fontSizeGap * indexPath.row)
        label.font = UIFont(name: fontName, size: size)
    }
    
    func setContentText(_ label : UILabel)
    {
        label.text = printText
    }
    
    @IBAction func actionStepperValueChanged(_ sender: UIStepper) {
        print("sender\(sender.value)")
        fontSizeGap = Int(sender.value)
        tableView.reloadData()
    }
    
    @IBAction func actionInitText(_ sender: Any) {
        textField.text = ""
        printText = initMessage
        tableView.reloadData()
    }
    
    @IBAction func actionColor(_ sender: Any) {
        let colorPickerController = DefaultColorPickerViewController()
        colorPickerController.delegate = self
        navigationController?.pushViewController(colorPickerController, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        printText = textField.text!
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
        if let singleLabelViewController = segue.destination as? SingleLabelViewController {
            singleLabelViewController.fontName = fontName
            singleLabelViewController.fontSize = selectFontSize
            singleLabelViewController.fontContent = printText
            singleLabelViewController.foutColor = self.pickedColor
        }
    }
}
 
extension FontDetailTableViewController: ColorPickerDelegate {

    func colorPicker(_: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
        self.pickedColor = selectedColor
    }

    func colorPicker(_: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl) {
        navigationController?.popViewController(animated: true)
    }
}

extension FontDetailTableViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    { 
        let cell = tableView.dequeueReusableCell(withIdentifier: nibCellName, for: indexPath) as! FontTableViewCell
        cell.selectionStyle = .none
        cell.fontSize.text = getRowFontSize(indexPath)
        cell.contentText.textColor = self.pickedColor
        setContentTextSetting(indexPath, cell.contentText)
        setContentText(cell.contentText)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFontSize = CGFloat(Int(initFontSize) + fontSizeGap * indexPath.row)
        self.performSegue(withIdentifier: "singleText", sender: self)
        
    }
}
