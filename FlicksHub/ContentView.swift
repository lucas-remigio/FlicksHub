//
//  ContentView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 01/10/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = false
    @State private var isRegistering: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isUserLoggedIn{
                    TabView {
                        MainView()
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }
                        
                        FavoritesView()  // Create this view for favorites
                            .tabItem {
                                Label("Favorites", systemImage: "star.fill")
                            }
                        
                        ProfileView()  // Create this view for profile
                            .tabItem {
                                Label("Profile", systemImage: "person.fill")
                            }
                    }
                    .transition(.move(edge: .trailing))   // Add the transition
                } else {
                    // Switch between LoginView and RegisterView
                    if isRegistering {
                        RegisterView(isRegistering: $isRegistering)
                            .transition(.move(edge: .leading))
                    } else {
                        LoginView(isRegistering: $isRegistering)
                            .transition(.move(edge: .leading))
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
