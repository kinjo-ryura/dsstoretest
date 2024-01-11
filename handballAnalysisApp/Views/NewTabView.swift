//
//  NewTabViewj.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct NewTabView: View {
    @ObservedObject var tabViewTypeManager:TabViewTypeManager
    
    var body: some View {
        VStack{
            Button {
                tabViewTypeManager.changeTabType(tabViewType: .labelingTabView)
            } label: {
                Text("labeling")
            }
            Button {
                tabViewTypeManager.changeTabType(tabViewType: .displayTabView)
            } label: {
                Text("display")
            }

        }.frame(maxWidth: .infinity,maxHeight: .infinity)
            .clipShape(.rect(
                topLeadingRadius: 8,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 8
            ))
    }
}

