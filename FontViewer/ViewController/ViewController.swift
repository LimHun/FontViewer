//
//  ViewController.swift
//  FontViewer
//
//  Created by tunko on 2019/10/22.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet var inputViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var models : [String] = []
    var filteredModels : [String] = []
    let data = [""]
    var filteredData: [String]!
    var searchListString : [String] = []
    
    let nibCellName : String = "FontMenuTableViewCell"
    
    var selectIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        let cellNib = UINib.init(nibName: nibCellName, bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: nibCellName)
       
        setDiviceFontFileList()
        setModel()
        setkeyboard()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let fontDetailViewController = segue.destination as? FontDetailViewController {
            fontDetailViewController.fontName = filteredModels[selectIndex]
        }
        
        if let fontDetailTableViewController = segue.destination as? FontDetailTableViewController {
            fontDetailTableViewController.fontName = filteredModels[selectIndex]
        }
    }
    
    // 폰트 데이터 셋
    func setDiviceFontFileList()
    {
        for family: String in UIFont.familyNames
        {
            let stringList = UIFont.fontNames(forFamilyName: family)
            if stringList.count == 1 {
                DataManager.shared.dataFontList.append(family)
            }
        }

        DataManager.shared.fontListSort()
        
        for family: String in UIFont.familyNames
        {
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                if !DataManager.shared.dataFontList.contains(names) {
                    DataManager.shared.dataFontList.append(names)
                }
            }
        }
    }
    
    func setModel()
    {
        models = DataManager.shared.dataFontList
        filteredModels = models
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
        inputViewBottomAnchor.constant = heightConstant
        UIView.animate(withDuration: keyboardShowAnimateDuartion.doubleValue)
        {
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = filteredModels.count
        print(count)
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nibCellName, for: indexPath) as! FontMenuTableViewCell
        let fontName = filteredModels[indexPath.row]
        
        cell.fontNameLabel.font = UIFont(name: fontName, size: 24)
        cell.fontNameLabel.text = fontName
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(filteredModels[indexPath.row])")
        
        self.selectIndex = indexPath.row
        
        self.performSegue(withIdentifier: "fontTableDetail", sender: self)
        
    }
}

extension ViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        filteredModels = models.filter({ (text) -> Bool in
            return text.lowercased().contains(searchBar.text!.lowercased())
        })
        
        if searchBar.text?.count == 0 {
            searchBar.text = ""
            setModel()
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
        setModel()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let keyword : String = searchBar.text!
        
        if keyword.trimmingCharacters(in: .whitespaces).isEmpty
        {
            //showOkPopup(self, "공백 문자로 검색할 수 없습니다.", "확인")
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
