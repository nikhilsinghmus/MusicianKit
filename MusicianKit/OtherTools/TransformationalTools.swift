//
//  TransformationalTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

/**
 **TransformationalTools** is an abstract class and a toolkit for dealing with neo-riemannian and transformational ideas in musical composition and analysis.
 */
public class TransformationalTools {
    private init() { } // Abstract class

    /// Dictionary mapping roots for the R transformation from major.
    public static let relativeFromMajor: [PitchLetter: PitchLetter] = [.C: .A, .Bs: .Gx, .Dbb: .Bbb, .Db: .Bb, .Cs: .As, .D: .B, .Cx: .Ax, .Ebb: .Cb, .Eb: .C, .Ds: .Bs, .E: .Cs, .Dx: .Bx, .Fb: .Db, .F: .D, .Es: .Cx, .Gbb: .Ebb, .Gb: .Eb, .Fs: .Ds, .G: .E, .Fx: .Dx, .Abb: .Fb, .Ab: .F, .Gs: .Es, .A: .Fs, .Gx: .Ex, .Bbb: .Gb, .Bb: .G, .As: .Fsx, .B: .Gs, .Ax: .Fx, .Cb: .Ab]

    /// Dictionary mapping roots for the L transformation from major.
    public static let leadingToneFromMajor: [PitchLetter: PitchLetter] = [.C: .A, .Bs: .Gx, .Dbb: .Bbb, .Db: .Bb, .Cs: .As, .D: .B, .Cx: .Ax, .Ebb: .Cb, .Eb: .C, .Ds: .Bs, .E: .Cs, .Dx: .Bx, .Fb: .Db, .F: .D, .Es: .Cx, .Gbb: .Ebb, .Gb: .Eb, .Fs: .Ds, .G: .E, .Fx: .Dx, .Abb: .Fb, .Ab: .F, .Gs: .Es, .A: .Fs, .Gx: .Ex, .Bbb: .Gb, .Bb: .G, .As: .Fsx, .B: .Gs, .Ax: .Fx, .Cb: .Ab]

    /// Perform a standard transformation on some triad represented by a tuplet containing a root and a chord quality. Available transformations are cases in the **Transformation** enum: P, L, R, N, S, H.
    public static func transform(_ chord: (PitchLetter, ChordQuality), by transformation: Transformation) -> (PitchLetter, ChordQuality)? {

        switch chord.1 {
        case .major:
            switch transformation {
            case .P: return getParallel(chord)
            case .R: return getRelative(chord)
            case .L: return getLeadingTone(chord)
            case .N:
                if let c = getRelative(chord) {
                    if let c = getLeadingTone(c) {
                        if let c = getParallel(c) {
                            return c
                        }
                    }
                }
                return nil
            case .S:
                if let c = getLeadingTone(chord) {
                    if let c = getParallel(c) {
                        if let c = getRelative(c) {
                            return c
                        }
                    }
                }
                return nil
            case .H:
                if let c = getLeadingTone(chord) {
                    if let c = getParallel(c) {
                        if let c = getLeadingTone(c) {
                            return c
                        }
                    }
                }
                return nil
            }
        case .minor: break
        default: break
        }

        return nil
    }

    /// Perform a P transformation on some triad represented by a tuplet containing a root and a chord quality.
    public static func getParallel(_ chord: (PitchLetter, ChordQuality)) -> (PitchLetter, ChordQuality)? {
        switch chord.1 {
        case .major: return (chord.0, ChordQuality.minor)
        case .minor: return (chord.0, ChordQuality.major)
        default: return nil
        }
    }

    /// Perform a R transformation on some triad represented by a tuplet containing a root and a chord quality.
    public static func getRelative(_ chord: (PitchLetter, ChordQuality)) -> (PitchLetter, ChordQuality)? {
        return transform(chord, with: relativeFromMajor)
    }

    /// Perform an L transformation on some triad represented by a tuplet containing a root and a chord quality.
    public static func getLeadingTone(_ chord: (PitchLetter, ChordQuality)) -> (PitchLetter, ChordQuality)? {
        return transform(chord, with: leadingToneFromMajor)
    }

    /// Attempt to identify a single standard transformational mapping between two triads.
    public static func checkSingleTransformation(from chord: (PitchLetter, ChordQuality), to otherChord: (PitchLetter, ChordQuality)) -> Transformation? {

        for t in Transformation.allValues {
            if let r = transform(chord, by: t), r == otherChord { return t }
        }

        return nil
    }

    private static func transform(_ chord: (PitchLetter, ChordQuality), with lookupDict: Dictionary<PitchLetter, PitchLetter>) -> (PitchLetter, ChordQuality)? {
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
