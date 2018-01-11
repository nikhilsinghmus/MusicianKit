//
//  PCSet.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

extension Sequence where Iterator.Element: Hashable {
    internal func unique() -> [Iterator.Element] {
        var s: Set<Iterator.Element> = []
        return filter {
            s.insert($0).inserted
        }
    }
}

/**
 The **PCSet** type deals with collections of pitch-classes. It abstracts an Array of pitch-classes than a set type, in order to allow for duplicates, explicit ordering, etc.
 */
public struct PCSet: Equatable, ExpressibleByArrayLiteral, Collection, SetAlgebra {

    /// Underlying PitchClass array.
    public var pitchClasses = [PitchClass]()

    public typealias ArrayLiteralElement = PitchClass
    public subscript(position: Int) -> Int {
        get {
            return pitchClasses[position]
        }
        set {
            pitchClasses[position] = newValue
        }
    }

    public static func ==(lhs: PCSet, rhs: PCSet) -> Bool {
        return lhs.pitchClasses == rhs.pitchClasses
    }

    // MARK: Initializers
    /// Initialize an empty pitch-class set.
    public init() {
        pitchClasses = []
    }

    /// Initialize from a Set of PitchClasses.
    public init(_ set: Set<PitchClass>) {
        pitchClasses = [PitchClass](set.sorted())
    }

    /// Initialize from an array of MIDI note numbers.
    public init(with midiNotes: [UInt8]) {
        pitchClasses = midiNotes.map { PitchClass($0 % 12) }
    }

    /** Initialize as an array literal of PitchClasses. For example:
    ```
    let set: PCSet = [0, 1, 4, 5, 8, 11]
    ```
     */
    public init(arrayLiteral elements: PitchClass...) {
        pitchClasses = elements.map { $0 % 12 }
    }

    /// Initialize from an Array of PitchClasses.
    public init(_ pcSetLiteral: [PitchClass]) {
        pitchClasses = pcSetLiteral.map { $0 % 12 }
    }

    /// Initialize from an ArraySlice of PitchClasses.
    public init(_ pcSetSlice: ArraySlice<PitchClass>) {
        pitchClasses = Array(pcSetSlice)
    }

    /// Initialize from a Forte code string. E.g. PCSet("4-Z15") returns [0, 1, 4, 6]
    public init?(_ forteCodeName: String) {
        guard let pcstring = (forteDict.first { $0.value == forteCodeName })?.key else { return nil }

        let split = pcstring.characters.map { String($0) }
        self = PCSet( split.map { Int($0) ?? (($0 == "A") ? 10 : 11) } )
    }

    /// Returns the number of unique elements in the current PCSet instance.
    public var cardinality: Int {
        return thinned().pitchClasses.count
    }

    // MARK: Indexing
    public func index(after i: Int) -> Int {
        return i + 1
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return pitchClasses.count
    }

    // MARK: SetAlgebra methods
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

    public mutating func formUnion(_ other: PCSet) {
        self = union(other)
    }

    public mutating func formIntersection(_ other: PCSet) {
        self = intersection(other)
    }

    public mutating func formSymmetricDifference(_ other: PCSet) {
        self = symmetricDifference(other)
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

    // MARK: Utility methods
    /// Returns an ordered replica of the current PCSet with duplicates removed.
    public func thinned() -> PCSet {
        return PCSet(pitchClasses.unique())
    }

    /// Returns the Forte code of the current PCSet if one can be found that matches.
    public var forteCode: String? {
        var primeString = ""
        let pf = self.primeForm()
        pf.forEach { primeString.append(($0 < 10) ? "\($0)" : (($0 == 10) ? "A" : "B")) }

        let ps = primeString.replacingOccurrences(of: " ", with: "")
        return forteDict[ps]
    }

    /// Returns the normal form of the current PCSet.
    public func normalForm() -> PCSet {
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

    /// Returns the prime form of the current PCSet.
    public func primeForm() -> PCSet {
        let nf = self.normalForm()
        let rev: PCSet = nf.inverted().normalForm()
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

    /// Returns an inversion of the current PCSet.
    public func inverted() -> PCSet {
        return PCSet(map { (12 - $0) % 12 })
    }

    /// Inverts the current PCSet.
    public mutating func invert() {
        self = inverted()
    }

    /// Returns a transposition of the current PCSet.
    public func transposed(_ t: Int) -> PCSet {
        return PCSet(map { ($0 + t) % 12 })
    }

    /// Transposes the current PCSet.
    public mutating func transpose(_ t: Int) {
        self = transposed(t)
    }

    /// Returns a transposition and/or inversion of the current PCSet.
    public func transformed(t: Int, i: Bool) -> PCSet {
        return i ? inverted().transposed(t).normalForm() : transposed(t)
    }

    /// Performs a compound transformation (inversion and transposition) on the current PCSet.
    public mutating func transform(t: Int, i: Bool) {
        self = transformed(t: t, i: i)
    }
}
