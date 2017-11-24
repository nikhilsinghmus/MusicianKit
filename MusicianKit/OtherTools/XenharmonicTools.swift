//
//  XenharmonicTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public typealias ED = (Int, Int)

open class XenharmonicTools {
    public static func midiParseEDO(_ midiPitches: [Double]) -> Int {
        let afterRadix = midiPitches.map { $0 - floor($0) }
        guard let smallest = (afterRadix.filter { $0 != 0 }).min() else { return 0 }
        guard let largest = afterRadix.max() else { return 0 }
        
        if largest == 0 { return 12 }
        return Int(round((1/smallest) * 12))
    }
    
    public static func EDOGetIncrement(_ edo: Int) -> Double {
        return 12/Double(edo)
    }
}
