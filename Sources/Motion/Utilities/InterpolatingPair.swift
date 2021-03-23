//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 22/03/21.
//

import simd

public struct InterpolatingPair<T> {
    public let start: T
    public let end: T
    
    @inlinable
    public init(from start: T, to end: T)  {
        self.start = start
        self.end = end
    }
}

extension InterpolatingPair where T: SupportedSIMD {
    @inlinable
    static var zero: Self { .init(from: .zero, to: .zero) }
    
    @inlinable
    func contains(_ element: T) -> Bool {
        all((min(start, end) .<= element) .& (element .<= max(start, end)))
    }
}

internal extension InterpolatingPair where T: SIMDRepresentable {
    @usableFromInline
    func simdRepresentation() -> InterpolatingPair<T.SIMDType> {
        .init(from: start.simdRepresentation(),
              to: end.simdRepresentation())
    }
}
