//
//  ContentView.swift
//  Company Project
//
//  Created by Roy Alameh on 12/25/23.
//

import SwiftUI
import Charts

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}

struct Data: Identifiable {
    var id = UUID()
    var name : String
    var minutes : Int
    var output : Double
    
    init(name: String, minutes: Int, output: Double) {
        self.name = name
        self.minutes = minutes
        self.output = output
    }
}

var data:  [Data] = []
var data2: [Data] = []
var data3: [Data] = []

var chartDomain = 25
var chartRange = 10
var heightMultiplier = 0.25

func firstData() {
    data.append(Data(name: "First Data", minutes: 0, output: Double.random(in:Double(chartRange/2 - 1)...Double(chartRange/2 + 1))))
    for _ in 1...chartDomain - 1 {
        refreshData()
    }
}

func refreshData() {
    if data.count == 0 {
        firstData()
    }
    let range = 1.0
    let rangeBottom = data[data.count - 1].output - range/2
    let rangeTop = data[data.count - 1].output + range/2
    data.append(Data(name: "First Data", minutes: data.count, output: Double.random(in:rangeBottom..<rangeTop)))
    if data.count >= chartDomain {
        data.remove(at: 0)
        for i in 0..<data.count {
            data[i].minutes -= 1
        }
    }
    
    data2 = data.map {Data(name: "SecondData", minutes: $0.minutes, output: Double(chartRange) - $0.output)}
    data3 = data.map {Data(name: "ThirdData", minutes: $0.minutes, output: $0.output - Double(chartRange) * 0.25)}
    
    
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
            
            ScrollView {
                Chart(data) {
                    LineMark(
                        x: .value("Minutes", $0.minutes),
                        y: .value("Output", $0.output)
                    )
                }
                .chartXScale(domain: 0...chartDomain - 1)
                .chartYScale(domain: 0...chartRange)
                .frame(minHeight: (UIWindow.current?.screen.bounds.height ?? 250) * heightMultiplier)
                
                Chart(data2) {
                    LineMark(
                        x: .value("Minutes", $0.minutes),
                        y: .value("Output", $0.output)
                    )
                }
                .chartXScale(domain: 0...chartDomain - 1)
                .chartYScale(domain: 0...chartRange)
                .foregroundStyle(Color(.green))
                .frame(minHeight: (UIWindow.current?.screen.bounds.height ?? 250) * heightMultiplier)
                
            }
        }
        .padding()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        
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
