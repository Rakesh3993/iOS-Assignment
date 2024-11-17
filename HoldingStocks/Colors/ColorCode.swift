//
//  ColorCode.swift
//  HoldingStocks
//
//  Created by Rakesh Kumar on 17/11/24.
//

import Foundation
import UIKit

enum ColorCode {
    static let appearanceColor = UIColor(
        red: CGFloat(0) / 255.0,
        green: CGFloat(45) / 255.0,
        blue: CGFloat(127) / 255.0,
        alpha: 1.0
    )
    
    static let expandViewBackground = UIColor(
        red: (247.5 / 255.0),
        green: (247.5 / 255.0),
        blue: (247.5 / 255.0),
        alpha: 1
    )
    
    static let expandViewBorderColor = CGColor(
        red: 128/255.0,
        green: 128/255.0,
        blue: 128/255.0,
        alpha: 1
    )
    
    static let greenPnLTextColor = UIColor(
        red: (0.0 / 255.0),
        green: (173.0 / 255.0),
        blue: (131.0 / 255.0),
        alpha: 1
    )
    
    static let redPnLTextColor = UIColor(
        red: (255.0 / 255.0),
        green: (8.0 / 255.0),
        blue: (0.0 / 255.0),
        alpha: 1
    )
}
