//
//  XenharmonicTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

public typealias ED = (Int, Int)

/**
 **XenharmonicTools** is an abstract class and a toolkit for dealing with tuning systems, and more generally with pitch-spaces, outside 12-ED2.
 */
open class XenharmonicTools {
    private init() { } // Abstract class

    /// Fit an equal division of an octave/diapason (>= 12) to an array of MIDI-note-number-style Doubles.
    public static func midiParseEDO(_ midiPitches: [Double]) -> Int {
        let afterRadix = midiPitches.map { $0 - floor($0) }
        guard let smallest = (afterRadix.filter { $0 != 0 }).min() else { return 0 }
        guard let largest = afterRadix.max() else { return 0 }

        if largest == 0 { return 12 }
        return Int(round((1/smallest) * 12))
    }

    /// Get an increment to use as a generator for some equal division of an octave/diapason.
    public static func EDOGetIncrement(_ edo: Int) -> Double {
        return 12/Double(edo)
    }
}
