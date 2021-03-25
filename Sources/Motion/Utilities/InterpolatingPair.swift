//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 22/03/21.
//

import simd


/// A struct holding two values of the same type which pupose is to be fed to an easing function to interpolate between.
///
/// Unlike Swift Standard Library's `Range` and `ClosedRange` `InterpolatingPair` doesn't expect its bounds to be ordered in an ascending order.
public struct InterpolatingPair<T> {
    
    /// The starting bound of the interpolation
    public let start: T
    
    /// The end bound of the interpolation
    public let end: T
    
    @inlinable
    public init(from start: T, to end: T)  {
        self.start = start
        self.end = end
    }
}

extension InterpolatingPair where T: SupportedSIMD {
    
    /// The zero value pair.
    @inlinable static var zero: Self { .init(from: .zero, to: .zero) }
    
    /// Checks if the given element exists between the receiver's bounds.
    /// - Parameter element: The element to find.
    /// - Returns: `true` if the value of the element lies between `start`'s and `end`'s values in all lanes. Returns `false` otherwise.
    @inlinable func contains(_ element: T) -> Bool {
        all((min(start, end) .<= element) .& (element .<= max(start, end)))
    }
}

internal extension InterpolatingPair where T: SIMDRepresentable {
    
    /// Transforms `self`'s bound to their simd representation counterpart.
    /// - Returns: A new `InterpolatingPair` instance with the receiver's bounds' simd representations as its own bounds.
    @usableFromInline func simdRepresentation() -> InterpolatingPair<T.SIMDType> {
        .init(from: start.simdRepresentation(),
              to: end.simdRepresentation())
    }
}
