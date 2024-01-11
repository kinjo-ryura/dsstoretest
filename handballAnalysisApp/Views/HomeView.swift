//
//  HomeView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct HomeView: View {
//    @Binding var viewType:TabViewType
//    @Binding var viewType: TabViewType
    @State private var inputText: String = ""
    
    var body: some View {
        VStack{
//            TextField("",text:$inputText)
//            Button(action: {
//                viewType = .labelingView
//            }, label: {
//                Text("labeling view")
//            })
//            Button(action: {
//                viewType = .displayView
//            }, label: {
//                Text("display view")
//            })
            Text("homeview")
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(.pink)
    }
}


