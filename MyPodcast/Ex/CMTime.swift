//
//  CMTime.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/15.
//  Copyright © 2019 洪森達. All rights reserved.
//

import Foundation
import AVFoundation

extension CMTime {
    
    func toDisplayString() -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minites = totalSeconds / 60
        
        let timeString = String(format: "%02d:%02d", minites,seconds)
        
        return timeString
        
    }
}
