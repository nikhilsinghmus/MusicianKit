//
//  String+ParseChordSymbol.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

/// Extensions to the String type to enable parsing chord symbols in a functional style.
public extension String {
    /// Separate a chord symbol's root from its suffix in a string and return both in a SeparatedChordSymbol instance.
    public func separateRoot() -> SeparatedChordSymbol? {
        let accidental = String(prefix(2)).suffix(1)
        let extAccidental = String(prefix(3)).suffix(2)

        var portion = ""

        if extAccidental == "bb" || extAccidental == "♭♭" {
            if let pitchLetter = characters.first {
                portion = String(pitchLetter) + extAccidental
            }
        } else if accidental == "#" || accidental == "b" || accidental == "x" || accidental == "♭" || accidental == "♯" {
            if let pitchLetter = characters.first {
                portion = String(pitchLetter) + accidental
            }
        } else {
            if let pitchLetter = characters.first {
                portion = String(pitchLetter)
            }
        }

        if let pl = portion.mapPitchToLetter() {
            return SeparatedChordSymbol(pl, self.replacingOccurrences(of: portion, with: ""))
        }

        return nil
    }

    /// Map a string containing a pitch-letter to a pitch-class.
    public func mapPitch() -> PitchClass? {
        var initialPC = 0
        var stringCopy = self

        if let first = stringCopy.characters.popFirst() {
            switch first {
            case "C": initialPC = 0
            case "D": initialPC = 2
            case "E": initialPC = 4
            case "F": initialPC = 5
            case "G": initialPC = 7
            case "A": initialPC = 9
            case "B": initialPC = 11
            default: return nil
            }
        }

        switch stringCopy {
        case "#": initialPC += 1
        case "b": initialPC -= 1
        case "x": initialPC += 2
        case "♯": initialPC += 1
        case "bb": initialPC -= 2
        case "♭": initialPC -= 1
        case "♭♭": initialPC -= 2
        default: return nil
        }

        return initialPC
    }

    /// Map a string containing a pitch-letter to a PitchLetter instance.
    public func mapPitchToLetter() -> PitchLetter? {
        let stringCopy = self.replacingOccurrences(of: "♭", with: "b").replacingOccurrences(of: "♯", with: "s").replacingOccurrences(of: "#", with: "s")
        return PitchLetter.all[stringCopy]
    }

    /// Parse a chord symbol's suffix and get a pitch-class set from it as it would apply to C (pitch-class 0). E.g. "m7".mapSuffix().
    public func mapSuffix() -> PCSet? {

        var offsets = Set<Int>()
        let s = Array(self).map { String($0) }

        if s[0] == "7" {
            [0, 4, 7, 10].forEach { offsets.insert($0) }
        } else if (s[0] == "m" || s[0] == "-") && self.substring(0, 3) != "maj" {

            switch s[1] {
            case "7": offsets.insert(10)
            case "6": offsets.insert(9)
            case "9": offsets.insert(2)
            default: break
            }

            if self.contains("b5") {
                [0, 3, 6].forEach { offsets.insert($0) }
            } else {
                [0, 3, 7].forEach { offsets.insert($0) }
            }

            if self.substring(1, 4) == "maj" || self.substring(1, 4) == "Maj" {
                switch (s[4]) {
                case "7": offsets.insert(11)
                case "9": [11, 2].forEach { offsets.insert($0) }
                default: break;
                }
            }

        } else if s[0] == "M" || self.substring(0, 3) == "maj" || self.substring(0, 3) == "Maj" {

            if s[1] == "7" || s[3] == "7" {
                offsets.insert(11);
            } else if (s[1] == "9" || s[3] == "9") {
                [11, 2].forEach { offsets.insert($0) }
            }

            if self.contains("#5") {
                [0, 4, 8].forEach { offsets.insert($0) }
            } else {
                [0, 4, 7].forEach { offsets.insert($0) }
            }

        } else if s[0] == "º" || s[0] == "o" || s[0] == "d" || self.substring(0, 3) == "dim" {
            [0, 3, 6].forEach { offsets.insert($0) }

            if (s[1] == "7" || s[3] == "7") {
                offsets.insert(9);
            }
        } else if s[0] == "+" || s[0] == "a" || self.substring(0, 3) == "aug" {
            [0, 4, 8].forEach { offsets.insert($0) }

            if self.contains("maj7") || self.contains("Maj7") {
                offsets.insert(11);
            } else if self.contains("7") {
                offsets.insert(10);
            }
        }

        for i in 0 ..< s.count {
            if s[i] == "#" {
                switch (s[i+1]) {
                case "9": offsets.insert(3)
                case "5": offsets.insert(8); _ = offsets.remove(7)
                case "1": if s[i+2] == "1" { offsets.insert(6) }
                default: break
                }
            } else if s[i] == "b" {
                switch (s[i + 1]) {
                case "9": offsets.insert(1)
                case "5": offsets.insert(6); _ = offsets.remove(7)
                case "1": if s[i+2] == "3" { offsets.insert(8) }
                default: break
                }
            }
        }

        return PCSet(offsets)
    }

    /// Helper function to get substrings using a JavaScript-like interface.
    public func substring(_ fromIndex: Int, _ toIndex: Int) -> String {
        return String(String(self.suffix(self.endIndex.encodedOffset - fromIndex)).prefix(toIndex - fromIndex))
    }
}
