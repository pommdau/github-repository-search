//
//  AuthorizationButtonStyle.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct LogInButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .fontWeight(.semibold)
            .frame(width: 240, height: 40)
            .foregroundStyle(.white)
            .background(
                Color.init(red: 46/255, green: 164/255, blue: 79/255)
            )
            .cornerRadius(8)
    }
}

struct LogOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .fontWeight(.semibold)
            .frame(width: 240, height: 40)
            .foregroundStyle(.white)
            .background(Color(uiColor: .systemRed))
            .cornerRadius(8)
    }
}

#Preview {    
    VStack {
        Button("Log in") {}
            .buttonStyle(LogInButtonStyle())
        Button("Log out") {}
            .buttonStyle(LogOutButtonStyle())
    }
}
