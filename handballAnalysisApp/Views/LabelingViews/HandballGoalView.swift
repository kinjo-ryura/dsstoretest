//
//  HandballGoalView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI

struct HandballGoalView: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @State var canvasWidth = 10.0
    @State var canvasHeight = 10.0
    
    var body: some View {
        VStack{
            GeometryReader { geometory in
                Canvas { context, size in
                    if geometory.size.width/geometory.size.height < 5/3 {
                        canvasWidth = geometory.size.width
                        canvasHeight = canvasWidth*3/5
                    } else {
                        canvasHeight = geometory.size.height
                        canvasWidth = canvasHeight*5/3
                    }

                    
                    let goalposts : [CGRect] = [
                        CGRect(x: canvasWidth/5*0.92, y: canvasWidth/5*0.92, width: canvasWidth/5*3.16, height: canvasWidth/5*0.08),
                        CGRect(x: canvasWidth/5*0.92, y: canvasWidth/5*0.92, width: canvasWidth/5*0.08, height: canvasHeight/3*2.08),
                        CGRect(x: canvasWidth/5*4, y: canvasWidth/5*0.92, width: canvasWidth/5*0.08, height: canvasHeight/3*2.08)
                    ]
                    
                    goalposts.forEach { rect in
                        context.fill(Path(rect), with: .color(handballGoalRed))
                    }
                    
                    
                    (1...7).forEach { sidebar in
                        let x = canvasWidth/5 * (0.8 + 0.4 * Double(sidebar))
                        let y = canvasWidth/5 * 0.92
                        let width = canvasWidth/5 * 0.2
                        let height = canvasWidth/5 * 0.08
                        let goalpostWhite = CGRect(x: x, y: y, width: width, height: height)
                        context.fill(Path(goalpostWhite), with: .color(handballGoalWhite))
                    }
                    
                    (1...5).forEach { sidebar in
                        var x = canvasWidth/5 * 0.92
                        let y = canvasWidth/5 * (0.8 + 0.4 * Double(sidebar))
                        let width = canvasWidth/5 * 0.08
                        let height = canvasWidth/5 * 0.2
                        var goalpostWhite = CGRect(x: x, y: y, width: width, height: height)
                        context.fill(Path(goalpostWhite), with: .color(handballGoalWhite))
                        x = canvasWidth/5 * 4
                        goalpostWhite = CGRect(x: x, y: y, width: width, height: height)
                        context.fill(Path(goalpostWhite), with: .color(handballGoalWhite))
                    }
                    
                    if let point = labelingRecordListManager.temporaryRecord.goalPoint {
                        let x = canvasWidth * (point.x/5 + 0.5)
                        let y = canvasHeight * (1 - point.y/3)
                        context.fill(Path(ellipseIn: CGRect(x: x - canvasWidth/5*0.08, y: y - canvasWidth/5*0.08, width: canvasWidth/5*0.16, height: canvasWidth/5*0.16)), with: .color(.yellow))
                    }
                    
                }
                .background(HandballCourtColor)
                .frame(width: canvasWidth, height: canvasHeight)
                .position(x: geometory.size.width / 2, y: geometory.size.height / 2)
                            .gesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onChanged { value in
                                        var newPoint = value.location
                                        let difposX = geometory.size.width - canvasWidth
                                        let difposY = geometory.size.height - canvasHeight
                                        newPoint = CGPoint(x: newPoint.x - difposX/2, y: newPoint.y - difposY/2)
                
                                        labelingRecordListManager.temporaryRecord.goalPoint = CGPoint(x: (newPoint.x / canvasWidth*5) -  2.5, y: 3 - (newPoint.y / canvasHeight*3))
                                    }
                                    .onEnded { _ in
                                    }
                            )
            }
        }
        .background(secondaryColor)
        .frame(minWidth: 1)
    }
}
