//
//  ViewController.swift
//  FontViewer
//
//  Created by tunko on 2019/10/22.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FontListViewController: UIViewController
{
    @IBOutlet var inputViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var rightMenu: UIBarButtonItem!
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var bannerHeight: NSLayoutConstraint!
    @IBOutlet var tableBottomPosY: NSLayoutConstraint!
    
    var searchBar : UISearchBar! = nil
    
    let data : [String]             = []
    var models : [String]           = []
    var filteredModels : [String]   = []
    var filteredData : [String]     = []
    var searchListString : [String] = []
    
    let nibCellName : String = "FontMenuTableViewCell"
    var selectIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adsBannerSetting()
        
        hideKeyboardWhenTappedAround()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
         
        let cellNib = UINib.init(nibName: nibCellName, bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: nibCellName)
       
        setDiviceFontFileList()
        setModel()
        setkeyboard()
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search :)"
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .default
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        showSearchCancelMenu(isVisble: false)
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!

        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                if item.contains(".otf") || item.contains(".ttf") {
                    print(item.components(separatedBy: ".")[0])
                    if let font = UIFont(name: item.components(separatedBy: ".")[0], size: 10) {
                        print("fontName : \(font.fontName)")
                    }


                    DataManager.shared.dataFontList.append(item.components(separatedBy: ".")[0])
                }
            }
        } catch {

        }
    }
    
    func adsBannerSetting() {
        
        bannerView.delegate = self
        #if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        #else
        bannerView.adUnitID = "ca-app-pub-9063444605027888/8951672388"
        #endif
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
        if let singleLabelViewController = segue.destination as? SingleLabelViewController {
            singleLabelViewController.fontName = filteredModels[selectIndex]
            singleLabelViewController.fontSize = 20
            singleLabelViewController.fontContent = "안녕하세요"
            
            if self.traitCollection.userInterfaceStyle == .dark {
                // User Interface is Dark
                singleLabelViewController.foutColor = UIColor.white
            } else {
               // User Interface is Light
                singleLabelViewController.foutColor = UIColor.black
            }
            
        }
    }
    
    func showSearchCancelMenu(isVisble : Bool)
    {
        if isVisble {
            navigationItem.rightBarButtonItems = []
        } else {
            navigationItem.rightBarButtonItems = [rightMenu]
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
        bannerHeight.constant = 50
        tableBottomPosY.constant = 0
        handleKeyboardIssue(notification: notification, isAppearing: false)
    }
    
    // Keyboard show
    @objc func keyboardWillShow(_ notification: Notification)
    {
        bannerHeight.constant = 0
        tableBottomPosY.constant = -34
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

extension FontListViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = filteredModels.count
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nibCellName, for: indexPath) as! FontMenuTableViewCell
        let fontName = filteredModels[indexPath.row]
        cell.fontName.text = fontName
        
        if let range = fontName.range(of: searchBar!.text!) {
            let substring = fontName[..<range.lowerBound]
            let textIndex = substring.count
            let length : Int = searchBar!.text!.count
            let attributedString = NSMutableAttributedString(string: filteredModels[indexPath.row], attributes: [
            .font: UIFont(name: "NotoSansCJKkr-Regular", size: 24.0)!,
            .foregroundColor: UIColor(named: "Color/FontTitle")
            ])
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "Color/FontHighlight") , range: NSRange(location: textIndex, length: length))
            cell.fontName.attributedText = attributedString
        }
        
        cell.fontReview.font = UIFont(name: fontName, size: 24)
        cell.fontReview.text = fontName
        cell.selectionStyle = .default
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(filteredModels[indexPath.row])")
        
        self.selectIndex = indexPath.row
        
        self.performSegue(withIdentifier: "SingleLabelViewController", sender: self)
        
    }
}

extension FontListViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
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
        //searchBar.text = ""
        searchBar.endEditing(false)
        setModel()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        showSearchCancelMenu(isVisble: true)
        
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        if searchBar.text!.count == 0 {
            searchBar.showsCancelButton = false
            showSearchCancelMenu(isVisble: false)
        }
        else {
            searchBar.showsCancelButton = true
            showSearchCancelMenu(isVisble: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
}

extension FontListViewController : GADBannerViewDelegate {
   
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
