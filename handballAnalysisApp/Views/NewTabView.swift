//
//  NewTabViewj.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

struct NewTabView: View {
    @EnvironmentObject var tabListManager:TabListManager
    let id:UUID
    
    var body: some View {
        VStack{
            HStack{
                Text("ハンドボール分析アプリ")
                    .bold()
                    .font(.system(size: 50))
                    .foregroundStyle(handballGoalWhite)
                Spacer()
            }.padding(EdgeInsets(top: 70,
                                 leading: 110,
                                 bottom: 0,
                                 trailing: 0))
            HStack{
                Button {
                    tabListManager.setTabType(id:id, tabViewType: .labelingTabView)
                    tabListManager.setContentTitle(id: id, newTitle: "データ記録")
                } label: {
                    HStack{
                        Image(systemName: "square.and.pencil")
                            .font(.title)
                        Text("データ記録")
                            .font(.title2)
                            .padding(EdgeInsets(top: 7,
                                                leading: 0,
                                                bottom: 0,
                                                trailing: 0))
                    }.foregroundStyle(handballGoalWhite)
                }.onHover { inside in
                    if inside {
                        NSCursor.pointingHand.set() // ポインタカーソルに変更
                    } else {
                        NSCursor.arrow.set() // 通常の矢印カーソルに戻す
                    }
                }
                Spacer()
            }.padding(EdgeInsets(top: 100,
                                 leading: 150,
                                 bottom: 0,
                                 trailing: 0))
            HStack{
                Button {
                    tabListManager.setTabType(id: id, tabViewType: .displayTabView)
                    tabListManager.setContentTitle(id: id, newTitle: "スコアボード")
                } label: {
                    HStack{
                        Image(systemName: "list.dash")
                            .font(.title)
                        Text("スコアボード")
                            .font(.title2)
                            .padding(EdgeInsets(top: 3,
                                                leading: 0,
                                                bottom: 0,
                                                trailing: 0))
                    }.foregroundStyle(handballGoalWhite)
                     
                }.onHover { inside in
                    if inside {
                        NSCursor.pointingHand.set() // ポインタカーソルに変更
                    } else {
                        NSCursor.arrow.set() // 通常の矢印カーソルに戻す
                    }
                }
                Spacer()
            }.padding(EdgeInsets(top: 30,
                                 leading: 150,
                                 bottom: 0,
                                 trailing: 0))
            Spacer()

        }.frame(maxWidth: .infinity,maxHeight: .infinity)
            .clipShape(.rect(
                topLeadingRadius: 8,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 8
            ))
            .buttonStyle(.plain)
    }
}

