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
        
        var curX = rect.minX-2
        var curY = rect.midY - 10
        path.move(to: CGPoint(x: curX, y: curY))

        for x in stride(from: rect.minX-2, to: rect.maxX+2, by: 1) {
            let relativeX = x - rect.minX-2
            let yOffset = -amplitude * sin(relativeX / frequency)
            
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
        
        var curX = rect.maxX+2
        var curY = rect.minY - 10
        path.move(to: CGPoint(x: curX, y: curY))

        curX = rect.minX-2
        path.addLine(to: CGPoint(x: curX, y: curY))
        
        curY = rect.midY
        path.addLine(to: CGPoint(x: curX, y: curY))

        for x in stride(from: rect.minX-2, to: rect.maxX+2, by: 1) {
            let relativeX = x - rect.minX-2
            let yOffset = -amplitude * sin(relativeX / frequency)
            
            curX = x
            curY = rect.midY + yOffset
            path.addLine(to: CGPoint(x: curX, y: curY))
        }
        
        curY = rect.minY - 10
        path.addLine(to: CGPoint(x: curX, y: curY))
        
        return path
    }
}

