//
//  DownloadController.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/18.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit


class DownloadController:UITableViewController {
    
   
    
    var episodes = UserDefaults.standard.downloadedEpisodes()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        
        tableView.reloadData()
        
        UIApplication.mainTabarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        
        addObsever()

    }
    
    
    fileprivate func addObsever(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleProgress), name: NSNotification.Name(rawValue: NSNotification.Name.downloadProgress), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCompletion), name: NSNotification.Name(rawValue: NSNotification.Name.completiomDownloadTask), object: nil)
        
        
    }
    
    @objc fileprivate func handleCompletion(notification:Notification){
        
        guard let userTuple = notification.object as? APIServer.episodeDownloadTuple else{return}
        
        guard let index = episodes.index(where: {$0.episodeTitle == userTuple.episodeTitle}) else {return}
        
        episodes[index].fileUrl = userTuple.fileUrl
    
    }
    
    
    @objc fileprivate func handleProgress(notification:Notification){
        
        guard let userInfo = notification.userInfo else {return}
        
        guard let title = userInfo["title"] as? String else {return}
        
        guard let progress = userInfo["progress"] as? Double else {return}
        
        guard let index = episodes.index(where: {$0.episodeTitle == title}) else {return}
        
        
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EpisodeCell
        cell.progressLabel.isHidden = false
        
        cell.progressLabel.text = "\(Int(progress * 100)) %"
        
        if progress == 1 {
            
            cell.progressLabel.isHidden = true
        }
        
        
        
       
    }
    
    
    
    //MARK: - table view delegate / row action
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let episode = episodes[indexPath.row]
        
        if episode.fileUrl != nil {
            
               UIApplication.mainTabarController()?.maximunPlayDetailView(epsodie: episode, episodeList: episodes)
            
        }else{
            
            let alertController = UIAlertController(title: "Not found!", message: "The episode is not downloaded..Do you want to use streaming url instead?", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                
                UIApplication.mainTabarController()?.maximunPlayDetailView(epsodie: episode, episodeList: self.episodes)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
     
        
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            
            let deletedEpisode = self.episodes[indexPath.row]
            
            self.episodes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.toDeleteEpisoded(ep:deletedEpisode)
            
            
        }
        
        
        
        return [deleteAction]
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    
    fileprivate let cellid = "cellid"
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
//
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
}
