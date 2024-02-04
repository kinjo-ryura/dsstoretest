//
//  TeamModel.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI
import TabularData

struct TeamData :Identifiable{
    public let id: UUID
    public var teamName: String?
    public var teamCsvPath: String?
    public var playerList: [String:Bool] = [:]
    public var goalKeeperList:[String:Bool] = [:]
    public var positionPlayer = PositionPlayer()
    
    
    mutating func setTeamName(teamName:String){
        self.teamName = teamName
    }
}


class TeamDataManager: ObservableObject {
    @Published var leftTeam: TeamData
    @Published var rightTeam: TeamData
    @Published var selectedTab: Int
    
    init(id:UUID) {
        self.leftTeam = TeamData(id:id)
        self.rightTeam = TeamData(id:id)
        self.selectedTab = 1
    }
    
    //leftかrightを指定してTeamDataを取得する
    func getTeamData(teamType:TeamType) -> TeamData{
        switch teamType{
        case .leftTeam:
            return leftTeam
        case .rightTeam:
            return rightTeam
        }
    }
    
    func getSelectedTab() -> Int{
        return selectedTab
    }
    
    
    func setSelectedTab(select:Int){
        selectedTab = select
    }
    
    func getPositionPlayer(teamType:TeamType,position:Position) -> String?{
        let positionPlayer = getTeamData(teamType: teamType).positionPlayer
        switch position {
        case .leftWing:
            return positionPlayer.leftWing
        case .rightWing:
            return positionPlayer.rightWing
        case .leftBack:
            return positionPlayer.leftBack
        case .rightBack:
            return positionPlayer.rightBack
        case .centerBack:
            return positionPlayer.centerBack
        case .pivot:
            return positionPlayer.pivot
        case .nonPosition:
            return nil
        }
    }
    
    func searchPosition(teamType:TeamType,player:String) ->Position{
        let positionPlayer = getTeamData(teamType: teamType).positionPlayer
        
        if positionPlayer.leftWing == player{
            return .leftWing
        }else if positionPlayer.rightWing == player{
            return .rightWing
        }else if positionPlayer.leftBack == player{
            return .leftBack
        }else if positionPlayer.rightBack == player{
            return .rightBack
        }else if positionPlayer.centerBack == player{
            return .centerBack
        }else if positionPlayer.pivot == player{
            return .pivot
        }else{
            return .nonPosition
        }
    }
    
    func setPositionPlayer(teamType:TeamType, position:Position, player:String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // ドロップ先ののポジションに割り当てられているプレイヤーを保存
            let currentPlayer = self.getPositionPlayer(teamType: teamType, position: position)
            // ドラッグ元のポジションを保存
            let pastPosition = self.searchPosition(teamType: teamType, player: player)
            
            switch teamType {
            case .leftTeam:
                switch position {
                case .leftWing:
                    leftTeam.positionPlayer.leftWing = player
                case .rightWing:
                    leftTeam.positionPlayer.rightWing = player
                case .leftBack:
                    leftTeam.positionPlayer.leftBack = player
                case .rightBack:
                    leftTeam.positionPlayer.rightBack = player
                case .centerBack:
                    leftTeam.positionPlayer.centerBack = player
                case .pivot:
                    leftTeam.positionPlayer.pivot = player
                case .nonPosition:
                    print("nonPosition")
                }
                switch pastPosition {
                case .leftWing:
                    leftTeam.positionPlayer.leftWing = currentPlayer
                case .rightWing:
                    leftTeam.positionPlayer.rightWing = currentPlayer
                case .leftBack:
                    leftTeam.positionPlayer.leftBack = currentPlayer
                case .rightBack:
                    leftTeam.positionPlayer.rightBack = currentPlayer
                case .centerBack:
                    leftTeam.positionPlayer.centerBack = currentPlayer
                case .pivot:
                    leftTeam.positionPlayer.pivot = currentPlayer
                case .nonPosition:
                    break
                }
            case .rightTeam:
                switch position {
                case .leftWing:
                    rightTeam.positionPlayer.leftWing = player
                case .rightWing:
                    rightTeam.positionPlayer.rightWing = player
                case .leftBack:
                    rightTeam.positionPlayer.leftBack = player
                case .rightBack:
                    rightTeam.positionPlayer.rightBack = player
                case .centerBack:
                    rightTeam.positionPlayer.centerBack = player
                case .pivot:
                    rightTeam.positionPlayer.pivot = player
                case .nonPosition:
                    print("nonPosition")
                }
                switch pastPosition {
                case .leftWing:
                    rightTeam.positionPlayer.leftWing = currentPlayer
                case .rightWing:
                    rightTeam.positionPlayer.rightWing = currentPlayer
                case .leftBack:
                    rightTeam.positionPlayer.leftBack = currentPlayer
                case .rightBack:
                    rightTeam.positionPlayer.rightBack = currentPlayer
                case .centerBack:
                    rightTeam.positionPlayer.centerBack = currentPlayer
                case .pivot:
                    rightTeam.positionPlayer.pivot = currentPlayer
                case .nonPosition:
                    break
                }
            }
            
            
        }
    }
    
    
    
    //leftかrightを指定してチーム名を取得する
    func getTeamName(teamType:TeamType?) -> String?{
        if let teamType{
            return getTeamData(teamType: teamType).teamName
        }else{
            return nil
        }
    }
    
    //leftかrightを指定してplayerListを取得する
    func getPlayerList(teamType:TeamType) -> [String:Bool]{
        return getTeamData(teamType: teamType).playerList
    }
    
    //leftかrightを指定してgoalKeeperListを取得する
