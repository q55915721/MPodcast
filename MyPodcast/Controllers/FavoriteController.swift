//
//  FavoriteController.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/17.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit

class FavoriteController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    
    
    var savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
    
    
    //MARK: - View Did ....
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCell()
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
        collectionView.reloadData()
       
        UIApplication.mainTabarController()?.viewControllers?[0].tabBarItem.badgeValue = nil
        
    }
    
    @objc fileprivate func handleLongPress(gesture:UILongPressGestureRecognizer){
        guard  let SelectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {return}
        
        let alertCOntroller = UIAlertController(title: "Do you want to delete the Podcast?", message: "", preferredStyle: .actionSheet)
        alertCOntroller.addAction(UIAlertAction(title: "Yes!", style: .destructive, handler: { (_) in
            
            let currentPoadcast = self.savedPodcasts[SelectedIndexPath.item]
            self.savedPodcasts.remove(at: SelectedIndexPath.item)
            self.collectionView.deleteItems(at: [SelectedIndexPath])
            UserDefaults.standard.toDeletePodcast(pod:currentPoadcast )
            
        }))
        
        alertCOntroller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertCOntroller, animated: true, completion: nil)
    }
    
    //MARK: - Setup colletionVIew cell
    
    fileprivate func setupCell(){
        
        collectionView.backgroundColor = .white
        
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: cellid)
    }
    
    
    
    //MARK: - UICOLLECTION VIEW DELEGATE
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let podcast = savedPodcasts[indexPath.item]
        let episodeController = EpisodeController()
            episodeController.podcast = podcast
        
        navigationController?.pushViewController(episodeController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedPodcasts.count
    }
    
    fileprivate let cellid = "cellif"
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! FavoriteCell
        
        let podcast = savedPodcasts[indexPath.item]
       
        cell.podcast = podcast
        return cell
    }
    
    fileprivate let padding:CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - padding * 3) / 2
        
        return CGSize(width: width, height: width + 46)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return padding
    }
    
    
}
