//
//  WindowDelegate.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI

class WindowDelegate: NSObject, NSWindowDelegate, ObservableObject {
    @Published var isFullScreen = false
    @Published var windowSize: CGSize = .zero
    
    //フルスクリーンになったらtrue
    func windowDidEnterFullScreen(_ notification: Notification) {
        isFullScreen = true
    }
    
    //フルスクリーンが解除されたらfalse
    func windowDidExitFullScreen(_ notification: Notification) {
        isFullScreen = false
    }
    
    //ウィンドウの大きさが変わったらwindowSizeに反映する
    func windowDidResize(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            windowSize = window.frame.size
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    let windowDelegate = WindowDelegate()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.delegate = windowDelegate
        }
    }
}

