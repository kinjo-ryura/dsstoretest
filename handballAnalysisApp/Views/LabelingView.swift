//
//  LabelingView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct LabelingView: View {
    @State var textFiledcontent = ""
    
    var body: some View {
        VStack{
            Text("labeling view")
            TextField("",text:$textFiledcontent)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(.red)
    }
}
