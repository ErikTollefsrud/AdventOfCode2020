//: [Previous](@previous)

import Foundation

/*
 --- Part Two ---

 Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

 Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

 Right 1, down 1.
 Right 3, down 1. (This is the slope you already checked.)
 Right 5, down 1.
 Right 7, down 1.
 Right 1, down 2.
 In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

 What do you get if you multiply together the number of trees encountered on each of the listed slopes?
 */

guard let fileURL = Bundle.main.url(
        forResource: "input", withExtension: "txt"
) else { fatalError("Failed to load file.") }

guard let puzzleInput = try? String.init(
        contentsOfFile: fileURL.path)
else { fatalError("Failed to parse file.") }

let rows = puzzleInput
    .split(separator: "\n")
    .compactMap(String.init)
let rowLength = rows[0][...].count // Get the number of chars in a single row
let runLength = 3 // as in "rise over run" in the slope.

func norm(_ val: Int, to size: Int) -> Int { ((val % size) + size) % size }

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

let oneByOne = rows.enumerated()
    .dropFirst()
    .map { (rowText: $0.element, positionInRow: norm($0.offset * 1, to: rowLength)) }
    .reduce(0) {
        $1.rowText[$1.positionInRow] == "#"
            ? $0 + 1
            : $0
    }
let threeByOne = rows.enumerated()
    .dropFirst()
    .map { (rowText: $0.element, positionInRow: norm($0.offset * runLength, to: rowLength)) }
    .reduce(0) {
        $1.rowText[$1.positionInRow] == "#"
            ? $0 + 1
            : $0
    }

let fiveByOne = rows.enumerated()
    .dropFirst()
    .map { (rowText: $0.element, positionInRow: norm($0.offset * 5, to: rowLength)) }
    .reduce(0) {
        $1.rowText[$1.positionInRow] == "#"
            ? $0 + 1
            : $0
    }
let sevenByOne = rows.enumerated()
    .dropFirst()
    .map { (rowText: $0.element, positionInRow: norm($0.offset * 7, to: rowLength)) }
    .reduce(0) {
        $1.rowText[$1.positionInRow] == "#"
            ? $0 + 1
            : $0
    }

let mock = [
"...#...###......##.#..#.....##.",
"..#.#.#....#.##.#......#.#....#",
"......#.....#......#....#...##.",
"...#.....##.#..#........##.....",
"...##...##...#...#....###....#.",
"...##...##.......#....#...#.#..",
"..............##..#..#........#",
"#.#....#.........#...##.#.#.#.#",
".#..##......#.#......#...#....#",
"#....#..#.#.....#..#...#...#...",
]

let oneByTwo = rows.enumerated()
    .filter { $0.offset % 2 == 0}
    .map { item -> (rowText: String, positionInRow: Int) in
        return (rowText: item.element, positionInRow: norm(item.offset * 1, to: rowLength))
    }
    .enumerated()
    .map { item -> (rowText: String, positionInRow: Int, iteration: Int) in
        return (rowText: item.element.rowText, positionInRow: item.element.positionInRow, iteration: item.offset)
    }
    .reduce(0) {
        $1.rowText[norm($1.iteration, to: rowLength)] == "#"
            ? $0 + 1
            : $0
    }

let answer =
    [oneByOne, threeByOne, fiveByOne, sevenByOne, oneByTwo]
    .reduce(1) { $0 * $1 }

//: [Next](@next)
