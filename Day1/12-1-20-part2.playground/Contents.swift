import UIKit

/*
 --- Part Two ---

 The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

 Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.

 In your expense report, what is the product of the three entries that sum to 2020?
 */

guard let resourceURL = Bundle.main.url(forResource: "input", withExtension: "txt") else { fatalError() }
guard let contentsOfFile = try? String.init(contentsOfFile: resourceURL.path) else { fatalError()}
    
let numbers = contentsOfFile.split(separator: "\n")
    .map(String.init)
    .compactMap(Int.init)

var solution3:(Int, Int, Int)? = nil
for num1 in numbers {
    for num2 in numbers {
        for num3 in numbers {
            if num1 + num2 + num3 == 2020 {
                solution3 = (num1, num2, num3)
                break
            }
        }
    }
}

if let solution3 = solution3 {
    print("Numbers whose sum is 2020: \(String(describing: solution3))")
    print("Puzzle Answer: \(solution3.0 * solution3.1 * solution3.2)")
}

