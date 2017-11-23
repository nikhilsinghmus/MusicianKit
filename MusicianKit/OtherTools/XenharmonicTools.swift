//
//  XenharmonicTools.swift
//  MusicianKit
//
//  Created by Nikhil Singh on 10/8/17.
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public typealias ED = (Int, Int)

open class XenharmonicTools {
    public func midiParseEDO(_ midiPitches: [Double]) -> Int {
        let afterRadix = midiPitches.map { $0 - floor($0) }
        guard let smallest = afterRadix.min() else { return 0 }
        
        if smallest == 0 { return 12 }
        return Int((1/smallest) * 12)
    }
    
    public func EDOGetIncrement(_ edo: Int) -> Double {
        return Double(edo)/12
    }
    
    public func EDXGetIncrement(_ edx: ED) -> Double {
        return (Double(edx.1)/2 * 12)/Double(edx.0)
    }
}
