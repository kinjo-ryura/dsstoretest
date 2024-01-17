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
    @ObservedObject var tabViewDataManager: TabViewDataManager
    @ObservedObject var labelingRecordListManager: LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    @ObservedObject var videoPlayerManaer:VideoPlayerManager
    
    
    init(id:UUID,
        title: String,
         tabViewType: TabViewType,
         tabViewDataManager: TabViewDataManager,
         labelingRecordListManager: LabelingRecordListManager,
         teamDataManager: TeamDataManager,
         videoPlayerManaer:VideoPlayerManager
    ) {
        self.id = id
        self.title = title
        self.tabViewType = tabViewType
        self.tabViewDataManager = tabViewDataManager
        self.labelingRecordListManager = labelingRecordListManager
        self.teamDataManager = teamDataManager
        self.videoPlayerManaer = videoPlayerManaer
    }
    
    var body: some View {
        switch tabViewDataManager.getTabType() {
        case .newTabView:
            NewTabView(tabViewTypeManager: tabViewDataManager,id:id)
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
