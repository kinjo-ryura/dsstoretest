//
//  ResultView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI

struct ResultView: View {
    var body: some View {
        VStack{
            Spacer()
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            Spacer()
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
    }
}

