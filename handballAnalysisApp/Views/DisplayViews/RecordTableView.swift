//
//  RecordTableView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/24.
//

import SwiftUI

struct RecordTableView: View {
    @ObservedObject var displayRecordManager:DisplayRecordManager
    
    var body: some View {
        VStack{
            Table(displayRecordManager.displayRecordList,selection:$displayRecordManager.selectionId) {
                TableColumn("チーム", value:\.team)
                TableColumn("時間", value:\.time)
                TableColumn("結果", value:\.result)
                TableColumn("パス", value:\.assist)
                TableColumn("シュート", value:\.action)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onChange(of: displayRecordManager.selectionId) {
                if let selectedRecord = displayRecordManager.displayRecordList.first(where: { $0.id == displayRecordManager.selectionId }) {
                    displayRecordManager.selectionRecord = selectedRecord
                    print("選択")
                }else{
                    print("選択なし")
                }
            }
        }
        .padding(EdgeInsets(top: 50,
                            leading: 10,
                            bottom: 10,
                            trailing: 10))
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
    }
}

