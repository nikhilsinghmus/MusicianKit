//
//  String+ParseChordSymbol.swift
//  MusicianKit
//
//  Created by Nikhil Singh on 11/6/17.
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public extension String {
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
            return SeparatedChordSymbol(pl, replacingOccurrences(of: portion, with: ""))
        }
        
        return nil
    }
    
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
    
    public func mapPitchToLetter() -> PitchLetter? {
        return nil
    }
}
