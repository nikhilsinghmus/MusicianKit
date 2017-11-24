//
//  ToneRow.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public struct ToneRow: Equatable, ExpressibleByArrayLiteral, MutableCollection {
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public typealias ArrayLiteralElement = PitchClass
    public var startIndex: Int = 0
    public var endIndex: Int { return notes.cardinality }
    
    public var notes: PCSet!
    
    public static func ==(lhs: ToneRow, rhs: ToneRow) -> Bool {
        return lhs.notes == rhs.notes
    }
    
    public init(arrayLiteral: PitchClass...) {
        notes = PCSet(arrayLiteral)
    }
    
    public init(_ pcSet: PCSet) {
        notes = pcSet
    }
    
    public init(_ pitchClasses: [PitchClass]) {
        notes = PCSet(pitchClasses)
    }
    
    public subscript(_ index: Int) -> PitchClass {
        get {
            return notes[index]
        }
        
        set(newValue) {
            notes[index] = newValue
        }
    }
    
    public func buildMatrix() -> ToneMatrix {
        return ToneMatrix(from: self)
    }
}
