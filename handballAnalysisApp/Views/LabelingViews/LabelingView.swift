//
//  LabelingView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct LabelingView: View {
    @ObservedObject var tabViewDataManager:TabViewDataManager
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    
    var body: some View {
        VSplitView{
            HSplitView{
                VideoView()
                HandballCourtView()
            }
            HSplitView{
                TeamMemberView(teamDataManager: teamDataManager)
                ResultView()
                HandballGoalView()
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}
