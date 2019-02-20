//
//  PlayDetailView.swift
//  MyPodcast
//
//  Created by 洪森達 on 2019/2/14.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import MediaPlayer

class PlayDetailView:UIView {
    
    
    var episode:Episode!{
        didSet{
            
            episodeName.text = episode.episodeTitle
            miniPlayerTitle.text = episode.episodeTitle
            authorName.text = episode.author
            guard let imgurl = URL(string: episode.imageUrl?.toHttps() ?? "" )  else {return}
            
            
            
            setupAVsession()
            setupNowPlayerInfo()
            playEpisode()
            
            
            
            episodeImageVIew.layer.cornerRadius = 10
            episodeImageVIew.clipsToBounds = true
            episodeImageVIew.sd_setImage(with: imgurl)
            miniPlayerImg.layer.cornerRadius = 5
            miniPlayerImg.clipsToBounds = true
            miniPlayerImg.sd_setImage(with: imgurl) { (image, _, _, _) in
                guard let image = image else {return}
                
                let artworkForInfo = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
                    return image
                })
                
                var nowPlayerInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                
                nowPlayerInfo?[MPMediaItemPropertyArtwork] = artworkForInfo
                
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayerInfo
                
                
            }
            
        }
    }
    
    fileprivate func setupNowPlayerInfo(){
        
        
        var nowPlayerInfo = [String:Any]()
        
            nowPlayerInfo[MPMediaItemPropertyTitle] = episode.episodeTitle
            nowPlayerInfo[MPMediaItemPropertyArtist] = episode.author
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayerInfo
        
        
        
        
    }
    
    
    fileprivate func playEpisode(){
        
        player.pause()
        
        if episode.fileUrl != nil {
            
            playEpisodeUsingFileUrl()
            
        }else{
            
            guard let url = URL(string: episode.streamUrl.toHttps() ) else {return}
            let playItem = AVPlayerItem(url: url)
            
            player.replaceCurrentItem(with: playItem)
            
            player.play()
        
        }
  
    }
    
    fileprivate func playEpisodeUsingFileUrl(){
        
        guard let fileUrl = URL(string: episode.fileUrl ?? "") else {return}
        
        let fileName = fileUrl.lastPathComponent
        
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first  else {return}
        
        trueLocation.appendPathComponent(fileName)
        
        
        let playItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playItem)
        player.play()
        
        
        
    }
    
    var player:AVPlayer = {
        let pl = AVPlayer()
        pl.automaticallyWaitsToMinimizeStalling = false
        return pl
    }()

    
    @IBAction func dismiss(_ sender: Any) {
     
        
     UIApplication.mainTabarController()?.minimunPlayDetailView()
      
    }
    
    @IBOutlet weak var episodeImageVIew: UIImageView!{
        
        didSet{
            
            episodeImageVIew.transform = self.shrunkenImg
        }
    }
    
    @IBOutlet weak var playPauseBtn: UIButton!{
        didSet{
            playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseBtn.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    @objc func handlePlayPause(){
        if player.timeControlStatus == .paused {
            playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayerPlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            setupElapsedTime(playingRate: 1)
            player.play()
            enlargeImg()
        }else {
            playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayerPlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            setupElapsedTime(playingRate: 0)
            player.pause()
            shrinkImg()
        }
    }
    
    @IBOutlet weak var rewindBtn: UIButton!
    
    @IBOutlet weak var fastForwardBtn: UIButton!
    
    @IBOutlet weak var volumeBtn: UISlider!
    
    @IBOutlet weak var episodeName: UILabel!
    
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    //MARK: - IBAction
    
    
    
    
    
    
    @IBOutlet weak var miniPlayerImg: UIImageView!
    
    @IBOutlet weak var miniPlayerTitle: UILabel!
    
    @IBOutlet weak var miniPlayerPlayButton: UIButton!{
        didSet{
            miniPlayerPlayButton.transform = shrunkenImg
            miniPlayerPlayButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var miniPlayerFastForward: UIButton!{
        didSet{
            miniPlayerFastForward.transform = shrunkenImg
            miniPlayerFastForward.addTarget(self, action: #selector(handleFastForward(_:)), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!

    
    @IBAction func handleTimeSlider(_ sender: Any) {
        
        
        let percentage = timeSlider.value
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        let seekTimeSeconds = Float64(percentage) * durationSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds, preferredTimescale: 1)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeSeconds
        player.seek(to: seekTime)
    }
    
    @IBAction func handleRewind(_ sender: Any) {
        handleRewindFastForward(delta: -15)
    }
    
    
    @IBAction func handleFastForward(_ sender: Any) {
        
        handleRewindFastForward(delta: 15)
    }
    
    
    @IBAction func handleVolume(_ sender: Any) {
        
        player.volume = volumeBtn.value
        
    }
    
    
    fileprivate func handleRewindFastForward(delta:Int64){
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let timeAdd = CMTimeAdd(player.currentTime(), fifteenSeconds)
        
        player.seek(to: timeAdd)

    }
    
    
    static func initFromNib() -> PlayDetailView {
        
        return Bundle.main.loadNibNamed("PlayDetailView", owner: self, options: nil)?.first as! PlayDetailView
    }
    
    
    fileprivate func addPridicObserver(){
        let time = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self ](time) in
            
            self?.startTimeLabel.text = time.toDisplayString()
            self?.endTimeLabel.text = self?.player.currentItem?.duration.toDisplayString()
            
            self?.toDisplaySliderValue()
        }
        
    }
    
    fileprivate func toDisplaySliderValue(){
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        let percentage = currentTime / durationSeconds
        
        timeSlider.value = Float(percentage)
        
        
        
    }
    
    
    var panGesture:UIPanGestureRecognizer!
    
    fileprivate func addGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMaxi)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        
        mainStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanforMainStackView)))
        
        
    }
    
    
    //MARK: - Set up Audio Session
    
    fileprivate func setupAVsession(){
        
        
        do{
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
        }catch let sessionErr {
            print("session error",sessionErr)
        }
        
        
    }
    
    //MARK: - Set up RemoteController
    
    fileprivate func setRomoteController(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        
        
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.player.play()
            
            self.miniPlayerPlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.setupElapsedTime(playingRate: 1)
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.player.pause()
            
            self.miniPlayerPlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.setupElapsedTime(playingRate: 0)
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.handlePlayPause()
            
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextTrack))
        
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePreviousTrack))

    }
    
    var episodesList = [Episode]()
    
    @objc fileprivate func handlePreviousTrack(){
        if episodesList.count == 0 { return }
        
        let currentEpisodeIndex = episodesList.index(where: { (ep) -> Bool in
            return ep.episodeTitle == self.episode.episodeTitle && ep.author == self.episode.author
        })
        
        guard let index = currentEpisodeIndex else {return}
        
        var previousEp:Episode!
        
        if index == 0 {
            previousEp = episodesList[episodesList.count - 1]
        }else{
            previousEp = episodesList[index - 1]
        }
        
        self.episode = previousEp
    }
    
    
    @objc fileprivate func handleNextTrack(){
        
        if episodesList.count == 0 { return }
        
       let currentEpisodeIndex = episodesList.index(where: { (ep) -> Bool in
            return ep.episodeTitle == self.episode.episodeTitle && ep.author == self.episode.author
        })
        
        guard let index = currentEpisodeIndex else {return}
        
        var nextEp:Episode!
        
        if index == episodesList.count - 1 {
            nextEp = episodesList[0]
        }else {
            nextEp = episodesList[index + 1]
        }
        
        self.episode = nextEp
        
    }
    
    fileprivate func setupElapsedTime(playingRate:Float){
        let currentTime = player.currentTime()
        let currentTimeSeconds = CMTimeGetSeconds(currentTime)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTimeSeconds
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playingRate
    }
    
    fileprivate func observerBoundaryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            
            self?.enlargeImg()
            self?.setupMPNowPlayerDuration()
        }
    }
    
    fileprivate func setupMPNowPlayerDuration(){
        
        guard let duration = player.currentItem else {return}
        let durationSeconds = CMTimeGetSeconds(duration.duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
    
    //MARK: - Awake
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
  
        observerNotification()
        setRomoteController()
        addGesture()
        
        addPridicObserver()
        observerBoundaryTime()
    }
    
    fileprivate func observerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc fileprivate func handleInterruption(notification:Notification){
        
        guard let userInfo = notification.userInfo else {return}
        
        
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else {return}
        
        if type == AVAudioSession.InterruptionType.began.rawValue {
            
            player.pause()
            playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayerPlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            
        }else{
            
            guard let option = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else{return}
            
            if option == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                
                player.play()
                playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                miniPlayerPlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                
            }
        }
  
    }
    
    
    
    @objc func handlePanforMainStackView(gesture:UIPanGestureRecognizer){
        
        
        switch gesture.state {
            
        case .changed:
            
            let translation = gesture.translation(in: superview)
            
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
        case .ended:
            
            let translation = gesture.translation(in: superview)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.transform = .identity
                
                if translation.y > 50 {
                    UIApplication.mainTabarController()?.minimunPlayDetailView()
                }else{
                    self.miniPlayerView.alpha = 0
                    self.mainStackView.alpha = 1
                }
                
                
                
            })
            
        default:
            break
        }
        
        
        
    }
    
    
    
    
    @objc fileprivate func handlePan(gesture:UIPanGestureRecognizer){
        
        
        switch gesture.state {
        case .began:
            print("begin")
            
        case  .changed:
        
            handlePanChanged(gesture: gesture)
            
            
        case .ended :
            
            handlePanEnded(gesture: gesture)
    
        default:
        
            break
        }
        
        
    }
    
    func handlePanChanged(gesture:UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.miniPlayerView.alpha = 1 + translation.y / 200
        self.mainStackView.alpha = -translation.y / 200
        
    }
    func handlePanEnded(gesture:UIPanGestureRecognizer){
        
        
        let translation = gesture.translation(in: superview)
        let volocity = gesture.velocity(in: superview)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.transform = .identity
            
            if translation.y < -200 || volocity.y < -500 {
                UIApplication.mainTabarController()?.maximunPlayDetailView(epsodie: nil)
                
            }else{
                self.miniPlayerView.alpha = 1
                self.mainStackView.alpha = 0
            }
            
        })
        
        
    }
    
    @objc fileprivate func handleMaxi(){
        
        UIApplication.mainTabarController()?.maximunPlayDetailView(epsodie: nil)
      
    }
    
    
    fileprivate func enlargeImg(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.episodeImageVIew.transform = .identity
        })
    }
    
    fileprivate let shrunkenImg:CGAffineTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func shrinkImg(){
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.episodeImageVIew.transform = self.shrunkenImg
        })
    }
    
    
}
