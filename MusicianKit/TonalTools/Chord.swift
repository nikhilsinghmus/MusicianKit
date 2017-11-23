//
//  Chord.swift
//  MusicianKit
//
//  Created by Nikhil Singh on 11/6/17.
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public struct Chord: Equatable {
    public var function: HarmonicFunction {
        return .undetermined
    }
    
    public var pitchClasses = PCSet()
    public var tones: [ScaleDegree] {
        get {
            return pitchClasses.flatMap { toScaleDegree(from: $0) }
        }
        
        set {
            pitchClasses = PCSet(newValue.map { toPitchClass(from: $0) })
        }
    }
    public var key = (Key.C, KeyType.major)
    
    public static func ==(lhs: Chord, rhs: Chord) -> Bool {
        return lhs.tones == rhs.tones
    }
    
    public static func =~(lhs: Chord, rhs: Chord) -> Bool {
        if lhs.function != .undetermined { return lhs.function == rhs.function }
        return false
    }
    
    public static func parse(_ chordSymbol: String) -> Chord? {
        return nil
    }
    
    public init(scaleDegrees: [ScaleDegree]) {
        tones = scaleDegrees
    }
    
    public init(pitchClassSet: PCSet) {
        pitchClasses = pitchClassSet
    }
    
    public init?(_ chordSymbol: String) {
        guard let chord = Chord.parse(chordSymbol) else { return nil }
        self = chord
    }
    
    public func toScaleDegree(from pc: PitchClass) -> ScaleDegree? {
        return key.1.pattern.map { ($0 + key.0.rawValue) % 12 }.index(of: pc)
    }
    
    public func toPitchClass(from degree: ScaleDegree) -> PitchClass {
        return key.1.pattern.map { ($0 + key.0.rawValue) % 12 }[degree]
    }
    
    public static func classify(_ chord: Chord) -> HarmonicFunction {
        if chord.tones.contains(7), !(chord.tones.contains(3)) {
            return .dominant
        } else if chord.tones.contains(4), chord.tones.contains(6) {
            return .subdominant
        }
        return .undetermined
    }
    
    // Naive (O(n^2)) solution
    public static func voiceLead(from chord: [Int], to nextChord: Chord) -> [Int] {
        
        var outChord = [Int]()
        
        let midiChord = chord.filter { $0 <= 127 && $0 >= 0 }
        let toNotes = nextChord.pitchClasses
        
        for p in toNotes {
            var distance = 12
            var offset = 0
            var note = 0
            
            for n in midiChord {
                
                let d = p - (n % 12)
                if pcabs(d) < distance {
                    distance = d
                    offset = d
                    note = n
                }
            }
            
            outChord.append(note + offset)
        }
        
        return outChord
    }
    
    public static func pcabs(_ pc: Int) -> Int {
        guard pc < -6 else { return abs(pc) }
        return 12 + pc
    }
}

public struct SeparatedChordSymbol {
    var root: PitchLetter!
    var suffix: String!
    
    public static func getPitchClasses() -> PCSet? {
        return nil
    }
    
    public init(_ chordRoot: PitchLetter, _ chordSuffix: String) {
        root = chordRoot
        suffix = chordSuffix
    }
}
