//
//  ContentView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

let primaryColor = Color(red: 0.04, green: 0.1, blue: 0.2)
let secondaryColor = Color(red: 0.11, green: 0.2, blue: 0.36)
let hoverColor = Color(red: 0.06, green: 0.15, blue: 0.26)
let plusHoverColor = Color(red: 0.2, green: 0.25, blue: 0.32)
let xmarkHoverColor = Color(red: 0.22, green: 0.28, blue: 0.38)

struct ContentView: View {
    @ObservedObject var windowDelegate: WindowDelegate
    @ObservedObject var tabListManager = TabListManager()
    @State var toolBarStatus = false
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    
    var body: some View {
        GeometryReader{geometry in
            VStack {
                if let selectedView = tabListManager.getSelectedTabContent(){
                    selectedView
                }else{
                    EmptyView()
                }
            }
            .background(primaryColor)
            .onAppear(){
                NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {NSEvent in
                    if toolBarStatus{
                        if mouseLocation.y < windowDelegate.windowSize.height - 92{
                            toolBarStatus = false
                        }
                    }else if mouseLocation.y > windowDelegate.windowSize.height - 4{
                        toolBarStatus = true
                    }else{
                        toolBarStatus = false
                    }
                    return NSEvent
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    toolBar(windowDelegate: windowDelegate, TabListManager: tabListManager, toolBarStatus: $toolBarStatus, geometry: geometry)
                }
            }
            .toolbarBackground(primaryColor)
        }
    }
}

