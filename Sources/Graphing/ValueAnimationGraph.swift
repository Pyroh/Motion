//
//  SwiftUIView.swift
//  
//
//  Created by Adam Bell on 12/6/20.
//

#if canImport(SwiftUI)

import Motion
import SwiftUI

public struct ValueAnimationShape: Shape {

    public enum GraphType {
        case position
        case velocity
    }

    public let animation: ValueAnimation<CGFloat>

    public let graphType: GraphType

    public let duration: CFTimeInterval

    public init(_ animation: ValueAnimation<CGFloat>, graphType: GraphType, duration: CFTimeInterval) {
        self.animation = animation
        if graphType == .velocity, ((animation as? SpringAnimation) != nil || (animation as? DecayAnimation) != nil) {
            // Only velocity is supported on these types.
            self.graphType = graphType
        } else {
            self.graphType = .position
        }
        self.duration = duration
    }

    public func path(in rect: CGRect) -> Path {
        let dt = 1.0 / 60.0

        animation.stop()
        animation.updateValue(to: 0.0)

        let height = rect.size.height / 2.0

        let points: [CGPoint] = stride(from: 0.0, to: duration, by: dt).map { (i) -> CGPoint in
            let percent: CGFloat = CGFloat(i / duration)

            let point: CGPoint

            let position = { () -> CGPoint in
                if let decayAnimation = animation as? DecayAnimation {
                    return CGPoint(x: rect.width * percent, y: height - decayAnimation.value)
                } else {
                    return CGPoint(x: rect.width * percent, y: height + ((animation.toValue - animation.value) * height))
                }
            }

            let velocity = { () -> CGPoint in
                let velocity: CGFloat
                if type(of: animation).supportsVelocity {
                    velocity = animation.velocity
                } else {
                    return position()
                }

                return CGPoint(x: rect.width * percent, y: height + velocity * height / 3.0)
            }

            switch graphType {
            case .position:
                point = position()
            case .velocity:
                point = velocity()
            }

            animation.tick(dt)

            return point
        }

        var path = Path()
        path.addLines(points)
        return path
    }

}

public struct ValueAnimationGraphView: View {

    public let animation: ValueAnimation<CGFloat>

    public let graphType: ValueAnimationShape.GraphType

    public let duration: CFTimeInterval

    public init(_ animation: ValueAnimation<CGFloat>, graphType: ValueAnimationShape.GraphType, duration: CFTimeInterval = 3.0) {
        self.animation = animation
        if graphType == .velocity, type(of: animation).supportsVelocity {
            // Only velocity is supported on these types.
            self.graphType = graphType
        } else {
            self.graphType = .position
        }
        self.duration = duration
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(.black)

            ValueAnimationShape(animation, graphType: graphType, duration: duration)
                .stroke(lineWidth: 4.0)
                .foregroundColor(.blue)
                .padding(12.0)

            HStack {
                if let springAnimation = animation as? SpringAnimation {
                    Text(String(format: "Damping: %.2f", springAnimation.damping))
                    Text(String(format: "Stiffness: %.2f", springAnimation.stiffness))
                } else if let decayAnimation = animation as? DecayAnimation {
                    Text(String(format: "Decay Constant: %.3f", decayAnimation.decayConstant))
                }
            }
            .foregroundColor(.white)
            .padding()
        }
        .frame(height: 320.0)
    }

}


#endif
