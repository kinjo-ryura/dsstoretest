//
//  ToolBar.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI


struct toolBar: View{
    @ObservedObject var windowDelegate: WindowDelegate
    @ObservedObject var tabDataManager: TabDataManager
    @Binding var toolBarStatus: Bool
    let geometry: GeometryProxy
    @State var activeTab: Int = 1
    let primaryColor = Color(red: 0.04, green: 0.1, blue: 0.2)
    let plusHoverColor = Color(red: 0.2, green: 0.25, blue: 0.32)
    @State var plusIsHovering: Bool = false
    
    var body: some View{
        ZStack{
            if windowDelegate.isFullScreen{
                Rectangle()
                //                    .fill(primaryColor)
                    .fill(.red)
                    .frame(width: toolBarStatus ? geometry.size.width:geometry.size.width+70)
                    .padding(EdgeInsets(top: 0, leading: -80, bottom: 0, trailing:-8))
                
            }else{
                Rectangle()
                    .fill(primaryColor)
                    .frame(width: toolBarStatus ? geometry.size.width:geometry.size.width)
                    .padding(EdgeInsets(top: 0, leading: -80, bottom: 0, trailing:-8))
                
            }
            HStack(spacing: 0){
                toolBarDivder(id: nil, tabDataManager:_tabDataManager)
                ForEach(Array(tabDataManager.TabDataList.indices), id: \.self) { index in
                    toolBarTab(id: tabDataManager.TabDataList[index].id, tabDataManager:_tabDataManager, icon: "figure.handball")
                        .frame(maxWidth: 180)
                    toolBarDivder(id: tabDataManager.TabDataList[index].id, tabDataManager:_tabDataManager)
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
                            var newTab = IdentifiableView(title: "tab1", colorManager: ColorManager(color: .red)) { AnyView(NewTabView()) }
                            newTab.changeContent()
                            tabDataManager.addTabData(tabData: newTab)
//                            tabDataManager.addNewTabData()
                        }
                    
                }
                Spacer()
            }
        }
    }
}



struct toolBarDivder: View {
    let id: UUID?
    @ObservedObject var tabDataManager: TabDataManager
    let primaryColor = Color(red: 0.04, green: 0.1, blue: 0.2)
    let secondaryColor = Color(red: 0.11, green: 0.2, blue: 0.36)
    
    init(id: UUID?, tabDataManager: ObservedObject<TabDataManager>) {
        self.id = id
        self._tabDataManager = tabDataManager
    }
    
    var body: some View {
        ZStack{
            Rectangle().fill(secondaryColor).frame(width: 10)
            Rectangle().fill(primaryColor).frame(width: 10)
                .clipShape(.rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: tabDataManager.isSelectedTab(id: id) ? 7:0,
                    bottomTrailingRadius: tabDataManager.isNextSelectedTab(id: id) ? 7:0,
                    topTrailingRadius: 0
                ))

            //最初のdividerだけは常に表示しない
            if let id{
                //タブと次のタブが選択されていない時だけ表示する
                if !tabDataManager.isSelectedTab(id: id) && !tabDataManager.isNextSelectedTab(id: id){
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
    @ObservedObject var tabDataManager:TabDataManager
    let icon:String
    let primaryColor = Color(red: 0.04, green: 0.1, blue: 0.2)
    let secondaryColor = Color(red: 0.11, green: 0.2, blue: 0.36)
    let hoverColor = Color(red: 0.06, green: 0.15, blue: 0.26)
    let xmarkHoverColor = Color(red: 0.22, green: 0.28, blue: 0.38)
    @State var ishovering: Bool = false
    @State var xmarkIshovering: Bool = false
    
    
    
    init(id: UUID, tabDataManager: ObservedObject<TabDataManager>, icon: String) {
        self.id = id
        self._tabDataManager = tabDataManager
        self.icon = icon
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(tabDataManager.isSelectedTab(id: id) ? secondaryColor:primaryColor)
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
                Image(systemName: icon)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                Text(tabDataManager.getContentTitle(id: id))
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
                            tabDataManager.removeTabData(id: id)
                        }
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .foregroundStyle(.white)
            //            .frame(width: 180,height: 28)
            .frame(maxWidth: .infinity,maxHeight:28)
            .background(tabDataManager.isSelectedTab(id: id) ? secondaryColor:
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
                tabDataManager.setSelectedTab(id: id)
            }
        }.frame(maxWidth: .infinity)
    }
}

