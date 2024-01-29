//
//  ContentView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

let primaryColor = Color(red: 0.04, green: 0.1, blue: 0.2)
let secondaryColor = Color(red: 0.10, green: 0.21, blue: 0.36)
let thirdColor = Color(red: 0.28, green: 0.36, blue: 0.51)
let hoverColor = Color(red: 0.06, green: 0.15, blue: 0.26)
let plusHoverColor = Color(red: 0.2, green: 0.25, blue: 0.32)
let xmarkHoverColor = Color(red: 0.22, green: 0.28, blue: 0.38)
let HandballCourtColor = Color(red:0.16, green:0.16, blue:0.16)
let handballGoalWhite = Color(red: 0.89, green: 0.9, blue: 0.91)
let handballGoalRed = Color(red: 0.85, green: 0.32, blue: 0.25)
let tintBlue = Color(red: 0.30, green: 0.58, blue: 10)

struct ContentView: View {
    @ObservedObject var windowDelegate: WindowDelegate
    @EnvironmentObject var tabListManager:TabListManager
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
            .frame(maxWidth: .infinity,maxHeight:.infinity)
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

