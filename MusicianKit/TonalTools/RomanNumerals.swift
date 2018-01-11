//
//  RomanNumerals.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

/**
 The **RomanNumeral** type abstracts data and operations related to working with roman-numeral expressions of harmony. Two basic systems of roman-numerals are provided: 'Traditional' and 'Berklee', the former employing figured-bass notation and both upper and lower case characters, and the latter resembling chord symbols and using all upper case characters.
 */
public struct RomanNumeral {

    /**
     The **Traditional** roman numeral type uses figured-bass notation and both upper and lower case characters. Examples:

     - **iv6**: first-inversion minor triad built on the fourth scale-degree
     - **IM43**: second-inversion major-seventh chord built on the tonic.
     - **Ger6**: German augmented-sixth chord.
     - **VI6**: first-inversion major triad built on the flatted-sixth scale-degree.

     Note that the convention of using the upper case 'M' character to imply a major-seventh chord is applied here. I7, for example, implies a dominant-seventh chord built on the tonic. Initialized with a string, e.g. RomanNumeral.Traditional("iv6").
     */
    public struct Traditional {
        /// All available roman numeral strings as an array of strings.
        public static var options: [String] {
            return RNDict.keys.map { String($0) }
        }

        /// Offsets-from-tonic for the current instance (values can be > 12).
        public var offsets = [Int]()

        /// Offsets-from-tonic as a pitch-class set (may negate inversion).
        public var pcset: PCSet {
            return PCSet(offsets)
        }

        /// Initialize from a string containing a roman numeral symbol. E.g. RomanNumeral.Traditional("viiº7")
        public init?(_ symbol: String) {
            guard let o = RNDict[symbol] else { return nil }
            offsets = o.split(separator: " ").map { Int($0)! }
        }

        /// Map a roman numeral's offsets to a particular key and octave, in the style of MIDI note numbers.
        public func toMIDI(in key: Key, bassOctave: UInt8) -> [UInt8] {
            return offsets.map { UInt8($0 + key.PC) + (min(8, bassOctave) * 12) }
        }

        /// Map a roman numeral's offsets to a particular key.
        public func offsets(in key: Key) -> [Int] {
            return offsets.map { $0 + key.PC }
        }

        /// Map a secondary function. E.g. RomanNumeral.Traditional("iv").of(RomanNumeral.Traditional("III"), in: .C).
        public func of(_ secondaryRef: Traditional, in key: Key) -> [Int] {
            let sec = PCSet(secondaryRef.offsets)[0]
            return offsets.map { $0 + sec + key.PC }
        }
    }

    /**
     The **Berklee** roman numeral type uses chord-symbol style notation and only upper case characters, as is used in the system of harmony taught to undergraduates in the Berkee College of Music's core jazz-based harmony courses. Examples:

     - **IVm6**: minor-sixth chord built on the fourth scale-degree.
     - **bVImaj7#11**: major-seventh chord with an added sharp-eleventh built on the flatted-sixth scale-degree.
     - **V7b9#9b5#5**: dominant-seventh chord with a flatted-ninth, sharp-ninth, flatted-fifth, and sharp-fifth (no perfect-fifth) built on the fifth scale-degree.
     - **subV7/IV**: dominant-seventh chord built on the flatted-fifth scale-degree.

     Initialized with a string, e.g. RomanNumeral.Traditional("bIIImaj7b5").
     */
    public struct Berklee {
        /// Offsets-from-tonic for the current instance (values can be > 12).
        public var offsets = [Int]()

        /// Offsets-from-tonic as a pitch-class set (may negate inversion).
        public var pcset: PCSet {
            return PCSet(offsets)
        }

        /// Initialize from a string containing a roman numeral symbol. E.g. RomanNumeral.Berklee("Imaj7#9")
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

        /// Helper function to map the roman numeral portion of the symbol to an initial offset value.
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

        /// Returns a pitch-class set corresponding to the current roman numeral instance, as it applies to the specified key (may negate inversion).
        public func pitchClasses(in key: Key) -> PCSet? {
            return PCSet(offsets.map { ($0 + key.rawValue) % 12 })
        }

        /// Map a roman numeral's offsets to a particular key and octave, in the style of MIDI note numbers.
        public func toMIDI(bassOctave: UInt8) -> [UInt8] {
            return offsets.map { UInt8($0) + (min(8, bassOctave) * 12) }
        }
    }
}
