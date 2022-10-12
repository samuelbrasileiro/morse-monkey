import Foundation

import SpriteKit

public protocol GameDelegate{
    func updateGame()
    func gameOver()
}

public enum ZPosition: Int {
    case background
    case foreground
    case player
    case otherNodes
}

public class GameScene: SKScene, GameDelegate {

    var hasMoved: Bool = false
    
    var trunks: [SKSpriteNode] = []
    var branches: [SKSpriteNode] = []
    var bananas: [SKSpriteNode] = []
    
    var monkey: SKSpriteNode = SKSpriteNode()
    var environment: GameEnvironment?
    
    var monkeyStillTexture = SKTexture(imageNamed: "monkey_still")
    var monkeyJumpingTexture = SKTexture(imageNamed: "monkey_jumping")
    var monkeyFallingTexture = SKTexture(imageNamed: "monkey_falling")
    public func updateGame() {
        //print("boolean")
        
        if let environment = environment{
            let range = environment.getRange()
            
            if Int(trunks.last!.name!) != range.last!{
                
                addTrunk(imageName: environment.stages[range.last!].trunkIndex, index: range.last!, y: trunks.last!.position.y + 120)
                
                addBranch(index: range.last!, y: trunks.last!.position.y)
                
                addBanana(index: range.last!, y: trunks.last!.position.y - 17)
            }
            
            for trunk in trunks{
                let action = SKAction.moveBy(x: 0, y: -120, duration: 1)
                
                trunk.run(action)
            }
            for branch in branches{
                let action = SKAction.moveBy(x: 0, y: -120, duration: 1)
                branch.run(action)
            }
            for banana in bananas{
                let action = SKAction.moveBy(x: 0, y: -120, duration: 1)
                banana.run(action)
            }
            setMonkeyPosition(animate: true)
            
            
            if trunks.count > 7{
                trunks.first?.removeFromParent()
                trunks.removeFirst()
                branches.first?.removeFromParent()
                branches.removeFirst()
            }
            
            
        }
    }
    public func gameOver() {
        self.monkey.xScale *= 1.2
        self.monkey.yScale *= 1.4
        self.monkey.texture = monkeyJumpingTexture
        let action = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY + 100), duration: 0.8)
        
        monkey.run(action,completion: {
            self.monkey.texture = self.monkeyFallingTexture
            let action = SKAction.moveTo(y: -120, duration: 2.5)
            self.monkey.run(action)
            
        })
    }
    
    override public func didMove(to view: SKView) {
        if self.hasMoved{
            return
        }
        //print("moved")
        self.hasMoved = true
        let background = SKSpriteNode(imageNamed: "background")
            background.size = frame.size
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            background.zPosition = CGFloat(ZPosition.background.rawValue)
            addChild(background)
        
        if let environment = environment{
            environment.gameDelegate = self
            
            if trunks.isEmpty{
                for index in environment.getRange(){
                    addTrunk(imageName: environment.stages[index].trunkIndex, index: index, y: 60 + CGFloat(120*index))
                    if index >= 1{
                        addBranch(index: index, y: 60 + CGFloat(120*index))
                    }
                    if index >= 2{
                        addBanana(index: index, y: 43 + CGFloat(120*index))
                        
                    }
                }
            }
            
        }
        
        self.monkey = SKSpriteNode(imageNamed: "monkey_still")
        self.monkey.name = "monkey"
        self.monkey.size.width = 160
        self.monkey.size.height = 150
        self.monkey.zPosition = CGFloat(ZPosition.player.rawValue)
        setMonkeyPosition(animate: false)
        self.addChild(monkey)
    }
    
    func endMonkeyJump(){
        self.monkey.xScale *= -1
        self.monkey.xScale /= 1.2
        self.monkey.yScale /= 1.4
        self.monkey.texture = self.monkeyStillTexture
        self.bananas.first?.removeFromParent()
        self.bananas.removeFirst()
    }
    
    func setMonkeyPosition(animate: Bool){
        
        if var branchPos = self.branches.first(where: {$0.name == String(environment!.current)})?.position{
            //print(environment!.current)
            branchPos.y += 50
            if environment!.current % 2 == 0{
                branchPos.x -= 12
            }
            else{
                branchPos.x += 12
            }
            if animate{
                branchPos.y -= 120
                self.monkey.texture = self.monkeyJumpingTexture
                self.monkey.xScale *= 1.2
                self.monkey.yScale *= 1.4
                let action = SKAction.move(to: branchPos, duration: 1)
                self.monkey.run(action, completion: {
                    self.endMonkeyJump()
                })
            }
            else{
                self.monkey.position = branchPos
            }
        }
    }
    
    func addBranch(index: Int, y: CGFloat){
        let branch = SKSpriteNode(imageNamed: "branch")
        branch.size.height = 90
        branch.name = String(index)
        branch.size.width = 200
        var xToAdd: CGFloat = 140
        if index % 2 == 0{
            branch.xScale *= -1
        }
        else{
            xToAdd *= -1
        }
        branch.position = CGPoint(x: self.frame.midX + xToAdd, y: y)
        
        branch.zPosition = CGFloat(ZPosition.foreground.rawValue)
        branches.append(branch)
        addChild(branch)
    }
    func addBanana(index: Int, y: CGFloat){
        let banana = SKSpriteNode(imageNamed: "banana")
        banana.size.height = 15
        banana.name = String(index)
        banana.size.width = 50
        var xToAdd: CGFloat = 100
        if index % 2 == 0{
            banana.xScale *= -1
        }
        else{
            xToAdd *= -1
        }
        banana.position = CGPoint(x: self.frame.midX + xToAdd, y: y )
        banana.zPosition = CGFloat(ZPosition.foreground.rawValue)
        bananas.append(banana)
        addChild(banana)
    }
    
    func addTrunk(imageName: String, index: Int, y: CGFloat){
        let trunk = SKSpriteNode(imageNamed: imageName)
        trunk.size.height = 120
        trunk.name = String(index)
        trunk.size.width = 90
        trunk.position = CGPoint(x: self.frame.midX, y: y)
        trunk.zPosition = CGFloat(ZPosition.foreground.rawValue)
        trunks.append(trunk)
        addChild(trunk)
    }
    
}
