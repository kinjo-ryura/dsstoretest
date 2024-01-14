//
//  PositionDragDelegate.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/12.
//

import SwiftUI
import UniformTypeIdentifiers


struct PositionDragDelegation: DropDelegate {
    let teamType: TeamType
    let position: Position
    @ObservedObject var teamDataManager:TeamDataManager
    
    func performDrop(info: DropInfo) -> Bool {
        guard let provider = info.itemProviders(for: [UTType.text]).first else {
            print("false")
            return false
        }
        
        provider.loadObject(ofClass: NSString.self) { item, error in
            
            
            
            let player = item as! String
            print(player)
            print(position)
            
            teamDataManager.setPositionPlayer(teamType: teamType,position: position, player: player)
            
        }
        return true
    }
}


enum Position{
    case leftWing
    case rightWing
    case leftBack
    case rightBack
    case centerBack
    case pivot
    case nonPosition
}
