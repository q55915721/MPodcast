//
//  EpisodeCell.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/12.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    
    @IBOutlet weak var progressLabel: UILabel!
    
    
    
    @IBOutlet weak var episodeImg: UIImageView!
    
    @IBOutlet weak var putDate: UILabel!
    
    
    @IBOutlet weak var episodeTitle: UILabel!{
        
        didSet{
            episodeTitle.numberOfLines = 2
        }
    }
    
    
    @IBOutlet weak var episodeDescription: UILabel!{
        didSet{
            episodeDescription.numberOfLines = 2
        }
    }
    
    
    var episode:Episode?{
        didSet{
            
            self.episodeTitle.text = episode?.episodeTitle
            self.episodeDescription.text = episode?.discription
            
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd ,yyyy"
            self.putDate.text = dateFormatter.string(from: episode?.putdate ?? Date())
            guard let imgurl = episode?.imageUrl?.toHttps() else {return}
            guard let url = URL(string: imgurl) else {return}
            episodeImg.layer.cornerRadius = 5
            episodeImg.clipsToBounds = true
            episodeImg.backgroundColor = .lightGray
            episodeImg.contentMode = .scaleAspectFill
            episodeImg.sd_setImage(with: url)
            
        }
    }
    
    
    
}
