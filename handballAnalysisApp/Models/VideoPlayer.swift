//
//  VideoPlayerManager.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/14.
//

import SwiftUI
import AVKit

struct LocalVideoPlayer: Identifiable{
    public var id = UUID()
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
    
    init() {
        self.localvideoPlayer = LocalVideoPlayer()
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
    
    //再生地点の時間をアップデートうる
    func updateCurrentTime(){
        let timeInSeconds = CMTimeGetSeconds(localvideoPlayer.player.currentTime())
        if !timeInSeconds.isNaN{
            let totalSeconds = Int(timeInSeconds)
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            let seconds = totalSeconds % 60
            
            if hours > 0 {
                localvideoPlayer.videoCurrentTimeString  = String(format: "%i:%02i:%02i", hours, minutes, seconds)
            } else {
                localvideoPlayer.videoCurrentTimeString  = String(format: "%02i:%02i", minutes, seconds)
            }
            if localvideoPlayer.isSliderEditing{
                localvideoPlayer.videoCurrentTimeDouble = Double(timeInSeconds)
            }
        }else{
            localvideoPlayer.videoCurrentTimeString = ""
        }
    }
    
    //動画時間をセットする
    func setVideoPlayTime(){
        print("関数は動いているよ")
        if let duration = localvideoPlayer.player.currentItem?.duration{
            print("itemがnilだよ")
            let totalSeconds = CMTimeGetSeconds(duration)
            // ここで総再生時間を扱う
            if !totalSeconds.isNaN {
                print("totalSecondsがnanだよ")
                let hours = Int(totalSeconds / 3600)
                let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
                let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
                
                let timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                localvideoPlayer.videoPlayTimeString = timeString
                if localvideoPlayer.isSliderEditing{
                    localvideoPlayer.videoPlayTimeDouble = Double(totalSeconds)
                }
                print("変更したよ")
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


