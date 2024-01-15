//
//  TeamMemberView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI
import UniformTypeIdentifiers

struct TeamMemberView: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack{
                TabView(selection: .constant(teamDataManager.getSelectedTab()),
                        content:{
                    PlayerView(
                        teamType: .leftTeam,
                        labelingRecordListManager: labelingRecordListManager,
                        teamDataManager: teamDataManager
                    )
                    .tabItem {}
                    .tag(0)
                    RegisterTeamView(
                        teamDataManager: teamDataManager
                    )
                    .tabItem {}
                    .tag(1)
                    PlayerView(
                        teamType: .rightTeam,
                        labelingRecordListManager: labelingRecordListManager,
                        teamDataManager: teamDataManager
                    )
                    .tabItem {}
                    .tag(2)
                })
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(secondaryColor)
                VStack{
                    HStack(spacing: 0){
                        teamMemberTabDivider(dividerNumber: 0, teamDataManager: teamDataManager)
                        Button(role: .none, action: {teamDataManager.setSelectedTab(select: 0)},
                               label:{
                            Text(teamDataManager.getTeamName(teamType: .leftTeam))
                                .frame(maxWidth: .infinity, maxHeight:.infinity)
                                .foregroundStyle(.white)
                                .background(teamDataManager.getSelectedTab()==0 ? secondaryColor:primaryColor)
                                .clipShape(.rect(topLeadingRadius: 5,topTrailingRadius: 5))
                        }
                        )
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        .buttonStyle(.plain)
                        .buttonBorderShape(.roundedRectangle(radius: 0))
                        .background(primaryColor)
                        .frame(width:geometry.size.width/3-12,height:32)
                        teamMemberTabDivider(dividerNumber: 1, teamDataManager: teamDataManager)
                        Button(role: .none, action: {teamDataManager.setSelectedTab(select: 1)},
                               label:{
                            Text("チーム登録")
                                .frame(maxWidth: .infinity, maxHeight:.infinity)
                                .foregroundStyle(.white)
                                .background(teamDataManager.getSelectedTab()==1 ? secondaryColor:primaryColor)
                                .clipShape(.rect(topLeadingRadius: 5,topTrailingRadius: 5))
                        }
                        )
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        .buttonStyle(.plain)
                        .buttonBorderShape(.roundedRectangle(radius: 0))
                        .background(primaryColor)
                        .frame(width:geometry.size.width/3-12,height:32)
                        teamMemberTabDivider(dividerNumber: 2, teamDataManager: teamDataManager)
                        Button(role: .none, action: {teamDataManager.setSelectedTab(select: 2)},
                               label:{
                            Text(teamDataManager.getTeamName(teamType: .rightTeam))
                                .frame(maxWidth: .infinity, maxHeight:.infinity)
                                .foregroundStyle(.white)
                                .background(teamDataManager.getSelectedTab()==2 ? secondaryColor:primaryColor)
                                .clipShape(.rect(topLeadingRadius: 5,topTrailingRadius: 5))
                        }
                        )
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        .buttonStyle(.plain)
                        .buttonBorderShape(.roundedRectangle(radius: 0))
                        .background(primaryColor)
                        .frame(width:geometry.size.width/3-12,height:32)
                        teamMemberTabDivider(dividerNumber: 3, teamDataManager: teamDataManager)
                    }
                    .background(primaryColor)
                    .frame(width:geometry.size.width,height:32)
                    Spacer()
                }
            }
        })
    }
}


