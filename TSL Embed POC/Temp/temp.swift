//
//  temp.swift
//  TSL Embed POC
//
//  Created by Daman Mehta on 2023-08-25.
//
import WebKit
import SwiftUI

struct ContentView2: View {
    @State private var isToggled = false
    
    var body: some View {
        VStack {
            Text(isToggled ? "ON" : "OFF")
                .font(.largeTitle)
                .padding()
            
            Button("Toggle") {
                isToggled = !isToggled
            }
            .padding()
        }
    }
}


struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}

