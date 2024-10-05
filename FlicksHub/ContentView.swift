//
//  ContentView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 01/10/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if loginViewModel.isAuthenticated {
                    MainView()
                        .transition(.move(edge: .trailing))  // Add the transition
                } else {
                    LoginView(viewModel: loginViewModel)
                        .transition(.move(edge: .leading))  // Add the transition
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
