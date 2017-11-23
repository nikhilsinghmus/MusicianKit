//
//  ModalTools.swift
//  MusicianKit
//
//  Created by Nikhil Singh on 9/28/17.
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public enum Modes {
    private static func modalRotate(_ baseType: [Int], by amount: Int) -> [Int] {
        return (0..<baseType.count).map { (baseType[($0 + amount) % baseType.count] - baseType[amount] + 12) % 12 }
    }
    
    public enum Major: Int {
        case ionian, dorian, phrygian, lydian, mixolydian, aeolian, locrian
        static let first = ionian, second = dorian, third = phrygian, fourth = lydian, fifth = mixolydian, sixth = aeolian, seventh = locrian
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

open class Mode {
    
    public func define(_ offsets: [Int]) {
        
    }
    
    public func define(with pcset: PCSet) {
        
    }
}
