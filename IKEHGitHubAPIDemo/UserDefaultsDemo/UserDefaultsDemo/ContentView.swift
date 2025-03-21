//
//  ContentView.swift
//  UserDefaultsDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/19.
//
//  [【Swift】UserDefaultsをもう少しちゃんと理解する #iOS - Qiita](https://qiita.com/tanaka-tt/items/ab6c5bc2983a32b11fe3)
//  [removePersistentDomain(forName:) | Apple Developer Documentation](https://developer.apple.com/documentation/foundation/userdefaults/1417339-removepersistentdomain)
//  [UserDefaultsを含むclassをテストするtips #Swift - Qiita](https://qiita.com/ARATAYOKOYAMA/items/e92c39bf20bd5aea5be6)
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
    
    @State private var name = "(nil)"
    
    private let userDefaultsSecondarySuitName = "com.ikeh.secondary"
    private let userDefaultsStandard: UserDefaults
    private let userDefaultsSecondary: UserDefaults
    
    init() {
        self.userDefaultsStandard = UserDefaults.standard
        self.userDefaultsSecondary = UserDefaults(suiteName: userDefaultsSecondarySuitName)!
    }
    
    var body: some View {
        Form {
            Section("Result") {
                LabeledContent("Name", value: name)
            }
            
            Section("Standard") {
                Button("Load") {
                    name = userDefaultsStandard.string(forKey: "name") ?? "(nil)"
                }
                
                Button("Write") {
                    userDefaultsStandard.set("standard-\(UUID().uuidString.prefix(5))", forKey: "name")
                }
                
                Button("Print plist path") {
                    guard let bundleIdentifier = Bundle.main.bundleIdentifier,
                          let url = UserDefaults.plistURL(suitName: bundleIdentifier) else  {
                        fatalError()
                    }
                    print(url.path)
                }
                
                Button("Delete", role: .destructive) {
                    guard let identifier = Bundle.main.bundleIdentifier else {
                        fatalError()
                    }
                    print("identifier: \(identifier)")
                    UserDefaults().removePersistentDomain(forName: identifier)
//                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                }
            }
            
            Section("Debug") {
                
                Button("Load") {
                    name = userDefaultsSecondary.string(forKey: "name") ?? "(nil)"
                }
                
                Button("Write") {
                    userDefaultsSecondary.set("debug-\(UUID().uuidString.prefix(5))", forKey: "name")
                }
                
                Button("Print plist path") {
                    guard let url = UserDefaults.plistURL(suitName: userDefaultsSecondarySuitName) else  {
                        fatalError()
                    }
                    print(url.path)
                }

                Button("Delete", role: .destructive) {
                    /*
                     https://developer.apple.com/documentation/foundation/userdefaults/1417339-removepersistentdomain
                     removeObject(forKey:)を回すのと同等の処理
                     */
                    UserDefaults().removePersistentDomain(forName: userDefaultsSecondarySuitName)
                    
                    if let url = UserDefaults.plistURL(suitName: userDefaultsSecondarySuitName),
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
