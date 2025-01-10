import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/nicholasdalba/Developer/Animated Set/Animated Set/View/CoolS.swift", line: 1)
//
//  CoolS.swift
//  Animated Set
//
//  Created by Nicholas Alba on 11/23/24.
//

import SwiftUI

private struct CoolSPath {
    var origin: CGPoint
    var verticalTickLength: CGFloat
    var perimeter: [CGPoint] = []
    var upperInterior: [CGPoint] = []
    var lowerInterior: [CGPoint] = []
    
    init(in rect: CGRect) {
        origin = CGPoint(x: rect.midX, y: rect.midY)
        verticalTickLength = min(rect.height / 6, rect.width / 2)
        
        var perimeterWalk = CGPoint(x: origin.x + verticalTickLength * 0.5, y: origin.y)
        perimeter.append(perimeterWalk)
        
        let topPerimeterMovements = topPerimeterMovements()
        for point in topPerimeterMovements {
            let newX = perimeterWalk.x + point.x
            let newY = perimeterWalk.y + point.y
            perimeterWalk = CGPoint(x: newX, y: newY)
            perimeter.append(perimeterWalk)
        }
        
        for point in topPerimeterMovements {
            let newX = perimeterWalk.x + -1.0 * point.x
            let newY = perimeterWalk.y + -1.0 * point.y
            perimeterWalk = CGPoint(x: newX, y: newY)
            perimeter.append(perimeterWalk)
        }
         
        upperInterior = [
            CGPoint(x: origin.x, y: origin.y - verticalTickLength * 1.5),
            CGPoint(x: origin.x, y: origin.y - verticalTickLength * 0.5),
            CGPoint(x: origin.x + verticalTickLength * 0.5, y: origin.y)]
        
        lowerInterior = [
            CGPoint(x: origin.x, y: origin.y + verticalTickLength * 1.5),
            CGPoint(x: origin.x, y: origin.y + verticalTickLength * 0.5),
            CGPoint(x: origin.x - verticalTickLength * 0.5, y: origin.y)
        ]
    }
    
    private func topPerimeterMovements() -> [CGPoint] {
        [CGPoint(x: verticalTickLength * __designTimeFloat("#12486_0", fallback: 0.5), y: verticalTickLength * __designTimeFloat("#12486_1", fallback: -0.5)),
         CGPoint(x: __designTimeInteger("#12486_2", fallback: 0), y: verticalTickLength * __designTimeFloat("#12486_3", fallback: -1.0)),
         CGPoint(x: verticalTickLength * __designTimeFloat("#12486_4", fallback: -1.0), y: verticalTickLength * __designTimeFloat("#12486_5", fallback: -1.0)),
         CGPoint(x: verticalTickLength * __designTimeFloat("#12486_6", fallback: -1.0), y: verticalTickLength),
         CGPoint(x: __designTimeInteger("#12486_7", fallback: 0), y: verticalTickLength),
         CGPoint(x: verticalTickLength * __designTimeFloat("#12486_8", fallback: 0.5), y: verticalTickLength * __designTimeFloat("#12486_9", fallback: 0.5))
        ]
    }
}

struct CoolS: Shape {
    
    func path(in rect: CGRect) -> Path {
        let coolSPath = CoolSPath(in: rect)
        let perimeter = coolSPath.perimeter
        let upperInterior = coolSPath.upperInterior
        let lowerInterior = coolSPath.lowerInterior
                
        var p = Path()
        p.move(to: perimeter[__designTimeInteger("#12486_10", fallback: 0)])
        for i in __designTimeInteger("#12486_11", fallback: 1)..<perimeter.count {
            p.addLine(to: perimeter[i])
        }
        
        p.move(to: upperInterior[__designTimeInteger("#12486_12", fallback: 0)])
        for i in __designTimeInteger("#12486_13", fallback: 1)..<upperInterior.count {
            p.addLine(to: upperInterior[i])
        }
        
        p.move(to: lowerInterior[__designTimeInteger("#12486_14", fallback: 0)])
        for i in __designTimeInteger("#12486_15", fallback: 1)..<lowerInterior.count {
            p.addLine(to: lowerInterior[i])
        }
        
        return p
    }
}

struct CoolSPreview: View {
    var body: some View {
        CoolS().stroke(style: StrokeStyle(lineWidth: __designTimeFloat("#12486_16", fallback: 8.0))).background().padding(__designTimeInteger("#12486_17", fallback: 64))
    }
}

#Preview {
    CoolSPreview()
}
