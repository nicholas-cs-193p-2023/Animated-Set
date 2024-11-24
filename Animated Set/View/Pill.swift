//
//  Pill.swift
//  Set
//
//  Created by Nicholas Alba on 8/24/24.
//

import SwiftUI

struct Pill: Shape {
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.height, rect.width) / 2

        let verticalInset = rect.width >= rect.height ? 0 : rect.height / 2 - radius
        let p0 = CGPoint(x: rect.minX + radius, y: rect.minY + verticalInset)
        let p1 = CGPoint(x: rect.maxX - radius, y: rect.minY + verticalInset)
        let p2 = CGPoint(x: rect.minX + radius, y: rect.maxY - verticalInset)
        let c0 = CGPoint(x: rect.maxX - radius, y: rect.midY)
        let c1 = CGPoint(x: rect.minX + radius, y: rect.midY)
                
        var p = Path()
        p.move(to: p0)
        p.addLine(to: p1)
        p.addArc(center: c0, radius: radius, startAngle: .radians(-1.0*CGFloat.pi/2.0), endAngle: .radians(CGFloat.pi/2.0),  clockwise: false)
        p.addLine(to: p2)
        p.addArc(center: c1, radius: radius, startAngle: .radians(CGFloat.pi/2.0), endAngle: .radians(-1.0*CGFloat.pi/2.0), clockwise: false)
                
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
