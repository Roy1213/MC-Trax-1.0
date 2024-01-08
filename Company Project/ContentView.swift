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

struct Machine {
    
    static let models = ["ECO",
                         "MODULAR TOWER",
                         "COMMERCIAL TOWER",
                         "LEGACY",
                         "DELTA",
                         "FUSION"]
    
    var model : String
    var serialNumber : String
    
    init(model: String, serialNumber: String) {
        self.model = model
        self.serialNumber = serialNumber
    }
}
struct Owner {
    static var owners = [Owner]()
    
    var role : String
    var email : String
    var password : String
    var machines : [Machine]
    
    public var description: String { return "\nRole: \(role)\nEmail : \(email)\nPassword: \(password)\nMachines: \(machines)"}
    
    init(role: String, email: String, password: String, machines: [Machine]) {
        self.role = role
        self.email = email
        self.password = password
        self.machines = machines
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

struct ContentView : View {
    @State private var userName = ""
    @State private var password = ""
    @State private var loginBackgroundColor = Color.red
    @State private var loginBackgroundColorAngle = 0.0
    @State private var nextView = false
    @State private var loginAngle = 0.0
    @State private var wiggleDuration = 0.1
    @State private var wiggleAngle = 2.5
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Mathews Company")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .fontWeight(.black)
                Text("Monitoring and Remote Control\n")
                    .fontWidth(.expanded)
                    .foregroundStyle(.white)
                
                TextField("Enter user name (email address)", text: $userName)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .textInputAutocapitalization(.never)
                
                SecureField("Enter password", text: $password)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .textInputAutocapitalization(.never)
                
                Text("")
                Button(action: {
                    var found = false
                    for i in 0..<Owner.owners.count {
                        if userName == Owner.owners[i].email.lowercased() && password == Owner.owners[i].password {
                            found = true
                            nextView = true
                        }
                    }
                    if !found {
                        
                        withAnimation(.easeInOut(duration: wiggleDuration / 2)) {
                            loginAngle = wiggleAngle
                        }
                        withAnimation(.easeInOut(duration: wiggleDuration).delay(wiggleDuration / 2)) {
                            loginAngle = -wiggleAngle
                        }
                        withAnimation(.easeInOut(duration: wiggleDuration).delay(3 * wiggleDuration / 2)) {
                            loginAngle = wiggleAngle
                        }
                        withAnimation(.easeInOut(duration: wiggleDuration).delay(5 * wiggleDuration / 2)) {
                            loginAngle = -wiggleAngle
                        }
                        withAnimation(.easeInOut(duration: wiggleDuration).delay(7 * wiggleDuration / 2)) {
                            loginAngle = 0
                        }
                        
                    }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .background(.black, in: RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                        .foregroundStyle(LinearGradient(colors: [.blue, .red], startPoint: .leading, endPoint: .trailing))
                        .fontWidth(.expanded)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .font(.title)
                        .padding(.horizontal)
                        .rotationEffect(.degrees(Double(loginAngle)))
                }
                .disabled(userName.count == 0 || password.count == 0)
                .opacity(userName.count == 0 || password.count == 0 ? 0.5 : 1)
                .animation(.smooth, value: userName.count == 0 || password.count == 0)
            }
            .frame(width: UIWindow.current?.screen.bounds.width, height: UIWindow.current?.screen.bounds.height)
            .preferredColorScheme(.dark)
            .background(LinearGradient(colors: [loginBackgroundColor, loginBackgroundColor], startPoint: .top, endPoint: .bottom)
                .hueRotation(.degrees(Double(loginBackgroundColorAngle))))
            .ignoresSafeArea()
            .navigationDestination(isPresented: $nextView) {
                RemoteControlView()
            }
            .onAppear {
                
                var owners = [Owner]()
                var owners2 = [Owner]()
                
                for i in 1...100 {
                    let model = Machine.models[Int.random(in: 0...Machine.models.count - 1)]
                    let serialNumber = String(Int.random(in: 1000000000...9999999999))
                    
                    let machine = Machine(model: model, serialNumber: serialNumber)
                    
                    let email = "farmer\(i)@gmail.com"
                    let password = "farmer\(i)Password"
                    let machines = [machine]
                    
                    let farmer = Owner(role: "Farmer", email: email, password: password, machines: machines)
                    owners.append(farmer)
                    owners2.append(farmer)
                }
                
                for i in 1...20 {
                    let email = "distributor\(i)@gmail.com"
                    let password = "distributor\(i)Password"
                    var machines = [Machine]()
                    
                    for _ in 1...5 {
                        machines += owners.remove(at: 0).machines
                    }
                    
                    let distributor = Owner(role: "Distributor", email: email, password: password, machines: machines)
                    owners.append(distributor)
                    owners2.append(distributor)
                }
                
                for i in 1...4 {
                    let email = "regionalManager\(i)@gmail.com"
                    let password = "regionalManager\(i)Password"
                    var machines = [Machine]()
                    
                    for _ in 1...5 {
                        machines += owners.remove(at: 0).machines
                    }
                    
                    let regionalManager = Owner(role: "regionalManager", email: email, password: password, machines: machines)
                    owners.append(regionalManager)
                    owners2.append(regionalManager)
                }
                
                for i in 1...4 {
                    let email = "owner\(i)@gmail.com"
                    let password = "owner\(i)Password"
                    var machines = [Machine]()
                    
                    for j in 0...3 {
                        machines += owners[j].machines
                    }
                    
                    let owner = Owner(role: "Owner", email: email, password: password, machines: machines)
                    owners.append(owner)
                    owners2.append(owner)
                }
                
                Owner.owners = owners2
                
                withAnimation(.linear(duration: 60).repeatForever()) {
                    loginBackgroundColorAngle = 360
                }
            }
        }
    }
}

struct RemoteControlView: View {
    @State private var data:            [Data] = []
    @State private var data2:           [Data] = []
    @State private var data3:           [Data] = []
    @State private var combinedData:    [Data] = []
    
