//
//  RomanNumeralsDictionary.swift
//  MusicianKit
//
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

import Foundation

/// A dictionary mapping traditional roman numeral symbols to offset collections (as strings). Used for lookup internally by RomanNumeral.Traditional.
public let RNDict: Dictionary<String, String> = ["I": "0 4 7",
                                                 "I6": "4 7 12",
                                                 "I64": "7 12 16",
                                                 "IM7": "0 4 7 11",
                                                 "IM65": "4 7 11 12",
                                                 "IM43": "7 11 12 16",
                                                 "IM42": "11 12 16 19",
                                                 "I7": "0 4 7 10",
                                                 "I65": "4 7 10 12",
                                                 "I43": "7 10 12 16",
                                                 "I42": "10 12 16 19",
                                                 "i": "0 3 7",
                                                 "i6": "3 7 12",
                                                 "i64": "7 12 15",
                                                 "i7": "0 3 7 10",
                                                 "i65": "3 7 10 12",
                                                 "i43": "7 10 12 15",
                                                 "i42": "10 12 17 19",
                                                 "ii": "2 5 9",
                                                 "ii6": "5 9 14",
                                                 "ii64": "9 14 17",
                                                 "ii7": "2 5 9 12",
                                                 "ii65": "5 9 12 14",
                                                 "ii43": "9 12 14 17",
                                                 "ii42": "0 2 5 9",
                                                 "iiº": "2 5 8",
                                                 "iiº6": "5 8 14",
                                                 "iiº64": "8 14 17",
                                                 "iiø7": "2 5 8 12",
                                                 "iiø65": "5 8 12 14",
                                                 "iiø43": "8 12 14 17",
                                                 "iiø42": "0 2 5 8",
                                                 "iii": "4 7 11",
                                                 "iii6": "7 11 16",
                                                 "iii64": "11 16 19",
                                                 "iii7": "4 7 11 14",
                                                 "iii65": "7 11 14 16",
                                                 "iii43": "11 14 16 19",
                                                 "iii42": "2 4 7 11",
                                                 "III": "3 7 10",
                                                 "III6": "7 10 15",
                                                 "III64": "10 15 19",
                                                 "IIIM7": "3 7 10 14",
                                                 "IIIM65": "7 10 14 15",
                                                 "IIIM43": "10 14 15 19",
                                                 "IIIM42": "2 3 7 10",
                                                 "III7": "3 7 10 13",
                                                 "III65": "7 10 13 15",
                                                 "III43": "10 13 15 19",
                                                 "III42": "1 3 7 10",
                                                 "IV": "5 9 12",
                                                 "IV6": "9 12 17",
                                                 "IV64": "0 5 9",
                                                 "IVM7": "5 9 12 16",
                                                 "IVM65": "9 12 16 17",
                                                 "IVM43": "0 4 5 9",
                                                 "IVM42": "4 5 9 12",
                                                 "IV7": "5 9 12 15",
                                                 "IV65": "9 12 15 17",
                                                 "IV43": "0 3 5 9",
                                                 "IV42": "3 5 9 12",
                                                 "iv": "5 8 12",
                                                 "iv6": "8 12 17",
                                                 "iv64": "0 5 8",
                                                 "iv7": "5 8 12 15",
                                                 "iv65": "8 12 15 17",
                                                 "iv43": "0 3 5 8",
                                                 "iv42": "3 5 8 12",
                                                 "V": "7 11 14",
                                                 "V6": "11 14 19",
                                                 "V64": "2 7 11",
                                                 "V7": "7 11 14 17",
                                                 "V65": "11 14 17 19",
                                                 "V43": "2 5 7 11",
                                                 "V42": "5 7 11 14",
                                                 "v": "7 10 14",
                                                 "v6": "10 14 19",
                                                 "v64": "2 7 10",
                                                 "v7": "7 10 14 17",
                                                 "v65": "10 14 17 19",
                                                 "v43": "2 5 7 10",
                                                 "v42": "5 7 10 14",
                                                 "vi": "9 12 16",
                                                 "vi6": "0 4 9",
                                                 "vi64": "4 9 12",
                                                 "vi7": "9 12 16 19",
                                                 "vi65": "0 4 7 9",
                                                 "vi43": "4 7 9 12",
                                                 "vi42": "7 9 12 16",
                                                 "VI": "8 12 15",
                                                 "VI6": "0 3 8",
                                                 "VI64": "3 8 12",
                                                 "VIM7": "8 12 15 19",
                                                 "VIM65": "0 3 7 8",
                                                 "VIM43": "3 7 8 12",
                                                 "VIM42": "7 8 12 15",
                                                 "VI7": "8 12 15 18",
                                                 "VI65": "0 3 6 8",
                                                 "VI43": "3 6 8 12",
                                                 "VI42": "6 8 12 15",
                                                 "viiº": "11 14 17",
                                                 "viiº6": "2 5 11",
                                                 "viiº64": "5 11 14",
                                                 "viiº7": "11 14 17 20",
                                                 "viiº65": "2 5 8 11",
                                                 "viiº43": "5 8 11 14",
                                                 "viiº42": "8 11 14 17",
                                                 "N": "1 5 8",
                                                 "N6": "5 8 13",
                                                 "N64": "8 13 17",
                                                 "It6": "8 12 18",
                                                 "Fr6": "8 12 14 18",
                                                 "Ger6": "8 12 15 18"]
