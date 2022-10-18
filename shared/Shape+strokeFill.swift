//
//  Shape+strokeFill.swift
//  k
//
//  Created by Zachary Gorak on 10/17/22.
//

import SwiftUI

/// https://www.hackingwithswift.com/quick-start/swiftui/how-to-fill-and-stroke-shapes-at-the-same-time
public extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

/// https://www.hackingwithswift.com/quick-start/swiftui/how-to-fill-and-stroke-shapes-at-the-same-time
public extension InsettableShape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}
