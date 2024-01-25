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
        VStack(spacing:0){
            AVPlayerViewRepresentable(player: videoPlayerManager.localvideoPlayer.player)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(EdgeInsets(top: 7,
                            leading: 7,
                            bottom: 0,
                            trailing: 3))
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
