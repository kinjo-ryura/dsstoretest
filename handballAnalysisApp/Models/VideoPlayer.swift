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
    public var videoPastTimeString:String = ""
    public var videoPlayTimeString = ""
    public var videoCurrentTimeDouble:Double = 0
    public var videoPlayTimeDouble:Double = 0
}

class VideoPlayerManager: ObservableObject{
    @Published var localvideoPlayer:LocalVideoPlayer
    @Published var remoteView = false
    
    init(id:UUID) {
        self.localvideoPlayer = LocalVideoPlayer(id:id)
    }
    
    //
    func stopPlayer(){
        localvideoPlayer.player.pause()
    }
    
    //再生中かどうかを返す
    func isPlay() -> Bool{
        return localvideoPlayer.player.timeControlStatus == .playing
    }
    
    //現在の再生レートを取得する
    func getCurrentPlayRate() -> String{
        return String(format:"%.1f",localvideoPlayer.player.rate)
    }
    
    //現在の再生レートよりレートをあげる
    func rateUp(){
        let rate = localvideoPlayer.player.rate
        if rate < 2.0{
            localvideoPlayer.player.rate = rate + 0.25
        }
    }
    
    //現在の再生レートよりレートを下げる
    func rateDown(){
        let rate = localvideoPlayer.player.rate
        if rate > 0.25{
            localvideoPlayer.player.rate = rate - 0.25
        }
    }
    
    //指定した秒数とばす、マイナスを指定したら巻き戻し
    func seekPlusTime(plusTime:Double){
        let newTime = CMTime(seconds: localvideoPlayer.videoCurrentTimeDouble+plusTime, preferredTimescale: 1)
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
    
    
    //再生地点の時間をアップデートうる
    func updateCurrentTime(){
        let timeInSeconds = CMTimeGetSeconds(localvideoPlayer.player.currentTime())
        if !timeInSeconds.isNaN{
            //current time
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
            
            //pasttime
            let pastTotalSeconds = Int(timeInSeconds-3)
            let pastHours = pastTotalSeconds / 3600
            let pastMinutes = (pastTotalSeconds % 3600) / 60
            let pastSeconds = pastTotalSeconds % 60
            
            let pastTimeString:String
            if pastHours > 0 {
                pastTimeString  = String(format: "%i:%02i:%02i", pastHours, pastMinutes, pastSeconds)
            } else {
                pastTimeString  = String(format: "%02i:%02i", pastMinutes, pastSeconds)
            }
            

            localvideoPlayer.videoCurrentTimeString = timeString
            localvideoPlayer.videoPastTimeString = pastTimeString
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