    @State private var chartDomain       = 25
    @State private var chartRange        = 10
    @State private var heightMultiplier  = 0.45
    @State private var developerMode     = false
    @State private var paused            = false
    @State private var buttonEngaged     = false
    @State private var buttonDowntime    = false
    @State private var downtimeStart     = -1
    @State private var downtimeWait      = 5
    @State private var lightMode         = false
    @State private var frequency         = 1
    @State private var index             = 0
    @State private var expanded          = false
    @State private var expanded2         = false
    @State private var expanded3         = false
    @State private var expanded4         = false
    @State private var expanded5         = false
    @State private var rotationAngle     = -30
    @State private var scalingEffect     = 0.7
    @State private var color1Pick        = Color.blue
    @State private var color2Pick        = Color.purple
    @State private var color1            = Color.blue
    @State private var color2            = Color.purple
    @State private var slider1           = 0.925
    @State private var slider2           = 0.925
    @State private var slider3           = 0.925
    @State private var inAnimation       = false
    //@State private var rotationAngle2    = 0
    //@State private var dynamicOn         = true
    @State private var timer             = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        return ZStack(alignment: .top) {
            ScrollView {
                Text("\n\n")
                VStack {
                    Button(action: {
                        withAnimation(.easeIn) {
                            expanded2 = !expanded2
                        }
                    })
                    {
                        Text("Controls")
                            .bold()
                            .frame(maxWidth: UIWindow.current?.screen.bounds.width, minHeight:  ((UIWindow.current?.screen.bounds.height)! * 0.05))
                            .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(.gray))
                            .foregroundStyle(lightMode ? .black : .white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    
                    VStack {
                        ScrollView {
                            Text("Ticks Elapsed: \(index)")
                                .onReceive(timer) {time in
                                    refreshData()
                                    index += 1
                                    
                                    if (index >= downtimeStart + downtimeWait) {
                                        withAnimation(.smooth) {
                                            buttonDowntime = false
                                        }
                                    }
                                }
                                .foregroundStyle(lightMode ? .black : .white)
                            Button(action: {
                                withAnimation(.smooth) {
                                    buttonEngaged = !buttonEngaged
                                    buttonDowntime = true
                                    downtimeStart = index
                                    slider1 = 0.925
                                    slider2 = 0.925
                                    slider3 = 0.925
                                }
                                
                                
                            }) {
                                Text(buttonEngaged ? "Shut Down" : "Turn On")
                                
                                    .frame(width: ((UIWindow.current?.screen.bounds.height)! * 0.2), height:  ((UIWindow.current?.screen.bounds.height)! * 0.2))
                                    .font(.title)
                                    .background(Circle().fill(buttonEngaged ? Color.green : Color.red))
                                    .foregroundStyle(lightMode ? .black : .white)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(buttonDowntime)
                            .animation(.smooth, value: buttonDowntime)
                            
                            Slider(value: $slider1, in: 0.25...1.6, step: 0.01) {
                                Text("First Slider")
                            }
                        minimumValueLabel: {
                            Text("0.25")
                        }
                        maximumValueLabel: {
                            Text("1.60")
                        }
                        .tint(.blue)
                        .foregroundStyle(lightMode ? .black : .white)
                        .allowsHitTesting(buttonEngaged)
                        .opacity(buttonEngaged ? 1 : 0.5)
                            
                            
                            Text("First Slider Value: \(slider1, specifier: "%.2f")")
                                .foregroundStyle(lightMode ? .black : .white)
                                .opacity(buttonEngaged ? 1 : 0.5)
                            
                            
                            Slider(value: $slider2, in: 0.25...1.6, step: 0.01) {
                                Text("Second Slider")
                            }
                        minimumValueLabel: {
                            Text("0.25")
                        }
                        maximumValueLabel: {
                            Text("1.60")
                        }
                        .tint(.green)
                        .foregroundStyle(lightMode ? .black : .white)
                        .allowsHitTesting(buttonEngaged)
                        .opacity(buttonEngaged ? 1 : 0.5)
                            
                            
                            Text("Second Slider Value: \(slider2, specifier: "%.2f")")
                                .foregroundStyle(lightMode ? .black : .white)
                                .opacity(buttonEngaged ? 1 : 0.5)
                            
                            
                            Slider(value: $slider3, in: 0.25...1.6, step: 0.01) {
                                Text("Third Slider")
                            }
                        minimumValueLabel: {
                            Text("0.25")
                        }
                        maximumValueLabel: {
                            Text("1.60")
                        }
                        .tint(.red)
                        .foregroundStyle(lightMode ? .black : .white)
                        .allowsHitTesting(buttonEngaged)
                        .opacity(buttonEngaged ? 1 : 0.5)
                            
                            Text("Third Slider Value: \(slider3, specifier: "%.2f")")
                                .foregroundStyle(lightMode ? .black : .white)
                                .opacity(buttonEngaged ? 1 : 0.5)
                            
                            
                            
                            
                            
                            
                            
                        }
                        .padding()
                        .scrollIndicators(.hidden)
                    }
                    .frame(maxWidth: UIWindow.current?.screen.bounds.width, maxHeight: expanded2 ? ((UIWindow.current?.screen.bounds.height)! * 0.5) : 0)
                    .clipShape(Rectangle())
                }
                .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(lightMode ? .white : .black))
                .padding(.horizontal)
                
                VStack{
                    Button(action: {
                        withAnimation(.easeIn) {
                            expanded = !expanded
                        }
                    })
                    {
                        Text("Charts")
                            .bold()
                            .frame(maxWidth: UIWindow.current?.screen.bounds.width, minHeight:  ((UIWindow.current?.screen.bounds.height)! * 0.05))
                            .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(.gray))
                            .foregroundStyle(lightMode ? .black : .white)
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    
                    
                    VStack {
                        ScrollView {
                            VStack {
                                Text("\nFirst Data")
                                    .foregroundStyle(lightMode ? .black : .white)
                                Chart(data) {
                                    LineMark(
                                        x: .value("Minutes", $0.minutes),
                                        y: .value("Output", $0.output)
                                    )
                                }
                                
                                .chartXScale(domain: 1...chartDomain - 1)
                                .chartYScale(domain: 0...chartRange)
                                .chartXAxis {
                                    AxisMarks(values: .automatic) {
                                        AxisValueLabel()
                                            .foregroundStyle(.gray)
                                        AxisGridLine()
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .foregroundStyle(.blue)
                                .chartYAxis {
                                    AxisMarks(values: .automatic) {
                                        AxisValueLabel()
                                            .foregroundStyle(.gray)
                                        AxisGridLine()
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .frame(minHeight: (UIWindow.current?.screen.bounds.height)! * heightMultiplier)
                            }
                            .containerRelativeFrame(.vertical)
                            .scrollTransition(axis: .vertical) {
                                content, phase in
                                content.rotation3DEffect(Angle(degrees: phase.value * Double(rotationAngle)), axis: (x : 1, y : 0, z : 0))
                                    .scaleEffect(CGSize(width: phase.isIdentity ? 1 : scalingEffect, height: phase.isIdentity ? 1 : scalingEffect))
                            }
                            
                            
                            VStack {
                                Text("\nSecond Data")
                                    .foregroundStyle(lightMode ? .black : .white)
                                Chart(data2) {
                                    LineMark(
                                        x: .value("Minutes", $0.minutes),
                                        y: .value("Output", $0.output)
                                    )
                                }
                                .chartXScale(domain: 1...chartDomain - 1)
                                .chartYScale(domain: 0...chartRange)
                                .chartXAxis {
                                    AxisMarks(values: .automatic) {
                                        AxisValueLabel()
                                            .foregroundStyle(.gray)
                                        AxisGridLine()
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(values: .automatic) {
                                        AxisValueLabel()
                                            .foregroundStyle(.gray)
                                        AxisGridLine()
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .foregroundStyle(Color(.green))
                                .frame(minHeight: (UIWindow.current?.screen.bounds.height)! * heightMultiplier)
                            }
                            .containerRelativeFrame(.vertical)
                            .scrollTransition(axis: .vertical) {
                                content, phase in
                                content.rotation3DEffect(Angle(degrees: phase.value * Double(rotationAngle)), axis: (x : 1, y : 0, z : 0))
                                    .scaleEffect(CGSize(width: phase.isIdentity ? 1 : scalingEffect, height: phase.isIdentity ? 1 : scalingEffect))
                            }
                            
                            VStack {
                                Text("\nThird Data")
                                    .foregroundStyle(lightMode ? .black : .white)
                                Chart(data3) {
                                    LineMark(
                                        x: .value("Minutes", $0.minutes),
                                        y: .value("Output", $0.output)
                                    )
                                }
                                .chartXScale(domain: 1...chartDomain - 1)
                                .chartYScale(domain: 0...chartRange)
                                .chartXAxis {
                                    AxisMarks(values: .automatic) {
                                        AxisValueLabel()
                                            .foregroundStyle(.gray)
                                        AxisGridLine()
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(values: .automatic) {
                                        AxisValueLabel()
                                            .foregroundStyle(.gray)
                                        AxisGridLine()
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .foregroundStyle(Color(.red))
                                .frame(minHeight: (UIWindow.current?.screen.bounds.height)! * heightMultiplier)
                            }
                            .containerRelativeFrame(.vertical)
                            .scrollTransition(axis: .vertical) {
                                content, phase in
                                content.rotation3DEffect(Angle(degrees: phase.value * Double(rotationAngle)), axis: (x : 1, y : 0, z : 0))
                                    .scaleEffect(CGSize(width: phase.isIdentity ? 1 : scalingEffect, height: phase.isIdentity ? 1 : scalingEffect))
                            }
                            
                            VStack {
                                Text("\nCombined Data")
                                    .foregroundStyle(lightMode ? .black : .white)
                                Chart(combinedData) {
                                    LineMark(
                                        x: .value("Minutes", $0.minutes),
                                        y: .value("Output", $0.output),
                                        series: .value("Data Name", $0.name)
                                    )
                                    .foregroundStyle(by: .value("Data Name", $0.name))
                                }
                                .chartXScale(domain: 1...chartDomain - 1)
                                .chartYScale(domain: 0...chartRange)
                                .chartXAxis {
                                    AxisMarks(values: .automatic) {
                                        AxisValueLabel()
                                            .foregroundStyle(.gray)
                                        AxisGridLine()
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(values: .automatic) {
                                        AxisValueLabel()
                                            .foregroundStyle(.gray)
                                        AxisGridLine()
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .chartForegroundStyleScale(["First Data": .blue, "Second Data": .green, "Third Data": .red])
                                .chartLegend(position: .bottom) {
                                    HStack {
                                        HStack {
                                            BasicChartSymbolShape.circle
                                                .foregroundColor(.blue)
                                                .frame(width: 8, height: 8)
                                            Text("First Data")
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                            BasicChartSymbolShape.circle
                                                .foregroundColor(.green)
                                                .frame(width: 8, height: 8)
                                            Text("Second Data")
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                            BasicChartSymbolShape.circle
                                                .foregroundColor(.red)
                                                .frame(width: 8, height: 8)
                                            Text("Third Data")
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                        }
                                    }
                                }
                                .frame(minHeight: (UIWindow.current?.screen.bounds.height)! * heightMultiplier)
                            }
                            .scrollTransition(axis: .vertical) {
                                content, phase in
                                content.rotation3DEffect(Angle(degrees: phase.value * Double(rotationAngle)), axis: (x : 1, y : 0, z : 0))
                                    .scaleEffect(CGSize(width: phase.isIdentity ? 1 : scalingEffect, height: phase.isIdentity ? 1 : scalingEffect))
                            }
                            
                        }
                        .padding()
                        .scrollIndicators(.hidden)
                    }
                    .frame(maxWidth: UIWindow.current?.screen.bounds.width, maxHeight: expanded ? ((UIWindow.current?.screen.bounds.height)! * 0.5) : 0)
                    .clipShape(Rectangle())
                    .animation(.smooth, value: index)
                }
                .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(lightMode ? .white : .black))
                .padding(.horizontal)
                
                VStack {
                    Button(action: {
                        withAnimation(.easeIn) {
                            expanded3 = !expanded3
                        }
                    })
                    {
                        Text("Additional Information")
                            .foregroundStyle(lightMode ? .black : .white)
                            .bold()
                            .frame(maxWidth: UIWindow.current?.screen.bounds.width, minHeight: ((UIWindow.current?.screen.bounds.height)! * 0.05))
                            .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(.gray))
                    }
                    .buttonStyle(PlainButtonStyle())
                    //.disabled(inAnimation)
                    
                    
                    
                    VStack {
                        ScrollView {
                            Text("Part Number: 123456789")
                                .foregroundStyle(lightMode ? .black : .white)
                            Text("Product Name: Fusion Series")
                                .foregroundStyle(lightMode ? .black : .white)
                            Text("")
                            Link("\nMathews Company Phone Number\n(815) 459-2210", destination: URL(string: "tel:8154592210")!)
                            Link("\nMathews Company Website\n(Click Here For More Info)", destination: URL(string: "https://www.mathewscompany.com/contact-us.html")!)
                            
                        }
                        .padding()
                        .scrollIndicators(.hidden)
                    }
                    .frame(maxWidth: UIWindow.current?.screen.bounds.width, maxHeight: expanded3 ? ((UIWindow.current?.screen.bounds.height)! * 0.325) : 0)
                    .clipShape(Rectangle())
                }
                .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(lightMode ? .white : .black))
                .padding(.horizontal)
                
                VStack {
                    Button(action: {
                        withAnimation(.easeIn) {
                            expanded4 = !expanded4
                        }
                    })
                    {
                        Text("Settings")
                            .bold()
                            .frame(maxWidth: UIWindow.current?.screen.bounds.width, minHeight: ((UIWindow.current?.screen.bounds.height)! * 0.05))
                            .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(.gray))
                            .foregroundStyle(lightMode ? .black : .white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    //.disabled(inAnimation)
                    
                    
                    
                    VStack {
                        ScrollView {
                            Button(lightMode ? "Toggle Dark Mode" : "Toggle Light Mode", action: {
                                withAnimation(.easeOut) {
                                    inAnimation = true
                                    lightMode.toggle()} completion: {
                                        inAnimation = false
                                    }
                            })
                            Button("Toggle Developer Mode", action: {developerMode = !developerMode
                                startTimer()})
                            HStack{
                                Button("Pause", action: {stopTimer()})
                                    .opacity(developerMode ? 1 : 0)
                                Button("Resume", action: {startTimer()})
                                    .opacity(developerMode ? 1 : 0)
                                Button("Reset", action: {reset()
                                    downtimeStart = 0})
                                .opacity(developerMode ? 1 : 0)
                            }
                            
                            ColorPicker("Choose Top Color", selection: $color1, supportsOpacity: false)
                                .foregroundStyle(lightMode ? .black : .white)
                            
                            ColorPicker("Choose Bottom Color", selection: $color2, supportsOpacity: false)
                                .foregroundStyle(lightMode ? .black : .white)
                            
                            //Toggle("Dynamic Background", isOn: $dynamicOn)
                        }
                        .padding()
                        .scrollIndicators(.hidden)
                    }
                    .frame(maxWidth: UIWindow.current?.screen.bounds.width, maxHeight: expanded4 ? ((UIWindow.current?.screen.bounds.height)! * 0.25) : 0)
                    .clipShape(Rectangle())
                }
                .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(lightMode ? .white : .black))
                .padding(.horizontal)
                
                VStack {
                    Button(action: {
                        withAnimation(.easeIn) {
                            expanded5 = !expanded5
                        }
                    })
                    {
                        Text("Back to Login")
                            .bold()
                            .frame(maxWidth: UIWindow.current?.screen.bounds.width, minHeight: ((UIWindow.current?.screen.bounds.height)! * 0.05))
                            .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(.gray))
                            .foregroundStyle(lightMode ? .black : .white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    //.disabled(inAnimation)
                    
                    
                    
                    VStack {
                        ScrollView {
                            Button("Are You Sure?", action: {dismiss()})
                        }
                        .padding()
                        .scrollIndicators(.hidden)
                    }
                    .frame(maxWidth: UIWindow.current?.screen.bounds.width, maxHeight: expanded5 ? ((UIWindow.current?.screen.bounds.height)! * 0.075) : 0.01)
                    .clipShape(Rectangle())
                }
                .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(lightMode ? .white : .black))
                .padding(.horizontal)
                
                Text("\n")
            }
            .scrollIndicators(.hidden)
            
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .circular)
                .background(.ultraThinMaterial)
                .frame(width: UIWindow.current?.screen.bounds.width, height: 60)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .circular))
                .ignoresSafeArea()
        }
        .frame(width: UIWindow.current?.screen.bounds.width, height: UIWindow.current?.screen.bounds.height)
        .padding()
        .preferredColorScheme(.dark)
        .background(LinearGradient(colors: [color2, color1], startPoint: .top, endPoint: .bottom)
            .animation(.smooth, value : color1)
            .animation(.smooth, value : color2))
        //            .frame(width: ((UIWindow.current?.screen.bounds.height)!) * 1.25, height: ((UIWindow.current?.screen.bounds.height)!) * 1.25)
        //            .rotationEffect(.degrees(Double(rotationAngle2)))
        
        //        .onAppear {
        //            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
        //                rotationAngle2 = 360
        //            }
        //        }
        
        .navigationBarBackButtonHidden()
        .allowsHitTesting(!inAnimation)
        
        
        
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
        data.append(Data(name: "First Data", minutes: 0, output: Double.random(in:Double(chartRange/2 - 1)...Double(chartRange/2 + 1)) * slider1))
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
        
        data.append(Data(name: "First Data", minutes: data.count, output: Double.random(in:rangeBottom..<rangeTop) * slider1))
        if data.count >= chartDomain {
            data.remove(at: 0)
            for i in 0..<data.count {
                data[i].minutes -= 1
            }
        }
        
        data2.append(Data(name: "Second Data", minutes: data2.count, output: Double.random(in:rangeBottom..<rangeTop) * slider2))
        if data2.count >= chartDomain {
            data2.remove(at: 0)
            for i in 0..<data2.count {
                data2[i].minutes -= 1
            }
        }
        
        data3.append(Data(name: "Third Data", minutes: data3.count, output: Double.random(in:rangeBottom..<rangeTop) * slider3))
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
