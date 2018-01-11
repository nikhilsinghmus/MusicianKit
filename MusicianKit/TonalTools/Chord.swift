//
//  Chord.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

/**
 The **Chord** type provides an abstraction for dealing with vertically-oriented harmonic structures. Can be initialized with a pitch-class set, with a chord symbol (e.g. Chord("Fmaj7#11")), or with MIDI note numbers as an Int array. Chord parity, considering inversional equivalence, can be checked using the == operator.
 */
public struct Chord: Equatable {
    /// The underlying pitch-class set.
    public var pitchClasses = PCSet()

    /// The chord's key context, useful for certain operations. Defaults to C Major. Expressed as a tuplet (Key, KeyType).
    public var key = (Key.C, KeyType.major)

    /// The chord represented as scale degrees, if available, according to the 'key' property.
    public var tones: [ScaleDegree] {
        get {
            return pitchClasses.flatMap { toScaleDegree(from: $0) }
        }

        set {
            pitchClasses = PCSet(newValue.map { toPitchClass(from: $0) })
        }
    }

    /// Check chord parity.
    public static func ==(lhs: Chord, rhs: Chord) -> Bool {
        return lhs.pitchClasses.sorted() == rhs.pitchClasses.sorted()
    }

    // MARK: Initializers
    /// Initialize with scale degrees.
    public init(scaleDegrees: [ScaleDegree], in initialKey: (Key, KeyType)) {
        key = initialKey
        tones = scaleDegrees
    }

    /// Initialize from a pitch-class set.
    public init(pitchClassSet: PCSet) {
        pitchClasses = pitchClassSet
    }

    /// Initialize from a chord symbol. E.g. Chord("Gbm7").
    public init?(_ chordSymbol: String) {
        guard let chord = Chord.parse(chordSymbol) else { return nil }
        self = chord
    }

    /// Parse a chord symbol and return an Optional<Chord>. Returns nil if the chord symbol could not be parsed.
    public static func parse(_ chordSymbol: String) -> Chord? {
        guard let c = chordSymbol.separateRoot()?.pitchClasses() else { return nil }
        return Chord(pitchClassSet: c)
    }

    // MARK: Utility methods
    /// Convert from pitch-class to scale-degree.
    public func toScaleDegree(from pc: PitchClass) -> ScaleDegree? {
        return key.1.pattern.map { ($0 + key.0.rawValue) % 12 }.index(of: pc)
    }

    /// Convert from scale-degree to pitch-class.
    public func toPitchClass(from degree: ScaleDegree) -> PitchClass {
        return key.1.pattern.map { ($0 + key.0.rawValue) % 12 }[degree]
    }

    /// Use the **Chord** abstraction to voice-lead from one set of MIDI note numbers to another. E.g. Chord.voiceLead(from: [60, 64, 67], to: Chord("Fmaj7")).
    public static func voiceLead(from chord: [UInt8], to nextChord: Chord) -> [UInt8] { // Naive (O(n^2)) solution.
        var outChord = [UInt8]()

        let midiChord = chord.filter { $0 <= 127 && $0 >= 0 }
        let toNotes = nextChord.pitchClasses

        for p in toNotes {
            var distance = 12
            var offset = 0
            var note = 0

            for n in midiChord {
                let d = p - (Int(n) % 12)
                if pcabs(d) < distance {
                    distance = d
                    offset = d
                    note = Int(n)
                }
            }

            outChord.append(UInt8(note + offset))
        }

        return outChord
    }

    fileprivate static func pcabs(_ pc: Int) -> Int {
        guard pc < -6 else { return abs(pc) }
        return 12 + pc
    }
}

/**
 The **SeparatedChordSymbol** type provides a separated root and symbol suffix, as an intermediary stage in the chord-parsing process.
 */
public struct SeparatedChordSymbol {
    /// The chord root.
    var root: PitchLetter!

    /// The chord symbol suffix.
    var suffix: String!

    /// Initialize with a chord root and a chord suffix string, without argument labels.
    public init(_ chordRoot: PitchLetter, _ chordSuffix: String) {
        root = chordRoot
        suffix = chordSuffix
    }

    /// Get a pitch-class set of the suffix as it would apply to C (pitch-class 0).
    public func pitchClasses() -> PCSet? {
        let rootPC = root.PC
        let mapped = suffix.mapSuffix()?.pitchClasses.map { ($0 + rootPC) % 12 }
        guard let PCs = mapped else { return nil }
        return PCSet(PCs)
    }
}
