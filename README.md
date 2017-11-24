## MusicianKit
##### A framework for musical software-development and analytics on iOS devices.

MusicianKit provides a simple API for musical composition, investigation, and more. It doesn't intend to produce audio, but to provide tools with which to construct and work with musical ideas, sequences, and to gather information about the ways in which musical iOS apps are being used through a kind of distributed corpus analysis, where the corpus is a living collection of music being made by iOS musickers.

It is currently essentially in pre-alpha mode.


#### Modules, Usage

```swift
// Build a twelve-tone matrix from a ToneRow literal (returns an initialized ToneMatrix)
let matrix = ToneRow([1, 2, 7, 10, 4, 5, 9, 11, 8, 6, 3, 0]).buildMatrix()

// Alternatively, initialize a ToneMatrix with a ToneRow literal argument
let matrix = ToneMatrix(row: [1, 2, 7, 10, 4, 5, 9, 11, 8, 6, 3, 0])

// Voice-lead smoothly between two harmonies (returns [Int] of MIDI note numbers)
let chord = [60, 63, 64, 67, 70]
if let nextChord = Chord("Fmaj#11") { // Note that the return type of Chord(_ chordSymbol: String) is Chord? (Optional<Chord>)
	let nextChord = Chord.voiceLead(from: chord to: nextChord)
}

// Returns an array of semitonal offets-from-tonic for a mode (e.g. Modes.Major.first.offsets -> [0, 2, 4, 5, 7, 9, 11])
let phrygianDominant = Modes.Minor.Harmonic.fifth.offsets

// Perform a parallel transformation on a triad
let nextChord = TransformationalTools.transform((.C, .major), by: .P)

// Classify chord by diatonic function (using the settable Chord.key property)
let function = Chord.classify(chord1)

// Check chord parity (considers inversional equivalence)
if chord1 == chord2 { /* do something */ }

// Check chord-function parity
if chord1 ~= chord2 { /* do something else */ }

// (Many) more usage examples (and Swift playground) coming soon...

```


#### Current Limitations, Future Plans

MusicianKit is currently a relatively small and modular framework, as it relates to certain kinds of musical work (inevitably informed by my own biases). My hope is that other musicians and musical domain experts will contribute new modules that relate to their work and interests, perhaps building on what's already there or adding new ways of working, or porting it to other platforms of interest, etc.

Additionally, I'm hoping that musicians and musical people operating in non-western musical cultures and traditions will have insight into creating interfaces to interact with their musical languages meaningfully and expressively as well.