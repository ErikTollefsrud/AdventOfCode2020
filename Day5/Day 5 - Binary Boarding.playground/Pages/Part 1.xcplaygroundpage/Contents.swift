import UIKit
/**
--- Day 5: Binary Boarding ---

You board your plane only to discover a new problem: you dropped your boarding pass! You aren't sure which seat is yours, and all of the flight attendants are busy with the flood of people that suddenly made it through passport control.

You write a quick program to use your phone's camera to scan all of the nearby boarding passes (your puzzle input); perhaps you can find your seat through process of elimination.

Instead of zones or groups, this airline uses binary space partitioning to seat people. A seat might be specified like FBFBBFFRLR, where F means "front", B means "back", L means "left", and R means "right".

The first 7 characters will either be F or B; these specify exactly one of the 128 rows on the plane (numbered 0 through 127). Each letter tells you which half of a region the given seat is in. Start with the whole list of rows; the first letter indicates whether the seat is in the front (0 through 63) or the back (64 through 127). The next letter indicates which half of that region the seat is in, and so on until you're left with exactly one row.

For example, consider just the first seven characters of FBFBBFFRLR:

Start by considering the whole range, rows 0 through 127.
F means to take the lower half, keeping rows 0 through 63.
B means to take the upper half, keeping rows 32 through 63.
F means to take the lower half, keeping rows 32 through 47.
B means to take the upper half, keeping rows 40 through 47.
B keeps rows 44 through 47.
F keeps rows 44 through 45.
The final F keeps the lower of the two, row 44.
The last three characters will be either L or R; these specify exactly one of the 8 columns of seats on the plane (numbered 0 through 7). The same process as above proceeds again, this time with only three steps. L means to keep the lower half, while R means to keep the upper half.

For example, consider just the last 3 characters of FBFBBFFRLR:

Start by considering the whole range, columns 0 through 7.
R means to take the upper half, keeping columns 4 through 7.
L means to take the lower half, keeping columns 4 through 5.
The final R keeps the upper of the two, column 5.
So, decoding FBFBBFFRLR reveals that it is the seat at row 44, column 5.

Every seat also has a unique seat ID: multiply the row by 8, then add the column. In this example, the seat has ID 44 * 8 + 5 = 357.

Here are some other boarding passes:

BFFFBBFRRR: row 70, column 7, seat ID 567.
FFFBBBFRRR: row 14, column 7, seat ID 119.
BBFFBBFRLL: row 102, column 4, seat ID 820.
As a sanity check, look through your list of boarding passes. What is the highest seat ID on a boarding pass?
*/

guard let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt") else { fatalError("Could not load file url.")}

guard let puzzleInput = try? String.init(contentsOfFile: fileURL.path) else { fatalError("Could not load puzzle data from file url.")}

func formatStringToBinay(_ string: String) -> String {
    return string
        .replacingOccurrences(of: "F", with: "0")
        .replacingOccurrences(of: "B", with: "1")
        .replacingOccurrences(of: "R", with: "1")
        .replacingOccurrences(of: "L", with: "0")
}

let answer = puzzleInput
    .split(separator: "\n")
    .map(String.init)
    .map(formatStringToBinay)
    .map {
        $0.reduce(0) { partialResult, char in
            guard let num = Int(String(char)) else { fatalError() }
            return partialResult * 2 + num
        }
    }
    .max()

print("The answer is: \(String(describing: answer))")

/**
 # First Attempt Code
 
 Below is the code I wrote before seeking help from the community. I know now (and should have looked into) that the solution relies on converting the seat code from a series of "F"s, "B"s, "R"s, and "L"s into a binary number (0 and 1).
 
 My code follows the instructions given; that is, it finds the mid-point between the upper and lower bounds, and sets the new upper or lower number.
 
 What I find interesting is that my first attempt code does produce the correct values for the test data.
 

 func inputStringToCharacterArray(_ string: String) -> [Character] {
     string.map { $0 }
 }

 func formatInputArrayToDictionary(_ array: [Character]) -> [String: [Character]] {
     guard Array(array.prefix(upTo: 7)).count == 7,
                 Array(array.suffix(from: 7)).count == 3 else { fatalError() }
     return ["row": Array(array.prefix(upTo: 7)),
      "column": Array(array.suffix(from: 7))]
 }

 func calculateColumnInt(_ array: [Character]) -> Int {
     print("Starting with: \(array)")
     let processedArray = array.reduce(("Z", (1, 7))) { partialResult, char in
         switch char {
         case "L":
             print("Got L: \(("L", (partialResult.1.0, (partialResult.1.0 + partialResult.1.1) / 2)))")
             return ("L", (partialResult.1.0, (partialResult.1.0 + partialResult.1.1) / 2))
         case "R":
             print("Got R: \(("R", ((partialResult.1.0 + partialResult.1.1) / 2, partialResult.1.1)))")
             return ("R", ((partialResult.1.0 + partialResult.1.1) / 2, partialResult.1.1))
         default:
             print("Error in calculating column.")
             return ("Z", (partialResult.1.0, partialResult.1.1))
         }
     }
     print("ProcessedArray: \(processedArray)")
     guard processedArray.0 != "Z" else { fatalError() }
     
     return processedArray.0 == "R" ? processedArray.1.1 : processedArray.1.0
 }

 func calculateRowInt(_ array: [Character]) -> Int {
     let processedArray = array.reduce(("Z", (0, 127))) { partialResult, char in
         switch char {
         case "F":
             return ("F", (partialResult.1.0, (partialResult.1.0 + partialResult.1.1) / 2))
         case "B":
             return ("B", ((partialResult.1.0 + partialResult.1.1) / 2, partialResult.1.1))
         default:
             print("Error in calculating row.")
             return ("Z", (partialResult.1.0, partialResult.1.1))
         }
     }
     
     guard processedArray.0 != "Z" else { fatalError() }
     return processedArray.0 == "F" ? processedArray.1.1 : processedArray.1.0
 }

 func parseValues(_ dictionary: [String: [Character]]) -> [String: Int] {
     let rowValue = dictionary["row"]
         .flatMap{ $0 }
         .flatMap(calculateRowInt)
     let columnValue = dictionary["column"]
         .flatMap{ $0 }
         .flatMap(calculateColumnInt)
     guard rowValue != nil, columnValue != nil else { fatalError() }
     return ["row": rowValue!, "column": columnValue!]
 }

 func calculateSeatID(_ dictionary: [String: Int]) -> Int {
     guard let rowValue = dictionary["row"] else { fatalError() }
     guard let columnValue = dictionary["column"] else { fatalError() }
     
     return (rowValue * 8) + columnValue
 }


 let puzzle = puzzleInput.split(separator: "\n")
     .map(String.init)
     .flatMap(inputStringToCharacterArray)
     .map(formatInputArrayToDictionary)
     .map(parseValues)
     .map(calculateSeatID)
     .sorted(by: >)

 print(puzzle.max()!)

 */

