//
//  ContentView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/01.
//

import SwiftUI
import IKEHGitHubAPI

struct ContentView: View {
    var body: some View {
        Text(Omikuji().text)
            .padding()
    }
}

#Preview {
    ContentView()
}
