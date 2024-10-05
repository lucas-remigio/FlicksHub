//
//  Login.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""

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
                        .foregroundColor(.gray)
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(.systemGray5).opacity(0.5))
                .cornerRadius(10)
                .padding(.horizontal, 30)
                .foregroundColor(.white)
                
                // Password Field
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(.systemGray5).opacity(0.5))
                .cornerRadius(10)
                .padding(.horizontal, 30)
                .padding(.top, 15)
                
                // Login Button
                Button(action: {
                    // Handle login action here
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .cornerRadius(20)
                        .padding(.horizontal, 100)
                }
                .padding(.top, 20)
                
                // Register Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                    Button(action: {
                        // Handle registration navigation
                    }) {
                        Text("Register here")
                            .foregroundColor(.blue)
                            .underline()
                    }
                }
                .padding(.top, 10)
                
            }
            .padding(.bottom, 100)
        }
        .background(
            Image("movie-background") // Use the appropriate background image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

