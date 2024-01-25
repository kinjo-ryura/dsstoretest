//
//  DisplayCourtView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/25.
//

import SwiftUI

struct DisplayCourtView: View {
    @ObservedObject var displayRecordManager: DisplayRecordManager
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
                
                let color = Color.white
                
                
                
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
                
                commonArcs.forEach { arc in
                    context.stroke(Path { path in
                        path.addArc(center: CGPoint(x: arc.centerX, y: arc.centerY), radius: arc.radius, startAngle: .degrees(arc.startAngle), endAngle: .degrees(arc.endAngle), clockwise: false)
                    }, with: .color(color), lineWidth: canvasWidth/22*0.05)
                }
                
                let pairMarkers:[(HandballCourtMarkerType,HandballCourtMarkerType)] = [
                    (.assistPoint,.catchPoint),
                    (.catchPoint,.actionPoint),
                ]
                
                pairMarkers.forEach{from, to in
                    if let start = displayRecordManager.getMarkerPosition(markerType: from),
                       let end = displayRecordManager.getMarkerPosition(markerType: to){
                        let fixedStart = CGPoint(x:canvasWidth * (start.x / 22 + 0.5),y:canvasHeight * (0.5 - start.y / 42))
                        let fixedEnd = CGPoint(x:canvasWidth * (end.x / 22 + 0.5),y:canvasHeight * (0.5 - end.y / 42))
                        var path = Path()
                        path.move(to:fixedStart)
                        path.addLine(to:fixedEnd)
                        // 点線のスタイルを設定
                        let dashStyle = StrokeStyle(lineWidth: canvasWidth/22*0.2, dash: [10,from == .assistPoint ? 10 : 0])
                        // 点線を描画
                        context.stroke(path, with: .color(from == .assistPoint ? .yellow : .red), style: dashStyle)
                        
                        // 矢印の先端（三角形）を描画
                        
                        var arrowPoints:[CGPoint] = [
                            CGPoint(x: -18, y: 0), //矢印の先端
                            CGPoint(x: -100, y: -45), //矢印の左下
                            CGPoint(x: -100, y: 45), //矢印の右上
                            
                        ]
                        
                        let theta = atan2(fixedEnd.y - fixedStart.y, fixedEnd.x - fixedStart.x)
                        let arrowSize = canvasWidth/22*1.3
                        
                        for i in 0...2{
                            arrowPoints[i].x =  arrowPoints[i].x * arrowSize/100
                            arrowPoints[i].y =  arrowPoints[i].y * arrowSize/100
                            
                            let x = arrowPoints[i].x
                            let y = arrowPoints[i].y
                            
                            arrowPoints[i].x = x*cos(theta) - y*sin(theta)
                            arrowPoints[i].y = x*sin(theta) + y*cos(theta)
                            
                            arrowPoints[i].x +=  fixedEnd.x
                            arrowPoints[i].y +=  fixedEnd.y
                        }
                        
                        var arrowPath = Path()
                        arrowPath.move(to: arrowPoints[0])
                        arrowPath.addLine(to: arrowPoints[1])
                        arrowPath.addLine(to: arrowPoints[2])
                        arrowPath.closeSubpath()
                        
                        context.fill(arrowPath, with: .color(from == .assistPoint ? .yellow : .red))
                    }
                }
                
                let markers:[HandballCourtMarkerType] = [
                    .assistPoint,
                    .catchPoint,
                    .actionPoint,
                ]
                
                markers.forEach{ marker in
                    if let point = displayRecordManager.getMarkerPosition(markerType: marker){
                        let x = canvasWidth * (point.x / 22 + 0.5)
                        let y = canvasHeight * (0.5 - point.y / 42)
                        context.fill(Path(ellipseIn: CGRect(x: x - canvasWidth/5*0.08, y: y-canvasWidth/5*0.08, width: canvasWidth/5*0.16, height: canvasWidth/5*0.16)), with: .color(marker.getColor()))
                    }
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
//                        let x = (newPoint.x / canvasWidth*22 - 11)
//                        let y =  (21 - newPoint.y / canvasHeight*42)
//                        labelingRecordListManager.setMarkerPosition(markerType: labelingRecordListManager.handballCourtMarkerType, point: CGPoint(x:x, y:y))
//                        labelingRecordListManager.isPressedInCourt = true
//                    }
//                    .onEnded { _ in
//                        labelingRecordListManager.isPressedInCourt = false
//                    }
//            )
        }
        .padding(EdgeInsets(top: 50,
                            leading: 10,
                            bottom: 10,
                            trailing: 10))
        .frame(minWidth: 1, minHeight: 1)
        .background(secondaryColor)
    }
}

