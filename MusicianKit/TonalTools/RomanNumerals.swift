//
//  RomanNumerals.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public struct RomanNumeral {
    
    public struct Traditional {
        public var offsets = [Int]()
        public var pcset: PCSet {
            return PCSet(offsets)
        }
        public var options: [String] {
            return RNDict.keys.map { String($0) }
        }
        
        public init?(_ symbol: String) {
            guard let o = RNDict[symbol] else { return nil }
            offsets = o.split(separator: " ").map { Int($0)! }
        }
        
        public func toMIDI(in key: Key, bassOctave: UInt8) -> [Int] {
            return offsets.map { ($0 + key.PC) + (min(8, Int(bassOctave)) * 12) }
        }
        
        public func offsets(in key: Key) -> [Int] {
            return offsets.map { $0 + key.PC }
        }
        
        public func of(_ secondaryRef: Traditional, in key: Key) -> [Int] {
            let sec = PCSet(secondaryRef.offsets)[0]
            return offsets.map { $0 + sec + key.PC }
        }
    }
    
    public struct Berklee {
        public var offsets = [Int]()
        public var pcset: PCSet {
            return PCSet(offsets)
        }
        
        public init?(_ symbol: String) {
            var sym = symbol.uppercased()
            var subV7Flag = false
            
            if sym == "SUBV7" {
                offsets = [1, 5, 8, 11]
                return
            }
            
            var rootOffset = (sym.prefix(1) == "#") ? 1 : ((sym.prefix(1) == "B") ? -1 : 0)
            if rootOffset != 0 { sym = String(sym.suffix(sym.endIndex.encodedOffset - 1)) }
            
            guard var prefix = mapRN(sym) else { return nil }
            
            if prefix == "SUBV7" {
                subV7Flag = true
                rootOffset += 1
                if let p = mapRN(sym.replacingOccurrences(of: "SUBV7/", with: "")) {
                    prefix = p
                } else {
                    return nil
                }
            }
            
            let suffix = sym.replacingOccurrences(of: prefix, with: "")
            
            var offset = 0
            switch prefix {
            case "II": offset = 2
            case "III": offset = 4
            case "IV": offset = 5
            case "V": offset = 7
            case "VI": offset = 9
            case "VII": offset = 11
            default: break
            }
            
            offset += rootOffset
            var offsetsFromZero = [Int]()
            
            if suffix == "" {
                offsetsFromZero = [0, 4, 7]
            } else if let o = suffix.mapSuffix() {
               offsetsFromZero = o.pitchClasses
            }
        
            if subV7Flag {
                offsetsFromZero = [0, 4, 7, 10]
            }
            
            offsets = offsetsFromZero.map { ($0 + offset) % 12 }
        }
        
        public func mapRN(_ symbol: String) -> String? {
            let first1 = symbol.prefix(1)
            let first2 = symbol.prefix(2)
            let first3 = symbol.prefix(3)
            let first5 = symbol.prefix(5)
            
            var prefix = ""
            
            if first5 == "SUBV7" {
                prefix = String(first5)
            } else if first3 == "III" || first3 == "VII" {
                prefix = String(first3)
            } else if first2 == "II" || first2 == "IV" || first2 == "VI" {
                prefix = String(first2)
            } else if first1 == "I" || first1 == "V" {
                prefix = String(first1)
            } else {
                return nil
            }
            
            return prefix
        }
        
        public func pitchClasses(in key: Key) -> PCSet? {
            return PCSet(offsets.map { ($0 + key.rawValue) % 12 })
        }
        
        public func toMIDI(bassOctave: UInt8) -> [Int] {
            return offsets.map { $0 + (min(8, Int(bassOctave)) * 12) }
        }
    }
}
