//
//  FlicksHubApp.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 01/10/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct FlicksHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
