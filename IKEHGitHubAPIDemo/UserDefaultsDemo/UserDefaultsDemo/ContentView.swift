//
//  ContentView.swift
//  UserDefaultsDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/19.
//
//  [【Swift】UserDefaultsをもう少しちゃんと理解する #iOS - Qiita](https://qiita.com/tanaka-tt/items/ab6c5bc2983a32b11fe3)
//  [removePersistentDomain(forName:) | Apple Developer Documentation](https://developer.apple.com/documentation/foundation/userdefaults/1417339-removepersistentdomain)

import SwiftUI

extension UserDefaults {
    static func plistURL(suitName: String) -> URL? {
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            return nil
        }
        return libraryURL
            .appendingPathComponent("Preferences")
            .appendingPathComponent("\(suitName).plist")
    }
}

struct ContentView: View {
    
    let userDefaultsDebugSuitName = "com.ikeh.secondary"
    let userDefaultsStandard: UserDefaults
    let userDefaultsSecondary: UserDefaults
    
    @State private var name = "(nil)"
    
    init() {
        self.userDefaultsStandard = UserDefaults.standard
        self.userDefaultsSecondary = UserDefaults(suiteName: userDefaultsDebugSuitName)!
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
                    name = userDefaultsSecondary.string(forKey: "name") ?? "(nil)"
                }
                
                Button("Write to debug") {
                    userDefaultsSecondary.set("debug-\(UUID().uuidString.prefix(5))", forKey: "name")
                }
                
                Button("Print plist path") {
                    if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
                        let userDefaultsPath = url.appendingPathComponent("Preferences/debug.plist")
                        print(userDefaultsPath)
                    }
                }

                Button("Delete by domain") {
                    /*
                     https://developer.apple.com/documentation/foundation/userdefaults/1417339-removepersistentdomain
                     removeObject(forKey:)を回すのと同等の処理
                     */
                    UserDefaults().removePersistentDomain(forName: userDefaultsDebugSuitName)
                    
                    if let url = UserDefaults.plistURL(suitName: userDefaultsDebugSuitName),
                       FileManager.default.fileExists(atPath: url.path()) {
                        do {
                            try FileManager.default.removeItem(at: url)
                        } catch {
                            fatalError()
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
