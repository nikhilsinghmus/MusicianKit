//
//  PostTonalTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

public typealias PitchClass = Int

/**
 **PostTonalTools** is an abstract class and a toolkit for dealing with post-tonal music-theoretic and compositional conventions, including musical group theory, tone rows and matrices, etc.
 */
open class PostTonalTools {
    private init() { } // Abstract class
    
    private static let notes: Dictionary<String, Int> = ["C": 0, "D": 2, "E": 4, "F": 5, "G": 7, "A": 9, "B": 11]
    
    private static func nn2n(_ noteNames: [String]) -> [PitchClass?] {
        return noteNames.flatMap { noteMap($0) }
    }
    
    /// Map a note name to a pitch-class (0 - 11). Returns nil if a direct mapping cannot be found. E.g. noteMap("F") returns 5.
    public static func noteMap(_ noteName: String) -> PitchClass? {
        var ext = noteName.uppercased()
        let letter = ext.characters.popFirst()
        
        guard let letterName = letter else { return nil }
        guard var note = notes[String(letterName)] else { return nil }
        
        for c in ext.characters {
            switch String(c) {
            case "#": note += 1
            case "b": note -= 1
            case "x": note += 2
            default: return nil
            }
        }
        
        return note
    }
    
    /// Map a note name to a pitch-class (0 - 23) in 24EDO. Returns nil if a direct mapping cannot be found. Uses '+' for quarter-tone-sharp, and 'd' for quarter-tone-flat. E.g. noteMap24("Fd") returns 9, noteMap24("G+") returns 15, noteMap24("A") returns 18.
    public static func noteMap24(_ noteName: String) -> PitchClass? {
        var ext = noteName.uppercased()
        let letter = ext.characters.popFirst()
        
        guard let letterName = letter else { return nil }
        guard var note = notes[String(letterName)] else { return nil }
        note *= 2
        
        for c in ext.characters {
            switch String(c) {
            case "#": note += 2
            case "b": note -= 2
            case "x": note += 4
            case "+": note += 1
            case "d": note -= 1
            default: return nil
            }
        }
        
        return note
    }
}

/**
 **MatrixForm** is an enum to help navigate ToneMatrix objects. The four forms available are p, i, r, and ri, corresponding to Prime, Inversion, Retrograde, and Retrograde-Inversion respectively.
 */
public enum MatrixForm {
    case p, i, r, ri
}
