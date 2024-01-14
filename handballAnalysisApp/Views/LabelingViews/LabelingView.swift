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
    
    var body: some View {
        VSplitView{
            HSplitView{
                VideoView()
                HandballCourtView()
            }
            .padding(EdgeInsets(top: 38,//なぜか上が飛び出るのでtoolbar分だけ下げる
                                 leading: 0,
                                 bottom: 0,
                                 trailing: 0))
            HSplitView{
                TeamMemberView(teamDataManager: teamDataManager)
                ResultView()
                HandballGoalView()
            }
        }
        .background(thirdColor)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}
