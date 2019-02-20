//
//  UserDefault.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/17.
//  Copyright © 2019 洪森達. All rights reserved.
//

import Foundation




extension UserDefaults {
    
    
    static let savedFavorite = "savedFavorite"
    static let downdloadedEpisodes = "downdloadedEpisodes"
    
    func toDeleteEpisoded(ep:Episode){
        
        var downLoadedEpisodes = downloadedEpisodes()
        let isExist = downLoadedEpisodes.contains(where: {$0.episodeTitle == ep.episodeTitle && $0.author == ep.author})
        
        if isExist {
            
            guard let index = downLoadedEpisodes.index(where: {$0.author == ep.author && $0.episodeTitle == ep.episodeTitle}) else { return }
            
            downLoadedEpisodes.remove(at: index)
            
            do{
                
                let data = try JSONEncoder().encode(downLoadedEpisodes)
                
                set(data, forKey: UserDefaults.downdloadedEpisodes)
                
            }catch let deleteErr {
                print(deleteErr.localizedDescription)
            }
            
            
        }else{
            print("this episode is not downloaded...")
            return
        }
        
    }
    
    func toDownloadEpisode(ep:Episode){
        
        var downLoadedEpisodes = downloadedEpisodes()
        let isExist = downLoadedEpisodes.contains(where: {$0.episodeTitle == ep.episodeTitle && $0.author == ep.author})
        
        if isExist {
            print("this episode is downloaded....")
            return
        }else{
            
            downLoadedEpisodes.insert(ep, at: 0)
        }
        
        do{
            
            let data = try JSONEncoder().encode(downLoadedEpisodes)
            
            set(data, forKey: UserDefaults.downdloadedEpisodes)
            
            
        }catch let downloadErr{
            
            print(downloadErr.localizedDescription)
        }
    }

    func downloadedEpisodes()->[Episode]{
        
        
        guard let data = data(forKey: UserDefaults.downdloadedEpisodes) else {return [] }
        
        do {
            
            let downloadedEpisodes = try JSONDecoder().decode([Episode].self, from: data)
            
            return downloadedEpisodes
            
            
        }catch let downloadedErr{
            
            print(downloadedErr.localizedDescription)
        }
        
        
        return []
    }
    
    func toDeletePodcast(pod:Podcast){
        
        var savedPodcast = fetchSavedPodcasts()
        
        guard let index = savedPodcast.index(where: {$0.artistName == pod.artistName && $0.trackName == pod.trackName}) else {return}
        
        savedPodcast.remove(at: index)
        
        do{
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: savedPodcast, requiringSecureCoding: true)
            
            setValue(data, forKey: UserDefaults.savedFavorite)
            
        }catch let deteleItemErr{
            print(deteleItemErr.localizedDescription)
        }
        
    }
    
    func toCleanAllOfPodcasts(){
        
        let blankArray = [AnyObject]()
        
        setValue(blankArray, forKey: UserDefaults.savedFavorite)
    
    }
    
    func toSavePodcast(pod:Podcast){
        
        var savedPodcasts = fetchSavedPodcasts()
        
        let isExist = savedPodcasts.contains(where: {$0.artistName == pod.artistName && $0.trackName == pod.trackName})
        
        if isExist {
            print("there is a object in the UserDefault already!")
            return
        }else{
            savedPodcasts.insert(pod, at: 0)
        }
        
        
        
        do{
            
        
            let data = try NSKeyedArchiver.archivedData(withRootObject: savedPodcasts, requiringSecureCoding: true)
            
            setValue(data, forKey: UserDefaults.savedFavorite)
            
        }catch let savePodcastErr{
           
            print("savePodcastErr:",savePodcastErr)
        }
        
        
        
    }
    
    func fetchSavedPodcasts() -> [Podcast] {
        
        
        do{
            
            guard let data = UserDefaults.standard.data(forKey: UserDefaults.savedFavorite) else { return [] }
            
            
            
            guard let savedPodcasts = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self,Podcast.self], from: data) as? [Podcast] else {return [] }
            
        
            return savedPodcasts
        }catch let fetchSavedPodcastsErr{
            print("fetchSavedPodcasts:",fetchSavedPodcastsErr)
        }
        
        return []
    }
}
