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
            HStack{
                Text(displayRecordManager.getLeftTeamName())
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                Spacer()
                Text(displayRecordManager.getRightTeamName())
                    .foregroundStyle(.white)
                    .font(.largeTitle)
            }
            
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
                        }else if resultArray[index] == displayRecordManager.leftTeam{
                            Rectangle()
                                .frame(height: 20)
                                .foregroundColor(.clear)
                                .overlay(IncreaseLine().stroke(Color.blue, lineWidth: 2))
                        }
                    }
                    if resultArray[index] == displayRecordManager.leftTeam || resultArray[index] == displayRecordManager.rightTeam{
                        Text("\(count)")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: resultArray[index] == displayRecordManager.leftTeam ? .leading:.trailing)
                            .padding(EdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 20))
                    }
                }
            }
//            .padding(EdgeInsets(top: 20,
//                                leading: 0,
//                                bottom: 10,
//                                trailing: 0))
            .frame(maxWidth: 700,maxHeight: 900)
            .background(HandballCourtColor)
//            .clipShape(RoundedRectangle(cornerRadius: 11))
        }
        .padding(0)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
        .onAppear(perform: {
            displayRecordManager.setTeamNames()
            print(displayRecordManager.leftTeam)
        })

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
                                    
