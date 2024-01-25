//
//  DisplayView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct DisplayView: View {
    @ObservedObject var displayRecordManager: DisplayRecordManager
    @EnvironmentObject var tabListManager:TabListManager
    let id:UUID

    var body: some View {
        HSplitView{
            RecordTableView(displayRecordManager: displayRecordManager)
            VSplitView{
                ScoreBoardView(displayRecordManager: displayRecordManager)
//                Button(action: {
//                    var csvName = displayRecordManager.setGameCsvPath()
//                    if let csvName{
//                        tabListManager.setContentTitle(id: id, newTitle: csvName)
//                    }
//                    
//                }, label: {
//                    Text("gamecsv")
//                })
//                Button(action: {
//                    displayRecordManager.exchangeTeam()
//                }, label: {
//                    Text("change court")
//                })
                Rectangle()
            }
        }
        .padding(0)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(thirdColor)
    }
    
}
