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
    @Published var gameCsvPath:String? = nil
    
    
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
                              "ゴールキーパー","詳細","追加情報","パスx","パスy",
                              "キャッチx","キャッチy","シュートx","シュートy",
                              "ゴールx","ゴールy"]
                )
                print("sitamojiko")
                //正しければそのpathを設定する
                self.gameCsvPath = panel.url?.path
                
                
                
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
                //ファイル名を返す
                return panel.url?.lastPathComponent.split(separator: ".").map(String.init).first
            }catch{
                print(error)
            }
        }
        return nil
    }
    
}

struct DisplayRecord: Identifiable {
    public let id: UUID = UUID()
    public var team: String?
    public var time: String?
    public var result: String?
    public var assist: String?
    public var action: String?
    public var goalkeeper: String?
    public var actionDetail: String?
    public var addition: String?
    public var assistPoint: CGPoint?
    public var catchPoint: CGPoint?
    public var actionPoint: CGPoint?
    public var goalPoint: CGPoint?
    
}
