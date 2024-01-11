//
//  TabModel.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI
import Combine

struct IdentifiableView: View, Identifiable {
    let id: UUID
    var title: String
    @ObservedObject var tabViewDataManager: TabViewDataManager
    
    init(title: String,tabViewDataManager: TabViewDataManager) {
        self.id = UUID()
        self.title = title
        self.tabViewDataManager = tabViewDataManager
    }
    
    var body: some View {
        switch tabViewDataManager.getTabType() {
        case .newTabView:
            NewTabView(tabViewTypeManager: tabViewDataManager)
        case .labelingTabView:
            LabelingView(tabViewDataManager: tabViewDataManager)
        case .displayTabView:
            DisplayView()
        }
    }
}


class TabViewDataManager:ObservableObject{
    @Published var text: String = ""
    @Published var tabViewType: TabViewType
    
    init(tabType:TabViewType) {
        self.tabViewType = tabType
    }
    
    func getText() -> String{
        return text
    }
    
    func changeText(text:String){
        self.text = text
    }
    
    func getTabType() -> TabViewType{
        return tabViewType
    }
    
    func changeTabType(tabViewType:TabViewType){
        self.tabViewType = tabViewType
    }
}




class TabListManager: ObservableObject{
    @Published var TabDataList: [IdentifiableView]
    @Published var selectedTab: UUID? = nil
    
    init() {
        self.TabDataList = []
    }
    
    func setSelectedTab(id: UUID?) {
        selectedTab = id
    }
    
    //選択されているタブのcontentを取得する
    func getSelectedTabContent() -> IdentifiableView? {
        guard let selectedTabId = selectedTab else {
            return nil  // 選択されているタブがない場合
        }
        print(selectedTabId)
        return TabDataList.first(where: { $0.id == selectedTabId })
    }
    
    //選択されているタブのタイトルを取得する
    func getContentTitle(id: UUID) -> String{
        if let tabData = TabDataList.first(where: { $0.id == id }) {
            return tabData.title
        } else {
            return ""  // タブデータが見つからない場合のデフォルト値
        }
    }
    
    //指定したidのTabDataを削除する
    func removeTabData(id: UUID) {
        if let index = TabDataList.firstIndex(where: { $0.id == id }) {
            TabDataList.remove(at: index)
        }
    }
    
    //指定したidが選択されているタブのTabData.idと一致していればtrue
    func isSelectedTab(id: UUID?) -> Bool {
        if let id{
            return selectedTab == id
        }else{
            return false
        }
    }
    
    //指定したidが選択されているタブの次のタブのTabData.idと一致していればtrue
    func isNextSelectedTab(id: UUID?) -> Bool {
        if let index = TabDataList.firstIndex(where: { $0.id == id }) {
            if TabDataList.indices.contains(index+1){
                return TabDataList[index+1].id == selectedTab
            }else{
                return false
            }
        }else{
            //idをnilで指定した場合は最初のTabDataが選択されていたらtrue
            if let firstTabData = TabDataList.first{
                if firstTabData.id == selectedTab{
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        }
    }
    
    //新たなTabDataを追加する
    func addTabData(tabData: IdentifiableView) {
        TabDataList.append(tabData)
        setSelectedTab(id: tabData.id)
    }
    
}


enum TabViewType{
    case newTabView
    case labelingTabView
    case displayTabView
    init(){
        self = .newTabView
    }
}
