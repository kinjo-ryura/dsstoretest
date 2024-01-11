//
//  TeamMemberView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI

struct TeamMemberView: View {
    @ObservedObject var teamDataManager: TeamDataManager
    
    var body: some View {
        TabView(){
            PlayerView(teamType: .leftTeam,teamDataManager: teamDataManager)
                .tabItem { Text(teamDataManager.getTeamName(teamType: .leftTeam)) }
            RegisterTeamView(teamDataManager: teamDataManager)
                .tabItem { Text("チーム登録") }
            PlayerView(teamType: .rightTeam,teamDataManager: teamDataManager)
                .tabItem { Text(teamDataManager.getTeamName(teamType: .rightTeam)) }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(.gray)
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
            Divider()
            Spacer()
            Divider()
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(.blue)
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
            Divider()
            Spacer()
            Button {
                teamDataManager.readTeamCsv(teamType: .rightTeam)
            } label: {
                Text("right tam")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(.yellow)
    }
}
