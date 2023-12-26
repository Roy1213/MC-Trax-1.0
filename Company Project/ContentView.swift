//
//  ContentView.swift
//  Company Project
//
//  Created by Roy Alameh on 12/25/23.
//

import SwiftUI
import Charts

struct Data: Identifiable {
    var id = UUID()
    var hours : Int
    var minutes : Int
    var output : Double
    
    init(hours: Int, minutes: Int, output: Double) {
        self.hours = hours
        self.minutes = minutes
        self.output = output
    }
}

var data: [Data] = []

func refreshData() {
    data.append(Data(hours: 4, minutes: data.count, output: Double(Int.random(in:1..<20))))
}

var paused = false

struct ContentView: View {
    var frequency = 1
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var index = 0
    
    var body: some View {
        
        refreshData()
        return VStack {
            Text("\(index)")
                .onReceive(timer) {time in
                    index += 1
                }
            Button("Pause", action: {stopTimer()})
            Button("Resume", action: {startTimer()})
            Button("Reset", action: {reset()})
            
            Chart(data) {
                LineMark(
                    x: .value("Minutes", $0.minutes),
                    y: .value("Output", $0.output)
                )
            }
        }
        .padding()
        
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
        paused = true
    }
    func startTimer() {
        if paused {
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            paused = false
        }
    }
    func reset() {
        index = 0
        stopTimer()
        data = []
    }
}

#Preview {
    ContentView()
}
