//
//  Episode.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/12.
//  Copyright © 2019 洪森達. All rights reserved.
//

import Foundation
import FeedKit

struct Episode:Codable {
    let putdate:Date
    let episodeTitle:String
    let discription:String
    var imageUrl:String?
    var author:String
    var streamUrl:String
    var fileUrl:String?
    
    init(feed:RSSFeedItem){
        
        self.putdate = feed.pubDate ?? Date()
        self.episodeTitle = feed.title ?? ""
        self.discription = feed.iTunes?.iTunesSubtitle ??  feed.description ?? ""
        self.imageUrl = feed.iTunes?.iTunesImage?.attributes?.href 
        self.streamUrl = feed.enclosure?.attributes?.url ?? ""
        self.author = feed.iTunes?.iTunesAuthor ?? ""
    }
    
}
