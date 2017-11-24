//
//  PitchTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation
import AVFoundation

public typealias ScaleDegree = Int
public typealias Key = PitchLetter

public enum PitchLetter: Int {
    case C = 0
    static var Bs = PitchLetter.C, Dbb = PitchLetter.C
    case Db = 1
    static var Cs = PitchLetter.Db, Bx = PitchLetter.Db
    case D = 2
    static var Cx = PitchLetter.D, Ebb = PitchLetter.D
    case Eb = 3
    static var Ds = PitchLetter.Eb
    case E  = 4
    static var Dx = PitchLetter.E, Fb = PitchLetter.E
    case F = 5
    static var Es = PitchLetter.E, Gbb = PitchLetter.E
    case Gb = 6
    static var Fs = PitchLetter.Gb, Ex = PitchLetter.Gb
    case G = 7
    static var Fx = PitchLetter.G, Abb = PitchLetter.G
    case Ab = 8
    static var Gs = PitchLetter.Ab, Fsx = PitchLetter.Ab
    case A = 9
    static var Gx = PitchLetter.A, Bbb = PitchLetter.A
    case Bb = 10
    static var As = PitchLetter.Bb
    case B = 11
    static var Ax = PitchLetter.B, Cb = PitchLetter.B
    
    public var PC: Int {
        return rawValue
    }
    
    public static var all: Dictionary<String, PitchLetter> = ["C": .C, "Bs": .Bs, "Dbb": .Dbb, "Db": .Db, "Cs": .Cs, "Bx": .Bx, "D": .D, "Cx": .Cx, "Ebb": .Ebb, "Eb": .Eb, "Ds": .Ds, "E": .E, "Dx": .Dx, "Fb": .Fb, "F": .F, "Es": .Es, "Gbb": .Gbb, "Gb": .Gb, "Fs": .Fs, "Ex": .Ex, "G": .G, "Fx": .Fx, "Abb": .Abb, "Ab": .Ab, "Gs": .Gs, "Fsx": .Fsx, "A": .A, "Gx": .Gx, "Bbb": .Bbb, "Bb": .Bb, "As": .As, "B": .B, "Ax": .Ax, "Cb": .Cb]
}

public struct Pitch: Equatable {
    public var pitchClass: PitchClass = 0
    public var octave: Int = 0
    
    public var midiValue: Int {
        return (octave * 12) + pitchClass
    }
    
    public init(_ pitchClass: PitchClass, _ octave: Int) {
        
    }
    
    public init(_ pitchLetter: PitchLetter, _ octave: Int) {
        
    }
    
    public init(_ midiNote: UInt8) {
        self.init(PitchClass(midiNote % 12), Int(midiNote / 12))
    }
    
    public init?(_ description: String) {
        
    }
    
    public static func ==(lhs: Pitch, rhs: Pitch) -> Bool {
        return lhs.midiValue == rhs.midiValue
    }
}

public struct Note: Equatable {
    public var pitch: Pitch = Pitch(0, 4)
    public var duration = Time()
    
    public init(_ pitch: Pitch, _ duration: Time) {
        
    }
    
    public static func ==(lhs: Note, rhs: Note) -> Bool {
        return (lhs.pitch.midiValue == rhs.pitch.midiValue)
    }
}

extension PitchLetter {
    public init?(_ letter: String) {
        let modifiedLetter = letter.replacingOccurrences(of: "#", with: "s")
            .replacingOccurrences(of: "♯", with: "s")
            .replacingOccurrences(of: "♭", with: "b")
        
        switch modifiedLetter {
        case "C": self = PitchLetter.C
        case "Bs": self = PitchLetter.Bs
        case "Dbb": self = PitchLetter.Dbb
        case "Db": self = PitchLetter.Db
        case "Cs": self = PitchLetter.Cs
        case "Db": self = PitchLetter.Db
        case "Bx": self = PitchLetter.Bx
        case "D": self = PitchLetter.D
        case "Cx": self = PitchLetter.Cx
        case "Ebb": self = PitchLetter.Ebb
        case "Eb": self = PitchLetter.Eb
        case "Ds": self = PitchLetter.Ds
        case "Eb": self = PitchLetter.Eb
        case "E": self = PitchLetter.E
        case "Dx": self = PitchLetter.Dx
        case "Fb": self = PitchLetter.Fb
        case "F": self = PitchLetter.F
        case "Es": self = PitchLetter.Es
        case "Gbb": self = PitchLetter.Gbb
        case "Gb": self = PitchLetter.Gb
        case "Fs": self = PitchLetter.Fs
        case "Ex": self = PitchLetter.Ex
        case "G": self = PitchLetter.G
        case "Fx": self = PitchLetter.Fx
        case "Abb": self = PitchLetter.Abb
        case "Ab": self = PitchLetter.Ab
        case "Gs": self = PitchLetter.Gs
        case "Fsx": self = PitchLetter.Fsx
        case "A": self = PitchLetter.A
        case "Gx": self = PitchLetter.Gx
        case "Bbb": self = PitchLetter.Bbb
        case "Bb": self = PitchLetter.Bb
        case "As": self = PitchLetter.As
        case "B": self = PitchLetter.B
        case "Ax": self = PitchLetter.Ax
        case "Cb": self = PitchLetter.Cb
        default:  self = PitchLetter.C
        }
    }
}

public struct NoteSequence {
    public var notes = [Note]()
    
    public init(_ duration: Time, pitches: Pitch...) {
        for p in pitches {
            notes.append(Note(p, duration))
        }
    }
    
    public init(_ duration: Time, pitches: [Pitch]) {
        for p in pitches {
            notes.append(Note(p, duration))
        }
    }
    
    public init(durations: [Time], pitches: [Pitch]) {
        for i in 0 ..< min(durations.count, pitches.count) {
            notes.append(Note(pitches[i], durations[i]))
        }
    }
    
    public func toMusicSequence(at tempo: Double) -> MusicSequence? {
        return nil
    }
}
