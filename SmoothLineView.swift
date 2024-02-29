//
//  SmoothLineView.swift
//  补点测试
//
//  Created by zeki on 2023/11/1.
//

import UIKit

class SmoothLineView: UIView {
    struct PressurePoint {
            var point: CGPoint
            var pressure: CGFloat // 压力值
        }

        var points: [PressurePoint] = []

        // 假设这是一些示例点，你可以根据实际情况来更改它们
        let startPoint = PressurePoint(point: CGPoint(x: 100, y: 200), pressure: 2.0)
        let endPoint = PressurePoint(point: CGPoint(x: 300, y: 300), pressure: 4.0)

        override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            let interpolatedPoints = interpolatePoints(startPoint: startPoint, endPoint: endPoint)
            drawSmoothLine(points: interpolatedPoints)
        }

        private func interpolatePoints(startPoint: PressurePoint, endPoint: PressurePoint) -> [PressurePoint] {
            var points: [PressurePoint] = [startPoint]
            let numberOfPoints = calculateNumberOfPointsToInterpolate(startPoint: startPoint, endPoint: endPoint)
            
            let deltaX = (endPoint.point.x - startPoint.point.x) / CGFloat(numberOfPoints + 1)
            let deltaY = (endPoint.point.y - startPoint.point.y) / CGFloat(numberOfPoints + 1)
            let deltaPressure = (endPoint.pressure - startPoint.pressure) / CGFloat(numberOfPoints + 1)
            
            for i in 1...numberOfPoints {
                let newX = startPoint.point.x + deltaX * CGFloat(i)
                let newY = startPoint.point.y + deltaY * CGFloat(i)
                let newPressure = startPoint.pressure + deltaPressure * CGFloat(i)
                points.append(PressurePoint(point: CGPoint(x: newX, y: newY), pressure: newPressure))
            }
            
            points.append(endPoint)
            return points
        }

        private func calculateNumberOfPointsToInterpolate(startPoint: PressurePoint, endPoint: PressurePoint) -> Int {
            let distance = distanceBetweenPoints(startPoint.point, endPoint.point)
            let averageLineWidth = (startPoint.pressure + endPoint.pressure) / 2
            let pixelsPerPoint = max(10, averageLineWidth)
            return Int(distance / pixelsPerPoint)
        }

        private func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
            return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
        }

        private func drawSmoothLine(points: [PressurePoint]) {
            for point in points {
                let circlePath = UIBezierPath(arcCenter: point.point,
                                              radius: point.pressure / 2,
                                              startAngle: 0,
                                              endAngle: CGFloat.pi * 2,
                                              clockwise: true)
                UIColor.black.setStroke()
                circlePath.stroke()
             }
            
//            let path = UIBezierPath()
//            path.lineWidth = points.first?.pressure ?? 1.0
//            path.move(to: points.first?.point ?? .zero)
//
//            for point in points.dropFirst() {
//                path.addLine(to: point.point)
//                path.lineWidth = point.pressure
//                path.stroke()
//            }
        }

}
