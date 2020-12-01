import UIKit

/*
 --- Day 1: Report Repair ---

 After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island. Surely, Christmas will go on without you.

 The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.

 To save your vacation, you need to get all fifty stars by December 25th.

 Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

 Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.

 Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

 For example, suppose your expense report contained the following:

 1721
 979
 366
 299
 675
 1456
 In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579, so the correct answer is 514579.

 Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?
 */

guard let resourceURL = Bundle.main.url(forResource: "input", withExtension: "txt") else { fatalError() }
guard let contentsOfFile = try? String.init(contentsOfFile: resourceURL.path) else { fatalError()}
    
let numbers = contentsOfFile.split(separator: "\n")
    .map(String.init)
    .compactMap(Int.init)

func magicTotal(_ a: Int, _ b: Int) -> (Int, Int)? {
    a + b == 2020 ? (a, b) : nil
}


let solutionTuple = numbers.map { num in
    numbers.compactMap { num2 -> (Int, Int)? in
        if magicTotal(num, num2) != nil {
            return (num, num2)
        }
        return nil
    }
}.flatMap { $0 }

print("Numbers whose sum is 2020: \(solutionTuple[0].0), \(solutionTuple[0].1)")
print("Puzzle Answer: \(solutionTuple[0].0 * solutionTuple[0].1)")
