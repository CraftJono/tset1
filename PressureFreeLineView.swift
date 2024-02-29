import UIKit

class PressureFreeLineView: UIView {
    
    struct PointData {
        var point: CGPoint
        var estimatedPressure: CGFloat
    }

    var points: [PointData] = []
    var lastPointTime: TimeInterval = 0
    
    // 根据速度计算估算的压力值
    private func estimatedPressureFromVelocity(velocity: CGFloat) -> CGFloat {
        // 这里的公式可以根据需要调整，以获得理想的效果
        let maxPressure: CGFloat = 100.0
        let minPressure: CGFloat = 2.0
        let minVelocity: CGFloat = 50.0
        
        if velocity < minVelocity {
            return maxPressure
        } else {
            return max(minPressure, maxPressure - velocity / 200)
        }
    }
    
    // 计算两点之间的距离
    private func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            let currentTime = touch.timestamp
            points = [PointData(point: point, estimatedPressure: 5.0)]
            lastPointTime = currentTime
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            let currentTime = touch.timestamp
            
            if let lastPoint = points.last {
                let velocity = distanceBetweenPoints(lastPoint.point, point) / CGFloat(currentTime - lastPointTime)
                let estimatedPressure = estimatedPressureFromVelocity(velocity: velocity)
                points.append(PointData(point: point, estimatedPressure: estimatedPressure))
                lastPointTime = currentTime
                setNeedsDisplay()
            }
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
         
         context.setLineCap(.round)
         context.setLineJoin(.round)
         
         // 设置线条颜色
         context.setStrokeColor(UIColor.blue.cgColor)
         
         // 确保在开始绘制线之前，已经移动到第一个点
         if let firstPointData = points.first {
             context.move(to: firstPointData.point)
             context.setLineWidth(firstPointData.estimatedPressure)
         }
         
         for pointData in points {
             context.addLine(to: pointData.point)
             context.setLineWidth(pointData.estimatedPressure)
             context.strokePath() // 绘制路径并开始新的路径
             context.move(to: pointData.point) // 移动到当前点，为下一条线做准备
         }
    }
}
 
