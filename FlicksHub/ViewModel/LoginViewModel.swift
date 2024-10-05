//
//  LoginViewModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//

import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    
    private var authService = AuthenticationService()

    func login() {
        authService.login(username: username, password: password) { [weak self] success in
            if success {
                self?.isAuthenticated = true
            } else {
                self?.errorMessage = "Invalid credentials. Please try again."
            }
        }
    }
}

