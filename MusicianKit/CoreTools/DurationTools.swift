//
//  DurationTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

extension CountableClosedRange where Bound == Int {
    init?(tempo: String) {
        switch tempo {
        case "grave":
            self = 40...50
        case "largo":
            self = 50...55
        case "larghetto":
            self = 55...60
        case "adagio":
            self = 60...70
        case "andante":
            self = 70...85
        case "moderato":
            self = 85...100
        case "allegretto":
            self = 100...115
        case "allegro":
            self = 115...140
        case "vivace":
            self = 140...150
        case "presto":
            self = 150...170
        case "prestissimo":
            self = 170...200
        default:
            return nil
        }
    }
}

/**
 The **TimeSignature** type consists of a numerator and a denominator, together representing a time signature. It currently only supports dyadic rationals, but support for 'irrational' time signatures is planned.
 */
public struct TimeSignature {
    /// The underlying numerator.
    public var numerator: UInt8 = 4
    /// The underlying denominator.
    public var denominator: UInt8 = 4
    
    /// Initialize from a numerator and a denominator, e.g. TimeSignature(4, 4).
    public init?(_ count: UInt8, _ value: UInt8) {
        let x = log2(Double(value))
        guard x == floor(x) else { return nil } // Ensure meter is a dyadic rational. No 'irrational' meter implementation (yet!)
        
        numerator = count
        denominator = value
    }
}

/**
 The **NoteValue** enum type, with a Double rawValue, consists of scaling factors for use as standard durations. Plugged into the equation as described below, they will yield approx. durations (in seconds).
 
 ```
 seconds = 60/(tempo * (noteValue.rawValue/4))
 ```
 
 Note that the convention used is **n_4** for a quarter-note, **t_8** for a triplet eighth-note, **d_16** for a dotted sixteenth-note, etc.
 */
public enum NoteValue: Double {
    case n_1 = 1.0, n_2 = 2.0, n_4 = 4.0, n_8 = 8.0, n_16 = 16.0, n_32 = 32.0, n_64 = 64.0, n_128 = 128.0
    case t_1 = 1.5, t_2 = 3.0, t_4 = 6.0, t_8 = 12.0, t_16 = 24.0, t_32 = 48.0, t_64 = 96.0, t_128 = 192.0
    case d_1 = 0.6666666666666667,
    d_2 = 1.3333333333333333,
    d_4 = 2.6666666666666667,
    d_8 = 5.3333333333333333,
    d_16 = 10.666666666666667,
    d_32 = 21.333333333333333,
    d_64 = 42.666666666666667,
    d_128 = 85.33333333333333
}

/**
 The **Tempo** type consists of a beats-per-minute value, and a NoteValue instance to indicate what each of these beats is. It can be initialized with a BPM value alone, in which case the beat's value defaults to a quarter note, or with both together. Additionally, it can be initialized with a description, e.g. Tempo("Andante"). There is an internal soft limit that defaults to 400.0 and can be user-modified.
 */
public struct Tempo {
    /// An internal soft limit that can be modified. Defaults to 400.0.
    public static var softLimit: Double = 400.0 {
        didSet {
            softLimit = abs(softLimit)
        }
    }
    
    /// The number of beats per minute.
    public var BPM: Double = 120
    
    /// The value of each beat.
    public var value: NoteValue = .n_4
    
    /// Initialize with a note value and a BPM value, e.g. Tempo(.d_4, 140).
    public init(_ noteValue: NoteValue, _ initialBPM: Double) {
        value = noteValue
        BPM = min(abs(initialBPM), Tempo.softLimit)
    }
    
    /// Initialize with a BPM value alone, e.g. Tempo(116.5). Beat value defaults to .n_4, or a quarter-note.
    public init(_ initialBPM: Double) {
        value = .n_4
        BPM = min(abs(initialBPM), Tempo.softLimit)
    }
    
    /// Initialize from a string describing the tempo, e.g. Tempo("Presto"). Generates a random value within a range (e.g. 115 - 140 for "Allegro").
    public init?(description: String) {

        guard let range = CountableClosedRange<Int>(tempo: description) else { return nil }
        self = Tempo(Double(arc4random_uniform(UInt32((range.upperBound - range.lowerBound) + range.lowerBound))))
    }
}

/**
 **Duration** is a simple base-class, not intended to be instantiated directly but to allow the **Metered** and **Proportional** subclasses to operate interchangeably in some contexts.
 */
open class Duration: Equatable {
    /// The most recent absolute-time interval represented by an instance.
    public var lastInterval: TimeInterval = 1.0
    
    public static func ==(lhs: Duration, rhs: Duration) -> Bool {
        return lhs.lastInterval == rhs.lastInterval
    }
}


/**
 **Metered** is a subclass of **Duration** that acts as an abstraction for a duration that has some metric context. The *lastInterval* property reflects the most recent absolute-time interval represented by an instance.
 */
open class Metered: Duration {
    /// The underlying meter.
    public var meter: TimeSignature? = TimeSignature(4, 4)
    
    /// A computed property that reflects the meter property, provided for convenience.
    public var timeSignature: TimeSignature? {
        get {
            return meter
        }
        set {
            meter = newValue
        }
    }
    
    /// The underlying tempo.
    public var tempo = Tempo(120)
    
    /// A computed property that reflects the tempo's beats-per-minute value, provided for convenience.
    public var BPM: Double {
        get {
            return tempo.BPM
        }

        set {
            tempo = Tempo(newValue)
        }
    }
    
    /// A NoteValue instance to easily change duration to another regular metric subdivision.
    public var noteValue: NoteValue = .n_4 {
        didSet {
            lastInterval = TimeInterval(60.0/(tempo.BPM * (noteValue.rawValue/tempo.value.rawValue)))
        }
    }
    
    /// Initialize with a tempo, a meter, and a beat value.
    public init(initialTempo: Tempo, initialMeter: TimeSignature, initialValue: NoteValue) {
        tempo = initialTempo
        meter = initialMeter
        noteValue = initialValue
    }
}

/**
 **Proportional** is a subclass of **Duration** that acts as an abstraction for a duration that is proportional to some base absolute-time interval. The *lastInterval* property reflects the most recent absolute-time interval represented by an instance.
 */
open class Proportional: Duration {
    /// The underlying base absolute-time interval which is scaled.
    public var baseSeconds: TimeInterval = 1.0
    
    /// Initialize from a base absolute-time interval, also setting the lastInterval property to this interval initially.
    public init(baseInterval: TimeInterval) {
        super.init()
        baseSeconds = abs(baseInterval)
        lastInterval = baseSeconds
    }
    
    /// Initialize from a base absolute-time interval and an initial scaling factor.
    public init(baseInterval: TimeInterval, scalingFactor: Double) {
        super.init()
        baseSeconds = abs(baseInterval)
        lastInterval =  baseSeconds * scalingFactor
    }
    
    /// Rescale the current instance's lastInterval property. Also returns the new absolute-time interval, which can be discarded.
    @discardableResult
    public func scale(by scalingFactor: Double) -> TimeInterval {
        lastInterval = baseSeconds * abs(scalingFactor)
        return lastInterval
    }
}
