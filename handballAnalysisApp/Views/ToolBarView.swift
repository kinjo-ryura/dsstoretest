//
//  ToolBar.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI




struct toolBar: View{
    @ObservedObject var windowDelegate: WindowDelegate
    @EnvironmentObject var tabListManager:TabListManager
    @Binding var toolBarStatus: Bool
    let geometry: GeometryProxy
    @State var plusIsHovering: Bool = false
    
    var body: some View{
        ZStack{
            if windowDelegate.isFullScreen{
                Rectangle()
                    .fill(primaryColor)
                    .frame(width: toolBarStatus ? geometry.size.width:geometry.size.width+70,height: 40)
                    .padding(EdgeInsets(top: 0, leading: -80, bottom: 0, trailing:-8))
                
            }else{
                Rectangle()
                    .fill(primaryColor)
                    .frame(width: toolBarStatus ? geometry.size.width:geometry.size.width)
                    .padding(EdgeInsets(top: 0, leading: -80, bottom: 0, trailing:-8))
                
            }
            HStack(spacing: 0){
                toolBarDivder(id: nil)
                ForEach(Array(tabListManager.TabDataList.indices), id: \.self) { index in
                    toolBarTab(id: tabListManager.TabDataList[index].id)
                        .frame(maxWidth: 180)
                    toolBarDivder(id: tabListManager.TabDataList[index].id)
                }
                ZStack{
                    Rectangle()
                        .fill(plusIsHovering ? plusHoverColor:.clear)
                        .frame(width: 25)
                        .clipShape(Circle())
                    Image(systemName: "plus")
                        .font(Font.title.weight(.light))
                        .foregroundColor(.white)
                        .frame(width: 10)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 25)
                        .clipShape(Circle())
                        .onHover { hovering in
                            plusIsHovering = hovering
                        }
                        .onTapGesture {
                            let id = UUID()
                            let newTab = MainView(
                                id:id,
                                title: "新規タブ",
                                tabViewType: .newTabView,
                                labelingRecordListManager: LabelingRecordListManager(id:id),
                                teamDataManager: TeamDataManager(id:id),
                                videoPlayerManaer: VideoPlayerManager(id:id),
                                displayRecordManager: DisplayRecordManager()
                            )
                            tabListManager.addTabData(tabData: newTab)
                        }
                }
                Spacer()
            }
        }
    }
}



struct toolBarDivder: View {
    let id: UUID?
    @EnvironmentObject var tabListManager:TabListManager
    
    init(id: UUID?) {
        self.id = id
    }
    
    var body: some View {
        ZStack{
            Rectangle().fill(secondaryColor).frame(width: 10)
            Rectangle().fill(primaryColor).frame(width: 10)
                .clipShape(.rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: tabListManager.isSelectedTab(id: id) ? 7:0,
                    bottomTrailingRadius: tabListManager.isNextSelectedTab(id: id) ? 7:0,
                    topTrailingRadius: 0
                ))

            //最初のdividerだけは常に表示しない
            if let id{
                //タブと次のタブが選択されていない時だけ表示する
                if !tabListManager.isSelectedTab(id: id) && !tabListManager.isNextSelectedTab(id: id){
                    Rectangle()
                        .fill(secondaryColor)
                        .frame(width: 1.5, height: 16)
                }
            }
        }
    }
}

struct toolBarTab: View {
    let id: UUID
    @EnvironmentObject var TabListManager:TabListManager
    @State var ishovering: Bool = false
    @State var xmarkIshovering: Bool = false
    
    
    
    init(id: UUID) {
        self.id = id
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(TabListManager.isSelectedTab(id: id) ? secondaryColor:primaryColor)
            //                .frame(width: 180,height: 33)
                .frame(height: 33)
                .clipShape(.rect(
                    topLeadingRadius: 7,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 7
                ))
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            HStack{
                Image(systemName:TabListManager.getTabType(id: id).getTabIcon())
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                Text(TabListManager.getContentTitle(id: id))
                Spacer()
                ZStack{
                    Rectangle()
                        .fill(xmarkIshovering ? xmarkHoverColor:.clear)
                        .frame(width: 16)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    Image(systemName: "xmark")
                        .font(Font.title.weight(.light))
                        .frame(width: 10)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 16)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .onHover(perform: { hovering in
                            xmarkIshovering = hovering
                        })
                        .onTapGesture {
                            TabListManager.removeTabData(id: id)
                        }
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .foregroundStyle(.white)
            //            .frame(width: 180,height: 28)
            .frame(maxWidth: .infinity,maxHeight:28)
            .background(TabListManager.isSelectedTab(id: id) ? secondaryColor:
                            ishovering ? hoverColor:primaryColor
            )
            .clipShape(.rect(
                topLeadingRadius: 7,
                bottomLeadingRadius: 7,
                bottomTrailingRadius: 7,
                topTrailingRadius: 7
            ))
            .onHover(perform: { hovering in
                ishovering = hovering
            })
            .onTapGesture {
                TabListManager.setSelectedTab(id: id)
            }
        }.frame(maxWidth: .infinity)
    }
}

