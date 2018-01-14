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

/**
 The **PitchLetter** type is an enum whose raw value is the pitch class. The convention used is Cs for C-sharp, and Eb for E-flat, etc. Note that these are octave-invariant abstractions, like pitch-classes but for more tonal contexts.
 */
public enum PitchLetter {
    case C, Bs, Dbb
    case Db, Cs, Bx
    case D, Cx, Ebb
    case Eb, Ds, Csx
    case E , Dx, Fb
    case F, Es, Gbb
    case Gb, Fs, Ex
    case G, Fx, Abb
    case Ab, Gs, Fsx
    case A, Gx, Bbb
    case Bb, As, Gsx
    case B, Ax, Cb

    /// Initialize a PitchLetter instance from a string describing it. E.g. PitchLetter("C#").
    public init?(_ letter: String) {
        let modifiedLetter = letter.replacingOccurrences(of: "#", with: "s")
            .replacingOccurrences(of: "♯", with: "s")
            .replacingOccurrences(of: "♭", with: "b")

        guard let pl = PitchLetter.all[modifiedLetter] else { return nil }
        self = pl
    }

    /// The pitch class value of a PitchLetter case instance.
    public var PC: Int {
        switch self {
        case .C, .Bs, .Dbb: return 0
        case .Db, .Cs, .Bx: return 1
        case .D, .Cx, .Ebb: return 2
        case .Eb, .Ds, .Csx: return 3
        case .E , .Dx, .Fb: return 4
        case .F, .Es, .Gbb: return 5
        case .Gb, .Fs, .Ex: return 6
        case .G, .Fx, .Abb: return 7
        case .Ab, .Gs, .Fsx: return 8
        case .A, .Gx, .Bbb: return 9
        case .Bb, .As, .Gsx: return 10
        case .B, .Ax, .Cb: return 11
        }
    }

    /// A dictionary to map strings to PitchLetter cases.
    public static let all: [String: PitchLetter] = ["C": .C, "Bs": .Bs, "Dbb": .Dbb, "Db": .Db, "Cs": .Cs, "Bx": .Bx, "D": .D, "Cx": .Cx, "Ebb": .Ebb, "Eb": .Eb, "Ds": .Ds, "E": .E, "Dx": .Dx, "Fb": .Fb, "F": .F, "Es": .Es, "Gbb": .Gbb, "Gb": .Gb, "Fs": .Fs, "Ex": .Ex, "G": .G, "Fx": .Fx, "Abb": .Abb, "Ab": .Ab, "Gs": .Gs, "Fsx": .Fsx, "A": .A, "Gx": .Gx, "Bbb": .Bbb, "Bb": .Bb, "As": .As, "B": .B, "Ax": .Ax, "Cb": .Cb]
}

/**
 The **Pitch** type represents both a pitch class and an octave. It also contains a MIDI note number representation. Absolute pitch parity can be checked with ==, pitch class parity can be checked with ~=.
 */
public struct Pitch: Equatable {
    /// The underlying pitch class.
    public var pc: PitchClass = 0

    /// The underlying octave.
    public var oct: Int = 0

    /// A MIDI note number representation, for practical purposes.
    public var midiValue: UInt8 {
        return UInt8((oct * 12) + pc)
    }

    /// Initialize from a PitchClass and an integer denoting octave.
    public init(_ pitchClass: PitchClass, _ octave: Int) {
        oct = octave
        pc = min(pitchClass, 11)
    }

    /// Initialize from a PitchLetter and an integer denoting octave.
    public init(_ pitchLetter: PitchLetter, _ octave: Int) {
        pc = pitchLetter.PC
        oct = octave
    }

    /// Initialize from a MIDI note number.
    public init(_ midiNote: UInt8) {
        self.init(PitchClass(midiNote % 12), Int(midiNote / 12))
    }

    /// Initialize from a description string, e.g. Pitch("Eb5").
    public init?(_ description: String) {
        let charOct = String(description.characters.filter { Int(String($0)) != nil })
        guard let pl = PitchLetter(description.replacingOccurrences(of: charOct, with: "")) else { return nil }
        self.init(pl, Int(charOct)!)
    }

    // Check absolute pitch parity.
    public static func ==(lhs: Pitch, rhs: Pitch) -> Bool {
        return lhs.midiValue == rhs.midiValue
    }

    // Check pitch class parity.
    public static func ~=(lhs: Pitch, rhs: Pitch) -> Bool {
        return lhs.pc == rhs.pc
    }
}

/**
 The **Note** abstraction contains a Pitch instance, a Duration instance, and a velocity.
 */
public struct Note: Equatable {
    /// The underlying absolute pitch.
    public var pitch: Pitch = Pitch(9, 4)

    /// The underlying duration.
    public var duration = Duration()

    /// The underlying velocity.
    public var velocity: UInt8 = 0

    /// Initialize from initial pitch, duration, and velocity values.
    public init(_ initialPitch: Pitch, _ initialDuration: Duration, _ initialVelocity: UInt8) {
        pitch = initialPitch
        duration = initialDuration
        velocity = min(initialVelocity, 127)
    }

    // Compare two note instances by checking pitch and duration parity.
    public static func ==(lhs: Note, rhs: Note) -> Bool {
        return (lhs.pitch == rhs.pitch) && (lhs.duration.lastInterval == rhs.duration.lastInterval)
    }
}

/**
 The **NoteSequence** abstraction represents an ordered collection of **Note** objects.
 */
public struct NoteSequence: ExpressibleByArrayLiteral {
    public typealias Element = Note

    /// The underlying array of **Note** objects.
    public var notes: [Element]

    /// Variadic initializer from Note objects.
    public init(arrayLiteral elements: Element...) {
        notes = elements
    }

    /// Initialize from a single duration and single velocity applied to multiple pitches.
    public init(duration: Duration, velocity: UInt8, pitches: [Pitch]) {
        notes = pitches.map { Note($0, duration, velocity) }
    }

    /// Initialize from a single duration and single velocity applied to multiple pitches.
    public init(durations: [Duration], velocities: [UInt8], pitches: [Pitch]) {
        let cnt = min(durations.count, velocities.count, pitches.count)
        notes = (0..<cnt).map { Note(pitches[$0], durations[$0], velocities[$0]) }
    }

    /// Export NoteSequence instance as a **MusicSequence** object. Needs testing.
    public func toMusicSequence(on channel: UInt8) -> MusicSequence? {
        var sequence: MusicSequence? = nil
        var err = NewMusicSequence(&sequence)
        if err != OSStatus(noErr) {
            return nil
        }

        var track: MusicTrack? = nil
        err = MusicSequenceNewTrack(sequence!, &track)
        if err != OSStatus(noErr) {
            return nil
        }

        var time: MusicTimeStamp = 0

        for n in notes {
            var message = MIDINoteMessage(channel: channel, note: n.pitch.midiValue, velocity: n.velocity, releaseVelocity: 64, duration: Float32(n.duration.lastInterval))
            err = MusicTrackNewMIDINoteEvent(track!, time, &message)

            time += n.duration.lastInterval
        }

        return sequence
    }
}
