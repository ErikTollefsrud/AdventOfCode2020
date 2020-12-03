import Foundation

/*
 --- Day 2: Password Philosophy ---

 Your flight departs in a few days from the coastal airport; the easiest way down to the coast from here is via toboggan.

 The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's wrong with our computers; we can't log in!" You ask if you can take a look.

 Their password database seems to be a little corrupted: some of the passwords wouldn't have been allowed by the Official Toboggan Corporate Policy that was in effect when they were chosen.

 To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and the corporate policy when that password was set.

 For example, suppose you have the following list:

 1-3 a: abcde
 1-3 b: cdefg
 2-9 c: ccccccccc
 Each line gives the password policy and then the password. The password policy indicates the lowest and highest number of times a given letter must appear for the password to be valid. For example, 1-3 a means that the password must contain a at least 1 time and at most 3 times.

 In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.

 How many passwords are valid according to their policies?
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

let result = items.map { item -> Bool in
    let splitItems = item.split(separator: ":")
    let ruleComponents = splitItems[0].split(separator: " ")
    
    let lowHighValues = ruleComponents[0].split(separator: "-")
    let ruleLetter = ruleComponents[1]
    
    let total = splitItems[1].reduce(0) { (result, valueIn) in
        if String(valueIn) == String(ruleLetter) {
            return result + 1
        }
        return result
    }
    
    return total >= Int(lowHighValues[0])! && total <= Int(lowHighValues[1])!
}.filter{ $0 }.count


// A Parser can be thought of as a function that takes a string and returns an optional value
// ex: (String) -> A?
// But...this implies that it consumes the whole string. We want the ability to comsume the
// value if it matches, and return the rest of the String after removing the bit that we
// consumed. This would make it so that we could compose multiple parsers together.
// The signature looks like this:
// (String) -> (match: A?, rest: String)
// (inout String) -> A?
// (inout Substring) -> A?

//struct Parser<Output> {
//    let run: (inout Substring) -> Output?
//}
//
//extension Parser where Output == Int {
//   static let int = Self { input in
//        let original = input
//
//        let sign: Int
//        if input.first == "-" {
//            sign = -1
//            input.removeFirst()
//        } else if input.first == "+" {
//            sign = 1
//            input.removeFirst()
//        } else {
//            sign = 1
//        }
//
//        let intPrefix = input.prefix(while: \.isNumber)
//        guard let match = Int(intPrefix)
//        else {
//            input = original
//            return nil
//        }
//        input.removeFirst(intPrefix.count)
//        return match * sign
//    }
//}
//
//extension Parser where Output == Double {
//    static let double = Self { input in
//        let original = input
//        let sign: Double
//        if input.first == "-" {
//            sign = -1
//            input.removeFirst()
//        } else if input.first == "+" {
//            sign = 1
//            input.removeFirst()
//        } else {
//            sign = 1
//        }
//
//        var decimalCount = 0
//        let prefix = input.prefix { char in
//            if char == "." { decimalCount += 1 }
//            return char.isNumber || (char == "." && decimalCount <= 1)
//        }
//
//        guard let match = Double(prefix)
//        else {
//            input = original
//            return nil
//        }
//        input.removeFirst(prefix.count)
//        return match * sign
//    }
//}
//
//extension Parser where Output == Character {
//    static let char = Self { input in
//        guard !input.isEmpty else { return nil }
//        return input.removeFirst()
//    }
//}
//
//extension Parser where Output == Void {
//    static func prefix(_ p: String) -> Self {
//        Self { input in
//            guard input.hasPrefix(p) else { return nil }
//            input.removeFirst(p.count)
//            return ()
//        }
//    }
//}
//
//var input = "123 Hello"[...]
//
//Parser.int.run(&input)
//input
//
//extension Parser {
//    func run(_ input: String) -> (match: Output?, rest: Substring) {
//        var input = input[...]
//        let match = self.run(&input)
//        return (match, input)
//    }
//}
//
//Parser.int.run("123 Hello")
//Parser.int.run("Hello Blob")
//Parser.int.run("Hello 123")
//Parser.int.run("-Hello")
//Parser.int.run("+123 Hello")
//
//Parser.prefix("Hello").run("Hello Blob")
//
//extension Parser {
//    func map<NewOutput>(_ f: @escaping (Output) -> NewOutput) -> Parser<NewOutput> {
//        .init { input in
//            self.run(&input).map(f)
//        }
//    }
//}
//
//extension Parser {
//    func flatMap<NewOutput>(
//        _ f: @escaping (Output) -> Parser<NewOutput>
//    ) -> Parser<NewOutput> {
//        .init { (input) -> NewOutput? in
//            let original = input
//            let output = self.run(&input)
//            let newParser = output.map(f)
//            guard let newOutput = newParser?.run(&input) else {
//                input = original
//                return nil
//            }
//            return newOutput
//        }
//    }
//}
//
//extension Parser {
//    static func always(_ output: Output) -> Self {
//        Self { _ in output }
//    }
//
//    static var never: Self {
//        Self { _ in nil }
//    }
//}
//
//func zip<Output1, Output2>(
//    _ p1: Parser<Output1>,
//    _ p2: Parser<Output2>
//) -> Parser<(Output1, Output2)> {
//
//    .init { input -> (Output1, Output2)? in
//        let original = input
//        guard let output1 = p1.run(&input) else { return nil }
//        guard let output2 = p2.run(&input) else {
//            input = original
//            return nil
//        }
//        return (output1, output2)
//    }
//}
//
//let even = Parser.int.map { $0.isMultiple(of: 2) }
//
//even.run("123 Hello")
//even.run("124 Hello")
//
//let evenInt = Parser.int
//    .flatMap { n in
//        n.isMultiple(of: 2)
//            ? .always(n)
//            : .never
//    }
//
//evenInt.run("123 Hello")
//evenInt.run("124 Hello")
