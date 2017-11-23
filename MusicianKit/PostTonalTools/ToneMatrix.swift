//
//  ToneMatrix.swift
//  MusicianKit
//
//  Created by Nikhil Singh on 10/9/17.
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

public struct ToneMatrix: Equatable, ExpressibleByArrayLiteral, MutableCollection {
    public var rows: [ToneRow]!
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public typealias ArrayLiteralElement = ToneRow
    public var startIndex: Int = 0
    public var endIndex: Int {
        return rows.count
    }
    
    public static func ==(lhs: ToneMatrix, rhs: ToneMatrix) -> Bool {
        return lhs.rows == rhs.rows
    }
    
    public init(arrayLiteral: ToneRow...) {
        rows = arrayLiteral
    }
    
    public init(from row: ToneRow) {
        rows = [ToneRow](repeating: row, count: row.count)
        for pc in row {
            rows[pc] = ToneRow(row.map { ($0 + (row.count - row[pc])) % row.count })
        }
    }
    
    public subscript(_ index: Int) -> ToneRow {
        get {
            return rows[index]
        }
        
        set(newValue) {
            rows[index] = ToneRow(newValue.map { $0 % 12 })
        }
    }
    
    public func getRowForm(_ form: MatrixForm, offset: Int) -> ToneRow? {
        return getRowFormNon12(form, offset: offset, ed: (12, 2))
    }
    
    public func getRowFormNon12(_ form: MatrixForm, offset: Int, ed: ED) -> ToneRow? {
        var row: ToneRow?
        
        switch form {
        case .p: row = ToneRow([0].map { ($0 + offset) % ed.0 })
        case .r: row = ToneRow(self[0].map { ($0 + offset) % ed.0 }.reversed())
        case .i: row = ToneRow(self.map { ($0[0] + offset) % ed.0 })
        case .ri: row = ToneRow(self.map { ($0[0] + offset) % ed.0 }.reversed())
        }
        
        return row
    }
}
