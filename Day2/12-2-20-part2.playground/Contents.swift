import Foundation

/*
 --- Part Two ---

 While it appears you validated the passwords correctly, they don't seem to be what the Official Toboggan Corporate Authentication System is expecting.

 The shopkeeper suddenly realizes that he just accidentally explained the password policy rules from his old job at the sled rental place down the street! The Official Toboggan Corporate Policy actually works a little differently.

 Each policy actually describes two positions in the password, where 1 means the first character, 2 means the second character, and so on. (Be careful; Toboggan Corporate Policies have no concept of "index zero"!) Exactly one of these positions must contain the given letter. Other occurrences of the letter are irrelevant for the purposes of policy enforcement.

 Given the same example list from above:

 1-3 a: abcde is valid: position 1 contains a and position 3 does not.
 1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
 2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.
 How many passwords are valid according to the new interpretation of the policies?
 */


guard let resourceURL = Bundle.main.url(
        forResource: "input",
        withExtension: "txt"
) else {
    fatalError("Failed to read file.")
}

guard let contentsOfFile = try? String.init(contentsOfFile: resourceURL.path) else
{
    fatalError("Failed to parse the file.")
}

let items = contentsOfFile.split(separator: "\n")

// Test cases
let oneTrueTwoFalseMock = [
    "2-9 c: ccccccccc",
    "1-3 b: cdefg",
    "1-3 a: abcde"
]

let oneShortFalseMock = [
    "1-3 b: cdefg"
]

let oneLongFalseMock = [
    "2-9 c: ccccccccc"
]

let oneTrueMock = [
    "1-3 a: abcde"
]

// Add subscripting to Strings for cleaner code
extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

let result = items.map { item in
    let splitItems = item
        .split(separator: ":")
        .compactMap(String.init)
    let ruleComponents = splitItems[0]
        .split(separator: " ")
    let passwordInput = String(splitItems[1].dropFirst())

    let lowHighValues = ruleComponents[0]
        .split(separator: "-")
        .map(String.init)
        .compactMap(Int.init)
    let firstPosition = lowHighValues[0] - 1
    let secondPosition = lowHighValues[1] - 1
    let ruleLetter = ruleComponents[1]
        .compactMap(Character.init)
        .first
    
    // Create an array with two items, each being a bool representing
    // if the character at position matches the rule letter.
    // Filter out only true cases.
    // Check to validate there is only one true case (per puzzle rules)
    return [passwordInput[firstPosition] == ruleLetter!,
            passwordInput[secondPosition] == ruleLetter!]
        .filter{ $0 }
        .count == 1
}
.filter { $0 }
.count
