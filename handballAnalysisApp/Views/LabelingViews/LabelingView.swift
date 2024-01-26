//
//  LabelingView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct LabelingView: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    @ObservedObject var videoPlayerManager:VideoPlayerManager
    let id:UUID
    
    var body: some View {
        
        content
            .background(thirdColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var content: some View {
        if videoPlayerManager.remoteView {
            remoteViewLayout
        } else {
            localViewLayout
        }
    }
    
    @ViewBuilder
    private var localViewLayout: some View {
        // Remote view layout here
                    VSplitView{
                        HStack(spacing: 0){
                            HSplitView{
                                VStack(spacing:0){
                                    VideoView(videoPlayerManager: videoPlayerManager)
                                    VideoOperationView(videoPlayerManager: videoPlayerManager)
                                }
                                HandballCourtView(labelingRecordListManager: labelingRecordListManager)
                            }
                            MarkerSelectView(labelingRecordListManager: labelingRecordListManager).frame(maxWidth: 50,maxHeight:.infinity)
                        }
                        .padding(EdgeInsets(top: 38,//なぜか上が飛び出るのでtoolbar分だけ下げる
                                            leading: 0,
                                            bottom: 0,
                                            trailing: 0))
                        HSplitView{
                            TeamMemberView(
                                labelingRecordListManager: labelingRecordListManager,
                                teamDataManager: teamDataManager,
                                videoPlayerManager: videoPlayerManager
                            )
                            ResultView(labelingRecordListManager: labelingRecordListManager,
                                       teamDataManager: teamDataManager,
                                       id:id
                            )
                            HandballGoalView(labelingRecordListManager: labelingRecordListManager)
                        }
                    }
                    .background(thirdColor)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var remoteViewLayout: some View {
        // Local view layout here
                    VSplitView{
                        HStack(spacing: 0){
                            HSplitView{
                                HandballGoalView(labelingRecordListManager: labelingRecordListManager)
                                        .frame(maxWidth: .infinity,maxHeight:.infinity)
                                .frame(maxWidth: .infinity,maxHeight:.infinity)
                                HandballCourtView(labelingRecordListManager: labelingRecordListManager)
                            }
                            MarkerSelectView(labelingRecordListManager: labelingRecordListManager).frame(maxWidth: 50,maxHeight:.infinity)
                        }
                        .padding(EdgeInsets(top: 38,//なぜか上が飛び出るのでtoolbar分だけ下げる
                                            leading: 0,
                                            bottom: 0,
                                            trailing: 0))
                        HSplitView{
                            TeamMemberView(
                                labelingRecordListManager: labelingRecordListManager,
                                teamDataManager: teamDataManager,
                                videoPlayerManager: videoPlayerManager
                            )
                            VStack(spacing:0){
                                VideoOperationView(videoPlayerManager: videoPlayerManager)
                                ResultView(labelingRecordListManager: labelingRecordListManager,
                                           teamDataManager: teamDataManager,
                                           id:id
                                )
                            }
                        }
                    }
                    .background(thirdColor)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}
