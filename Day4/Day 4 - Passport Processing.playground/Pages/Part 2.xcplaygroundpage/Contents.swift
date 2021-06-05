import UIKit

/* --- Part Two ---
 
 The line is moving more quickly now, but you overhear airport security talking about how passports with invalid data are getting through. Better add some data validation, quick!

 You can continue to ignore the cid field, but each other field has strict rules about what values are valid for automatic validation:

 byr (Birth Year) - four digits; at least 1920 and at most 2002.
 iyr (Issue Year) - four digits; at least 2010 and at most 2020.
 eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
 hgt (Height) - a number followed by either cm or in:
 If cm, the number must be at least 150 and at most 193.
 If in, the number must be at least 59 and at most 76.
 hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
 ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
 pid (Passport ID) - a nine-digit number, including leading zeroes.
 cid (Country ID) - ignored, missing or not.
 Your job is to count the passports where all required fields are both present and valid according to the above rules. Here are some example values:

 byr valid:   2002
 byr invalid: 2003

 hgt valid:   60in
 hgt valid:   190cm
 hgt invalid: 190in
 hgt invalid: 190

 hcl valid:   #123abc
 hcl invalid: #123abz
 hcl invalid: 123abc

 ecl valid:   brn
 ecl invalid: wat

 pid valid:   000000001
 pid invalid: 0123456789
 Here are some invalid passports:

 eyr:1972 cid:100
 hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

 iyr:2019
 hcl:#602927 eyr:1967 hgt:170cm
 ecl:grn pid:012533040 byr:1946

 hcl:dab227 iyr:2012
 ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

 hgt:59cm ecl:zzz
 eyr:2038 hcl:74454a iyr:2023
 pid:3556412378 byr:2007
 Here are some valid passports:

 pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
 hcl:#623a2f

 eyr:2029 ecl:blu cid:129 byr:1989
 iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

 hcl:#888785
 hgt:164cm byr:2001 iyr:2015 cid:88
 pid:545766238 ecl:hzl
 eyr:2022

 iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
 Count the number of valid passports - those that have all required fields and valid values. Continue to treat cid as optional. In your batch file, how many passports are valid?
 */

guard let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt") else { fatalError("Could not load file url.")}

guard let puzzleInput = try? String.init(contentsOfFile: fileURL.path) else { fatalError("Could not load puzzle data from file url.")}


func stringToDictionary(_ inputString: String) -> Dictionary<String, String> {
    var dictionary = [String: String]()
    let pieces = inputString.split(separator: " ")
    let array = pieces.map { $0.split(separator: ":") }
    for piece in array {
        dictionary["\(piece[0])"] = String(piece[1])
    }
    
    return dictionary
}

func validateBirthYear(_ input: String?) -> Bool {
    guard let input = input, let input = Int(input) else { return false }
    guard input >= 1920 && input <= 2002 else { return false }
    return true
}

func validateIssueYear(_ input: String?) -> Bool {
    guard let input = input, let input = Int(input) else { return false }
    guard input >= 2010 && input <= 2020 else { return false }
    return true
}

func validateExpirationYear(_ input: String?) -> Bool {
    guard let input = input, let input = Int(input) else { return false }
    guard input >= 2020 && input <= 2030 else { return false }
    return true
}

func validateHeight(_ input: String?) -> Bool {
    guard let input = input else { return false }
    guard input.contains("cm") || input.contains("in") else { return false }
    
    var numberValueString = input
    numberValueString.removeLast(2)
    guard let numberValue = Int(numberValueString) else { fatalError("Did not get expected Int value from String.")}
    
    if input.contains("cm") {
        guard numberValue >= 150 && numberValue <= 193 else { return false }
    } else if input.contains("in") {
        guard numberValue >= 59 && numberValue <= 76 else { return false }
    }
    
    return true
}

func validateHairColor(_ input: String?) -> Bool {
    guard let input = input else { return false }
    guard input.count == 7 && input.hasPrefix("#") else { return false }
    return true
}

enum EyeColor: String {
    case amb = "amb"
    case blu = "blu"
    case brn = "brn"
    case gry = "gry"
    case grn = "grn"
    case hzl = "hzl"
    case oth = "oth"
}

func validateEyeColor(_ input: String?) -> Bool {
    guard let input = input else { return false }
    guard (EyeColor(rawValue: input) != nil) else { return false }
    return true
}

func validatePassportId(_ input: String?) -> Bool {
    guard let input = input else { return false }
    guard input.count == 9 else { return false }
    return true
}

func validateInput(_ inputDictionary: [String: String]) -> Bool {
    guard validateBirthYear(inputDictionary["byr"])else { return false }
    guard validateIssueYear(inputDictionary["iyr"]) else { return false }
    guard validateExpirationYear(inputDictionary["eyr"]) else { return false }
    guard validateHeight(inputDictionary["hgt"]) else { return false }
    guard validateHairColor(inputDictionary["hcl"]) else { return false }
    guard validateEyeColor(inputDictionary["ecl"]) else { return false }
    guard validatePassportId(inputDictionary["pid"]) else { return false }
    
    return true
}

let filteredPassports = puzzleInput
    .components(separatedBy: "\n\n")
    .map { $0.replacingOccurrences(of: "\n", with: " ", options: .regularExpression) }
    .map(stringToDictionary)
    .filter(validateInput)

print("Puzzle Answer: \(filteredPassports.count)")
