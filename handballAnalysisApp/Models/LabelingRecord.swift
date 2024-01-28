//
//  LabelingRecord.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI
import TabularData


struct LabelingRecord: Identifiable {
    public let id: UUID
    public var team: TeamType?
    public var time: String?
    public var result =  Result()
    public var assist: String?
    public var action: String?
    public var goalkeeper: String?
    public var actionDetail: String?
    public var addition: String?
    public var additionContact: Bool = false
    public var additionReversehand: Bool = false
    public var additionReversefoot: Bool = false
    public var assistPoint: CGPoint?
    public var catchPoint: CGPoint?
    public var actionPoint: CGPoint?
    public var goalPoint: CGPoint?
}



class LabelingRecordListManager: ObservableObject {    
    @Published var temporaryRecord: LabelingRecord
    @Published var gameCsvPath:String? = nil
    @Published var handballCourtMarkerType:HandballCourtMarkerType
    @Published var isPressedInCourt:Bool = false
    @Published var showAlert:Bool = false
    @Published var alertText:String = ""
    
    init(id:UUID){
        self.temporaryRecord = LabelingRecord(id:id)
        self.handballCourtMarkerType = HandballCourtMarkerType()
    }
    
    //temporaryRecordのresultと一致するかを調べる
    func isResult(result:Result) -> Bool{
        return temporaryRecord.result == result
    }
    
    //temporaryRecordのassistと一致するかを調べる
    func isPlayerAssist(player:String) -> Bool{
        return temporaryRecord.assist == player
    }
    
    //temporaryRecordのactionと一致するかを調べる
    func isPlayerAction(player:String) -> Bool{
        return temporaryRecord.action == player
    }
    
    //temporaryRecordのgoalkeeperと一致するかを調べる
    func isGoalkeeper(goalkeeper:String) -> Bool{
        return temporaryRecord.goalkeeper == goalkeeper
    }
    
    //temporaryRecordのactionDetailと一致するかを調べる
    func isActionDetail(actionDetail:String) -> Bool{
        return temporaryRecord.actionDetail == actionDetail
    }
    
    
    //記録用の仮のレコードを初期化する
    func clearTemporaryRecord(){
        temporaryRecord = LabelingRecord(id:UUID())
    }
    
    //記録用の仮のレコードのteamを設定する
    func setTeamOfTemporaryRecord(teamType:TeamType){
        temporaryRecord.team = teamType
    }
    
    //記録用の仮のレコードのresultを設定する
    func setResultOfTemporaryRecord(result:Result){
        temporaryRecord.result = result
    }
    
    //記録用の仮のレコードのtimeを設定する
    func setTimeOfTemporaryRecord(time:String){
        temporaryRecord.time = time
    }
    
    //記録用の仮のレコードのassistを設定する
    func setAssistOfTemporaryRecord(assist:String?){
        temporaryRecord.assist = assist
    }
    
    //記録用の仮のレコードのactionを設定する
    func setActionOfTemporaryRecord(action:String?){
        temporaryRecord.action = action
    }
    
    //記録用の仮のレコードのactionTypeを設定する
    func setActionDetailOfTemporaryRecord(type:String){
        temporaryRecord.actionDetail = type
    }
    
    //記録用の仮のレコードにgoalkeeperを設定する
    func setGoalkeeperOfTemporaryRecord(goalkeeper:String){
        temporaryRecord.goalkeeper = goalkeeper
    }
    
    //現在のresultによって表示するアクションタイプをリストで渡す
    func getActionDetailsList() -> [String]{
        return temporaryRecord.result.getActionDetails()
    }
    
    //記録用のレコードをshow
    func showTmpRecord(){
        print(temporaryRecord)
    }
    
