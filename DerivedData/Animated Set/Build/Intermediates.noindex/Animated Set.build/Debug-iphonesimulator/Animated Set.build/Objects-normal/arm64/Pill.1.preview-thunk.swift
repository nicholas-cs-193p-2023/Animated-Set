import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/nicholasdalba/Developer/Animated Set/Animated Set/View/Pill.swift", line: 1)
//
//  Pill.swift
//  Set
//
//  Created by Nicholas Alba on 8/24/24.
//

import SwiftUI

struct Pill: Shape {
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.height, rect.width) / __designTimeInteger("#70843_0", fallback: 2)

        let verticalInset = rect.width >= rect.height ? __designTimeInteger("#70843_1", fallback: 0) : rect.height / __designTimeInteger("#70843_2", fallback: 2) - radius
        let p0 = CGPoint(x: rect.minX + radius, y: rect.minY + verticalInset)
        let p1 = CGPoint(x: rect.maxX - radius, y: rect.minY + verticalInset)
        let p2 = CGPoint(x: rect.minX + radius, y: rect.maxY - verticalInset)
        let c0 = CGPoint(x: rect.maxX - radius, y: rect.midY)
        let c1 = CGPoint(x: rect.minX + radius, y: rect.midY)
                
        var p = Path()
        p.move(to: p0)
        p.addLine(to: p1)
        p.addArc(center: c0, radius: radius, startAngle: .radians(__designTimeFloat("#70843_3", fallback: -1.0)*CGFloat.pi/__designTimeFloat("#70843_4", fallback: 2.0)), endAngle: .radians(CGFloat.pi/__designTimeFloat("#70843_5", fallback: 2.0)),  clockwise: __designTimeBoolean("#70843_6", fallback: false))
        p.addLine(to: p2)
        p.addArc(center: c1, radius: radius, startAngle: .radians(CGFloat.pi/__designTimeFloat("#70843_7", fallback: 2.0)), endAngle: .radians(__designTimeFloat("#70843_8", fallback: -1.0)*CGFloat.pi/__designTimeFloat("#70843_9", fallback: 2.0)), clockwise: __designTimeBoolean("#70843_10", fallback: false))
                
        return p
    }
}

struct PillPreview: View {
    private let aspectRatio = 0.75
    
    var body: some View {
        pillView
    }
    
    var pillView: some View {
        Pill().stroke().aspectRatio(aspectRatio, contentMode: .fit).background(.yellow).padding().foregroundColor(.blue)
    }
}


#Preview {
    PillPreview()
}
