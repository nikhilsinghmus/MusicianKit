//
//  RomanNumerals.swift
//  MusicianKit
//
//  Created by Nikhil Singh on 10/8/17.
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public struct RomanNumeral {
    
    public static var rnDict: NSDictionary? {
        guard let path = Bundle.main.path(forResource: "RNLookup", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path)
    }
    
    public enum Traditional: String {
        case I,
        I6,
        I64,
        I7,
        I65,
        I43,
        I42,
        i,
        i6,
        i64,
        i7,
        i65,
        i43,
        i42,
        ii,
        ii6,
        ii64,
        ii7,
        ii65,
        ii43,
        ii42,
        iiº,
        iiº6,
        iiº64,
        iiø7,
        iiø65,
        iiø43,
        iiø42,
        iii,
        iii6,
        iii64,
        iii7,
        iii65,
        iii43,
        iii42,
        III,
        III6,
        III64,
        III7,
        III65,
        III43,
        III42,
        IV,
        IV6,
        IV64,
        IV7,
        IV65,
        IV43,
        IV42,
        iv,
        iv6,
        iv64,
        iv7,
        iv65,
        iv43,
        iv42,
        V,
        V6,
        V64,
        V7,
        V65,
        V43,
        V42,
        v,
        v6,
        v64,
        v7,
        v43,
        v42,
        vi,
        vi6,
        vi64,
        vi7,
        vi65,
        vi43,
        vi42,
        VI,
        VI6,
        VI65,
        VI43,
        VI42,
        viiº,
        viiº6,
        viiº64,
        viiº7,
        viiº65,
        viiº43,
        viiº42,
        N,
        N6,
        N64,
        It6,
        Fr6,
        Ger6
        
        public func notes(in key: Key) -> PCSet? {
            guard let rnval = rnDict?.value(forKey: rawValue) as? String else { return nil }
            let split = rnval.split(separator: " ")
            return PCSet(split.map { PitchClass($0) ?? 0 }.map { ($0 + key.rawValue) % 12 })
        }
        
        public func of(_ secondaryRef: Traditional, in key: Key) -> PCSet? {
            guard let offset = secondaryRef.notes(in: key), let notes = notes(in: key) else { return nil }
            return PCSet(notes.map { ($0 + offset[0]) % 12 })
        }
    }
}
