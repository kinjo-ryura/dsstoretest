//
//  DisplayRecordManager.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/24.
//

import SwiftUI
import TabularData

class DisplayRecordManager: ObservableObject {
    @Published var displayRecordList:[DisplayRecord] = []
    @Published var selectionId:DisplayRecord.ID? = nil
    @Published var selectionRecord:DisplayRecord?
    @Published var gameCsvPath:String? = nil
    @Published var leftTeam:String?
    @Published var rightTeam:String?
    
    
    //teamNameを取得する
    func getLeftTeamName() -> String{
        return self.leftTeam ?? ""
    }
    func getRightTeamName() -> String{
        return self.rightTeam ?? ""
    }
    
    //teamScoreを取得する
    func getLeftTeamScore() -> Int{
        let goalsCount = displayRecordList.filter { record in
            return record.team == self.leftTeam && record.result == "得点"
        }.count
        print(goalsCount)
        return goalsCount
    }
    //teamScoreを取得する
    func getRightTeamScore() -> Int{
        let goalsCount = displayRecordList.filter { record in
            return record.team == self.rightTeam && record.result == "得点"
        }.count
        print(goalsCount)
        return goalsCount
    }
    
    //チームを入れ替える
    func exchangeTeam(){
        let tmpteam = self.leftTeam
        self.leftTeam = self.rightTeam
        self.rightTeam = tmpteam
    }
    
    
    // displayRecordList内のDisplayRecordオブジェクトのteamプロパティをカウントする関数
    func countTeams() -> [String: Int] {
        var teamCounts: [String: Int] = [:]
        
        for record in displayRecordList {
            let team = record.team
            if let count = teamCounts[team] {
                teamCounts[team] = count + 1
            } else {
                teamCounts[team] = 1
            }
        }
        
        return teamCounts
    }
    
    // カウントが多い順に上位2つのチームを取得する関数
    func getTopTwoTeams() -> [String] {
        let teamCounts = countTeams()
        
        let sortedTeams = teamCounts.keys.sorted(by: { team1, team2 in
            return teamCounts[team1]! > teamCounts[team2]!
        })
        
        let topTwoTeams = Array(sortedTeams.prefix(2))
        return topTwoTeams
    }
    
    // topTwoTeamsの値をleftTeam,rightTeamに設定する
    func setTeamNames(){
        let topTwoTeams = getTopTwoTeams()
        if topTwoTeams.count == 0{
            
        }else if topTwoTeams.count == 1{
            self.leftTeam = topTwoTeams[0]
        }else if self.leftTeam == topTwoTeams[0]{
            self.leftTeam = topTwoTeams[0]
            self.rightTeam = topTwoTeams[1]
        }else if self.rightTeam == topTwoTeams[0]{
            self.leftTeam = topTwoTeams[1]
            self.rightTeam = topTwoTeams[0]
        }else{
            self.leftTeam = topTwoTeams[0]
            self.rightTeam = topTwoTeams[1]
        }
    }
    
    func getMarkerPosition(markerType:HandballCourtMarkerType) -> CGPoint?{
        switch markerType {
        case .assistPoint:
            return selectionRecord?.assistPoint
        case .catchPoint:
            return selectionRecord?.catchPoint
        case .actionPoint:
            return selectionRecord?.actionPoint
        case .none:
            return nil
        }
    }
    
