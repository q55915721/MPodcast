//
//  APIServer.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/12.
//  Copyright © 2019 洪森達. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit


extension NSNotification.Name {
    
    static let downloadProgress = "downloadProgress"
    static let completiomDownloadTask = "completiomDownloadTask"
}


class APIServer {
    
    
    static let shared = APIServer()
    
    let besicUrlWirhiTunes = "https://itunes.apple.com/search"
    
    typealias episodeDownloadTuple = (fileUrl:String , episodeTitle:String)
    
    
    func toDownloadEpisode(ep:Episode) {
        
        let downloadDestination = Alamofire.DownloadRequest.suggestedDownloadDestination()
        
        
        Alamofire.download(ep.streamUrl, to: downloadDestination).downloadProgress { (progress) in
            print(progress.fractionCompleted)
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotification.Name.downloadProgress), object: nil, userInfo: ["title":ep.episodeTitle , "progress":progress.fractionCompleted])
         
            
            
            }.response { (resp) in
                
                let object:episodeDownloadTuple = (resp.destinationURL?.absoluteString ?? "",ep.episodeTitle)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotification.Name.completiomDownloadTask), object: object , userInfo: nil)
              
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
               guard let index = downloadedEpisodes.index(where: {$0.author == ep.author && $0.episodeTitle == ep.episodeTitle}) else {return}
                
                downloadedEpisodes[index].fileUrl = resp.destinationURL?.absoluteString
            
                do{
                    
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    
                    UserDefaults.standard.set(data, forKey: UserDefaults.downdloadedEpisodes)
                    
                }catch let downloadErr{print(downloadErr.localizedDescription)}
                
        }
        
        
    }
    
    func fetchEpisodes(feedUrl:String ,completionHandler:@escaping ([Episode])->()){
        
        guard let url = URL(string: feedUrl.toHttps()) else {return}
        print(url)
        let feedParser = FeedParser(URL: url)
        
        feedParser.parseAsync(queue: DispatchQueue.global(qos: .background)) { (result) in
            
            if let err = result.error {
                print("failed to parser feed url ", err.localizedDescription)
                return
            }
            
            let episodes = result.rssFeed?.toEpisodes()
            
            completionHandler(episodes ?? [])
            
        }
    }
    
    func fetchPodcasts(searchText:String,completionHandler:@escaping ([Podcast]) ->()){
        
        let parameters:Parameters = ["term":searchText,"media":"podcast"]
        
        Alamofire.request(besicUrlWirhiTunes, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (resData) in
            if let err = resData.error {
                print(err.localizedDescription)
                return
            }
            
            guard let data = resData.data else {return}
            
            
            do{
                
                let searchResult = try JSONDecoder().decode(SearchResult.self,from: data)
                
                completionHandler(searchResult.results)
            }catch let err{
                
                print(err.localizedDescription)
            }
        }
        
    }
    
    
    struct SearchResult:Decodable {
        let resultCount:Int
        let results:[Podcast]
    }

}
