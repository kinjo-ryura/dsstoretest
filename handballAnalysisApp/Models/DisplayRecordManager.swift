//
//  DisplayRecordManager.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/24.
//

import SwiftUI
import TabularData

class DisplayRecordManager: ObservableObject {
    @Published var displayRecordList:[LabelingRecord] = []
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
                
                //ファイル名を返す
                return panel.url?.lastPathComponent.split(separator: ".").map(String.init).first
            }catch{
                print(error)
            }
        }
        return nil
    }
    
}

