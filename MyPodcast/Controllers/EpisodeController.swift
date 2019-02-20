//
//  EpisodeController.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/12.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit

class EpisodeController: UITableViewController {
   
    var podcast:Podcast!{
        didSet{
            navigationItem.title = podcast.trackName ?? "Episodes"
         
            fetchEpisodes(feedUrl:podcast.feedUrl ?? "")
        }
    }
    
    var episodes = [Episode]()
    
    fileprivate func fetchEpisodes(feedUrl:String){
        
        APIServer.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    //MARK: - view did....
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        
        setupNaviButton()
    }
    
    
    fileprivate let cellId = "cellid"
    
 
    
    fileprivate func setupNaviButton(){
        
        let savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
        
        let isHasTheOne = savedPodcasts.index(where: {$0.artistName == podcast.artistName && $0.trackName == podcast.trackName}) != nil
        
        if isHasTheOne {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: self, action: nil)
        }else{
          
            navigationItem.rightBarButtonItems =
            [UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite))]
            
        }
    }
    

    
     @objc func handleFetchData(){
        
        let savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
        
        savedPodcasts.forEach { (p) in
            print(p.trackName ?? "")
        }
    }
    
    @objc func handleSaveFavorite(){
        
       
        UserDefaults.standard.toSavePodcast(pod: self.podcast)
        
        changeIconAndBadgeValue()
        
    }
    
    fileprivate func changeIconAndBadgeValue(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: self, action: nil)
        
        UIApplication.mainTabarController()?.viewControllers?[0].tabBarItem.badgeValue = "New"
    }
    
    
    
    
    //MARK:- table view delegate / spacing...
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let downloadadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, indexPath) in
            
            UserDefaults.standard.toDownloadEpisode(ep: self.episodes[indexPath.row])
            APIServer.shared.toDownloadEpisode(ep: self.episodes[indexPath.row])
            UIApplication.mainTabarController()?.viewControllers?[2].tabBarItem.badgeValue = "New"
        }
        return [downloadadAction]
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episode = episodes[indexPath.row]
       UIApplication.mainTabarController()?.maximunPlayDetailView(epsodie: episode , episodeList: self.episodes)
    }
    
   override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spinning = UIActivityIndicatorView(style: .gray)
            spinning.startAnimating()
        
        return spinning
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return episodes.count > 0 ? 0 : 100
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        
        let epidoe = episodes[indexPath.row]
        
        cell.episode = epidoe
        
        return cell
        
        
    }
    
}
