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
            //追加情報窓
            HStack(spacing:40){
                AdditionToggle(labelingRecordListManager: labelingRecordListManager,isOn:$labelingRecordListManager.temporaryRecord.additionContact,title:"接触")
                AdditionToggle(labelingRecordListManager: labelingRecordListManager,isOn:$labelingRecordListManager.temporaryRecord.additionReversefoot,title:"逆足")
                AdditionToggle(labelingRecordListManager: labelingRecordListManager,isOn:$labelingRecordListManager.temporaryRecord.additionReversehand,title:"逆手")
                
            }
            Spacer()
            Divider()
                .background(thirdColor)
            Spacer()
            //登録窓
            //時間、チーム名、結果、アクション詳細
            HStack(spacing:0){
                Spacer()
                Spacer()
                Text(labelingRecordListManager.temporaryRecord.time ?? "*時間*")
                Spacer()
                Text(teamDataManager.getTeamName(teamType: labelingRecordListManager.temporaryRecord.team) ?? "*チーム名*")
                Spacer()
                Text(labelingRecordListManager.temporaryRecord.result.description() ?? "*結果*")
                Spacer()
                Text(labelingRecordListManager.temporaryRecord.actionDetail ?? "*アクション詳細*")
                Spacer()
                Spacer()
            }.font(.title3)
                .foregroundStyle(handballGoalWhite)
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 70, bottom: 0, trailing: 70))
            HStack(spacing:0){
                let showList = labelingRecordListManager.getRegisterViewShowList()
                //最大3までしかない
                let showListCount = showList.count
                //countの数によって表示の仕方を変える
                ForEach(0..<showListCount, id:\.self){index in
                    if index == 0{
                        //assist表示
                        Spacer()
                        Spacer()
                        Text(showList[index] ?? "*アシスト*")
                        Spacer()
                    }else if index == 1{
                        //action表示
                        Image(systemName: "arrow.right")
                        Spacer()
                        Text(showList[index] ?? "*アクション*")
                        Spacer()
                    }else if index == 2{
                        //detail表示
                        Image(systemName: "figure")
                            .padding(EdgeInsets(top: 0,
                                                leading: 0,
                                                bottom: 0,
                                                trailing: 5))
                        Text(showList[index] ?? "*ゴールキーパー*")
                        Spacer()
                        Spacer()
                    }
                }
            }.font(.title3)
                .foregroundStyle(handballGoalWhite)
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 70, bottom: 0, trailing: 70))
            HStack(spacing:0){
                Spacer()
                Spacer()
                Text(labelingRecordListManager.temporaryRecord.addition ?? "追加情報なし")
                    .font(.title3)
                    .foregroundStyle(handballGoalWhite)
                Spacer()
                if labelingRecordListManager.gameCsvPath == nil{
                    //csvpathがnilの時は読み込むボタンを表示する
                    Button(
                        action: {
                            let csvName = labelingRecordListManager.setGameCsvPath()
                            if let csvName{
                                tabListManager.setContentTitle(id: id, newTitle: csvName)
                            }
                        },label: {
                            Text("読み込む")
                                .bold()
                                .padding()
                                .frame(width: 100, height: 30)
                                .foregroundColor(handballGoalWhite)
                                .background(HandballCourtColor)
                                .clipShape(.rect(topLeadingRadius: 10,
                                                 bottomLeadingRadius: 10,
                                                 bottomTrailingRadius: 10,
                                                 topTrailingRadius: 10
                                                ))
                        }).buttonStyle(.plain)
                }else{
                    Button(
                        action: {
                            if let teamName = teamDataManager.getTeamName(teamType: labelingRecordListManager.temporaryRecord.team){
                                labelingRecordListManager.addRecordCsv(teamName: teamName)
                            }else{
                                labelingRecordListManager.showAlert = true
                                labelingRecordListManager.alertText = "チーム名が登録されていません"
                            }
                        },
                        label: {
                            Text("データ追加")
                                .bold()
                                .padding()
                                .frame(width: 100, height: 30)
                                .foregroundColor(handballGoalWhite)
                                .background(HandballCourtColor)
                                .clipShape(.rect(topLeadingRadius: 10,
                                                 bottomLeadingRadius: 10,
                                                 bottomTrailingRadius: 10,
                                                 topTrailingRadius: 10
                                                ))
                    }).buttonStyle(.plain)
                }
                Spacer()
                Spacer()
            }
            Spacer()
            
//            Button(
//                action: {labelingRecordListManager.createNewGameCsv()},
//                label: {Text("create")}
//            )
            Text(labelingRecordListManager.gameCsvPath ?? "")
                .foregroundStyle(handballGoalWhite)
                .font(.caption)
                .padding(EdgeInsets(top: 0,
                                    leading: 0,
                                    bottom: 5,
                                    trailing: 0))
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
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @Binding var isOn:Bool
    let title:String
    
    var body: some View {
        HStack{
            Text(title).foregroundStyle(.white)
            Toggle(isOn: $isOn, label: {})
                .toggleStyle(.switch)
                .tint(handballGoalRed)
                .background(tintBlue)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .onChange(of: isOn) { oldValue, newValue in
                    labelingRecordListManager.mergeAddition()
                }
        }
    }
}
