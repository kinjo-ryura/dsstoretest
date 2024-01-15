//
//  ResultView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @State  var isOn:Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            let types = labelingRecordListManager.getActionTypeList()
            let typesCount = types.count
            let typesRownum = Int(ceil(Double(typesCount) / Double(3)))
            
            ForEach(0..<typesRownum, id: \.self) { rowIndex in
                HStack {
                    Spacer()
                    ForEach(rowIndex * 3..<min(typesCount, rowIndex * 3 + 3), id: \.self) { elementIndex in
                        Button(action: {
                            // ここにボタンのアクションを記述
                        }, label: {
                            Text(types[elementIndex])
                        })
                        Spacer()
                    }
                }
            }
            
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            let details = labelingRecordListManager.getActionDetailList()
            let detailsCount = details.count
            let detailsRownum = Int(ceil(Double(detailsCount) / Double(3)))
            
            ForEach(0..<detailsRownum, id: \.self) { rowIndex in
                HStack {
                    Spacer()
                    ForEach(rowIndex * 3..<min(detailsCount, rowIndex * 3 + 3), id: \.self) { elementIndex in
                        Button(action: {
                            // ここにボタンのアクションを記述
                        }, label: {
                            Text(details[elementIndex])
                        })
                        Spacer()
                    }
                }
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            HStack{
                AdditionToggle(isOn:$labelingRecordListManager.temporaryRecord.shootAdditionContact,title:"接触")
                AdditionToggle(isOn:$labelingRecordListManager.temporaryRecord.shootAdditionReversefoot,title:"逆足")
                AdditionToggle(isOn:$labelingRecordListManager.temporaryRecord.shootAdditionReversehand,title:"逆手")
                
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            Button(
                role: .none,
                action: {labelingRecordListManager.showTmpRecord()},
                label: {Text("みせる")}
            )
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
    }
}


struct AdditionToggle: View {
    @Binding var isOn:Bool
    let title:String
    
    var body: some View {
        HStack{
            Text(title).foregroundStyle(.white)
            Toggle(isOn: $isOn, label: {})
                .toggleStyle(.switch)
                .tint(.red)
                .background(Color(red: 0.30, green: 0.58, blue: 10))
                .clipShape(RoundedRectangle(cornerRadius: 11))
        }
    }
}
