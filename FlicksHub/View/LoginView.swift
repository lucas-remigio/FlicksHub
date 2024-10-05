//
//  Login.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            // App Title
            Text("FlicksApp")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 40)
            
            Spacer()
            
            
            
            
            VStack {
                
                
                // Username Field
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.white)
                    TextField("Username", text: $viewModel.username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.white)
                        .accentColor(.white)
                }
                .padding()
                .background(Color("MidnightGrayColor").opacity(0.5))
                .cornerRadius(30)
                .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 1)
                    )
                .padding(.horizontal, 30)
                .foregroundColor(.white)
                
                // Password Field
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.white)
                    SecureField("Password", text: $viewModel.password)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color("MidnightGrayColor").opacity(0.5))
                .cornerRadius(30)
                .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 1)
                    )
                .padding(.horizontal, 30)
                .padding(.top, 15)
                
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                // Login Button
                Button(action: {
                    // Handle login action here
                    viewModel.login()
                }) {
                    Text("Login")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .cornerRadius(30)
                        .padding(.horizontal, 100)
                }
                .padding(.top, 100)
                
                
                // Register Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                    Button(action: {
                        // Handle register logic here
                    }) {
                        Text("Register here")
                            .foregroundColor(.blue)
                            .underline()
                    }
                }
                .padding(.top, 20)
                
            }
            .padding(.bottom, 100)
        }
        .background(
            ZStack {
                Image("movie-background") // Use the appropriate background image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Add the fading effect using a gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color("MidnightColor").opacity(1.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea() // Ensures the gradient follows the safe area
            }
        )
        .alert(isPresented: $viewModel.isAuthenticated) {
            Alert(title: Text("Success"), message: Text("Login Successful!"), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

