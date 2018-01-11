//
//  ToneMatrix.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

/**
 The **ToneMatrix** type deals with tone matrices expressed as multidimensional arrays, or arrays of ToneRow instances.
 */
public struct ToneMatrix: Equatable, ExpressibleByArrayLiteral, MutableCollection {

    public typealias Element = ToneRow

    public static func ==(lhs: ToneMatrix, rhs: ToneMatrix) -> Bool {
        return lhs.rows == rhs.rows
    }

    /// The underlying array of ToneRows.
    public var rows: [Element]!

    // MARK: Initializers
    public init(arrayLiteral: Element...) {
        rows = arrayLiteral
    }

    /// Initialize from a ToneRow instance.
    public init(from row: Element) {
        rows = [ToneRow](repeating: row, count: row.count)
        for pc in row {
            rows[pc] = ToneRow(row.map { ($0 + (row.count - row[pc])) % row.count })
        }
    }

    // MARK: Indexing
    public func index(after i: Int) -> Int {
        return i + 1
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return rows.count
    }

    public subscript(_ index: Int) -> Element {
        get {
            return rows[index]
        }

        set {
            rows[index] = ToneRow(newValue.map { $0 % 12 })
        }
    }

    // MARK: Utility methods
    /// Get a prticular row form from the matrix.
    public func rowForm(_ form: MatrixForm, offset: Int) -> Element {
        return rowFormNon12(form, offset: offset, ed: (12, 2))
    }

    /// Get a prticular row form from the matrix in an arbitrary equal division of the octave/diapason.
    public func rowFormNon12(_ form: MatrixForm, offset: Int, ed: ED) -> Element {
        switch form {
        case .p: return ToneRow([0].map { ($0 + offset) % ed.0 })
        case .r: return ToneRow(self[0].map { ($0 + offset) % ed.0 }.reversed())
        case .i: return ToneRow(self.map { ($0[0] + offset) % ed.0 })
        case .ri: return ToneRow(self.map { ($0[0] + offset) % ed.0 }.reversed())
        }
    }
}
