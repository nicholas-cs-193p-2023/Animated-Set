//
//  Squiggle.swift
//  Set
//
//  Created by Nicholas Alba on 8/24/24.
//

import SwiftUI

private struct Constants {
    static let curvePointRadius = 4.0
    static let controlPointRadius = 4.0
}

private struct SquigglePath {
    var minX: CGFloat
    var maxX: CGFloat
    var minY: CGFloat
    var maxY: CGFloat
    var width: CGFloat
    var height: CGFloat
    
    init(in rect: CGRect) {
        minX = rect.minX
        maxX = rect.maxX
        minY = rect.minY
        maxY = rect.maxY
        width = rect.width
        height = rect.height
    }
    
    var curvePoints: [CGPoint] {
        [CGPoint(x: minX, y: minY + 0.7 * height),
         CGPoint(x: minX + 0.20 * width, y: minY + 0.10 * height),
         CGPoint(x: minX + 0.85 * width, y: minY + 0.05 * height),
         CGPoint(x: maxX, y: minY + 0.40 * height),
         CGPoint(x: minX + 0.60 * width, y: maxY - 0.05 * height),
         CGPoint(x: minX + 0.35 * width, y: height - 0.10 * height),
         CGPoint(x: minX + 0.10 * width, y: height - 0.05 * height)]
    }
    
    var controlPoints:  [CGPoint] {
        [CGPoint(x: minX, y: minY),
         CGPoint(x: minX + 0.60 * width, y: minY + 0.25 * height),
         CGPoint(x: maxX, y: minY - 0.05 * height),
         CGPoint(x: maxX, y: maxY),
         CGPoint(x: minX + 0.50 * width, y: maxY - 0.05 * height),
         CGPoint(x: minX + 0.20 * width, y: maxY - 0.15 * height),
         CGPoint(x: minX, y: maxY + 0.10 * height)]
    }
}

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        let squigglePath = SquigglePath(in: rect)
        let curvePoints = squigglePath.curvePoints
        let controlPoints = squigglePath.controlPoints
                
        var p = Path()
        p.move(to: curvePoints[0])
        for i in 0..<curvePoints.count {
            let j = (i + 1) % curvePoints.count
            p.addQuadCurve(to: curvePoints[j], control: controlPoints[i])
        }
        
        return p
    }
}

struct CurvePointMarkers: Shape {
    func path(in rect: CGRect) -> Path {
        let squigglePath = SquigglePath(in: rect)
        let curvePoints = squigglePath.curvePoints
        
        var p = Path()
        let radius = Constants.curvePointRadius
        for point in curvePoints {
            p.addEllipse(in: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2.0, height: radius * 2.0))
        }
        
        return p
    }
}

struct ControlPointMarkers: Shape {
    func path(in rect: CGRect) -> Path {
        let squigglePath = SquigglePath(in: rect)
        let controlPoints = squigglePath.controlPoints
        
        var p = Path()
        let radius = Constants.controlPointRadius
        for point in controlPoints {
            p.addEllipse(in: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2.0, height: radius * 2.0))
        }
        
        return p
    }
}

struct SquigglePreview: View {
    private let aspectRatio = 2.0
    
    var body: some View {
        squiggle
    }
    
    var squiggle: some View {
        Squiggle().stroke().aspectRatio(aspectRatio, contentMode: .fit).background(.yellow)
            .overlay(CurvePointMarkers().fill(.blue))
            .overlay(ControlPointMarkers().fill(.red))
            .padding()
    }
}

#Preview {
    SquigglePreview()
}

