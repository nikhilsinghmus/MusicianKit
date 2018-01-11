//
//  TonalTools.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import UIKit

/**
 The **KeyType** enum distinguishes between major and minor keys and produces scale patterns for each.
 */
public enum KeyType {
    case major, minor

    /// Semitonal offset pattern from 0 for the current instance.
    public var pattern: [Int] {
        return (self == .major) ? [0, 2, 4, 5, 7, 9, 11] : [0, 2, 3, 5, 7, 8, 10]
    }
}
