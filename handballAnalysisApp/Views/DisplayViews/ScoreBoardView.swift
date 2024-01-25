//
//  ScoreBoardView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/24.
//

import SwiftUI

struct ScoreBoardView: View {
    @ObservedObject var displayRecordManager:DisplayRecordManager
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        Text(displayRecordManager.getLeftTeamName())
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                        Text("\(displayRecordManager.getLeftTeamScore())")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .padding(EdgeInsets(top:5,
                                                leading: 0,
                                                bottom: 0,
                                                trailing: 0
                                               ))
                    }
                    Spacer()
                    HStack(spacing: 50){
                        Image(systemName: "chevron.left")
                            .font(.largeTitle)
                            .foregroundStyle(thirdColor)
                        Image(systemName: "chevron.right")
                            .font(.largeTitle)
                            .foregroundStyle(thirdColor)
                    }
                    .padding(EdgeInsets(top:25,
                                        leading: 0,
                                        bottom: 25,
                                        trailing: 0
                                       ))
                    .background(HandballCourtColor)
                    .onTapGesture {
                        displayRecordManager.exchangeTeam()
                    }
                    Spacer()
                    VStack{
                        Text(displayRecordManager.getRightTeamName())
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                        Text("\(displayRecordManager.getRightTeamScore())")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .padding(EdgeInsets(top:5,
                                                leading: 0,
                                                bottom: 0,
                                                trailing: 0
                                               ))
                    }
                    Spacer()
                }
                .padding(10)
                Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
                
                let resultArray = displayRecordManager.displayRecordList.filter { $0.result == "得点"}.map { $0.team }
                
                
                ScrollView {
                    ForEach(resultArray.indices, id: \.self) { index in
                        let count = resultArray.prefix(upTo: index).filter { $0 == resultArray[index] }.count + 1
                        
                        if index > 0 && resultArray[index - 1] != resultArray[index] {
                            if resultArray[index] == displayRecordManager.rightTeam{
                                Rectangle()
                                    .frame(height: 20)
                                    .foregroundColor(.clear)
                                    .overlay(DecreaseLine().stroke(Color.blue, lineWidth: 2))
                                    .padding(EdgeInsets(top: 2, leading: 50, bottom: 2, trailing: 50))
                            }else if resultArray[index] == displayRecordManager.leftTeam{
                                Rectangle()
                                    .frame(height: 20)
                                    .foregroundColor(.clear)
                                    .overlay(IncreaseLine().stroke(Color.blue, lineWidth: 2))
                                    .padding(EdgeInsets(top: 2, leading: 50, bottom: 2, trailing: 50))
                            }
                        }
                        if resultArray[index] == displayRecordManager.leftTeam || resultArray[index] == displayRecordManager.rightTeam{
                            Text("\(count)")
                                .font(.title)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: resultArray[index] == displayRecordManager.leftTeam ? .leading:.trailing)
                                .padding(EdgeInsets(top: 2, leading: 50, bottom: 2, trailing: 50))
                        }
                    }
                }
            }
            .frame(maxWidth: 700,maxHeight: 900)
            .background(HandballCourtColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .onAppear(perform: {
            displayRecordManager.setTeamNames()
        })
        .padding(EdgeInsets(top: 50,
                            leading: 10,
                            bottom: 10,
                            trailing: 10))
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
    }
}

struct DecreaseLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 対角線の開始点（左上）
        path.move(to: CGPoint(x: rect.minX+35, y: rect.minY-14))
        
        // 対角線の終点（右下）
        path.addLine(to: CGPoint(x: rect.maxX-35, y: rect.maxY+14))
        
        return path
    }
}

struct IncreaseLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 対角線の開始点（左上）
        path.move(to: CGPoint(x: rect.minX+35, y: rect.maxY+14))
        
        // 対角線の終点（右下）
        path.addLine(to: CGPoint(x: rect.maxX-35, y: rect.minY-14))
        
        return path
    }
}
                                    
