//
//  Test.swift
//  FontViewer
//
//  Created by tunko on 2019/11/15.
//  Copyright © 2019 tunko. All rights reserved.
//

import UIKit

enum Reindeer : String {
    case Dasher, Dancer, Prancer, Vixen, comet, Cupid, Donner, Blitzen, Udolpth
    static var allCases : [Reindeer] {
        return [Dasher, Dancer, Prancer, Vixen, comet, Cupid, Donner, Blitzen, Udolpth]
    }
    
    static func randomCase() -> Reindeer {
        let randomValue = Int(
            arc4random_uniform(
                UInt32(allCases.count)
            )
        )
        return allCases[randomValue]
    }
} 
