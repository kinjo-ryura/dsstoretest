//
//  TeamMemberView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI
import UniformTypeIdentifiers

struct TeamMemberView: View {
    //    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack{
                TabView(selection: .constant(teamDataManager.getSelectedTab()),
                        content:{
                    PlayerView(teamType: .leftTeam,teamDataManager: teamDataManager)
                        .tabItem { Text(teamDataManager.getTeamName(teamType: .leftTeam)) }
                        .tag(0)
                    RegisterTeamView(teamDataManager: teamDataManager)
                    //                .tabItem { Text("チーム登録") }
                        .tabItem { Text("チーム登録").font(.largeTitle) }
                        .tag(1)
                    PlayerView(teamType: .rightTeam,teamDataManager: teamDataManager)
                        .tabItem { Text(teamDataManager.getTeamName(teamType: .rightTeam)) }
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
    @ObservedObject var teamDataManager: TeamDataManager
    
    init(teamType: TeamType,teamDataManager: TeamDataManager) {
        self.teamType = teamType
        self.teamDataManager = teamDataManager
    }
    
    var body: some View {
        VStack{
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            Spacer()
            let players = [
                ("左サイド",Position.leftWing),
                ("ポスト",Position.pivot),
                ("右サイド",Position.rightWing),
                ("左45",Position.leftBack),
                ("センター",Position.centerBack),
                ("右45", Position.rightBack)
            ]
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ], spacing: 10) {
                ForEach(players, id: \.0) {title, position in
                    PlayerPositionButtom(
                        teamType:teamType,
                        title: title,
                        player: nil,
                        position:position ,
                        teamDataManager: teamDataManager,
                        clickAction: {},
                        doubleClickAction: {},
                        longPressAction: {}
                    )
                }
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
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
                            title: nil,
                            player:player,
                            position: .nonPosition,
                            teamDataManager: teamDataManager,
                            clickAction: {},
                            doubleClickAction: {},
                            longPressAction: {}
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
    //    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
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
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
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
    @ObservedObject var teamDataManager:TeamDataManager
    let teamType:TeamType
    let title: String?
    let player: String?
    let position: Position
    var clickAction: () -> Void
    var doubleClickAction: () -> Void
    var longPressAction: () -> Void
    
    init(teamType:TeamType,
         title:String?,
         player:String?,
         position:Position,
         teamDataManager:TeamDataManager,
         clickAction: @escaping () -> Void,
         doubleClickAction: @escaping () -> Void,
         longPressAction: @escaping () -> Void) {
        self.teamType = teamType
        self.title = title
        self.player = player
        self.position = position
        self.teamDataManager = teamDataManager
        self.clickAction = clickAction
        self.doubleClickAction = doubleClickAction
        self.longPressAction = longPressAction
    }
    
    var body: some View {
        VStack{
            if let title{
                Text(title)
                    .foregroundStyle(.white)
            }
            let giveplayer = position == .nonPosition ? player ?? "": teamDataManager.getPositionPlayer(teamType: teamType, position: position)
            RoundedRectangle(cornerRadius: 5)
                .fill(.white)
                .frame(width: 60,height: 25)
                .overlay(
                    Text(giveplayer)
                )
                .onDrag({
                    NSItemProvider(object: giveplayer as NSItemProviderWriting)
                })
                .onDrop(of: [UTType.text],
                        delegate: PositionDragDelegation(teamType: teamType,position: position,teamDataManager: teamDataManager))
                .onTapGesture(count: 2) {
                    //                        shooter = labelingPositionManager.getPlayer(position: position)
                    self.doubleClickAction()
                }
                .onTapGesture {
                    //                        passer = labelingPositionManager.getPlayer(position: position)
                    self.clickAction()
                }
                .onLongPressGesture {
                    //                    if passer == labelingPositionManager.getPlayer(position: position){
                    //                        passer = ""
                    //                    }
                    //                    if shooter == labelingPositionManager.getPlayer(position: position){
                    //                        shooter = ""
                    //                    }
                    self.longPressAction()
                }
            //                .onHover(perform: { hovering in
            //                    if hovering{
            //                    }
            //////                        background = .black
            ////                    }else{
            //////                        background = .white
            ////                    }
            //                })
        }
    }
}
