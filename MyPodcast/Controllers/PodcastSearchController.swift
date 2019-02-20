//
//  PodcastSearchController.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/11.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit

class PodcastSearchController: UITableViewController,UISearchBarDelegate {
    
    
  
    var podcasts = [Podcast]()
    
    let searchBar = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        searchBar(self.searchBar.searchBar, textDidChange: "Ted")
        tableView.keyboardDismissMode = .onDrag
    }
    
    
    //MARK:- SetupSearchBar
    fileprivate func setupSearchBar(){
        definesPresentationContext = true
        searchBar.searchBar.delegate = self
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar.dimsBackgroundDuringPresentation = false
    }
    
    var time:Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        podcasts = []
        tableView.reloadData()
        
        time?.invalidate()
        time = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (time) in
            
            APIServer.shared.fetchPodcasts(searchText: searchText) { (pods) in
                
                self.podcasts = pods
                self.tableView.reloadData()
            }
            
        })
            
            
        
 
    }
    
    
    //MARK:- Setup TableView
    
    fileprivate func setupTableView(){
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
    }
    
    
    
    //MARK:- SetupUITableView
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
            label.text = "Search Something you want to listen"
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            label.textColor = .darkGray
        return label
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ep = EpisodeController()
        let pod = podcasts[indexPath.row]
        ep.podcast = pod
        navigationController?.pushViewController(ep, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchBar.searchBar.text?.isEmpty == true ? 250:0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
     
        let activeIndecator = UIActivityIndicatorView(style: .gray)
            activeIndecator.startAnimating()
        
        return activeIndecator
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchBar.searchBar.text?.isEmpty == false ? 150:0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    fileprivate let cellid = "cellid"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellid , for: indexPath) as! PodcastCell
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
}
