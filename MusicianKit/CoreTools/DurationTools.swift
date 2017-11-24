//
//  DurationTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public struct TimeSignature {
    public var numerator: UInt8 = 4
    public var denominator: UInt8 = 4
    
    public init?(_ count: UInt8, _ value: UInt8) {
        let x = log2(Double(value))
        guard x == floor(x) else { return nil } // Ensure meter is a dyadic rational. No 'irrational' meter implementation (yet!)
        
        numerator = count
        denominator = value
    }
}

public enum NoteValue: Double {
    case n_1, n_2, n_4, n_8, n_16, n_32, n_64, n_128
    case d_1, d_2, d_4, d_8, d_16, d_32, d_64, d_128
    case t_1, t_2, t_4, t_8, t_16, t_32, t_64, t_128
}

public struct Tempo {
    public static var softLimit: Double = 400.0
    
    public var BPM: Double = 120
    public var value: NoteValue = .n_4
    
    public init(_ noteValue: NoteValue, _ initialBPM: Double) {
        value = noteValue
        BPM = min(abs(initialBPM), Tempo.softLimit)
    }
    
    public init(_ initialBPM: Double) {
        value = .n_4
        BPM = min(abs(initialBPM), Tempo.softLimit)
    }
    
    public init?(description: String) {
        let descriptionDict: Dictionary<String, CountableRange<Int>> = ["grave": 40..<50, "largo": 50..<55, "larghetto": 55..<60, "adagio": 60..<70, "andante": 70..<85, "moderato": 85..<100, "allegretto": 100..<115, "allegro": 115..<140, "vivace": 140..<150, "presto": 150..<170, "prestissimo": 170..<200]
        
        guard let range = descriptionDict[description] else { return nil }
        self = Tempo(Double(arc4random_uniform(UInt32((range.upperBound - range.lowerBound) + range.lowerBound))))
    }
}

public struct Time {
    public struct Metered {
        public var meter: TimeSignature? = TimeSignature(4, 4)
        public var timeSignature: TimeSignature? {
            get {
                return meter
            }
            set(newValue) {
                meter = newValue
            }
        }
        public var tempo = Tempo(120)
        public var BPM: Double {
            get {
                return tempo.BPM
            }
            
            set(newValue) {
                tempo = Tempo(newValue)
            }
        }
        
        public func getAbsoluteTime(for subdivision: UInt8) -> TimeInterval {
            return TimeInterval(60.0/(tempo.BPM * (Double(subdivision)/tempo.value.rawValue)))
        }
        
        public init(initialTempo: Tempo, initialMeter: TimeSignature) {
            tempo = initialTempo
            meter = initialMeter
        }
    }
    
    public struct Proportional {
        public var baseSeconds: TimeInterval = 1.0
        public var lastInterval: TimeInterval = 1.0
        
        public init(baseInterval: TimeInterval) {
            baseSeconds = abs(baseInterval)
        }
        
        public mutating func scale(by scalingFactor: Double) -> TimeInterval {
            lastInterval = baseSeconds * abs(scalingFactor)
            return lastInterval
        }
    }
}

