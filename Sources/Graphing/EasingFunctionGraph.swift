//
//  SwiftUIView.swift
//  
//
//  Created by Adam Bell on 12/6/20.
//

#if canImport(SwiftUI)

import Motion
import SwiftUI

public struct EasingFunctionShape: Shape {

    public let easingFunction: EasingFunction<CGFloat>

    public init(_ easingFunction: EasingFunction<CGFloat>) {
        self.easingFunction = easingFunction
    }

    public func path(in rect: CGRect) -> Path {
        let pointCount = rect.size.width * 3.0

        let points: [CGPoint] = stride(from: 0.0, to: pointCount, by: 1.0).map { (i) -> CGPoint in
            let percent = CGFloat(i) / CGFloat(pointCount)

            let minY = rect.size.height * 0.15
            let maxY = rect.size.height * 0.85

            let value = easingFunction.solveInterpolatedValue(.init(from: minY, to: maxY), fraction: Double(percent))
    

            return CGPoint(x: percent * rect.size.width, y: value)
        }

        var path = Path()
        path.addLines(points)
        return path
    }

}

public extension EasingFunction {

    static var allFunctions: [EasingFunction] {
        return [.linear, .easeIn, .easeOut, .easeInOut, Self(bezier: Bezier(x1: 0.42, y1: 0.0, x2: 0.58, y2: 1.0))]
    }

}

public struct EasingFunctionGraphView: View {

    public let easingFunction: EasingFunction<CGFloat>

    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)

            EasingFunctionShape(easingFunction)
                .stroke(lineWidth: 4.0)
                .foregroundColor(.blue)
                .padding(12.0)

        }
        .frame(width: 320.0, height: 320.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }

}

#endif
