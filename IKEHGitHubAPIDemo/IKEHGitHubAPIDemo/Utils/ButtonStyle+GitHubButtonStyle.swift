//
//  AuthorizationButtonStyle.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct GitHubButtonStyle: ButtonStyle {
    
    enum ButtonType {
        case logIn
        case logOut
        
        var backgroundColor: Color {
            switch self {
            case .logIn:
                Color(red: 46 / 255, green: 164 / 255, blue: 79 / 255)
            case .logOut:
                Color(uiColor: .systemRed)
            }
        }
    }
    
    let buttonType: ButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .fontWeight(.semibold)
            .frame(width: 240, height: 40)
            .foregroundStyle(.white)
            .background(
                buttonType.backgroundColor
            )
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .cornerRadius(8)
    }
}

extension View {
    func gitHubButtonStyle(_ buttonType: GitHubButtonStyle.ButtonType) -> some View {
        self.buttonStyle(GitHubButtonStyle(buttonType: buttonType))
    }
}

#Preview {    
    VStack {
        Button("Log in") {}
            .gitHubButtonStyle(.logIn)
        Button("Log out") {}
            .gitHubButtonStyle(.logOut)
    }
}
