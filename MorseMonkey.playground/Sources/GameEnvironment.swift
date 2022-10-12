
import SwiftUI


public class GameEnvironment: ObservableObject{
    
    @Published public var score = 0
    
    @Published public var current = 0
    @Published public var currentToDisplay = 0
    
    public var currentMorse = ""
    
    public var stages: [Stage] = []
    
    @Published public var countOfBananas = 0
    
    @Published public var didLostGame = false
    
    @Published public var showLostView = false
    
    @Published public var isInCooldown = false
    
    public var letterOccurence: [String: Int] = [:]//Word.getKeys()
    public var gameDelegate: GameDelegate?
    
    public init(){
        reset()
    }
    
    public func selected(char: String){
        
        if didLostGame || current >= stages.count || isInCooldown {
            return
        }
        currentMorse += char
        //print("Stage \(current): \(stages[current].word)")
        let state = stages[current].check(index: 0, morse: currentMorse)
        
        switch state {
        case .completed:
            //print("completed word ", self.stages[self.current].word)
            self.currentMorse.removeAll()
            
            self.publishOccurences(word: self.getCurrentStage().word)
            
            self.score += 1
            if self.current + 1 < self.stages.count{
                self.stages.append(contentsOf: Word.getHardWords().map{Stage(word: $0, trunkIndex: (0..<6).randomElement()!)})
            }
            
            self.current += 1
            
            gameDelegate?.updateGame()
            
            self.isInCooldown = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.isInCooldown = false
                self.currentToDisplay += 1
                self.countOfBananas += 1
            }
            
        case .impossible:
            self.didLostGame = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){
                self.showLostView = true
            }
            self.gameDelegate?.gameOver()
            
            
        case let .inProgress(count, remain):
            self.stages[self.current].discoveredCount = count
            self.stages[self.current].remain = remain
            //print(count, " words were discovered until now, keep going!" )
        }
        
        
    }
    
    public func getRange()->Range<Int>{
        
        let count = self.stages.count
        let isOOB = current + 4 >= count
        
        return (self.current - 1) ..< (isOOB ? count : (self.current + 4))
    }
    
    public func reset(){
        self.score = 0
        self.current = 1
        self.currentToDisplay = 1
        self.countOfBananas = 0
        self.stages = Word.generateSet().map{Stage(word: $0, trunkIndex: (0..<6).randomElement()!)}
        self.didLostGame = false
        self.showLostView = false
        self.currentMorse = ""
        self.letterOccurence = Word.getKeys()
    }
    
    public func useBanana(){
        if countOfBananas == 0{
            return
        }
        
        countOfBananas -= 1
        let discovered = self.getCurrentStage().discoveredCount
        let array = self.getCurrentStage().word.map({String($0)})
        let filtered = (0..<array.count).filter({$0 <= discovered}).map{array[$0]}
                
        self.currentMorse = filtered.map{Word.translations[$0]!}.joined()
        
        //print(currentMorse)
        self.selected(char: "")
        
    }
    
    public func publishOccurences(word: String){
        for letter in word.map({String($0)}){
            self.letterOccurence[letter]! += 1
        }
    }
    
    public func getBiggestOccurences()-> ([String], Int){
        var result: [String] = []

       
        result = letterOccurence.filter({$0.value > 4}).map{$0.key}
        if result.count == 0{
            result = letterOccurence.filter({$0.value >= 1}).map{$0.key}
            if result.count == 0{
                return ([], 0)
            }
            else{
                return (result, 1)
            }
        }
        else{
            return (result, 5)
        }
        
    }
    public func getCurrentStage() -> Stage{
        return self.stages[self.current]
    }
}
