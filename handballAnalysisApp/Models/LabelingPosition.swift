////
////  LabelingPosition.swift
////  handballAnalysisApp
////
////  Created by 金城瑠羅 on 2024/01/11.
////
//
//import SwiftUI
//
//struct LabelingPosition:Identifiable{
//    public let id = UUID()
//    public var leftWing: String?
//    public var rightWing: String?
//    public var leftBack: String?
//    public var rightBack: String?
//    public var centerBack: String?
//    public var pivot: String?
//}
//
//class LabelingPositionManager: ObservableObject{
//    @Published var labelingPosition:LabelingPosition
//    
//    init() {
//        self.labelingPosition = LabelingPosition()
//    }
//    
//    
//    func getPlayer(position:Position) -> String{
//        let player:String
//        switch position {
//        case .leftWing:
//            player = labelingPosition.leftWing ?? ""
//        case .rightWing:
//            player = labelingPosition.rightWing ?? ""
//        case .leftBack:
//            player = labelingPosition.leftBack ?? ""
//        case .rightBack:
//            player = labelingPosition.rightBack ?? ""
//        case .centerBack:
//            player = labelingPosition.centerBack ?? ""
//        case .pivot:
//            player = labelingPosition.pivot ?? ""
//        case .nonPosition:
//            player = ""
//        }
//        return player
//    }
//    
//    func searchPosition(player:String) ->Position{
//        if labelingPosition.leftWing == player{
//            return .leftWing
//        }else if labelingPosition.rightWing == player{
//            return .rightWing
//        }else if labelingPosition.leftBack == player{
//            return .leftBack
//        }else if labelingPosition.rightBack == player{
//            return .rightBack
//        }else if labelingPosition.centerBack == player{
//            return .centerBack
//        }else if labelingPosition.pivot == player{
//            return .pivot
//        }else{
//            return .nonPosition
//        }
//    }
//    
//    func setPositionPlayer(position:Position, player:String) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            
//            // 現在のポジションに割り当てられているプレイヤーを保存
//            let currentPlayer = self.getPlayer(position: position)
//            
//            // 新しいプレイヤーを割り当て
//            self.assignPlayer(player, to: position)
//            
//            // 以前のポジションを検索し、そのポジションと新しいポジションが異なる場合は、プレイヤーを交代
//            let previousPosition = self.searchPosition(player: player)
//            if previousPosition != position && previousPosition != .nonPosition {
//                self.assignPlayer(currentPlayer, to: previousPosition)
//            }
//        }
//    }
//    
//    private func assignPlayer(_ player: String, to position: Position) {
//        switch position {
//        case .leftWing:
//            self.labelingPosition.leftWing = player
//        case .rightWing:
//            self.labelingPosition.rightWing = player
//        case .leftBack:
//            self.labelingPosition.leftBack = player
//        case .rightBack:
//            self.labelingPosition.rightBack = player
//        case .centerBack:
//            self.labelingPosition.centerBack = player
//        case .pivot:
//            self.labelingPosition.pivot = player
//        case .nonPosition:
//            break // 何もしない
//        }
//    }
//
//        
////    
////    func setPositionPlayer(position:Position, player:String) {
////        DispatchQueue.main.async { [weak self] in
////            let tmpPosition = self?.searchPosition(player: player)
////            print(tmpPosition)
////            let tmpPlayer:String
////            switch position {
////            case .leftWing:
////                tmpPlayer = self?.labelingPosition.leftWing ?? ""
////                self?.labelingPosition.leftWing = player
////            case .rightWing:
////                tmpPlayer = self?.labelingPosition.rightWing ?? ""
////                self?.labelingPosition.rightWing = player
////            case .leftBack:
////                tmpPlayer = self?.labelingPosition.leftBack ?? ""
////                self?.labelingPosition.leftBack = player
////            case .rightBack:
////                tmpPlayer = self?.labelingPosition.rightBack ?? ""
////                self?.labelingPosition.rightBack = player
////            case .centerBack:
////                tmpPlayer = self?.labelingPosition.centerBack ?? ""
////                self?.labelingPosition.centerBack = player
////            case .pivot:
////                tmpPlayer = self?.labelingPosition.pivot ?? ""
////                self?.labelingPosition.pivot = player
////            case .nonPosition:
////                tmpPlayer = ""
////            }
////            
////            switch tmpPosition {
////            case .leftWing:
////                self?.labelingPosition.leftWing = tmpPlayer
////            case .rightWing:
////                self?.labelingPosition.rightWing = tmpPlayer
////            case .leftBack:
////                self?.labelingPosition.leftBack = tmpPlayer
////            case .rightBack:
////                self?.labelingPosition.rightBack = tmpPlayer
////            case .centerBack:
////                self?.labelingPosition.centerBack = tmpPlayer
////            case .pivot:
////                self?.labelingPosition.pivot = tmpPlayer
////            case .nonPosition:
////                break
////            case .none:
////                break
////            }
////        }
////    }
//}
