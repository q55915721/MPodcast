//
//  PodcastCellTableViewCell.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/12.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {

    @IBOutlet weak var podcastImg: UIImageView!
    
    @IBOutlet weak var trackName: UILabel!
    
    @IBOutlet weak var artistName: UILabel!
    
    
    @IBOutlet weak var episodeCount: UILabel!
    
    
    var podcast:Podcast!{
        didSet{
            
            trackName.text = podcast.trackName ?? ""
            artistName.text = podcast.artistName ?? ""
            episodeCount.text = "\(podcast.trackCount ?? 0) episodes"
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else {return}
            podcastImg.layer.cornerRadius = 5
            podcastImg.clipsToBounds = true
            podcastImg.contentMode = .scaleAspectFill
            podcastImg.sd_setImage(with: url)
            
        }
    }
}
