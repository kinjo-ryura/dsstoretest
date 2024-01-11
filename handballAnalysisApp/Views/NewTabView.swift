//
//  NewTabViewj.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct NewTabView: View {
    
    
    var body: some View {
        VStack{
            //            switch tabViewType{
            //            case .homeView:
            //                HomeView(viewType: $tabViewType)
            //            case .labelingView:
            //                LabelingView()
            //            case .displayView:
            //                DisplayView()
//        }
            Text("newtab")

            
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
            .clipShape(.rect(
                topLeadingRadius: 8,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 8
            ))
    }
}

