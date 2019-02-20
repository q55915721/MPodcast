//
//  UIAPP.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/16.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func mainTabarController() -> MainTabContoller? {
        
        return shared.keyWindow?.rootViewController as? MainTabContoller
    }
}
