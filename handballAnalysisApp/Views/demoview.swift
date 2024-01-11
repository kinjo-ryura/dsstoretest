//
//  demoview.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI

struct demoview: View {
    let color : Color
    let string : String
    
    var body: some View {
        VStack{
            Text("Hello, World")
            NewTabView()
        }.background(color)
    }
}

struct demo2view: View {
    var body: some View {
        VStack{
            Text("Hello, World")
        }.background(.green)
    }
}

