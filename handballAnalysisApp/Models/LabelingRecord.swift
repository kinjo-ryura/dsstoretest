//
//  LabelingRecord.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI
import TabularData


struct LabelingRecord: Identifiable {
    public let id = UUID()
    public var team: String?
    public var time: String?
    public var result: String?
    public var assist: String?
    public var action: String?
    public var actionType: String?
    public var actionDetail: String?
    public var shootAddition: String?
    public var shootAdditionContact: Bool?
    public var shootAdditionReversehand: Bool?
    public var shootAdditionReversefoot: Bool?
    public var passPoint: CGPoint?
    public var catchPoint: CGPoint?
    public var shootPoint: CGPoint?
    public var goalPoint: CGPoint?
    
    func mergeDetail() -> String {
        var details = ""
        if shootAdditionContact == true{
            details += "接触_"
        }
        if shootAdditionReversefoot == true{
            details += "逆足_"
        }
        if shootAdditionReversehand == true{
            details += "逆手_"
        }
        return details
    }
    
    func checkElement() -> String? {
        if team == ""{
            return "チーム"
        }else if time == ""{
            return "時間"
        }else if result == ""{
            return "結果"
        }else if assist == ""{
            return "アシスト"
        }else if action == ""{
            return "アクション"
        }else if actionDetail == ""{
            return "詳細"
        }else if passPoint == nil{
            return "パスポイント"
        }else if catchPoint == nil{
            return "キャッチポイント"
        }else if shootPoint == nil{
            return "シュートポイント"
        }else if goalPoint == nil{
            return "ゴールポイント"
        }
        return nil
    }
    
    mutating func clearData(){
        team = ""
        time = ""
        result = ""
        assist = ""
        action = ""
        actionType = ""
        actionDetail = ""
        shootAddition = ""
        shootAdditionContact = false
        shootAdditionReversehand = false
        shootAdditionReversefoot = false
        passPoint = nil
        catchPoint = nil
        shootPoint = nil
        goalPoint = nil
    }
}



class LabelingRecordListManager: ObservableObject {
    @Published var labelingRecordList: [LabelingRecord]
    @Published var temporaryLabelingRecord: LabelingRecord
    @Published var csvPath:String? = nil
    @Published var team1score:Int? = nil
    @Published var team2score:Int? = nil
    
    init(){
        self.labelingRecordList = []
        self.temporaryLabelingRecord = LabelingRecord()
    }
    
    func clearRecordList() {
        labelingRecordList.removeAll()
    }
    
    func addRecord(record:LabelingRecord){
        labelingRecordList.append(record)
    }
    
    func readCsv(){
        let panel = NSOpenPanel()
        if panel.runModal() == .OK {
            self.csvPath = panel.url?.path
            self.clearRecordList()
            do{
                let csvdata = try DataFrame(
                    contentsOfCSVFile: URL(fileURLWithPath: self.csvPath ?? ""),
                    columns: ["チーム","時間","結果","アシスト","アクション",
                              "タイプ","タイミング","詳細","パスx","パスy",
                              "キャッチx","キャッチy","シュートx","シュートy",
                              "ゴールx","ゴールy"])
                csvdata.rows.forEach{ data in
                    let record = LabelingRecord(
                        team: data["チーム"] as? String ?? "",
                        time: data["時間"] as? String ?? "",
                        result: data["結果"] as? String ?? "",
                        assist: data["アシスト"] as? String ?? "",
                        action: data["アクション"] as? String ?? "",
                        actionType: data["アクションタイプ"] as? String ?? "",
                        actionDetail: data["詳細"] as? String ?? "",
                        shootAddition:(data["追加情報"] ?? "") as? String,
                        shootAdditionContact: false,
                        shootAdditionReversehand: false,
                        shootAdditionReversefoot: false,
                        passPoint: CGPoint(x:data["パスx"] as! Double,y:data["パスy"] as! Double),
                        catchPoint: CGPoint(x:data["キャッチx"] as! Double,y:data["キャッチy"] as! Double),
                        shootPoint: CGPoint(x:data["シュートx"] as! Double,y:data["シュートy"] as! Double),
                        goalPoint: CGPoint(x:data["ゴールx"] as! Double,y:data["ゴールy"] as! Double)
                    )
                    self.addRecord(record: record)
                }
            }catch{
                print(error)
            }
        }
        self.calScoreboard()
    }
    
    func reloadCsv(){
        if let csvPath = self.csvPath{
            do{
                let csvdata = try DataFrame(
                    contentsOfCSVFile: URL(fileURLWithPath: csvPath),
                    columns: ["チーム","時間","結果","アシスト","アクション",
                              "タイプ","タイミング","詳細","パスx","パスy",
                              "キャッチx","キャッチy","シュートx","シュートy",
                              "ゴールx","ゴールy"])
                csvdata.rows.forEach{ data in
                    let record = LabelingRecord(
                        team: data["チーム"] as? String ?? "",
                        time: data["時間"] as? String ?? "",
                        result: data["結果"] as? String ?? "",
                        assist: data["アシスト"] as? String ?? "",
                        action: data["アクション"] as? String ?? "",
                        actionType: data["タイプ"] as? String ?? "",
                        actionDetail: data["タイミング"] as? String ?? "",
                        shootAddition: (data["詳細"] ?? "") as? String,
                        shootAdditionContact: false,
                        shootAdditionReversehand: false,
                        shootAdditionReversefoot: false,
                        passPoint: CGPoint(x:data["パスx"] as! Double,y:data["パスy"] as! Double),
                        catchPoint: CGPoint(x:data["キャッチx"] as! Double,y:data["キャッチy"] as! Double),
                        shootPoint: CGPoint(x:data["シュートx"] as! Double,y:data["シュートy"] as! Double),
                        goalPoint: CGPoint(x:data["ゴールx"] as! Double,y:data["ゴールy"] as! Double)
                    )
                    self.addRecord(record: record)
                    print("add")
                }
            }catch{
                print(error)
            }
        }
    }
    
    func writeDataFrame(record:LabelingRecord){
        do{
            var csvdata = try DataFrame(
                contentsOfCSVFile: URL(fileURLWithPath: self.csvPath ?? ""),
                columns: ["チーム","時間","結果","アシスト","アクション",
                          "タイプ","タイミング","詳細","パスx","パスy",
                          "キャッチx","キャッチy","シュートx","シュートy",
                          "ゴールx","ゴールy"])
            let detail = record.mergeDetail()
            csvdata.append(row:
                            record.team,
                           record.time,
                           record.result,
                           record.assist,
                           record.action,
                           record.actionType,
                           record.actionDetail,
                           //                           record.shootTiming,
                           detail,
                           Double(record.passPoint?.x ?? 0),
                           Double(record.passPoint?.y ?? 0),
                           Double(record.catchPoint?.x ?? 0),
                           Double(record.catchPoint?.y ?? 0),
                           Double(record.shootPoint?.x ?? 0),
                           Double(record.shootPoint?.y ?? 0),
                           Double(record.goalPoint?.x ?? 0),
                           Double(record.goalPoint?.y ?? 0))
            if let csvPath{
                try csvdata.writeCSV(to: URL(fileURLWithPath: csvPath))
            }
        }catch{
            print(error)
        }
        
    }
    
    func calScoreboard(){
        var team1 = 0
        var team2 = 0
        for record in self.labelingRecordList{
            if record.result == "+1"{
                team1 += 1
            }else if record.result == "-1"{
                team2 += 1
            }
        }
        team1score = team1
        team2score = team2
    }
}
