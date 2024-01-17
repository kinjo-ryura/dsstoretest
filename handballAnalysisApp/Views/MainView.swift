//
//  MainView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI
import Combine

struct MainView: View, Identifiable {
    let id: UUID
    var title: String
    var tabViewType: TabViewType
    @ObservedObject var labelingRecordListManager: LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    @ObservedObject var videoPlayerManaer:VideoPlayerManager
    @EnvironmentObject var tabListManager:TabListManager
    
    
    init(id:UUID,
        title: String,
         tabViewType: TabViewType,
         labelingRecordListManager: LabelingRecordListManager,
         teamDataManager: TeamDataManager,
         videoPlayerManaer:VideoPlayerManager
    ) {
        self.id = id
        self.title = title
        self.tabViewType = tabViewType
        self.labelingRecordListManager = labelingRecordListManager
        self.teamDataManager = teamDataManager
        self.videoPlayerManaer = videoPlayerManaer
    }
    
    var body: some View {
//        switch tabViewDataManager.getTabType() {
        switch tabListManager.getTabType(id:id) {
        case .newTabView:
            NewTabView(id:id)
                .background(secondaryColor)
                .clipShape(
                    .rect(topLeadingRadius: 10,
                          topTrailingRadius: 10
                    )
                )
        case .labelingTabView:
            LabelingView(
                labelingRecordListManager: labelingRecordListManager,
                teamDataManager: teamDataManager,
                videoPlayerManager: videoPlayerManaer
            )
            .background(secondaryColor)
            .clipShape(
                .rect(topLeadingRadius: 10,
                      topTrailingRadius: 10
                     )
            )
        case .displayTabView:
            DisplayView()
                .background(secondaryColor)
                .clipShape(
                    .rect(topLeadingRadius: 10,
                          topTrailingRadius: 10
                         )
                )
        }
    }
}
