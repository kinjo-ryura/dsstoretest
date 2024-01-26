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
                //再生時間を表示
                Text("\(videoPlayerManager.getCurrentTime())  /  \(videoPlayerManager.getVideoPlayTime())")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(EdgeInsets(top: 0,
                                        leading: 27,
                                        bottom: 0,
                                        trailing: 0))
                Spacer()
                //10秒戻し
                Button(action: {
                    videoPlayerManager.seekPlusTime(plusTime: -10)
                }, label: {
                    Image(systemName: "gobackward.10")
                        .foregroundStyle(.white)
                        .font(.title)
                        .frame(maxWidth: .infinity,maxHeight:.infinity)
                        .background(HandballCourtColor)
                })
                .buttonStyle(.plain)
                .frame(maxWidth: 40, maxHeight:.infinity)
                //５秒戻し
                Button(action: {
                    videoPlayerManager.seekPlusTime(plusTime: -5)
                }, label: {
                    Image(systemName: "gobackward.5")
                        .foregroundStyle(.white)
                        .font(.title)
                        .frame(maxWidth: .infinity,maxHeight:.infinity)
                        .background(HandballCourtColor)
                })
                .buttonStyle(.plain)
                .frame(maxWidth: 40, maxHeight:.infinity)
                //再生ボタン
                Button(action: {
                    videoPlayerManager.startPauseVideo()
                }, label: {
                    Image(systemName: videoPlayerManager.isPlay() ? "pause.fill":"play.fill")
                        .foregroundStyle(.white)
                        .font(.title)
                        .frame(maxWidth: .infinity,maxHeight:.infinity)
                        .background(HandballCourtColor)
                })
                .buttonStyle(.plain)
                .frame(maxWidth: 40, maxHeight:.infinity)
                //５秒進める
                Button(action: {
                    videoPlayerManager.seekPlusTime(plusTime: 5)
                }, label: {
                    Image(systemName: "goforward.5")
                        .foregroundStyle(.white)
                        .font(.title)
                        .frame(maxWidth: .infinity,maxHeight:.infinity)
                        .background(HandballCourtColor)
                })
                .buttonStyle(.plain)
                .frame(maxWidth: 40, maxHeight:.infinity)
                //10秒進める
                Button(action: {
                    videoPlayerManager.seekPlusTime(plusTime: 10)
                }, label: {
                    Image(systemName: "goforward.10")
                        .foregroundStyle(.white)
                        .font(.title)
                        .frame(maxWidth: .infinity,maxHeight:.infinity)
                        .background(HandballCourtColor)
                })
                .buttonStyle(.plain)
                .frame(maxWidth: 40, maxHeight:.infinity)
                Spacer()
                //再生速度を下げる
                Button(action: {
                    videoPlayerManager.rateDown()
                }, label: {
                    Image(systemName: "backward.fill")
                        .foregroundStyle(.white)
                        .font(.title)
                        .frame(maxWidth: .infinity,maxHeight:.infinity)
                        .background(HandballCourtColor)
                })
                .buttonStyle(.plain)
                .frame(maxWidth: 40, maxHeight:.infinity)
                //再生速度を表示
                Text(videoPlayerManager.getCurrentPlayRate())
                    .font(.title)
                    .foregroundStyle(.white)
                //再生速度を上げる
                Button(action: {
                    videoPlayerManager.rateUp()
                }, label: {
                    Image(systemName: "forward.fill")
                        .foregroundStyle(.white)
                        .font(.title)
                        .frame(maxWidth: .infinity,maxHeight:.infinity)
                        .background(HandballCourtColor)
                })
                .buttonStyle(.plain)
                .frame(maxWidth: 40, maxHeight:.infinity)
                Spacer()
                //remoteviewにする
                //remoteviewじゃない時だけこのボタンを表示する
                if !videoPlayerManager.remoteView{
                    Button(action: {
                        openWindow(value:videoPlayerManager.localvideoPlayer.id)
                        videoPlayerManager.remoteView = true
                    }, label: {
                        Image(systemName: "rectangle.inset.bottomright.filled")
                            .foregroundStyle(.white)
                            .font(.title)
                            .frame(maxWidth: .infinity,maxHeight:.infinity)
                            .background(HandballCourtColor)
                    })
                    .buttonStyle(.plain)
                    .frame(maxWidth: 40, maxHeight:.infinity)
                }
                //再生するビデオを選択する
                Button(action: {
                    let panel = NSOpenPanel()
                    if panel.runModal() == .OK{
                        if let url = panel.url?.path{
                            videoPlayerManager.setVideoUrl(url: URL(filePath: url))
                        }
                    }
                }, label: {
                    Image(systemName: "film")
                        .foregroundStyle(.white)
                        .font(.title)
                        .frame(maxWidth: .infinity,maxHeight:.infinity)
                        .background(HandballCourtColor)
                })
                .padding(EdgeInsets(top: 0,
                                    leading: 10,
                                    bottom: 0,
                                    trailing: 27))
                .buttonStyle(.plain)
                .frame(maxWidth: 40, maxHeight:.infinity)
               
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

