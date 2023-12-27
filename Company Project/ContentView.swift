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

struct ContentView: View {
    @State var data:         [Data] = []
    @State var data2:        [Data] = []
    @State var data3:        [Data] = []
    @State var combinedData: [Data] = []

    @State var chartDomain = 25
    @State var chartRange = 10
    @State var heightMultiplier = 0.25
    @State var developerMode = false
    @State var paused = false
    @State var buttonEngaged = false
    @State var buttonDowntime = false
    @State var downtimeStart = -1
    @State var downtimeWait = 5
    @State var lightMode = false
    @State private var frequency = 1
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var index = 0
    @State private var expanded = false
    @State private var rotationAngle = -30
    @State private var scalingEffect = 0.7
    
    
    var body: some View {
        return VStack {
            Button(lightMode ? "Toggle Dark Mode" : "Toggle Light Mode", action: {lightMode = !lightMode})
            Button("Toggle Developer Mode", action: {developerMode = !developerMode
                startTimer()})
            HStack{
                Button("Pause", action: {stopTimer()})
                    .opacity(developerMode ? 1 : 0)
                Button("Resume", action: {startTimer()})
                    .opacity(developerMode ? 1 : 0)
                Button("Reset", action: {reset()})
                    .opacity(developerMode ? 1 : 0)
            }
            
            Text("Ticks Elapsed: \(index)")                
                .onReceive(timer) {time in
                    refreshData()
                    index += 1
                    
                    if (index >= downtimeStart + downtimeWait) {
                        buttonDowntime = false
                    }
                }
            Button(action: {buttonEngaged = !buttonEngaged
                buttonDowntime = true
                downtimeStart = index}) {
                    Text(buttonEngaged ? "Shut Down" : "Turn On")
                        
                        .frame(width: 150, height: 150)
                        .font(.title)
                        .background(Circle().fill(buttonEngaged ? Color.green : Color.red))
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(buttonDowntime)
            
            Button(expanded ? "Condense" : "Expand", action: {expanded = !expanded})
                
            if expanded {
                VStack {
                    ScrollView {
                        VStack {
                            Text("\nFirst Data")
                            Chart(data) {
                                LineMark(
                                    x: .value("Minutes", $0.minutes),
                                    y: .value("Output", $0.output)
                                )
                            }
                            .chartXScale(domain: 0...chartDomain - 1)
                            .chartYScale(domain: 0...chartRange)
                            .frame(minHeight: (UIWindow.current?.screen.bounds.height ?? 250) * heightMultiplier)
                        }
                        .containerRelativeFrame(.vertical)
                        .scrollTransition(axis: .vertical) {
                            content, phase in
                            content.rotation3DEffect(Angle(degrees: phase.value * Double(rotationAngle)), axis: (x : 1, y : 0, z : 0))
                                .scaleEffect(CGSize(width: phase.isIdentity ? 1 : scalingEffect, height: phase.isIdentity ? 1 : scalingEffect))
                        }
                        
                        
                        VStack {
                            Text("\nSecond Data")
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
                        .containerRelativeFrame(.vertical)
                        .scrollTransition(axis: .vertical) {
                            content, phase in
                            content.rotation3DEffect(Angle(degrees: phase.value * Double(rotationAngle)), axis: (x : 1, y : 0, z : 0))
                                .scaleEffect(CGSize(width: phase.isIdentity ? 1 : scalingEffect, height: phase.isIdentity ? 1 : scalingEffect))
                        }
                        
                        VStack {
                            Text("\nThird Data")
                            Chart(data3) {
                                LineMark(
                                    x: .value("Minutes", $0.minutes),
                                    y: .value("Output", $0.output)
                                )
                            }
                            .chartXScale(domain: 0...chartDomain - 1)
                            .chartYScale(domain: 0...chartRange)
                            .foregroundStyle(Color(.red))
                            .frame(minHeight: (UIWindow.current?.screen.bounds.height ?? 250) * heightMultiplier)
                        }
                        .containerRelativeFrame(.vertical)
                        .scrollTransition(axis: .vertical) {
                            content, phase in
                            content.rotation3DEffect(Angle(degrees: phase.value * Double(rotationAngle)), axis: (x : 1, y : 0, z : 0))
                                .scaleEffect(CGSize(width: phase.isIdentity ? 1 : scalingEffect, height: phase.isIdentity ? 1 : scalingEffect))
                        }
                        
                        VStack {
                            Text("\nCombined Data")
                            Chart(combinedData) {
                                LineMark(
                                    x: .value("Minutes", $0.minutes),
                                    y: .value("Output", $0.output),
                                    series: .value("Data Name", $0.name)
                                )
                                .foregroundStyle(by: .value("Data Name", $0.name))
                            }
                            .chartXScale(domain: 0...chartDomain - 1)
                            .chartYScale(domain: 0...chartRange)
                            .chartForegroundStyleScale(["First Data": .blue, "Second Data": .green, "Third Data": .red])
                            .frame(minHeight: (UIWindow.current?.screen.bounds.height ?? 250) * heightMultiplier)
                        }
                        .containerRelativeFrame(.vertical)
                        .scrollTransition(axis: .vertical) {
                            content, phase in
                            content.rotation3DEffect(Angle(degrees: phase.value * Double(rotationAngle)), axis: (x : 1, y : 0, z : 0))
                                .scaleEffect(CGSize(width: phase.isIdentity ? 1 : scalingEffect, height: phase.isIdentity ? 1 : scalingEffect))
                        }
                        
                    }
                    .padding()
                    .contentMargins(20)
                    .animation(.linear, value: index)
                }
                
            }
        }
        .padding()
        .preferredColorScheme(lightMode ? .light : .dark)
        .background(LinearGradient(colors: [.black, .gray], startPoint: .bottom, endPoint: .top))
        
        
        
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
        refreshData()
    }
    
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
        
        let rangeBottom = 0.4 * Double(chartRange)
        let rangeTop = 0.6 * Double(chartRange)
        
        data.append(Data(name: "First Data", minutes: data.count, output: Double.random(in:rangeBottom..<rangeTop)))
        if data.count >= chartDomain {
            data.remove(at: 0)
            for i in 0..<data.count {
                data[i].minutes -= 1
            }
        }
        
        data2.append(Data(name: "Second Data", minutes: data2.count, output: Double.random(in:rangeBottom..<rangeTop)))
        if data2.count >= chartDomain {
            data2.remove(at: 0)
            for i in 0..<data2.count {
                data2[i].minutes -= 1
            }
        }
        
        data3.append(Data(name: "Third Data", minutes: data3.count, output: Double.random(in:rangeBottom..<rangeTop) - 0.25 * Double(chartRange)))
        if data3.count >= chartDomain {
            data3.remove(at: 0)
            for i in 0..<data3.count {
                data3[i].minutes -= 1
            }
        }
        
        
        if (!buttonEngaged) {
            data[data.count - 1].output *= 0.1
            data2[data2.count - 1].output *= 0.1
            data3[data2.count - 1].output *= 0.1
        }
        
        combinedData = data + data2 + data3
    }

}

#Preview {
    ContentView()
}
