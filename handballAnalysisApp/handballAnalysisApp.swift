//
//  handballAnalysisAppApp.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

@main
struct handballAnalysisAppApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var tabListManager:TabListManager = TabListManager()
                     
    
    var body: some Scene {
        WindowGroup {
            ContentView(windowDelegate: appDelegate.windowDelegate)
                .environmentObject(tabListManager)
        }
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        .windowStyle(HiddenTitleBarWindowStyle())
        
        WindowGroup(for:LocalVideoPlayer.ID.self){ $id in
            RemoteVideoView(id:id)
                .environmentObject(tabListManager)
        }
    }
}
