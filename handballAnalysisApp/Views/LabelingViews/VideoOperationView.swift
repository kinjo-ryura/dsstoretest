//
//  VideoOperationView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/25.
//

import SwiftUI

struct VideoOperationView: View {
    @ObservedObject var videoPlayerManager:VideoPlayerManager
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack(spacing:0){
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
                Text(videoPlayerManager.getCurrentTime())
                    .font(.title)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity,maxHeight:30)
            .background(HandballCourtColor)
        }
        .padding(EdgeInsets(top: 0,
                            leading: 7,
                            bottom: 0,
                            trailing: 3))
        .background(secondaryColor)
    }
}

