//
//  ContentView.swift
//  BetterRest
//
//  Created by Nusaiba Rahman on 8/23/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State var wakeUpTime = defaultWakeTime
    @State var sleepAmount = 0.0
    @State var coffeeAmount = 1.0
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var showAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    var body: some View {
        NavigationView {
        Form {
            VStack(alignment: .leading, spacing: 0) {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            
            VStack(alignment: .leading, spacing: 0) {
            
                Text("How much sleep would you like?")
                    .font(.headline)
                
                Stepper(sleepAmount == 1 ? "1 hour" : "\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 1...12, step: 0.25)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("How many cups of coffee do you drink?")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount.formatted()) cups", value: $coffeeAmount, in: 0...20, step: 0.5)
            }
        }
        .navigationTitle("BetterRest")
        .toolbar {
            Button("Calculate", action: calculateBedtime)
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Ok") { }
        } message: {
            Text(alertMessage)
            
        }

        }
    }

    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let predicition = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUpTime - predicition.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }
        catch {
            alertTitle = "Error"
            alertMessage = "Sorry. There was a problem calculating your bedtime."
        }
        showAlert = true
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
