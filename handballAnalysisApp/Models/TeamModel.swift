//
//  TeamModel.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI
import TabularData

struct TeamData :Identifiable{
    public let id = UUID()
    public var teamName: String?
    public var teamCsvPath: String?
    public var playerList: [String:Bool] = [:]
    
    mutating func setTeamName(teamName:String){
        self.teamName = teamName
    }
}


class TeamDataManager: ObservableObject {
    @Published var leftTeam: TeamData
    @Published var rightTeam: TeamData
    
    init() {
        self.leftTeam = TeamData()
        self.rightTeam = TeamData()
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
    
    //leftかrightを指定してチーム名を取得する
    func getTeamName(teamType:TeamType) -> String{
        return getTeamData(teamType: teamType).teamName ?? ""
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
        case .rightTeam:
            rightTeam.playerList.removeAll()
        }
    }
    
    //leftかrightを指定してそのTeamDataのplayerListに要素を追加する。
    func addPlayerToPlayerList(teamType:TeamType,playerName:String){
        switch teamType{
        case .leftTeam:
            leftTeam.playerList[playerName] = false
        case .rightTeam:
            rightTeam.playerList[playerName] = false
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
                }catch{
                    print(error)
                }
            }
            //csvのファイル名からチーム名を取得する
            if let team = panel.url?.lastPathComponent{
                let teamname = team.split(separator: ".")[0]
                setTeamName(teamType: teamType, teamName: String(teamname))
            }
        }
    }
    
}

enum TeamType{
    case leftTeam
    case rightTeam
}
