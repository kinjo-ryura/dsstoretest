//
//  RemoteVideoView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/17.
//

import SwiftUI

struct RemoteVideoView: View {
    let id:UUID?
    @EnvironmentObject var tabListManager:TabListManager
    
    var body: some View {
        VStack{
            if let mainView = tabListManager.TabDataList.first(
                where: { $0.id == id}
            ) {
                AVPlayerViewRepresentable(player:mainView.videoPlayerManaer.localvideoPlayer.player)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }else{
                Text("none")
            }
        }
    }
}

