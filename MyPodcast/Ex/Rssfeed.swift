//
//  Rssfeed.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/12.
//  Copyright © 2019 洪森達. All rights reserved.
//

import FeedKit


extension RSSFeed {
    
    
    func toEpisodes() -> [Episode]{
        var episodes = [Episode]()
        let imgUrl = iTunes?.iTunesImage?.attributes?.href
      
        items?.forEach({ (item) in
            var episode = Episode(feed: item)
            if episode.imageUrl == nil {
                episode.imageUrl = imgUrl
            }
            episodes.append(episode)
        })
         return episodes
    }
    
    
}
