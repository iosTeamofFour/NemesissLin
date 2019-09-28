//
//  UIUtils.swift
//  ElegantLogin
//
//  Created by NemesissLin on 25/09/2019.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit

class UIUtils {
    
    public static func GetScreenWHPixel() -> (CGFloat, CGFloat) {
        let ScreenScale = UIScreen.main.scale
        let (DPWidth, DPHeight) = GetScreenWHDP()
        
        return (DPWidth * ScreenScale, DPHeight * ScreenScale)
    }
    
    public static func GetScreenWHDP() -> (CGFloat, CGFloat) {
        let ScreenSize = UIScreen.main.bounds.size
        return (ScreenSize.width, ScreenSize.height)
    }
}
