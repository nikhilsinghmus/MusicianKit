//
//  ToneRow.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

/**
 The **ToneRow** type deals with ordered collections of pitch-classes and adds utility methods for working with tone rows in compositional contexts.
 */
public struct ToneRow: Equatable, ExpressibleByArrayLiteral, MutableCollection {

    public static func ==(lhs: ToneRow, rhs: ToneRow) -> Bool {
        return lhs.notes == rhs.notes
    }

    /// The underlying pitch-class set.
    public var notes: PCSet!

    // MARK: Initializers
    public init(arrayLiteral: PitchClass...) {
        notes = PCSet(arrayLiteral)
    }

    /// Initialize from a PCSet.
    public init(_ pcSet: PCSet) {
        notes = pcSet
    }

    /// Initialize from an array of PitchClasses.
    public init(_ pitchClasses: [PitchClass]) {
        notes = PCSet(pitchClasses)
    }

    // MARK: Indexing
    public typealias ArrayLiteralElement = PitchClass
    public var startIndex: Int = 0
    public var endIndex: Int { return notes.cardinality }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(_ index: Int) -> PitchClass {
        get {
            return notes[index]
        }

        set {
            notes[index] = newValue
        }
    }

    // MARK: Utility methods
    /// Generate a ToneMatrix from the current ToneRow.
    public func buildMatrix() -> ToneMatrix {
        return ToneMatrix(from: self)
    }
}
