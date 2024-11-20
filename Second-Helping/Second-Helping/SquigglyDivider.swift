//
//  SquigglyDivider.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 11/20/24.
//

import SwiftUI

struct SquigglyDivider: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let amplitude: CGFloat = 6
        let frequency: CGFloat = 20
        
        var curX = rect.minX
        var curY = rect.midY
        path.move(to: CGPoint(x: curX, y: curY))

        for x in stride(from: rect.minX, to: rect.maxX, by: 1) {
            let relativeX = x - rect.minX
            let yOffset = amplitude * sin(relativeX / frequency)
            
            curX = x
            curY = rect.midY + yOffset
            path.addLine(to: CGPoint(x: curX, y: curY))
        }
        
        return path
    }
}

struct SquigglyDividerTopBG: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let amplitude: CGFloat = 6
        let frequency: CGFloat = 20
        
        var curX = rect.maxX
        var curY = rect.minY - 3
        path.move(to: CGPoint(x: curX, y: curY))

        curX = rect.minX
        path.addLine(to: CGPoint(x: curX, y: curY))
        
        curY = rect.midY
        path.addLine(to: CGPoint(x: curX, y: curY))

        for x in stride(from: rect.minX, to: rect.maxX, by: 1) {
            let relativeX = x - rect.minX
            let yOffset = amplitude * sin(relativeX / frequency)
            
            curX = x
            curY = rect.midY + yOffset
            path.addLine(to: CGPoint(x: curX, y: curY))
        }
        
        curY = rect.minY - 3
        path.addLine(to: CGPoint(x: curX, y: curY))
        
        return path
    }
}

