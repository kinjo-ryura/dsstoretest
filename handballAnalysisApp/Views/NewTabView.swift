//
//  NewTabViewj.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct NewTabView: View {
    @EnvironmentObject var tabListManager:TabListManager
    let id:UUID
    
    var body: some View {
        VStack{
            Button {
                tabListManager.setTabType(id:id, tabViewType: .labelingTabView)
                tabListManager.setContentTitle(id: id, newTitle: "labeling")
            } label: {
                Text("labeling")
            }
            Button {
                tabListManager.setTabType(id: id, tabViewType: .displayTabView)
                tabListManager.setContentTitle(id: id, newTitle: "display")
            } label: {
                Text("display")
            }
            Spacer()

        }.frame(maxWidth: .infinity,maxHeight: .infinity)
            .clipShape(.rect(
                topLeadingRadius: 8,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 8
            ))
    }
}

