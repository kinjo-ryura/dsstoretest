//
//  LabelingView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct LabelingView: View {
    @ObservedObject var tabViewDataManager:TabViewDataManager
    
    var body: some View {
        VStack{
            Text(tabViewDataManager.getText())
            Button {
                tabViewDataManager.changeText(text: "write")
            } label: {
                Text("write")
            }
            Button {
                tabViewDataManager.changeText(text: "non")
            } label: {
                Text("non")
            }

            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(.red)
    }
}
