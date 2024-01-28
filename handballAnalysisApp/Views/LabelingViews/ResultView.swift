//
//  ResultView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    @EnvironmentObject var tabListManager:TabListManager
    @State  var isOn:Bool = false
    let id:UUID
    
    var body: some View {
        VStack{
            //resultがシュート関係の時だけキーパーを表示する
            let currentResult = labelingRecordListManager.temporaryRecord.result
            if currentResult == .getPoint || currentResult == .missShot{
                Spacer()
                let keeperList = teamDataManager.getOppositeGoalKeeperList(teamType: labelingRecordListManager.temporaryRecord.team)
                let keeperCount = keeperList.count
                let keeperRownum = Int(ceil(Double(keeperCount) / Double(3)))
                
                ForEach(0..<keeperRownum, id: \.self) { rowIndex in
                    HStack {
                        Spacer()
                        ForEach(rowIndex * 3..<min(keeperCount, rowIndex * 3 + 3), id: \.self) { elementIndex in
                            Button(action: {
                                labelingRecordListManager.setGoalkeeperOfTemporaryRecord(goalkeeper: keeperList[elementIndex])
                            }, label: {
                                Text(keeperList[elementIndex])
                                    .bold()
                                    .padding()
                                    .frame(width: 100, height: 30)
                                    .foregroundColor(labelingRecordListManager.isGoalkeeper(goalkeeper: keeperList[elementIndex]) ? handballGoalRed:handballGoalWhite)
                                    .background(HandballCourtColor)
                                    .clipShape(.rect(topLeadingRadius: 10,
                                                     bottomLeadingRadius: 10,
                                                     bottomTrailingRadius: 10,
                                                     topTrailingRadius: 10
                                                    ))
                            }).buttonStyle(.plain)
                            Spacer()
                        }
                    }
                }
                Spacer()
                Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            }
            Spacer()
            let details = labelingRecordListManager.getActionDetailsList()
            let detailsCount = details.count
            let detailsRownum = Int(ceil(Double(detailsCount) / Double(3)))
            
            ForEach(0..<detailsRownum, id: \.self) { rowIndex in
                HStack {
                    Spacer()
                    ForEach(rowIndex * 3..<min(detailsCount, rowIndex * 3 + 3), id: \.self) { elementIndex in
                        Button(action: {
                            labelingRecordListManager.setActionDetailOfTemporaryRecord(type: details[elementIndex])
                        }, label: {
                            Text(details[elementIndex])
                                .bold()
                                .padding()
                                .frame(width: 140, height: 30)
                                .foregroundColor(labelingRecordListManager.isActionDetail(actionDetail: details[elementIndex]) ? handballGoalRed:handballGoalWhite)
                                .background(HandballCourtColor)
                                .clipShape(.rect(topLeadingRadius: 10,
                                                 bottomLeadingRadius: 10,
                                                 bottomTrailingRadius: 10,
                                                 topTrailingRadius: 10
                                                ))
                        }).buttonStyle(.plain)
                        Spacer()
                    }
                }
            }
            
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            HStack{
                AdditionToggle(isOn:$labelingRecordListManager.temporaryRecord.additionContact,title:"接触")
                AdditionToggle(isOn:$labelingRecordListManager.temporaryRecord.additionReversefoot,title:"逆足")
                AdditionToggle(isOn:$labelingRecordListManager.temporaryRecord.additionReversehand,title:"逆手")
                
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            Button(
                role: .none,
                action: {labelingRecordListManager.showTmpRecord()
                    labelingRecordListManager.checkCompleteness()
                },
                label: {Text("みせる")}
            )
            Button(
                action: {labelingRecordListManager.createNewGameCsv()},
                label: {Text("create")}
            )
            Button(
                action: {
                    let csvName = labelingRecordListManager.setGameCsvPath()
                    if let csvName{
                        tabListManager.setContentTitle(id: id, newTitle: csvName)
                    }
                },label: {
                    Text("read")
            })
            Button(
                action: {labelingRecordListManager.addRecordCsv()},
                label: {Text("write")}
            )
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
        .alert(isPresented: $labelingRecordListManager.showAlert){
            Alert(title: Text("注意"),
                  message: Text("\(labelingRecordListManager.alertText)"),
                  dismissButton: .default(Text("OK"))
            )
        }
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
