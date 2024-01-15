//
//  VideoView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI
import AVKit

struct VideoView: View {
    @ObservedObject var videoPlayerManager:VideoPlayerManager
    @State private var isEditing = false
    
    var body: some View {
        VStack{
            AVPlayerViewRepresentable(player: videoPlayerManager.localvideoPlayer.player)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack{
                Button(action: {
                    let panel = NSOpenPanel()
                    if panel.runModal() == .OK{
                        if let url = panel.url?.path{
                            videoPlayerManager.setVideoUrl(url: URL(filePath: url))
                        }
                    }
                    
                }, label: {
                    Text("動画選択")
                })
                Button(action: {
                    videoPlayerManager.startPauseVideo()
                }, label: {
                    Text("再生")
                })
                
                Text(videoPlayerManager.getCurrentTime())
                Text(videoPlayerManager.getVideoPlayTime())
                Slider(
                    value: Binding(
                        get: { self.videoPlayerManager.localvideoPlayer.videoCurrentTimeDouble },
                        set: { newValue in
                            self.videoPlayerManager.localvideoPlayer.videoCurrentTimeDouble = newValue
                            if !self.videoPlayerManager.localvideoPlayer.isSliderEditing {
                                self.videoPlayerManager.seekToTime(value: newValue)
                            }
                        }
                    ),
                    in: 0...videoPlayerManager.localvideoPlayer.videoPlayTimeDouble,
                    onEditingChanged: { editing in
                        self.videoPlayerManager.localvideoPlayer.isSliderEditing = editing
                        if !editing {
                            self.videoPlayerManager.seekToTime(value: self.videoPlayerManager.localvideoPlayer.videoCurrentTimeDouble)
                        }
                    }
                )
                
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
    }
}



struct AVPlayerViewRepresentable: NSViewRepresentable {
    var player: AVPlayer
    
    func makeNSView(context: Context) -> AVPlayerView {
        let playerView = AVPlayerView()
        
        playerView.player = player
        playerView.controlsStyle = .none // または他のスタイル
        return playerView
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        nsView.player = player
    }
}
