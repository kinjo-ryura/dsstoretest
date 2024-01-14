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
    @ObservedObject var tabViewDataManager: TabViewDataManager
    @ObservedObject var labelingRecordListManager: LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    
    
    init(title: String,
         tabViewDataManager: TabViewDataManager,
         labelingRecordListManager: LabelingRecordListManager,
         teamDataManager: TeamDataManager
    ) {
        self.id = UUID()
        self.title = title
        self.tabViewDataManager = tabViewDataManager
        self.labelingRecordListManager = labelingRecordListManager
        self.teamDataManager = teamDataManager
    }
    
    var body: some View {
        switch tabViewDataManager.getTabType() {
        case .newTabView:
            NewTabView(tabViewTypeManager: tabViewDataManager)
                .background(secondaryColor)
                .clipShape(
                    .rect(topLeadingRadius: 10,
                          topTrailingRadius: 10
                    )
                )
        case .labelingTabView:
            LabelingView(
                labelingRecordListManager: labelingRecordListManager,
                teamDataManager: teamDataManager
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