    //表示するmarkerのリストを取得する
    func getMarkers() -> [(HandballCourtMarkerType,String)]{
        switch temporaryRecord.result{
        case  .getPoint,.missShot:
            return [(.assistPoint,"soccerball.inverse")
                    ,(.catchPoint,"hands.clap.fill"),
                    (.actionPoint,"figure.handball")]
        case .intercept:
            if temporaryRecord.actionDetail == "ラインアウト" || temporaryRecord.actionDetail == "ルーズボール" || temporaryRecord.actionDetail == "ドリブルカット"{
                return [(.assistPoint,"soccerball.inverse")]
            }else{
                return [(.assistPoint,"soccerball.inverse"),
                        (.catchPoint,"hands.clap.fill")]
            }
        case .foul:
            if temporaryRecord.actionDetail == "チャージング" || temporaryRecord.actionDetail == "ラインクロス"{
                return [(.assistPoint,"soccerball.inverse"),
                        (.catchPoint, "hands.clap.fill"),
                        (.actionPoint,"figure.handball")]
            }else{
                return [(.assistPoint,"exclamationmark.shield.fill")]
            }
        case .none:
            return []
        }
    }

    
    //コートのmarkerを設定する
    func setMarkerPosition(markerType:HandballCourtMarkerType,point:CGPoint){
        switch markerType {
        case .assistPoint:
            temporaryRecord.assistPoint = point
        case .catchPoint:
            temporaryRecord.catchPoint = point
        case .actionPoint:
            temporaryRecord.actionPoint = point
        case .none:
            break
        }
    }
    
    func getMarkerPosition(markerType:HandballCourtMarkerType) -> CGPoint?{
        switch markerType {
        case .assistPoint:
            return temporaryRecord.assistPoint
        case .catchPoint:
            return temporaryRecord.catchPoint
        case .actionPoint:
            return temporaryRecord.actionPoint
        case .none:
            return nil
        }
    }
    
    //gamecsvを作成する
    func createNewGameCsv(){
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "gamefile.csv"
        if panel.runModal() == .OK {
            // ユーザーが保存を選択した場合の処理
            if let selectedURL = panel.url {
                // selectedURLにファイルが保存されます
//                ["チーム","時間","結果","アシスト","アクション",
//                 "ゴールキーパー","詳細","追加情報","パスx","パスy",
//                 "キャッチx","キャッチy","シュートx","シュートy",
//                 "ゴールx","ゴールy"]
                let data : DataFrame = ["チーム":["データ例"],
                                        "時間":["00:00"],
                                        "結果":["得点orシュートミス"],
                                        "アシスト":["選手名"],
                                        "アクション":["選手名"],
                                        "ゴールキーパー":["選手名"],
                                        "詳細":["クイックorノーマルorスロー"],
                                        "追加情報":["接触_逆足_..."],
                                        "アシストx":[0.0],
                                        "アシストy":[0.0],
                                        "キャッチx":[0.0],
                                        "キャッチy":[0.0],
                                        "アクションx":[0.0],
                                        "アクションy":[0.0],
                                        "ゴールx":[0.0],
                                        "ゴールy":[0.0]
                ]
                do{
                    try data.writeCSV(to: URL(fileURLWithPath:selectedURL.path))
                }catch{
                    print(error)
                }
            }
        } else {
            // キャンセルされた場合の処理
            print("Save operation canceled")
        }
    }
    
