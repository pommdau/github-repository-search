//
//  ContentView.swift
//  UserDefaultsDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/19.
//
//  [【Swift】UserDefaultsをもう少しちゃんと理解する #iOS - Qiita](https://qiita.com/tanaka-tt/items/ab6c5bc2983a32b11fe3)
//

import SwiftUI

struct ContentView: View {
    
    let userDefaultsDebugSuitName = "com.ikeh.debug"
    let userDefaultsStandard: UserDefaults
    let userDefaultsDebug: UserDefaults
    
    @State private var name = "(nil)"
    
    init() {
        self.userDefaultsStandard = UserDefaults.standard
        self.userDefaultsDebug = UserDefaults(suiteName: userDefaultsDebugSuitName)!
    }
    
    var body: some View {
        Form {
            Section("Result") {
                LabeledContent("Name", value: name)
            }
            
            Section("Standard") {
                Button("Load from standard") {
                    name = userDefaultsStandard.string(forKey: "name") ?? "(nil)"
                }
                
                Button("Write to standard") {
                    userDefaultsStandard.set("standard-\(UUID().uuidString.prefix(5))", forKey: "name")
                }
                
                Button("Print plist path") {
                    if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
                        let userDefaultsPath = url.appendingPathComponent("Preferences/\(Bundle.main.bundleIdentifier!).plist")
                        print(userDefaultsPath)
                    }
                }
                
                Button("Delete") {
                    guard let identifier = Bundle.main.bundleIdentifier else {
                        fatalError()
                    }
                    print("identifier: \(identifier)")
                    UserDefaults().removePersistentDomain(forName: identifier)
//                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                }
            }
            
            Section("Debug") {
                
                Button("Load from debug") {
                    name = userDefaultsDebug.string(forKey: "name") ?? "(nil)"
                }
                
                Button("Write to debug") {
                    userDefaultsDebug.set("debug-\(UUID().uuidString.prefix(5))", forKey: "name")
                }
                
                Button("Print plist path") {
                    if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
                        let userDefaultsPath = url.appendingPathComponent("Preferences/debug.plist")
                        print(userDefaultsPath)
                    }
                }
                
                Button("Delete by suite") {
//                    UserDefaults().removeSuite(named: userDefaultsDebugSuitName)
//                    userDefaultsDebug.removeSuite(named: userDefaultsDebugSuitName)
                    userDefaultsDebug.removeSuite(named: userDefaultsDebugSuitName)
                }
                
                Button("Delete by domain") {
                    UserDefaults().removePersistentDomain(forName: userDefaultsDebugSuitName)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
