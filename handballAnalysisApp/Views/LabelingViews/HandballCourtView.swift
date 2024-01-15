//
//  HandballCourtView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI

struct HandballCourtView: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @State var canvasWidth: CGFloat = 10
    @State var canvasHeight: CGFloat = 10
    var body: some View {
            GeometryReader { geometory in
                Canvas { context, size in
                    if geometory.size.width/geometory.size.height < 22/42 {
                        canvasWidth = geometory.size.width
                        canvasHeight = canvasWidth*42/22
                    } else {
                        canvasHeight = geometory.size.height
                        canvasWidth = canvasHeight*22/42
                    }
                    
                    //                switch marker {
                    //                case "pass":
                    //                    color = .yellow
                    //                case "catch":
                    //                    color = .blue
                    //                default:
                    //                    color = .red
                    //                }
                    let marker = labelingRecordListManager.handballCourtMarkerType
                    let color = marker.getColor()
                    
                    
                    let lines: [CGRect] = [
                        CGRect(x: canvasWidth/22*1, y: canvasHeight/42*1, width: canvasWidth/22*20, height: canvasWidth/22*0.05),
                        CGRect(x: canvasWidth/22*1, y: canvasHeight/42*1, width: canvasWidth/22*0.05, height: canvasHeight/42*40),
                        CGRect(x: canvasWidth/22*21, y: canvasHeight/42*1, width: canvasWidth/22*0.05, height: canvasHeight/42*40),
                        CGRect(x: canvasWidth/22*1, y: canvasHeight/42*41, width: canvasWidth/22*20, height: canvasWidth/22*0.05),
                        CGRect(x: canvasWidth/22*1, y: canvasHeight/42*21, width: canvasWidth/22*20, height: canvasWidth/22*0.05),
                        CGRect(x: canvasWidth/22*9.5, y: canvasHeight/42*7, width: canvasWidth/22*3, height: canvasWidth/22*0.05),
                        CGRect(x: canvasWidth/22*9.5, y: canvasHeight/42*10, width: canvasWidth/22*3, height: canvasWidth/22*0.05),
                        CGRect(x: canvasWidth/22*9.5, y: canvasHeight/42*32, width: canvasWidth/22*3, height: canvasWidth/22*0.05),
                        CGRect(x: canvasWidth/22*9.5, y: canvasHeight/42*35, width: canvasWidth/22*3, height: canvasWidth/22*0.05),
                    ]
                    
                    lines.forEach { rect in
                        context.fill(Path(rect), with: .color(color))
                    }
                    
                    //                let merkers: [(point: CGPoint?, color: Color)] = [
                    //                    (record.shootPoint, .red),
                    //                    (record.passPoint, .yellow),
                    //                    (record.catchPoint, .blue)
                    //                ]
                    
                    //                merkers.forEach{ merker in
                    //                    if let point = merker.point {
                    //                        let x = canvasWidth * (point.x / 22 + 0.5)
                    //                        let y = canvasHeight * (0.5 - point.y / 42)
                    //                        context.fill(Path(ellipseIn: CGRect(x: x - canvasWidth/5*0.08, y: y-canvasWidth/5*0.08, width: canvasWidth/5*0.16, height: canvasWidth/5*0.16)), with: .color(merker.color))
                    //                    }
                    //                }
                    
                    // 共通の円弧描画
                    let commonArcs = [
                        (centerX: canvasWidth/22*9.5, centerY: canvasHeight/42*1, startAngle: 90.0, endAngle: 180.0, radius:canvasWidth/22*6),
                        (centerX: canvasWidth/22*12.5, centerY: canvasHeight/42*1, startAngle: 0.0, endAngle: 90.0, radius:canvasWidth/22*6),
                        (centerX: canvasWidth/22*9.5, centerY: canvasHeight/42*41, startAngle: 180.0, endAngle: 270.0, radius:canvasWidth/22*6),
                        (centerX: canvasWidth/22*12.5, centerY: canvasHeight/42*41, startAngle: 270.0, endAngle: 360.0, radius:canvasWidth/22*6),
                        (centerX: canvasWidth/22*9.5, centerY: canvasHeight/42*1, startAngle: 90.0, endAngle: 158.0, radius:canvasWidth/22*9),
                        (centerX: canvasWidth/22*12.5, centerY: canvasHeight/42*1, startAngle: 21.0, endAngle: 90.0, radius:canvasWidth/22*9),
                        (centerX: canvasWidth/22*9.5, centerY: canvasHeight/42*41, startAngle: 202.0, endAngle: 270.0, radius:canvasWidth/22*9),
                        (centerX: canvasWidth/22*12.5, centerY: canvasHeight/42*41, startAngle: 270.0, endAngle: 339.0, radius:canvasWidth/22*9)
                    ]
                    
                    // 同じパターンの描画を繰り返し
                    
                    
                    commonArcs.forEach { arc in
                        context.stroke(Path { path in
                            path.addArc(center: CGPoint(x: arc.centerX, y: arc.centerY), radius: arc.radius, startAngle: .degrees(arc.startAngle), endAngle: .degrees(arc.endAngle), clockwise: false)
                        }, with: .color(color), lineWidth: canvasWidth/22*0.05)
                    }
                    
                    
                }
                .background(HandballCourtColor)
                .frame(width: canvasWidth, height: canvasHeight)
                .position(x: geometory.size.width / 2, y: geometory.size.height / 2)
                //            .gesture(
                //                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                //                    .onChanged { value in
                //                        var newPoint = value.location
                //                        let difposX = geometory.size.width - canvasWidth
                //                        let difposY = geometory.size.height - canvasHeight
                //                        newPoint = CGPoint(x: newPoint.x - difposX/2, y: newPoint.y - difposY/2)
                //                        if marker == "catch"{
                //                            let x = (newPoint.x / canvasWidth*22 - 11)
                //                            let y =  (21 - newPoint.y / canvasHeight*42)
                //                            //                                catchxy = CGPoint(x: x, y: y)
                //                            record.catchPoint = CGPoint(x: x, y: y)
                //
                //                        }else if marker == "shoot"{
                //                            let x = (newPoint.x / canvasWidth*22 - 11)
                //                            let y = (21 - newPoint.y / canvasHeight*42)
                //                            //                                shootxy = CGPoint(x: x, y: y)
                //                            record.shootPoint = CGPoint(x: x, y: y)
                //                        }else{
                //                            let x = (newPoint.x / canvasWidth*22 - 11)
                //                            let y = (21 - newPoint.y / canvasHeight*42)
                //                            //                                assistxy = CGPoint(x: x, y: y)
                //                            record.passPoint = CGPoint(x: x, y: y)
                //                        }
                //                        isMousePressed = true
                //                    }
                //                    .onEnded { _ in
                //                        isMousePressed = false
                //                    }
                //            )
            }
        .background(secondaryColor)
        .frame(minWidth: 1, minHeight: 1)
    }
}


