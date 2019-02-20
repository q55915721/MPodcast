//
//  Podcast.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/11.
//  Copyright © 2019 洪森達. All rights reserved.
//

import Foundation


class Podcast:NSObject,NSCoding,Codable,NSSecureCoding {
    static var supportsSecureCoding: Bool{
        return true
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(trackName, forKey: "trackName")
        aCoder.encode(artistName, forKey: "artistName")
        aCoder.encode(artworkUrl600?.toHttps(), forKey: "artwrokUrl600")
        aCoder.encode(feedUrl, forKey: "feedUrl")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        trackName = aDecoder.decodeObject(forKey: "trackName") as? String
         artistName = aDecoder.decodeObject(forKey: "artistName") as? String
         artworkUrl600 = aDecoder.decodeObject(forKey: "artwrokUrl600") as? String
         feedUrl = aDecoder.decodeObject(forKey: "feedUrl") as? String
        
    }
    
    
    var trackName:String?
    var artistName:String?
    var artworkUrl600:String?
    var trackCount:Int?
    var feedUrl: String?
    
    
}

