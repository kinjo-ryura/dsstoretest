//
//  VideoPlayerManager.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/14.
//

import SwiftUI
import AVKit

struct LocalVideoPlayer: Identifiable{
    public var id: UUID
    public var player = AVPlayer()
    public var localVideoUrl:URL?
    public var videoCurrentTimeString:String = ""
    public var videoPlayTimeString = ""
    public var videoCurrentTimeDouble:Double = 0
    public var videoPlayTimeDouble:Double = 0
    public var isSliderEditing: Bool = false
}

class VideoPlayerManager: ObservableObject{
    @Published var localvideoPlayer:LocalVideoPlayer
    
    init(id:UUID) {
        self.localvideoPlayer = LocalVideoPlayer(id: id)
    }
    
    func seekToTime(value: Double) {
        let newTime = CMTime(seconds: value, preferredTimescale: 1)
        localvideoPlayer.player.seek(to: newTime)
    }
    
    func getVideoPlayer() -> AVPlayer{
        return localvideoPlayer.player
    }
    
    func getCurrentTime() -> String{
        return localvideoPlayer.videoCurrentTimeString
    }
    
    func getVideoPlayTime() -> String{
        return localvideoPlayer.videoPlayTimeString
    }
    
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
    }
    
    //再生地点の時間をアップデートうる
    func updateCurrentTime(){
        let timeInSeconds = CMTimeGetSeconds(localvideoPlayer.player.currentTime())
        if !timeInSeconds.isNaN{
            let totalSeconds = Int(timeInSeconds)
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            let seconds = totalSeconds % 60
            
            let timeString:String
            if hours > 0 {
                timeString  = String(format: "%i:%02i:%02i", hours, minutes, seconds)
            } else {
                timeString  = String(format: "%02i:%02i", minutes, seconds)
            }
            localvideoPlayer.videoCurrentTimeString = timeString
            localvideoPlayer.videoCurrentTimeDouble = Double(timeInSeconds)
        }else{
            localvideoPlayer.videoCurrentTimeString = ""
        }
    }
    
    //動画時間をセットする
    func setVideoPlayTime(){
        if let duration = localvideoPlayer.player.currentItem?.duration{
            let totalSeconds = CMTimeGetSeconds(duration)
            // ここで総再生時間を扱う
            if !totalSeconds.isNaN {
                let hours = Int(totalSeconds / 3600)
                let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
                let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
                
                let timeString:String
                if hours > 0 {
                    timeString  = String(format: "%i:%02i:%02i", hours, minutes, seconds)
                } else {
                    timeString  = String(format: "%02i:%02i", minutes, seconds)
                }
                localvideoPlayer.videoPlayTimeString = timeString
                localvideoPlayer.videoPlayTimeDouble = Double(totalSeconds)
            }
        }
        
    }
    
    func setVideoUrl(url:URL){
        let player = AVPlayer(url: url)
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            // ここに時間が変わるたびに実行したい処理を記述
            self.updateCurrentTime()
            self.setVideoPlayTime()
            print(self.localvideoPlayer.videoCurrentTimeDouble)
            print(self.localvideoPlayer.videoPlayTimeDouble)
        }
        localvideoPlayer.player = player
    }
    
    
    
    func startPauseVideo(){
        if localvideoPlayer.player.timeControlStatus == .paused{
            localvideoPlayer.player.play()
        }else{
            localvideoPlayer.player.pause()
        }
    }
    
}



