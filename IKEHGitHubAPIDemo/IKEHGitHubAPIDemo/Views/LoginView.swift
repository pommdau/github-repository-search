//
//  LoginView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Image(.githubMark)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("Log in to GitHub")
                .font(.title)
                .padding(.bottom, 60)
                        
            Button {
                
            } label: {
                Text("Log in")
                    .padding()
                    .fontWeight(.semibold)
                    .frame(width: 240, height: 40)
                    .foregroundStyle(.white)
                    .background(
                        Color.init(red: 46/255, green: 164/255, blue: 79/255)
                    )
                    .cornerRadius(8)
            }
            .padding(.bottom, 8)
            
            Text("When you log in to GitHub, you can star repositories and browse a list of repositories you’ve starred.")
                .foregroundStyle(.secondary)
                .frame(width: 240)
        }
    }
}

#Preview {
    LoginView()
}
