//
//  MainTabController.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/11.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit

class MainTabContoller:UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        
        
        setupSubController()
        setupPlayDetailView()
   
        
    }
    
    func maximunPlayDetailView(epsodie: Episode?,episodeList: [Episode] = []){
        
        minimunTopAnchor.isActive = false
        maximunTopAnchor.isActive = true
        maximunTopAnchor.constant = 0
        bottomAnchor.constant = 0
    
        
    if epsodie != nil {
        playDetailView.episode = epsodie
    }
        playDetailView.episodesList = episodeList
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.view.layoutIfNeeded()
            
            self.playDetailView.miniPlayerView.alpha = 0
            self.playDetailView.mainStackView.alpha = 1
            
        })
    }
    
    
     func minimunPlayDetailView(){
        
        
        maximunTopAnchor.isActive = false
        bottomAnchor.constant = view.frame.height
        minimunTopAnchor.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playDetailView.miniPlayerView.alpha = 1
            self.playDetailView.mainStackView.alpha = 0
        })
    }
    
    
    
    let playDetailView = PlayDetailView.initFromNib()
    var maximunTopAnchor:NSLayoutConstraint!
    var minimunTopAnchor:NSLayoutConstraint!
    var bottomAnchor:NSLayoutConstraint!
    
    fileprivate func setupPlayDetailView(){
        
        
        view.insertSubview(playDetailView, belowSubview: tabBar)
        playDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximunTopAnchor = playDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        
        maximunTopAnchor.isActive = true
        
        minimunTopAnchor = playDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        playDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomAnchor =  playDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: view.frame.height)
        
        bottomAnchor.isActive = true
        
        
        
        
        
    }
    //MARK:- Setup Sub Controllers
    
    fileprivate func setupSubController(){
        
        
        let favortite = FavoriteController(collectionViewLayout:UICollectionViewFlowLayout())
        viewControllers = [
        generateSubController(for: favortite, title: "Favorite", image: #imageLiteral(resourceName: "favorites")),
        generateSubController(for: PodcastSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
        generateSubController(for: DownloadController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        
        ]
    }
    
    fileprivate func generateSubController(for rootViewController:UIViewController,title:String,image:UIImage) -> UIViewController {
        
        let nv = UINavigationController(rootViewController: rootViewController)
            rootViewController.navigationItem.title = title
        nv.tabBarItem.image = image
        nv.tabBarItem.title = title
        
        return nv
        
    }
    
    
}
