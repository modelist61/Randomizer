//
//  StopWatch.swift
//  StopWatch
//
//  Created by ProgrammingWithSwift on 2020/05/24.
//  Copyright © 2020 ProgrammingWithSwift. All rights reserved.
//
import Combine
import Foundation
import SwiftUI

struct TestScreen: View {
    
    @StateObject private var testTimer = CountdownTimer()
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                HStack {
                    Text("\(testTimer.showTimer)")
                        .font(.system(size: 50))
                        
                }.padding()
                
                HStack {
                    Button("Start") {
                        testTimer.start()
                    }
                    Button("Stop") {
                        testTimer.pause()
                    }
                    Button("Reset") {
                        testTimer.reset()
                    }
                }.font(.title)
            }
            .navigationBarTitle("Pony Running")
            .navigationBarItems(trailing: Button("Refresh") {
                
            })
        }
    }
}

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}


class CountdownTimer: ObservableObject {
    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "stopwatch.timer")
    private var counter: Int = 0
    
    var showTimer = "00:00:00" {
        didSet {
            self.update()
        }
    }
    
    var paused = true {
        didSet {
            self.update()
        }
    }
    
    var laps = [LapItem]() {
        didSet {
            self.update()
        }
    }
    
    private var currentLaps = [LapItem]() {
        didSet {
            self.laps = currentLaps.reversed()
        }
    }
    
    func start() {
        self.paused = !self.paused
        
        guard let _ = self.sourceTimer else {
            self.startTimer()
            return
        }
        
        self.resumeTimer()
    }
    
    func pause() {
        self.paused = !self.paused
        self.sourceTimer?.suspend()
    }
    
    func lap() {
        if let firstLap = self.laps.first {
            let difference = self.counter - firstLap.count
            self.currentLaps.append(LapItem(count: self.counter, diff: difference))
        } else {
            self.currentLaps.append(LapItem(count: self.counter))
        }
    }
    
    func reset() {
        self.showTimer = "00:00:00"
        self.counter = 0
        self.currentLaps = [LapItem]()
    }
    
    func update() {
        objectWillChange.send()
    }
    
    func isPaused() -> Bool {
        return self.paused
    }
    
    private func startTimer() {
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict,
                                                          queue: self.queue)
        
        self.resumeTimer()
    }
    
    private func resumeTimer() {
        self.sourceTimer?.setEventHandler {
            self.updateTimer()
        }
        
        self.sourceTimer?.schedule(deadline: .now(),
                                   repeating: 0.01)
        self.sourceTimer?.resume()
    }
    
    private func updateTimer() {
        self.counter += 1
        
        DispatchQueue.main.async {
            self.showTimer = CountdownTimer.convertCountToTimeString(counter: self.counter)
        }
    }
}

extension CountdownTimer {
    struct LapItem {
        let uuid = UUID()
        let count: Int
        let stringTime: String
        
        init(count: Int, diff: Int = -1) {
            self.count = count
            
            if diff < 0 {
                self.stringTime = CountdownTimer.convertCountToTimeString(counter: count)
            } else {
                self.stringTime = CountdownTimer.convertCountToTimeString(counter: diff)
            }
        }
    }
}

extension CountdownTimer {
    static func convertCountToTimeString(counter: Int) -> String {
        let millseconds = counter % 100
        let seconds = counter / 100
        let minutes = seconds / 60
        
        var millsecondsString = "\(millseconds)"
        var secondsString = "\(seconds)"
        var minutesString = "\(minutes)"
        
        if millseconds < 10 {
            millsecondsString = "0" + millsecondsString
        }
        
        if seconds < 10 {
            secondsString = "0" + secondsString
        }
        
        if minutes < 10 {
            minutesString = "0" + minutesString
        }
        
        return "\(minutesString):\(secondsString):\(millsecondsString)"
    }
}
