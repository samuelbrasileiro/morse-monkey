import SwiftUI
import SpriteKit
import Cocoa
public struct AcessibleButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white : Color.black)
            .background(configuration.isPressed ? Color.green : Color.white)
            .cornerRadius(6.0)
            .padding( 10)
    }
}

public class GameSceneLoader: ObservableObject{
    @Published public var scene: GameScene = GameScene()
    public init(){
        
    }
    public init(environment: GameEnvironment){
        reset(environment)
    }
    public func reset(_ environment: GameEnvironment){
        let scene = GameScene(size: CGSize(width: 800, height: 500))
        
        scene.environment = environment
        scene.scaleMode = .fill
        self.scene = scene
    }
    
}

public struct StageView: View{
    @ObservedObject public var stage: Stage
    public var isEasier: Bool
    public var occurences: [String: Int]
    public var body: some View{
        let wordArray = stage.word.map{String($0)}
        HStack(spacing: 0){
            ForEach(0..<stage.word.count, id: \.self){index in
                VStack{
                    let hasDiscovered = index < stage.discoveredCount
                    let willDiscover = index > stage.discoveredCount
                    let word = wordArray[index]
                    Text(word.uppercased())
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(hasDiscovered ? .green : (willDiscover ? .gray : .black))
                    
                    let morseArray = Word.translations[word]!.map{String($0)}
                    
                    HStack(spacing: 0){
                        ForEach(0..<morseArray.count, id: \.self){index in
                            let morseChar = morseArray[index]
                            let hasWritten = index < stage.remain
                            let willWrite = index > stage.remain
                            Text(morseChar)//[index])
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor((hasWritten && !willDiscover) || hasDiscovered ? .green : (willWrite || willDiscover ? .gray : .black))
                                .opacity(( occurences[word]! < 4) || hasDiscovered || (!hasDiscovered && !willDiscover && hasWritten) ? 1 : 0)
                            
                        }
                    }
                    
                }
                .frame(maxWidth:40)
            }
            
        }
        .frame(width: 300, height: 70)
        
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(#colorLiteral(red: 0.6509803922, green: 0.5098039216, blue: 0.3137254902, alpha: 1)), lineWidth: 3)
        )
        .padding(5)
        .background(Color(#colorLiteral(red: 0.9999235272, green: 1, blue: 0.9998829961, alpha: 1)))
        .cornerRadius(20)
    }
}


public struct MainView: View{
    
    @ObservedObject public var environment = GameEnvironment()
    
    @ObservedObject public var sceneLoader = GameSceneLoader()
    
    public init(){
        sceneLoader = GameSceneLoader(environment: environment)
        
    }
    public var body: some View{
        
        ZStack {
            ZStack(alignment: .topLeading){
                VStack(spacing: 0){
                    
                    
                    ZStack(alignment: .topTrailing){
                        ZStack(alignment: .bottomTrailing) {
                            SpriteView(scene: sceneLoader.scene)
                                .frame(width: 800, height: 500)
                                .ignoresSafeArea()
                            
                            BananaButtonView(environment: environment)
                                .onTapGesture{
                                    self.environment.useBanana()
                                }
                        }
                        
                        StageView(stage: environment.stages[environment.currentToDisplay], isEasier: environment.score < 20, occurences: environment.letterOccurence)
                            
                            .padding()
                    }
                    
                    
                    VStack{
                        
                        HStack{
                            Button(action: {
                                environment.selected(char: ".")
                                
                            }){
                                Text(".")
                                    .font(.system(size: 60, weight: .bold, design: .default))
                                    .frame(maxWidth: 600, maxHeight: 200)
                            }
                            .buttonStyle(AcessibleButtonStyle())
                            
                            Button(action: {
                                environment.selected(char: "-")
                            }){
                                Text("-")
                                    .font(.system(size: 60, weight: .bold, design: .default))
                                    .frame(maxWidth: 600, maxHeight: 200)
                            }
                            .buttonStyle(AcessibleButtonStyle())
                        }
                        
                    }
                    .frame(width: 800, height: 200)
                    .background(Color.clear)
                }
                .blur(radius: environment.showLostView ? 3 : 0)
                
                Text("Score: \(environment.score)")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(16)
                    .padding(12)
                
            }
            
            VStack{
                Spacer()
                Text("Good Try!")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding()
                Spacer()
                let biggest = self.environment.getBiggestOccurences()
                let text = biggest.1 == 5 ? "You've mastered these letters!" : "You've discovered some letters!"
                if biggest.1 > 0{
                    Text(text)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    Text(biggest.0.joined(separator: ",  ").uppercased())
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: 300)
                        .padding()
                    Spacer()
                }
                
                Text("Play again")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .padding(30)
                    .background(Color(#colorLiteral(red: 0.6509803922, green: 0.5098039216, blue: 0.3137254902, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .onTapGesture {
                        self.environment.reset()
                        self.sceneLoader.reset(environment)
                    }
                
                
                Spacer()
            }
            .frame(width: 500, height: 500)
            .background(Color(#colorLiteral(red: 0.9999235272, green: 1, blue: 0.9998829961, alpha: 1)))
            .cornerRadius(30)
            .offset(y: environment.showLostView ? -10 : 600)
            .shadow(radius: 7 )
            .animation(.spring())
            .opacity(environment.showLostView ? 1 : 0)
            
        }
        
    }
}

public struct BananaButtonView: View{
    @ObservedObject public var environment: GameEnvironment
    
    public var body: some View{
        ZStack(alignment: .bottomTrailing) {
            Image(nsImage: NSImage(named: "banana.png")!)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-30))
                .padding(10)
                .overlay(Circle().stroke(Color(#colorLiteral(red: 0.6509803922, green: 0.5098039216, blue: 0.3137254902, alpha: 1)), lineWidth: 3))
                .padding(5)
                .background(Circle().fill(Color(#colorLiteral(red: 0.9999235272, green: 1, blue: 0.9998829961, alpha: 1))).opacity(0.6))
                .padding()
            Text("\(environment.countOfBananas)")
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundColor(Color(#colorLiteral(red: 0.6509803922, green: 0.5098039216, blue: 0.3137254902, alpha: 1)))
                .frame(width:30,height: 30)
                .padding()
                .overlay(Circle().stroke(Color(#colorLiteral(red: 0.6509803922, green: 0.5098039216, blue: 0.3137254902, alpha: 1)), lineWidth: 3))
                .background(Circle().fill(Color(#colorLiteral(red: 0.9999235272, green: 1, blue: 0.9998829961, alpha: 1))))
                
                .padding(10)
        }
    }
}

