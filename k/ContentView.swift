//
//  ContentView.swift
//  k
//
//  Created by Zachary Gorak on 10/12/22.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("k.")
                    .font(.largeTitle)
                Spacer()
                Link("Add or change keyboards", destination: URL(string: "https://support.apple.com/guide/iphone/add-or-change-keyboards-iph73b71eb/ios")!)
                    .font(.footnote)
                HStack {
                    TextField("Test Your Keyboard", text: $text)
                        .textFieldStyle(.roundedBorder)
                    NavigationLink(destination: SettingsView(), label: {
                        Image(systemName: "gear")
                    })
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
