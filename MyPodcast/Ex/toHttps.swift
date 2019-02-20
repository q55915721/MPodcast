//
//  toHttps.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/12.
//  Copyright © 2019 洪森達. All rights reserved.
//

import Foundation


extension String {
    
    func toHttps() ->String{
        
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
        
    }
}