struct PlayerView: View {
    let teamType: TeamType
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    
    init(teamType: TeamType,labelingRecordListManager:LabelingRecordListManager,teamDataManager: TeamDataManager) {
        self.teamType = teamType
        self.labelingRecordListManager = labelingRecordListManager
        self.teamDataManager = teamDataManager
    }
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                let results = [
                    Result.getPoint,
                    Result.missShot,
                    Result.intercept,
                    Result.foul
                ]
                ForEach(results, id: \.self) {result in
                    Button(role: .none,
                           action: {labelingRecordListManager.setResultOfTemporaryRecord(result: result)},
                           label: {Text(result.description())}
                    )
                }
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            let positions = [
                Position.leftWing,
                Position.pivot,
                Position.rightWing,
                Position.leftBack,
                Position.centerBack,
                Position.rightBack
            ]
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ], spacing: 10) {
                ForEach(positions, id: \.self) {position in
                    PlayerPositionButtom(
                        teamType:teamType,
                        player: nil,
                        position: position,
                        labelingRecordListManager: labelingRecordListManager,
                        teamDataManager: teamDataManager
                    )
                }
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            let playerList = teamDataManager.getPlayerList(teamType: teamType)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ], spacing: 10) {
                ForEach(playerList.keys.sorted(), id: \.self) {player in
                    if teamDataManager.isPlayerTrue(teamType: teamType, playerName: player) &&
                        !teamDataManager.playerHavePosition(teamType: teamType, playerName: player){
                        PlayerPositionButtom(
                            teamType:teamType,
                            player:player,
                            position: .nonPosition,
                            labelingRecordListManager: labelingRecordListManager,
                            teamDataManager: teamDataManager
                        )
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
    }
}

struct RegisterTeamView: View {
    @ObservedObject var teamDataManager: TeamDataManager
    
    var body: some View {
        VStack{
            Spacer()
            Button {
                teamDataManager.readTeamCsv(teamType: .leftTeam)
            } label: {
                Text("left tam")
            }
            Spacer()
            let leftPlayerList = teamDataManager.getPlayerList(teamType: .leftTeam)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ], spacing: 10) {
                ForEach(leftPlayerList.keys.sorted(), id: \.self) {player in
                    let buttonColor: Color = teamDataManager.isPlayerTrue(teamType: .leftTeam, playerName: player) ? .red : .black
                    Button(action: {
                        teamDataManager.togglePlayer(teamType: .leftTeam, playerName: player)
                    }, label: {
                        Text(player).foregroundStyle(buttonColor)
                    })
                }
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            Button {
                teamDataManager.readTeamCsv(teamType: .rightTeam)
            } label: {
                Text("right tam")
            }
            let rightPlayerList = teamDataManager.getPlayerList(teamType: .rightTeam)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ], spacing: 10) {
                ForEach(rightPlayerList.keys.sorted(), id: \.self) {player in
                    let buttonColor: Color = teamDataManager.isPlayerTrue(teamType: .leftTeam, playerName: player) ? .red : .black
                    Button(action: {
                        teamDataManager.togglePlayer(teamType: .rightTeam, playerName: player)
                    }, label: {
                        Text(player).foregroundStyle(buttonColor)
                    })
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
    }
}


struct teamMemberTabDivider:View {
    let dividerNumber:Int
    @ObservedObject var teamDataManager:TeamDataManager
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(secondaryColor)
                .frame(width: 9,height: 32)
            Rectangle()
                .fill(primaryColor)
                .frame(width: 9,height: 32)
                .clipShape(.rect(bottomLeadingRadius: teamDataManager.getSelectedTab()==dividerNumber-1 ? 9:0,
                                 bottomTrailingRadius: teamDataManager.getSelectedTab()==dividerNumber ? 9:0)
                )
            if !(dividerNumber==0) && !(dividerNumber==3) && !(dividerNumber==teamDataManager.getSelectedTab()) && !(dividerNumber-1==teamDataManager.getSelectedTab()){
                Rectangle()
                    .fill(secondaryColor)
                    .frame(width: 1.5, height: 16)
            }
        }
    }
}


struct PlayerPositionButtom: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager:TeamDataManager
    let teamType:TeamType
    //    let title: String?
    let player: String?
    let position: Position
    
    init(teamType:TeamType,
         //         title:String?,
         player:String?,
         position:Position,
         labelingRecordListManager:LabelingRecordListManager,
         teamDataManager:TeamDataManager
    ){
        self.teamType = teamType
        //        self.title = title
        self.player = player
        self.position = position
        self.labelingRecordListManager = labelingRecordListManager
        self.teamDataManager = teamDataManager
    }
    
    var body: some View {
        VStack{
            if let title = position.description(){
                Text(title)
                    .foregroundStyle(.white)
            }
            let playerName = position == .nonPosition ? player ?? "": teamDataManager.getPositionPlayer(teamType: teamType, position: position)
            RoundedRectangle(cornerRadius: 5)
                .fill(.white)
                .frame(width: 60,height: 25)
                .overlay(
                    Text(playerName)
                )
                .onDrag({
                    NSItemProvider(object: playerName as NSItemProviderWriting)
                })
                .onDrop(of: [UTType.text],
                        delegate: PositionDragDelegation(teamType: teamType,position: position,teamDataManager: teamDataManager))
                .onTapGesture(count: 2) {
                    labelingRecordListManager.setActionOfTemporaryRedord(action: playerName)
                }
                .onTapGesture {
                    labelingRecordListManager.setAssistOfTemporaryRedord(assist: playerName)
                }
                .onLongPressGesture {
                    //長押しでリセットするか迷っている
                }
        }
    }
}
