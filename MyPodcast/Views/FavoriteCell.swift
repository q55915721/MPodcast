//
//  FavoriteCell.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/17.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit

class FavoriteCell:UICollectionViewCell {
    
    
    var podcast:Podcast? {
        didSet{
            guard let url = URL(string: podcast?.artworkUrl600 ?? "") else {return}
            podcastsImageView.layer.cornerRadius = 5
            podcastsImageView.clipsToBounds = true
            podcastsImageView.sd_setImage(with: url)
            
            podcastName.text = podcast?.trackName
            artistName.text = podcast?.artistName
        }
    }
    
    
    
    let podcastsImageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    let podcastName = UILabel()
    let artistName = UILabel()
    
    
    fileprivate func stylizeUI(){
        
        podcastName.text = "Podcast Name"
        podcastName.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        artistName.text = "Artist Name"
        artistName.textColor = .lightGray
        artistName.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stylizeUI()
        setupLayout()
       
        
    }
    
    fileprivate func setupLayout(){
        
        podcastsImageView.translatesAutoresizingMaskIntoConstraints = false
        podcastsImageView.heightAnchor.constraint(equalTo: podcastsImageView.widthAnchor).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [podcastsImageView,podcastName,artistName])
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