//    func getGoalKeeperList(teamType:TeamType) -> [String:Bool]{
//        return getTeamData(teamType: teamType).goalKeeperList
//    }
    
    //leftかrightを指定してplayerlistから
    //指定した名前のBoolを返す
    func isPlayerTrue(teamType:TeamType, playerName:String) -> Bool{
        switch teamType{
        case .leftTeam:
            return leftTeam.playerList[playerName] ?? false
        case .rightTeam:
            return rightTeam.playerList[playerName] ?? false
        }
    }
    
    //leftかrightを指定してgoalKeeperListから
    //指定した名前のBoolを返す
    func isGoalKeeperTrue(teamType:TeamType, goalKeeperName:String) -> Bool{
        switch teamType{
        case .leftTeam:
            return leftTeam.goalKeeperList[goalKeeperName] ?? false
        case .rightTeam:
            return rightTeam.goalKeeperList[goalKeeperName] ?? false
        }
    }
    
    func getOppositeGoalKeeperList(teamType:TeamType?) -> [String]{
        print(teamType)
        if let teamType{
            switch teamType {
            case .leftTeam:
                print("left team")
                return rightTeam.goalKeeperList.filter { $0.value }.map { $0.key }
            case .rightTeam:
                print("right team")
                return leftTeam.goalKeeperList.filter { $0.value }.map { $0.key }
            }
        }else{
            print("else")
            return []
        }
    }
    
    //leftかrightを指定してplayerlistから
    //指定した名前のBoolを反転する
    func togglePlayer(teamType:TeamType, playerName:String){
        switch teamType{
        case .leftTeam:
            leftTeam.playerList[playerName]!.toggle()
        case .rightTeam:
            rightTeam.playerList[playerName]!.toggle()
        }
    }
    
    
    //leftかrightを指定してplayerlistから
    //指定した名前のBoolを反転する
    func toggleGoalKeeper(teamType:TeamType, goalKeeperName:String){
        switch teamType{
        case .leftTeam:
            leftTeam.goalKeeperList[goalKeeperName]!.toggle()
        case .rightTeam:
            rightTeam.goalKeeperList[goalKeeperName]!.toggle()
        }
    }
    //leftかrightを指定してplayerlistから
    //指定した名前がpositionを持っているかを返す
    func playerHavePosition(teamType:TeamType, playerName:String) -> Bool{
        if searchPosition(teamType: teamType, player: playerName) == .nonPosition{
            return false
        }else{
            return true
        }
    }
    
    //leftかrightを指定してチーム名を設定する
    func setTeamName(teamType: TeamType, teamName: String) {
        switch teamType {
        case .leftTeam:
            leftTeam.setTeamName(teamName: teamName)
        case .rightTeam:
            rightTeam.setTeamName(teamName: teamName)
        }
    }
    
    //leftかrightを指定してそのTeamDataのplayerListの要素を全削除する。
    func removeAllPlayerList(teamType:TeamType){
        switch teamType{
        case .leftTeam:
            leftTeam.playerList.removeAll()
            leftTeam.goalKeeperList.removeAll()
        case .rightTeam:
            rightTeam.playerList.removeAll()
            rightTeam.goalKeeperList.removeAll()
        }
    }
    
    //leftかrightを指定してそのTeamDataのplayerListに要素を追加する。
    func addPlayerToPlayerList(teamType:TeamType,playerName:String){
        switch teamType{
        case .leftTeam:
            leftTeam.playerList[playerName] = false
            leftTeam.goalKeeperList[playerName] = false
        case .rightTeam:
            rightTeam.playerList[playerName] = false
            rightTeam.goalKeeperList[playerName] = false
        }
    }
    
    //panelを開いてcsvを読み込む
    //leftかrightを指定してそのTeamDataのplayerListにcsvの選手を追加する
    func readTeamCsv(teamType:TeamType){
        let panel = NSOpenPanel()
        if panel.runModal() == .OK {
            if let csvPath = panel.url?.path{
                do{
                    let csvdata = try DataFrame(
                        contentsOfCSVFile: URL(fileURLWithPath: csvPath),
                        columns: ["背番号", "読み仮名", "名前"]
                    )
                    //選手を追加する前に既存の選手を削除する
                    removeAllPlayerList(teamType: teamType)
                    csvdata.rows.forEach{ data in
                        //名前がstring型で読み取り可能な時だけ追加する
                        if let playerName = data["名前"] as? String {
                            addPlayerToPlayerList(teamType: teamType, playerName: playerName)
                        }
                    }
                    //csvのファイル名からチーム名を取得する
                    if let team = panel.url?.lastPathComponent{
                        let teamname = team.split(separator: ".")[0]
                        setTeamName(teamType: teamType, teamName: String(teamname))
                    }
                }catch{
                    print(error)
                }
            }
            
        }
    }
    
}



enum TeamType{
    case leftTeam
    case rightTeam
}


struct PositionPlayer: Identifiable{
    public let id = UUID()
    public var leftWing:String?
    public var rightWing:String?
    public var leftBack:String?
    public var rightBack:String?
    public var centerBack:String?
    public var pivot:String?
    
    //なぜこれを書かないといけないのかわからない
    init(leftWing: String? = nil, rightWing: String? = nil, leftBack: String? = nil, rightBack: String? = nil, centerBack: String? = nil, pivot: String? = nil) {
        self.leftWing = leftWing
        self.rightWing = rightWing
        self.leftBack = leftBack
        self.rightBack = rightBack
        self.centerBack = centerBack
        self.pivot = pivot
    }
    
}
