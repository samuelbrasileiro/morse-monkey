import Foundation

public enum Difficulty{
    case easy
    case medium
    case hard
}
public class Word{
    var text: String
    var difficulty: Difficulty
    public init(){
        text = ""
        difficulty = .easy
    }
    public init(_ text: String, _ difficulty: Difficulty){
        self.text = text
        self.difficulty = difficulty
    }
    public class func generateSet()->[String]{
        var words: [String] = [""]
        var easyWords = Self.words.filter{$0.difficulty == .easy}
        var mediumWords = Self.words.filter{$0.difficulty == .medium}
        var hardWords = Self.words.filter{$0.difficulty == .hard}
        
        while easyWords.count > 0 && mediumWords.count > 0 && hardWords.count > 0{
            
            if words.count < 7 {
                if let random = (0..<easyWords.count).randomElement(){
                    words.append(easyWords[random].text)
                    easyWords.remove(at: random)
                }
            }
            else if words.count < 20{
                if [true,true,false].randomElement()!{
                    if let random = (0..<mediumWords.count).randomElement(){
                        words.append(mediumWords[random].text)
                        mediumWords.remove(at: random)
                    }
                }
                else{
                    if let random = (0..<easyWords.count).randomElement(){
                        words.append(easyWords[random].text)
                        easyWords.remove(at: random)
                    }
                }
            }
            else{
                if [true,true,false].randomElement()!{
                    if let random = (0..<hardWords.count).randomElement(){
                        words.append(hardWords[random].text)
                        hardWords.remove(at: random)
                    }
                }
                else{
                    if let random = (0..<mediumWords.count).randomElement(){
                        words.append(mediumWords[random].text)
                        mediumWords.remove(at: random)
                    }
                }
            }
        }
        
        return words
    }
    static public func getHardWords() -> [String]{
        return Self.words.filter({$0.difficulty == .hard}).map{$0.text}
    }
    
    public class func getKeys() -> [String: Int]{
        return translations.reduce([String: Int]()){ dict, value in
            var dict = dict
            dict[value.key] = 0
            return dict
        }
    }
    
    static public let words: [Word] = [
        Word("bird", .easy),
        Word("tea", .easy),
        Word("son", .easy),
        Word("mom", .easy),
        Word("food", .easy),
        Word("love", .easy),
        Word("town", .easy),
        Word("dad", .easy),
        Word("hat", .easy),
        Word("max", .easy),
        Word("zoo", .easy),
        Word("maze", .easy),
        Word("zero", .easy),
        Word("sky", .easy),
        Word("fly", .easy),
        Word("kiss", .easy),
        Word("cow", .easy),
        Word("baby", .easy),
        Word("pot", .easy),
        Word("life", .easy),
        Word("dog", .easy),
        Word("cat", .easy),
        Word("ant", .easy),
        Word("bee", .easy),
        Word("pool", .easy),
        Word("queen", .easy),
        Word("baby", .easy),
        Word("bat", .easy),
        Word("fish", .medium),
        Word("hair", .medium),
        Word("math", .medium),
        Word("child", .medium),
        Word("banana", .medium),
        Word("people", .medium),
        Word("country", .medium),
        Word("apple", .medium),
        Word("family", .medium),
        Word("friends", .medium),
        Word("movie", .medium),
        Word("film", .medium),
        Word("chest", .medium),
        Word("glasses", .medium),
        Word("grocery", .medium),
        Word("science", .medium),
        Word("history", .medium),
        Word("child", .medium),
        Word("supply", .medium),
        Word("doctor", .medium),
        Word("banana", .hard),
        Word("razor", .medium),
        Word("shades", .medium),
        Word("lawyer", .medium),
        Word("pretty", .medium),
        Word("monster", .hard),
        Word("dinossaur", .hard),
        Word("academy", .hard),
        Word("collection", .hard),
        Word("fantasy", .hard),
        Word("loyality", .hard),
        Word("companion", .hard),
        Word("university", .hard),
        Word("chemestry", .hard),
        Word("satisfaction", .hard),
        Word("library", .hard),
        Word("politician", .hard),
        Word("physician", .hard),
        Word("respect", .hard),
        Word("diamond", .hard),
        Word("chimney", .hard),
        Word("classroom", .hard),
        Word("bathroom", .hard),
        Word("childhood", .hard),
    ]
    static public let translations: [String: String] = [
        "a": ".-",
        "b": "-...",
        "c": "-.-.",
        "d": "-..",
        "e": ".",
        "f": "..-.",
        "g": "--.",
        "h": "....",
        "i": "..",
        "j": ".---",
        "k": "-.-",
        "l": ".-..",
        "m": "--",
        "n": "-.",
        "o": "---",
        "p": ".--.",
        "q": "--.-",
        "r": ".-.",
        "s": "...",
        "t": "-",
        "u": "..-",
        "v": "...-",
        "w": ".--",
        "x": "-..-",
        "y": "-.--",
        "z": "--.."
    ]
}
