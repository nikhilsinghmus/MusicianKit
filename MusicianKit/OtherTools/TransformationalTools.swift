//
//  TransformationalTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

precedencegroup Monadic {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: LogicalDisjunctionPrecedence
}

infix operator >>-: Monadic
public func >>- <T, U>(a: T?, f: (T) -> U?) -> U? {
    return a.flatMap(f)
}

/**
 **TransformationalTools** is an abstract class and a toolkit for dealing with neo-riemannian and transformational ideas in musical composition and analysis.
 */
public class TransformationalTools {
    private init() { } // Abstract class

    /// Dictionary mapping roots for the R transformation from major.
    public static let relativeFromMajor: [PitchLetter: PitchLetter] = [.C: .A, .Bs: .Gx, .Dbb: .Bbb, .Db: .Bb, .Cs: .As, .D: .B, .Cx: .Ax, .Ebb: .Cb, .Eb: .C, .Ds: .Bs, .E: .Cs, .Dx: .Bx, .Fb: .Db, .F: .D, .Es: .Cx, .Gbb: .Ebb, .Gb: .Eb, .Fs: .Ds, .G: .E, .Fx: .Dx, .Abb: .Fb, .Ab: .F, .Gs: .Es, .A: .Fs, .Gx: .Ex, .Bbb: .Gb, .Bb: .G, .As: .Fsx, .B: .Gs, .Ax: .Fx, .Cb: .Ab]

    /// Dictionary mapping roots for the L transformation from major.
    public static let leadingToneFromMajor: [PitchLetter: PitchLetter] = [.C: .E, .Bs: .Dx, .Dbb: .Fb, .Db: .F, .Cs: .Es, .D: .Fs, .Cx: .Ex, .Ebb: .Gb, .Eb: .G, .Ds: .Fx, .E: .Gs, .Dx: .Fsx, .Fb: .Ab, .F: .A, .Es: .Gx, .Gbb: .Bbb, .Gb: .Bb, .Fs: .As, .G: .B, .Fx: .Ax, .Abb: .Cb, .Ab: .C, .Gs: .Bs, .A: .Cs, .Gx: .Bx, .Bbb: .Db, .Bb: .D, .As: .Cx, .B: .Ds, .Ax: .Csx, .Cb: .Eb]

    /// Perform a standard transformation on some triad represented by a tuplet containing a root and a chord quality. Available transformations are cases in the **Transformation** enum: P, L, R, N, S, H.
    public static func transform(_ chord: (PitchLetter, ChordQuality), by transformation: Transformation) -> (PitchLetter, ChordQuality)? {

        switch chord.1 {
        case .major:
            switch transformation {
            case .P: return parallel(chord)
            case .R: return relative(chord)
            case .L: return leadingTone(chord)
            case .N: return chord >>- relative >>- leadingTone >>- parallel
            case .S: return chord >>- leadingTone >>- parallel >>- relative
            case .H: return chord >>- leadingTone >>- parallel >>- leadingTone
            }
        case .minor: break
        default: break
        }

        return nil
    }

    /// Perform a P transformation on some triad represented by a tuplet containing a root and a chord quality.
    public static func parallel(_ chord: (PitchLetter, ChordQuality)) -> (PitchLetter, ChordQuality)? {
        switch chord.1 {
        case .major: return (chord.0, ChordQuality.minor)
        case .minor: return (chord.0, ChordQuality.major)
        default: return nil
        }
    }

    /// Perform a R transformation on some triad represented by a tuplet containing a root and a chord quality.
    public static func relative(_ chord: (PitchLetter, ChordQuality)) -> (PitchLetter, ChordQuality)? {
        return transform(chord, with: relativeFromMajor)
    }

    /// Perform an L transformation on some triad represented by a tuplet containing a root and a chord quality.
    public static func leadingTone(_ chord: (PitchLetter, ChordQuality)) -> (PitchLetter, ChordQuality)? {
        return transform(chord, with: leadingToneFromMajor)
    }

    /// Attempt to identify a single standard transformational mapping between two triads.
    public static func checkSingleTransformation(from chord: (PitchLetter, ChordQuality), to otherChord: (PitchLetter, ChordQuality)) -> Transformation? {

         return Transformation.allValues.first {
            transform(chord, by: $0).map { $0 == otherChord } ?? false
        }
    }

    private static func transform(_ chord: (PitchLetter, ChordQuality), with lookupDict: [PitchLetter: PitchLetter]) -> (PitchLetter, ChordQuality)? {
        var newQuality = ChordQuality.major
        var newRoot = PitchLetter.C

        switch chord.1 {
        case .major:
            newQuality = .minor
            guard let nr = lookupDict[chord.0] else { return nil }
            newRoot = nr
        case .minor:
            guard let index = lookupDict.index(forKey: chord.0) else { return nil }
            newRoot = lookupDict[index].key
        default: return nil
        }

        return (newRoot, newQuality)
    }
}

/**
 The **Transformation** enum identifies types of neo-riemannian transformations. Available transformations: P, R, L, N, S, H.
 */
public enum Transformation {
    case P, R, L, N, S, H

    /// An array of all enum cases.
    static let allValues: [Transformation] = [.P, .R, .L, .N, .S, .H]
}

/**
 The **ChordQuality** enum identifies triadic chord qualities for easy use in transformational contexts.
 */
public enum ChordQuality {
    case major, minor, diminished, augmented
}
