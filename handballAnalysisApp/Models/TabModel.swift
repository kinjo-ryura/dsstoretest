//
//  TabModel.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

//選択されているタブを記憶する
class TabListManager: ObservableObject{
    @Published var TabDataList: [MainView]
    @Published var selectedTab: UUID? = nil
    
    init() {
        self.TabDataList = []
    }
    
    func setSelectedTab(id: UUID?) {
        selectedTab = id
    }
    
    //選択されているタブのタブタイプを取得
    func getTabType(id:UUID) -> TabViewType{
        if let index = TabDataList.firstIndex(
            where:{ $0.id == id }){
            return TabDataList[index].tabViewType
        }else{
            return TabViewType.newTabView
        }
    }
    
    //選択されているタブのタブタイプを設定する
    func setTabType(id:UUID, tabViewType:TabViewType){
        if let index = TabDataList.firstIndex(
            where:{ $0.id == id }){
            TabDataList[index].tabViewType = tabViewType
        }
    }
    
    //選択されているタブのcontentを取得する
    func getSelectedTabContent() -> MainView? {
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
    
    //選択されているタブのタイトルを変更する
    func setContentTitle(id:UUID,newTitle:String){
        if let index = TabDataList.firstIndex(
            where:{ $0.id == id }){
            TabDataList[index].title = newTitle
        }
    }
    
    //選択されているタブのtabViewTypeを取得する
    func getContentTabViewType() -> TabViewType{
        if let id = selectedTab{
            return self.getTabType(id: id)
        }else{
            return TabViewType.newTabView
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
    func addTabData(tabData: MainView) {
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
    
    func getTabIcon() -> String{
        switch self {
        case .newTabView:
            "figure.handball"
        case .labelingTabView:
            "square.and.pencil"
        case .displayTabView:
            "chart.bar.fill"
        }
    }
}
