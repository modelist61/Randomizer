//
//  PonyView.swift
//  PonyRunning
//
//  Created by Dmitry Tokarev on 12.02.2021.
//

import SwiftUI

struct PonyView: View {
    
    @State private var isActiveTimer = false
    
    @State private var moveOffsetX1: CGFloat = -180
    @State private var moveOffsetX2: CGFloat = -180
    @State private var moveOffsetX3: CGFloat = -180
    @State private var moveOffsetX4: CGFloat = -180
    @State private var moveOffsetX5: CGFloat = -180
    @State private var moveOffsetX6: CGFloat = -180
    
    @State private var isCheck1 = false
    @State private var isCheck2 = false
    @State private var isCheck3 = false
    @State private var isCheck4 = false
    @State private var isCheck5 = false
    @State private var isCheck6 = false
    
    @State private var winnerColor: Color = Color.clear
    @State private var chooseColor: Color = .primary
    
    @State private var difArray: [CGFloat] = []
    
    var body: some View {
        VStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .frame(width: 200, height: 100)
                    .foregroundColor(winnerColor)
                Text(gameMessage())
                    .font(.title)
                    .fontWeight(.bold)
            }.animation(.easeIn)
            .padding()
            
            VStack {
                Image(systemName: !isActiveTimer ? "checkmark.seal" : "checkmark.seal.fill")
                    .font(.system(size: 40))
                    .foregroundColor(chooseColor)
                
                Text("choose color")
                    .font(.caption2)
                    .opacity(chooseColor != .primary ? 0.0 : 1.0)
                
                
               
            }.padding(10)
            
            RunLine(lineColor: .gray,
                    choosenColor: { chooseColor = .gray },
                    offSetX: $moveOffsetX1,
                    disableValue: $isActiveTimer) {
                moveAtTimer()
                difArray = randomArray()
            }
            
            RunLine(lineColor: .blue,
                    choosenColor: { chooseColor = .blue },
                    offSetX: $moveOffsetX2,
                    disableValue: $isActiveTimer) {
                moveAtTimer()
            }
            
            RunLine(lineColor: .green,
                    choosenColor: { chooseColor = .green },
                    offSetX: $moveOffsetX3,
                    disableValue: $isActiveTimer) {
                moveAtTimer()
            }
            
            RunLine(lineColor: .orange,
                    choosenColor: { chooseColor = .orange },
                    offSetX: $moveOffsetX4,
                    disableValue: $isActiveTimer) {
                moveAtTimer()
            }
            
            RunLine(lineColor: .pink,
                    choosenColor: { chooseColor = .pink },
                    offSetX: $moveOffsetX5,
                    disableValue: $isActiveTimer) {
                moveAtTimer()
            }
            
            RunLine(lineColor: .yellow,
                    choosenColor: { chooseColor = .yellow},
                    offSetX: $moveOffsetX6,
                    disableValue: $isActiveTimer) {
                moveAtTimer()
            }
            
            Button(action: { isActiveTimer.toggle()
                    winnerColor = .clear })
            {
                VStack {
                    Text(isActiveTimer ? "Pause" : "Start")
                        .frame(width: 100, height: 40)
                        .foregroundColor(chooseColor == .primary ? .gray : .white )
                        .background(Color.black)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white)
                    )
                    ForEach(difArray, id: \ .self) { rand in
                        Text("\(rand)")
                    }
                }

            }.disabled(chooseColor == .primary ? true : false)
            .padding(30)
            
//            ForEach(difArray, id: \ .self) { runStep in
//                RunLine2(lineColor: .blue, choosenColor: {
//                    chooseColor = .blue
//                }, offSetX: runStep, disableValue: $isActiveTimer) {
//                    moveAtTimer()
//                }
//            }
            
//            Spacer()
            
            
            Spacer()
            
        }
        .animation(.easeIn)
    }
    
    func moveAtTimer() {
        guard isActiveTimer else { return }
        
        let array = [moveOffsetX1, moveOffsetX2, moveOffsetX3, moveOffsetX4, moveOffsetX5]
        
        if array.max()! < 180 {
            
            moveOffsetX1 += CGFloat.random(in: -3...5)
            moveOffsetX2 += CGFloat.random(in: -3...5)
            moveOffsetX3 += CGFloat.random(in: -3...5)
            moveOffsetX4 += CGFloat.random(in: -3...5)
            moveOffsetX5 += CGFloat.random(in: -3...5)
            moveOffsetX6 += CGFloat.random(in: -3...5)
            
            if moveOffsetX1 > 180 {
                winnerColor = .gray
            } else if moveOffsetX2 > 180 {
                winnerColor = .blue
            } else if moveOffsetX3 > 180 {
                winnerColor = .green
            } else if moveOffsetX4 > 180 {
                winnerColor = .orange
            } else if moveOffsetX5 > 180 {
                winnerColor = .pink
            } else if moveOffsetX6 > 180 {
                winnerColor = .yellow
            }
            
        } else {
            
            isActiveTimer = false
            
            isCheck1 = false
            isCheck2 = false
            isCheck3 = false
            isCheck4 = false
            isCheck5 = false
            isCheck6 = false

            moveOffsetX1 = -180
            moveOffsetX2 = -180
            moveOffsetX3 = -180
            moveOffsetX4 = -180
            moveOffsetX5 = -180
            moveOffsetX6 = -180

            chooseColor = .primary
        }
    }
    
    func gameMessage() -> String {
        var message = "Let's play!"
        
        if isActiveTimer {
            message = "Wait..."
        } else if chooseColor == winnerColor {
            message = "YOU WIN!!!"
        }
        
        return message
    }
    
    func randomArray() -> [CGFloat] {
        var randomMove: [CGFloat] = []
        guard isActiveTimer else { return randomMove }

        for _ in 0...6 {
            let randomVal = CGFloat.random(in: -3...5)
            randomMove.append(randomVal)
        }
        
        return randomMove
    }
}

struct PonyView_Previews: PreviewProvider {
    static var previews: some View {
        PonyView()
    }
}

struct RunLine: View {
    
    let lineColor: Color
    var choosenColor: () -> Void
    @Binding var offSetX: CGFloat
    @Binding var disableValue: Bool
    let action: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: screenWidth, height: 40)
                .foregroundColor(lineColor)
            Circle()
                .frame(width: 30, height: 30)
                .offset(x: offSetX, y: 0)
        }.onReceive(mainTimer) { _ in
            action()
        }.onTapGesture {
            choosenColor()
        }
        .disabled(disableValue)
    }
}

struct RunLine2: View {
    
    let lineColor: Color
    var choosenColor: () -> Void
    let offSetX: CGFloat
    @Binding var disableValue: Bool
    let action: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: screenWidth, height: 40)
                .foregroundColor(lineColor)
            Circle()
                .frame(width: 30, height: 30)
                .offset(x: offSetX, y: 0)
        }.onReceive(mainTimer) { _ in
            action()
        }.onTapGesture {
            choosenColor()
        }
        .disabled(disableValue)
    }
}


