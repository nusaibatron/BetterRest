//
//  ContentView.swift
//  BetterRest
//
//  Created by Nusaiba Rahman on 8/23/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var sleepAmount = 0
    @State var wakeUpTime = Date.now
    
    var body: some View {
        
        
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 1)
        
        DatePicker("Select when to wake up", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
        
        

        Text("Hello, world!")
            .padding()
    }
    
    func trivialElement() {
        var components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
        
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