    //panelでgameCsvPathを設定する
    func setGameCsvPath() -> String?{
        let panel = NSOpenPanel()
        if panel.runModal() == .OK {
            do{
                //読み込んだpatnが正しいcsvのものかを確かめる
                let _ = try DataFrame(
                    contentsOfCSVFile: URL(fileURLWithPath: panel.url?.path ?? ""),
                    columns: ["チーム","時間","結果","アシスト","アクション",
                              "ゴールキーパー","詳細","追加情報","アシストx","アシストy",
                              "キャッチx","キャッチy","アクションx","アクションy",
                              "ゴールx","ゴールy"]
                )
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
    
    func getEmpty() -> [String]{
        var emptyList:[String] = []
        if temporaryRecord.team==nil{
            emptyList.append("team")
        }
        if temporaryRecord.time==nil{
            emptyList.append("time")
        }
        if temporaryRecord.result == .none{
            emptyList.append("result")
        }
        if temporaryRecord.assist==nil{
            emptyList.append("assist")
        }
        if temporaryRecord.action==nil{
            emptyList.append("action")
        }
        if temporaryRecord.goalkeeper==nil{
            emptyList.append("goalkeeper")
        }
        if temporaryRecord.actionDetail==nil{
            emptyList.append("actionType")
        }
        if temporaryRecord.addition==nil{
            emptyList.append("detail")
        }
        if temporaryRecord.assistPoint==nil{
            emptyList.append("assistPoint")
        }
        if temporaryRecord.catchPoint==nil{
            emptyList.append("catchPoint")
        }
        if temporaryRecord.actionPoint==nil{
            emptyList.append("actionPoint")
        }
        if temporaryRecord.goalPoint==nil{
            emptyList.append("goalPoint")
        }
        return emptyList
    }
    
    //emptyからアラートテキストを作成する
    func createAlertText(emptyList:[String]) -> String{
        var alertText = ""
        
        if emptyList.contains("team"){
            alertText += "チーム,"
        }
        if emptyList.contains("time"){
            alertText += "時間,"
        }
        if emptyList.contains("result"){
            alertText += "結果,"
        }
        if emptyList.contains("assist"){
            alertText += "アシスト,"
        }
        if emptyList.contains("action"){
            alertText += "アクション,"
        }
        if emptyList.contains("goalkeeper"){
            alertText += "ゴールキーパー,"
        }
        if emptyList.contains("actionType"){
            alertText += "詳細,"
        }
        if emptyList.contains("detail"){
            alertText += "追加情報,"
        }
        if emptyList.contains("assistPoint"){
            alertText += "アシストポイント,"
        }
        if emptyList.contains("catchPoint"){
            alertText += "キャッチポインt,"
        }
        if emptyList.contains("actionPoint"){
            alertText += "アクションポイント,"
        }
        if emptyList.contains("goalPoint"){
            alertText += "ゴールポイント,"
        }
        alertText = String(alertText.dropLast())
        
        return alertText
    }
    
    //temporaryRecordに足りない情報がないか調べる
    func checkCompleteness() -> [String]{
        let onlyInActual:[String]
        //teamはタブを切り替えたときに初期化されるので調べない
        //resultを確認する
        let result = temporaryRecord.result
            //resultによって埋める情報が違う
        switch result {
        case .getPoint,.missShot,.none:
            let assumptionEmpty:[String] = []//からでも良い要素のリスト
            let actualEmpty = getEmpty()//実際にからである要素のリスト
            //セットに変換
            let setAssumptionEmpty = Set(assumptionEmpty)
            let setActualEmpty = Set(actualEmpty)
            //想定していないから要素のリスト
            onlyInActual = Array(setActualEmpty.subtracting(setAssumptionEmpty))
        case .intercept:
            //actiontypeがラインアウト、ルーズボール、ドリブルカットの場合
            if["ラインアウト","ルーズボール","ドリブルカット"].contains(temporaryRecord.actionDetail){
                let assumptionEmpty:[String] = ["action","goalkeeper","catchPoint","actionPoint","goalPoint"]//からでも良い要素のリスト
                let actualEmpty = getEmpty()//実際にからである要素のリスト
                //セットに変換
                let setAssumptionEmpty = Set(assumptionEmpty)
                let setActualEmpty = Set(actualEmpty)
                //想定していないから要素のリスト
                onlyInActual = Array( setActualEmpty.subtracting(setAssumptionEmpty))
            }else{
                //actiontypeがラインアウト、ルーズボール、ドリブルカット以外の場合
                let assumptionEmpty:[String] = ["goalkeeper","actionPoint","goalPoint"]//からでも良い要素のリスト
                let actualEmpty = getEmpty()//実際にからである要素のリスト
                //セットに変換
                let setAssumptionEmpty = Set(assumptionEmpty)
                let setActualEmpty = Set(actualEmpty)
                //想定していないから要素のリスト
                onlyInActual = Array(setActualEmpty.subtracting(setAssumptionEmpty))
            }
        case .foul:
            //actiontypeがキック、オーバーステップ、ダブルドリブル、その他の場合
            if["キック", "オーバーステップ", "ダブルドリブル", "その他"].contains(temporaryRecord.actionDetail){
                let assumptionEmpty:[String] = ["action","goalkeeper","catchPoint","actionPoint","goalPoint"]//からでも良い要素のリスト
                let actualEmpty = getEmpty()//実際にからである要素のリスト
                //セットに変換
                let setAssumptionEmpty = Set(assumptionEmpty)
                let setActualEmpty = Set(actualEmpty)
                //想定していないから要素のリスト
                onlyInActual = Array(setActualEmpty.subtracting(setAssumptionEmpty))
                
            }else{
                //actiontypeがキック、オーバーステップ、ダブルドリブル、その他以外bの場合
                let assumptionEmpty:[String] = ["goalkeeper","goalPoint"]//からでも良い要素のリスト
                let actualEmpty = getEmpty()//実際にからである要素のリスト
                //セットに変換
                let setAssumptionEmpty = Set(assumptionEmpty)
                let setActualEmpty = Set(actualEmpty)
                //想定していないから要素のリスト
                onlyInActual = Array(setActualEmpty.subtracting(setAssumptionEmpty))
            }
        }
        return onlyInActual
    }

    //追加情報をまとめる
    func mergeAddition(){
        var addition = ""
        if temporaryRecord.additionContact{
            addition += "接触"
        }
        if temporaryRecord.additionReversefoot{
            addition += "逆足"
        }
        if temporaryRecord.additionReversehand{
            addition += "逆手"
        }
        temporaryRecord.addition = addition
    }
    
    
    
    //データをgameCsvに追加する
    func addRecordCsv(){
        //additionをまとめる
        mergeAddition()
        //temporaryRecordに足りない情報がないか調べる
        let onlyInActual = checkCompleteness()
        
        //足りない情報がある場合
        if onlyInActual.isEmpty{
            
            if let csvPath = gameCsvPath{
                //csvを一度読み込む
                do{
                    var csvdata = try DataFrame(
                        contentsOfCSVFile: URL(fileURLWithPath: self.gameCsvPath ?? ""),
                        columns: ["チーム","時間","結果","アシスト","アクション",
                                  "ゴールキーパー","詳細","追加情報","アシストx","アシストy",
                                  "キャッチx","キャッチy","アクションx","アクションy",
                                  "ゴールx","ゴールy"]
                    )
                    //temporaryRecordを追加する
                    csvdata.append(
                        row:temporaryRecord.team,
                        temporaryRecord.time,
                        temporaryRecord.result.description(),
                        temporaryRecord.assist,
                        temporaryRecord.action,
                        temporaryRecord.goalkeeper,
                        temporaryRecord.actionDetail,
                        temporaryRecord.addition,
                        Double(temporaryRecord.assistPoint?.x ?? 0),
                        Double(temporaryRecord.assistPoint?.y ?? 0),
                        Double(temporaryRecord.catchPoint?.x ?? 0),
                        Double(temporaryRecord.catchPoint?.y ?? 0),
                        Double(temporaryRecord.actionPoint?.x ?? 0),
                        Double(temporaryRecord.actionPoint?.y ?? 0),
                        Double(temporaryRecord.goalPoint?.x ?? 0),
                        Double(temporaryRecord.goalPoint?.y ?? 0)
                    )
                    //csvに上書きする
                    try csvdata.writeCSV(to: URL(fileURLWithPath: csvPath))
                }catch{
                    print("書き込みに失敗したよ")
                    print(error)
                }
            }else{
                print("csvpathが設定されていない")
            }
        }else{
            //足りない情報がある場合
            var alertText = createAlertText(emptyList: onlyInActual)
            alertText += "を入力してください"
            self.alertText = alertText
            self.showAlert = true
        }
    }
}

enum Result{
    case getPoint
    case missShot
    case intercept
    case foul
    case none
    
    init() {
        self = .none  // デフォルト値を設定
    }
    
    //文字列からタイプへの変換
    func stringToType(string:String) -> Result{
        if string == "得点"{
            return .getPoint
        }else if string == "シュートミス"{
            return .missShot
        }else if string == "インターセプト"{
            return .intercept
        }else if string == "反則"{
            return .foul
        }else{
            return .none
        }
    }
    
    func description() -> String{
        switch self {
        case .getPoint:
            return "得点"
        case .missShot:
            return "シュートミス"
        case .intercept:
            return "インターセプト"
        case .foul:
            return "反則"
        case .none:
            return ""
        }
    }
    
    func getActionDetails() -> [String]{
        switch self {
        case .getPoint,.missShot:
            return ["ジャンプクイック", "ジャンプノーマル", "ジャンプスロー" ,
                    "ステップクイック","ステップノーマル","ステップスロー"]
        case .intercept:
            return ["パスカット", "パスミス", "キャッチミス",
                    "ラインアウト","ルーズボール","ドリブルカット"]
        case .foul:
            return ["チャージング", "ラインクロス", "キック", "オーバーステップ", "ダブルドリブル", "その他"]
        case .none:
            return []
        }
    }
}

enum HandballCourtMarkerType{
    case assistPoint
    case catchPoint
    case actionPoint
    case none
    
    init(){
        self = .none
    }
    
    func getColor() -> Color{
        switch self {
        case .assistPoint:
            return Color.yellow
        case .catchPoint:
            return Color.green
        case .actionPoint:
            return Color.red
        case .none:
            return Color.white
        }
    }
}


