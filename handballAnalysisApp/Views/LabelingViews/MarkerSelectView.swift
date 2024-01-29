//
//  MarkerSelectView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/14.
//

import SwiftUI

struct MarkerSelectView: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing:0){
                let markers = labelingRecordListManager.getMarkers()
                let markersCount = markers.count
                ForEach(markers,id: \.1){ marker in
                    Button(action: {
                        labelingRecordListManager.handballCourtMarkerType = marker.0
                    }, label: {
                        Image(systemName: marker.1)
                            .foregroundStyle(marker.0.getColor())
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity,maxHeight:.infinity)
                            .background(labelingRecordListManager.handballCourtMarkerType == marker.0 ? secondaryColor:primaryColor)
                    })
                    .buttonStyle(.plain)
                    .frame(width: geometry.size.width,height:geometry.size.height/CGFloat(markersCount))
                    .keyboardShortcut(marker.2, modifiers: [])
                }
            }
        }
    }
}


struct MarkerButton:View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    let title:String
    let action:()->Void
    let markerType:HandballCourtMarkerType
    
    var body: some View {
        Rectangle()
            .fill(markerType.getColor())
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .onTapGesture {
                action()
            }
    }
}
