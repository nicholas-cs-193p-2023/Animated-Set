//
//  Rhombus.swift
//  Set
//
//  Created by Nicholas Alba on 8/24/24.
//

import SwiftUI

struct Rhombus: Shape {
    func path(in rect: CGRect) -> Path {
        let leftMidpoint = CGPoint(x: rect.minX, y: rect.midY)
        let topMidpoint = CGPoint(x: rect.midX, y: rect.minY)
        let rightMidpoint = CGPoint(x: rect.maxX, y: rect.midY)
        let bottomMidpoint = CGPoint(x: rect.midX, y: rect.maxY)
        
        var p = Path()
        p.move(to: leftMidpoint)
        p.addLine(to: topMidpoint)
        p.addLine(to: rightMidpoint)
        p.addLine(to: bottomMidpoint)
        p.addLine(to: leftMidpoint)
        
        return p
    }
}

struct RhombusPreview: View {
    private let aspectRatio = 2.0
    
    var body: some View {
        Rhombus().stroke().aspectRatio(aspectRatio, contentMode: .fit).foregroundColor(.blue).padding()
    }
}

#Preview {
    RhombusPreview()
}
