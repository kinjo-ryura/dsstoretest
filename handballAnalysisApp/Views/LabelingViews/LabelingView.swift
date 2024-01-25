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
        //remoteviewが表示されているかどうかで表示を変える
        if videoPlayerManager.remoteView{
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
                        teamDataManager: teamDataManager
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
        }else{
            VSplitView{
                HStack(spacing: 0){
                    HSplitView{
                        VStack(spacing: 0) {
                            HandballGoalView(labelingRecordListManager: labelingRecordListManager)
                                .frame(maxWidth: .infinity,maxHeight:.infinity)
                            VideoOperationView(videoPlayerManager: videoPlayerManager)
                        }
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
                        teamDataManager: teamDataManager
                    )
                    ResultView(labelingRecordListManager: labelingRecordListManager,
                               teamDataManager: teamDataManager,
                               id:id
                    )
                }
            }
            .background(thirdColor)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
        }

    }
}
