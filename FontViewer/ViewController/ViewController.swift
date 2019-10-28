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
    @IBOutlet weak var tableView: UITableView!

    let nibCellName : String = "FontMenuTableViewCell"
    
    var selectIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNib = UINib.init(nibName: nibCellName, bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: nibCellName)
        
        for i in 0...100
        {
            DataManager.shared.dataFontList.append("font : \(i)")
        }
        
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let fontDetailViewController = segue.destination as? FontDetailViewController {
            fontDetailViewController.fontName = DataManager.shared.dataFontList[selectIndex]
        }
        
        if let fontDetailTableViewController = segue.destination as? FontDetailTableViewController {
            fontDetailTableViewController.fontName = DataManager.shared.dataFontList[selectIndex]
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataManager.shared.dataFontList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nibCellName, for: indexPath) as! FontMenuTableViewCell
        let fontName = DataManager.shared.dataFontList[indexPath.row]
        
        cell.fontNameLabel.font = UIFont(name: fontName, size: 24)
        cell.fontNameLabel.text = fontName
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(DataManager.shared.dataFontList[indexPath.row])")
        
        self.selectIndex = indexPath.row
        
        self.performSegue(withIdentifier: "fontTableDetail", sender: self)
        
    }
    

}
