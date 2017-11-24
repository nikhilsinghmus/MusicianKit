//
//  PCSet.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public struct PCSet: Equatable, ExpressibleByArrayLiteral, Collection, SetAlgebra {
    public var isEmpty: Bool {
        return pitchClasses.count == 0
    }
    
    public func contains(_ member: Int) -> Bool {
        return pitchClasses.contains(member)
    }
    
    public mutating func update(with newMember: Int) -> Int? {
        let newPC = abs(newMember) % 12
        pitchClasses.append(newPC)
        return newPC
    }
    
    public func union(_ other: PCSet) -> PCSet {
        var pcs = self.pitchClasses
        pcs.append(contentsOf: other.pitchClasses)
        return PCSet(pcs).thinned()
    }
    
    public func intersection(_ other: PCSet) -> PCSet {
        return PCSet(other.pitchClasses.filter { pitchClasses.contains($0) })
    }
    
    public func symmetricDifference(_ other: PCSet) -> PCSet {
        let intersection = self.intersection(other)
        var union = self.union(other)
        intersection.pitchClasses.forEach { _ = union.remove($0) }
        return union
    }
    
    public mutating func insert(_ newMember: Int) -> (inserted: Bool, memberAfterInsert: Int) {
        let next = pitchClasses.first
        pitchClasses.insert(newMember, at: 0)
        return (inserted: true, memberAfterInsert: next ?? -1)
    }
    
    public mutating func remove(_ member: Int) -> Int? {
        guard let loc = pitchClasses.index(of: member) else { return nil }
        return pitchClasses.remove(at: loc)
    }
    
    public mutating func formUnion(_ other: PCSet) {
        self = union(other)
    }
    
    public mutating func formIntersection(_ other: PCSet) {
        self = intersection(other)
    }
    
    public mutating func formSymmetricDifference(_ other: PCSet) {
        self = symmetricDifference(other)
    }
    
    public init() {
        pitchClasses = []
    }
    
    public init(_ set: Set<PitchClass>) {
        pitchClasses = [PitchClass](set.sorted())
    }
    
    public subscript(position: Int) -> Int {
        get {
            return pitchClasses[position]
        }
        set(newValue) {
            pitchClasses[position] = newValue
        }
    }
    
    public typealias ArrayLiteralElement = PitchClass
    public var pitchClasses: [PitchClass] = []
    public var cardinality: Int {
        return thinned().pitchClasses.count
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public var startIndex: Int = 0
    public var endIndex: Int {
        return pitchClasses.count
    }
    
    public init(arrayLiteral elements: PitchClass...) {
        pitchClasses = elements.map { $0 % 12 }
    }
    
    public init(_ pcSetLiteral: [PitchClass]) {
        pitchClasses = pcSetLiteral.map { $0 % 12 }
    }
    
    public init(_ pcSetSlice: ArraySlice<PitchClass>) {
        pitchClasses = Array<PitchClass>(pcSetSlice)
    }
    
    public static func ==(lhs: PCSet, rhs: PCSet) -> Bool {
        return lhs.pitchClasses == rhs.pitchClasses
    }
    
    public func thinned() -> PCSet {
        var unique: Set<PitchClass> = []
        let thinned = pitchClasses.filter {
            guard !unique.contains($0) else { return false }
            unique.insert($0)
            return true
        }
        return PCSet(thinned)
    }
    
    public init?(_ forteCodeName: String) {
        guard let pcstring = (forteDict.first { $0.value == forteCodeName })?.key else { return nil }
        
        let split = pcstring.characters.map { String($0) }
        self = PCSet( split.map { Int($0) ?? (($0 == "A") ? 10 : 11) } )
    }
    
    public var forteCode: String? {
        var primeString = ""
        let pf = self.getPrimeForm()
        pf.forEach { primeString.append(($0 < 10) ? "\($0)" : (($0 == 10) ? "A" : "B")) }
        
        let ps = primeString.replacingOccurrences(of: " ", with: "")
        return forteDict[ps]
    }
    
    public func getNormalForm() -> PCSet {
        var st = self.thinned().sorted()
        st.append(st[0] + 12)
        var largestDiff = 0, ldIndex = 0
        
        for i in 1 ..< st.count {
            let diff = st[i] - st[i-1]
            if diff > largestDiff {
                largestDiff = diff
                ldIndex = i
            }
        }
        return PCSet(st[ldIndex ..< count] + st[0 ..< ldIndex])
    }
    
    public func getPrimeForm() -> PCSet {
        let nf = self.getNormalForm()
        let rev: PCSet = nf.inverted().getNormalForm()
        let option1 = PCSet(nf.map { ((12 + $0) - nf[0]) % 12 })
        let option2 = PCSet(rev.map { ((12 + $0) - rev[0]) % 12 })
        
        let weight1: Double = option1.reduce(1.0, { x, y in
            x + (Double(y) * (1.0/x))
        })
        
        let weight2: Double = option2.reduce(1.0, { x, y in
            x + (Double(y) * (1.0/x))
        })
        
        return weight1 < weight2 ? option1 : option2
    }
    
    public init(with midiNotes: [Int]) {
        pitchClasses = midiNotes.map { $0 % 12 }
    }
    
    public func inverted() -> PCSet {
        return PCSet(map { (12 - $0) % 12 })
    }
    
    public mutating func invert() {
        self = inverted()
    }
    
    public func transposed(_ t: Int) -> PCSet {
        return PCSet(map { ($0 + t) % 12 })
    }
    
    public mutating func transpose(_ t: Int) {
        self = transposed(t)
    }
    
    public func transformed(t: Int, i: Bool) -> PCSet {
        return i ? inverted().transposed(t).getNormalForm() : transposed(t)
    }
    
    public mutating func transform(t: Int, i: Bool) {
        self = transformed(t: t, i: i)
    }
}
