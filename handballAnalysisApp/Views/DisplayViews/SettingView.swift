//
//  SettingView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/25.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var displayRecordManager: DisplayRecordManager
    @EnvironmentObject var tabListManager:TabListManager
    let id: UUID
    
    var body: some View {
        VStack{
            Button(action: {
                var csvName = displayRecordManager.setGameCsvPath()
                if let csvName{
                    tabListManager.setContentTitle(id: id, newTitle: csvName)
                }

            }, label: {
                Text("gamecsv")
            })
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}

