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
    @Environment(\.openWindow) private var openWindow
    
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
                Button(action: {
                    openWindow(value:videoPlayerManager.localvideoPlayer.id)
                    videoPlayerManager.remoteView = false
                }, label: {
                    Text("openwindow")
                })

                
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
        playerView.controlsStyle = .inline
        playerView.allowsMagnification = true
        return playerView
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        nsView.player = player
    }
}
