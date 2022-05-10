//
//  DataManager.swift
//  FontViewer
//
//  Created by tunko on 2019/10/22.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataManager
{
    static let shared = DataManager()
    
    var commitCheck = false
    
    var dataFontList : [String] = []
    
    func fontListSort()
    {
        dataFontList = dataFontList.sorted()
        dataFontList = dataFontList.reversed()
    }
    
    static func compareHanguls2(_ descend: Bool = false, str1: String, str2: String) -> Bool {

        var compared: Bool = false

        //두 문자열 비교전 2개 중에 작은 길이가 기준 길이
        let limit = min(str1.count, str2.count)
        let arr1: [Character] = str1.map { $0 }
        let arr2: [Character] = str2.map { $0 }

        for idx in 0..<limit {
            if arr1[idx] == arr2[idx] {
                continue
            } else {
                if descend {
                    compared = arr1[idx] > arr2[idx]
                } else {
                    compared = arr1[idx] < arr2[idx]
                }
                break
            }
        }
            
        return compared
    }
    
    
    func getFontListJson()
    {
        if let path = Bundle.main.path(forResource: "assets/test", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                print("jsonData:\(jsonObj)")
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
}
