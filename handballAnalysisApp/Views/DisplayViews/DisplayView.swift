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
                if let selectionId = displayRecordManager.selectionId{
                    
                    
                }else{
                    ScoreBoardView(displayRecordManager: displayRecordManager)
                    SettingView(displayRecordManager: displayRecordManager,
                                id: id)
                }
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(thirdColor)
    }
    
}
