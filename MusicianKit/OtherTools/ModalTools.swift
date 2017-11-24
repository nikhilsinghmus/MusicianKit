//
//  ModalTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

open class Modes {
    private init() { } // Explicitly make Modes an abstract class
    
    public static var user: Dictionary<String, Mode> = [:]
    
    fileprivate static func modalRotate(_ baseType: [Int], by amount: Int) -> [Int] {
        return (0..<baseType.count).map { (baseType[($0 + amount) % baseType.count] - baseType[amount] + 12) % 12 }
    }
    
    public enum Major: Int {
        case ionian, dorian, phrygian, lydian, mixolydian, aeolian, locrian
        public static let first = ionian, second = dorian, third = phrygian, fourth = lydian, fifth = mixolydian, sixth = aeolian, seventh = locrian
        var offsets: [Int] {
            let baseType = KeyType.major.pattern
            return Modes.modalRotate(baseType, by: rawValue)
        }
        
        public enum Harmonic: Int {
            case first, second, third, fourth, fifth, sixth, seventh
            public var offsets: [Int] {
                var baseType = KeyType.major.pattern
                baseType[5] = 8
                return Modes.modalRotate(baseType, by: rawValue)
            }
        }
    }
    
    public enum Minor {
        public enum Harmonic: Int {
            case first, second, third, fourth, fifth, sixth, seventh
            public var offsets: [Int] {
                var baseType = KeyType.minor.pattern
                baseType[6] = 11
                return Modes.modalRotate(baseType, by: rawValue)
            }
        }
        
        public enum Melodic: Int {
            case first, second, third, fourth, fifth, sixth, seventh
            public var offsets: [Int] {
                var baseType = KeyType.minor.pattern
                baseType[5] = 9
                baseType[6] = 11
                return Modes.modalRotate(baseType, by: rawValue)
            }
        }
    }
}

public struct Mode {
    public var name = ""
    public var offsets = [Int]()
    
    public init(modeName: String, modeOffsets: [Int]) {
        name = modeName
        offsets = modeOffsets.map { $0 % 12 }
        Modes.user[name] = self
    }
    
    public init(modeName: String, pcset: PCSet) {
        name = modeName
        let temp = pcset.thinned().sorted()
        offsets = temp.map { $0 - temp[0] }
        Modes.user[name] = self
    }
    
    public func getMode(_ number: UInt8) -> [Int] {
        return Modes.modalRotate(offsets, by: min(max(0, Int(number) - 1), offsets.count - 1))
    }
}
