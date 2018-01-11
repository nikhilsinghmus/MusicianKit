//
//  ModalTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

/**
 **Modes** is an abstract class that deals with standard modal collections as well as cataloguing user-generated scales. E.g. Modes.Major.fourth.offsets gives offsets-from-tonic for the lydian mode as an array of Ints, i.e. [0, 2, 4, 6, 7, 9, 11].
 */
open class Modes {
    private init() { } // Abstract class

    /// A dictionary containing user-defined modes. The key is the mode name.
    public static var user: [String: Mode] = [:]

    /// Get offsets for an arbitrary mode of a base collection of offsets.
    public static func modalRotate(_ baseType: [Int], by amount: Int) -> [Int] {
        return (0..<baseType.count).map { (baseType[($0 + amount) % baseType.count] - baseType[amount] + 12) % 12 }
    }

    /// Major modes. Can be accessed by their names or numbered instances. E.g. Modes.Major.ionian is the same as Modes.major.first.
    public enum Major: Int {
        case ionian, dorian, phrygian, lydian, mixolydian, aeolian, locrian
        public static let first = ionian, second = dorian, third = phrygian, fourth = lydian, fifth = mixolydian, sixth = aeolian, seventh = locrian

        /// Offsets-from-tonic for the current mode, as an array of Ints.
        var offsets: [Int] {
            let baseType = KeyType.major.pattern
            return Modes.modalRotate(baseType, by: rawValue)
        }

        /// Harmonic major modes. Accessed by numbered cases, e.g. Modes.Major.Harmonic.fifth.offsets returns [0, 1, 4, 5, 7, 9, 10].
        public enum Harmonic: Int {
            case first, second, third, fourth, fifth, sixth, seventh

            /// Offsets-from-tonic for the current mode, as an array of Ints.
            public var offsets: [Int] {
                var baseType = KeyType.major.pattern
                baseType[5] = 8
                return Modes.modalRotate(baseType, by: rawValue)
            }
        }
    }

    /// Provides harmonic and melodic minor modes through Minor.Harmonic and Minor.Melodic respectively.
    public enum Minor {
        /// Harmonic minor modes. Accessed by numbered cases, e.g. Modes.Minor.Harmonic.fifth.offsets returns [0, 1, 4, 5, 7, 8, 10]
        public enum Harmonic: Int {
            case first, second, third, fourth, fifth, sixth, seventh

            /// Offsets-from-tonic for the current mode, as an array of Ints.
            public var offsets: [Int] {
                var baseType = KeyType.minor.pattern
                baseType[6] = 11
                return Modes.modalRotate(baseType, by: rawValue)
            }
        }

        /// Melodic minor modes. Accessed by numbered cases, e.g. Modes.Minor.Melodic.fifth.offsets returns [0, 2, 3, 5, 7, 8, 10].
        public enum Melodic: Int {
            case first, second, third, fourth, fifth, sixth, seventh

            /// Offsets-from-tonic for the current mode, as an array of Ints.
            public var offsets: [Int] {
                var baseType = KeyType.minor.pattern
                baseType[5] = 9
                baseType[6] = 11
                return Modes.modalRotate(baseType, by: rawValue)
            }
        }
    }
}

/**
 The **Mode** type is used for defining custom scale structures. Initialized with either a name string and an array of Int offsets-from-tonic, or with a name string and a pitch-class set (in which case the prime form is used).
 */
public struct Mode {
    /// Custom mode/scale name.
    public var name = ""

    /// Custom mode/scale offsets-from-tonic.
    public var offsets = [Int]()

    /// Initialize from a name string and offsets-from-tonic Int array.
    public init(modeName: String, modeOffsets: [Int]) {
        name = modeName
        offsets = modeOffsets.map { $0 % 12 }
        Modes.user[name] = self
    }

    /// Initialize from a name string and a pitch-class set (the prime form of which is used).
    public init(modeName: String, pcset: PCSet) {
        name = modeName
        let temp = pcset.getPrimeForm()
        offsets = temp.map { $0 - temp[0] }
        Modes.user[name] = self
    }

    /// Get a mode of a **Mode** parent scale instance.
    public func getMode(_ number: UInt8) -> [Int] {
        return Modes.modalRotate(offsets, by: min(max(0, Int(number) - 1), offsets.count - 1))
    }
}
