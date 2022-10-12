import SwiftUI

public enum Status{
    case inProgress(index: Int, remain: Int)
    case completed
    case impossible
}

public class Stage: ObservableObject{
    
    @Published private var _word: [String]
    
    public var word: String {
        get{
            return _word.joined()
        }
    }
    
    @Published private var _trunkIndex: Int
    
    public var trunkIndex: String{
        get{
            return "trunk\(_trunkIndex)"
        }
    }
    @Published public var remain: Int = 0
    @Published public var discoveredCount = 0
    
    public init(word: String, trunkIndex: Int) {
        self._word = word.map{String($0)}
        self._trunkIndex = trunkIndex
    }
    
    public func check(index: Int, morse: String) -> Status{
        if index < word.count{
            if let letterMorse = Word.translations.first(where: {$0.key == _word[index]})?.value{
                
                if morse.hasPrefix(letterMorse){
                    return check(index: index + 1, morse: String(morse.suffix(morse.count - letterMorse.count)))
                    
                }
                else if morse.count < letterMorse.count && letterMorse.hasPrefix(morse){
                    return .inProgress(index: index, remain: morse.count)
                }
                else{
                    return .impossible
                }
                
            }
            else{
                return .impossible
            }
        }
        else{
            self.discoveredCount += 1
            self.remain += 1
            return .completed
        }
    }
    
}
