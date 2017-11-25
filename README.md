# MusicianKit
##### A framework for musical software-development and analytics on iOS devices.

MusicianKit provides a simple API for musical composition, investigation, and more. It doesn't intend to produce audio, but to provide tools with which to construct and work with musical ideas, sequences, and to gather information about the ways in which musical iOS apps are being used through a kind of distributed corpus analysis, where the corpus is a living collection of music being made by iOS musickers.

It is currently essentially in **pre-alpha** mode.


## Modules, Usage

Below are a few examples of various modules or areas of functionality (in various degrees of completeness) for which APIs are provided.

**PostTonalTools**

```swift
// Initialize and perform operations on pitch-class sets
let pcset0: PCSet = [0, 2, 3, 11] // PCSet literal
let pcset1 = PCSet([67, 63, 61, 69]) // Returns a PC Set with [7, 3, 1, 9]
let pcset2 = PCSet("4-2") // Using a Forte code
let pcset3 = PCSet(4, 3, 1, 0, 2, 5) // Using a variadic initializer
print(pcset1.getPrimeForm()) // Prints [0, 2, 6, 8]
pcset1.transform(t: 3, i: false) // Mutating transformation to [10, 6, 4, 0]

// Build a twelve-tone matrix from a ToneRow literal (returns an initialized ToneMatrix)
let matrix = ToneRow([1, 2, 7, 10, 4, 5, 9, 11, 8, 6, 3, 0]).buildMatrix()

// Alternatively, initialize a ToneMatrix with a ToneRow literal argument
let matrix = ToneMatrix(row: [1, 2, 7, 10, 4, 5, 9, 11, 8, 6, 3, 0])
```

**ModalTools**

```swift
// Returns an array of semitonal offets-from-tonic for a mode (e.g. Modes.Major.first.offsets -> [0, 2, 4, 5, 7, 9, 11])
let lydian = Modes.Major.fourth.offsets
let alsoLydian = Modes.Major.lydian.offsets
let phrygianDominant = Modes.Minor.Harmonic.fifth.offsets
let mixob6 = Modes.Minor.Melodic.fifth.offsets

// Create a custom scalar structure and retrieve it or replace it (or a mode of it) at any time
let myMode = Mode("flixodiddlian", [0, 2, 3, 5, 6, 7, 9, 11])
// In some other scope
let flixo = Modes["flixodiddlian"].offsets
let flixo2 = flixo.getMode(3)
```

**TransformationalTools**

```swift
// Perform a parallel transformation on a triad
let nextChord = TransformationalTools.transform((.C, .major), by: .P)

// Check for a single simple transformational mapping between two chords
let transformation = checkSingleTransformation(from chord: (.C, .major), to otherChord: (.A, .minor))
```

**TonalTools**

```swift
// Check chord parity (considers inversional equivalence)
if chord1 == chord2 { /* do something */ }

// Parse two common styles/systems of Roman Numerals
let chord1 = RomanNumeral.Traditional("iv64")
let chord2 = RomanNumeral.Berklee("bVImaj7#11")

// Voice-lead smoothly between two harmonies (returns [Int] of MIDI note numbers)
let chord = [60, 63, 64, 67, 70]
if let nextChord = Chord("Fmaj#11") { // Note that the return type of Chord(_ chordSymbol: String) is Chord? (Optional<Chord>)
	let nextChord = Chord.voiceLead(from: chord to: nextChord)
}
```

**XenharmonicTools**

```swift
// Classify a sequence of MIDI-note-number-style doubles by the EDO they seem to imply (returns 72 below)
let EDO = XenharmonicTools.midiParseEDO([60, 42.33, 20, 44, 51.167, 90])

// Get an increment by which to generate sets of pitches in some arbitrary EDO. Returns a double (e.g. 0.5 in the example below)
let offset = XenharmonicTools.EDOGetIncrement(24)

```
Many more usage examples (and Swift playground) to follow.

## Current Limitations, Future Plans

MusicianKit is currently a relatively small and modular framework, as it relates to certain kinds of musical work (inevitably informed by my own biases). My hope is that other musicians and musical domain experts will contribute new modules that relate to their work and interests, perhaps building on what's already there or adding new ways of working, or porting it to other platforms of interest, etc.

Additionally, I'm hoping that musicians and musical people operating in non-western musical cultures and traditions will have insight into creating interfaces to interact with their musical languages meaningfully and expressively as well.