    //panelでgameCsvPathを設定する
    func setGameCsvPath() -> String?{
        let panel = NSOpenPanel()
        if panel.runModal() == .OK {
            do{
                print("hiraitemiruyo")
                //読み込んだpatnが正しいcsvのものかを確かめる
                let csvData = try DataFrame(
                    contentsOfCSVFile: URL(fileURLWithPath: panel.url?.path ?? ""),
                    columns: ["チーム","時間","結果","アシスト","アクション",
                              "ゴールキーパー","詳細","追加情報","アシストx","アシストy",
                              "キャッチx","キャッチy","アクションx","アクションy",
                              "ゴールx","ゴールy"]
                )
                print("sitamojiko")
                //正しければそのpathを設定する
                self.gameCsvPath = panel.url?.path
                
                //追加する前に初期化する
                displayRecordList.removeAll()
                csvData.rows.forEach{ data in
                    let record = DisplayRecord(
                        team: data["チーム"] as? String ?? "",
                        time: data["時間"] as? String ?? "",
                        result: data["結果"] as? String ?? "",
                        assist: data["アシスト"] as? String ?? "",
                        action: data["アクション"] as? String ?? "",
                        goalkeeper: data["ゴールキーパー"] as? String ?? "",
                        actionDetail: data["詳細"] as? String ?? "",
                        addition: data["追加情報"] as? String ?? "",
                        assistPoint: CGPoint(
                            x: data["アシストx"] as? Double ?? 0,
                            y: data["アシストy"] as? Double ?? 0),
                        catchPoint: CGPoint(
                            x: data["キャッチx"] as? Double ?? 0,
                            y: data["キャッチy"] as? Double ?? 0),
                        actionPoint: CGPoint(
                            x: data["アクションx"] as? Double ?? 0,
                            y: data["アクションy"] as? Double ?? 0),
                        goalPoint: CGPoint(
                            x: data["ゴールx"] as? Double ?? 0,
                            y: data["ゴールy"] as? Double ?? 0)
                    )
                    displayRecordList.append(record)
                    
                }
                setTeamNames()
                //ファイル名を返す
                return panel.url?.lastPathComponent.split(separator: ".").map(String.init).first
            }catch{
                print(error)
            }
        }
        return nil
    }
    
    //gameCsvPathがnilじゃないときreloadをする
    func reloadGameCsv(){
        if let gameCsvPath{
            do{
                let csvData = try DataFrame(
                    contentsOfCSVFile: URL(fileURLWithPath: gameCsvPath),
                    columns: ["チーム","時間","結果","アシスト","アクション",
                              "ゴールキーパー","詳細","追加情報","アシストx","アシストy",
                              "キャッチx","キャッチy","アクションx","アクションy",
                              "ゴールx","ゴールy"]
                )
                //追加する前に初期化する
                displayRecordList.removeAll()
                //データを追加していく
                csvData.rows.forEach{ data in
                    let record = DisplayRecord(
                        team: data["チーム"] as? String ?? "",
                        time: data["時間"] as? String ?? "",
                        result: data["結果"] as? String ?? "",
                        assist: data["アシスト"] as? String ?? "",
                        action: data["アクション"] as? String ?? "",
                        goalkeeper: data["ゴールキーパー"] as? String ?? "",
                        actionDetail: data["詳細"] as? String ?? "",
                        addition: data["追加情報"] as? String ?? "",
                        assistPoint: CGPoint(
                            x: data["アシストx"] as? Double ?? 0,
                            y: data["アシストy"] as? Double ?? 0),
                        catchPoint: CGPoint(
                            x: data["キャッチx"] as? Double ?? 0,
                            y: data["キャッチy"] as? Double ?? 0),
                        actionPoint: CGPoint(
                            x: data["アクションx"] as? Double ?? 0,
                            y: data["アクションy"] as? Double ?? 0),
                        goalPoint: CGPoint(
                            x: data["ゴールx"] as? Double ?? 0,
                            y: data["ゴールy"] as? Double ?? 0)
                    )
                    displayRecordList.append(record)
                }
                setTeamNames()
            }catch{
                print(error)
            }
        }
    }
    
}

struct DisplayRecord: Identifiable {
    public let id: UUID = UUID()
    public var team: String
    public var time: String
    public var result: String
    public var assist: String
    public var action: String
    public var goalkeeper: String
    public var actionDetail: String
    public var addition: String
    public var assistPoint: CGPoint
    public var catchPoint: CGPoint
    public var actionPoint: CGPoint
    public var goalPoint: CGPoint
    
}
