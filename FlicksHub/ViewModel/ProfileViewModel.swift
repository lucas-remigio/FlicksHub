//
//  ProfileViewModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 14/10/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var email: String?
    @Published var displayName: String?
    @Published var profilePictureURL: URL?


    private let authService = AuthenticationService()
    
    init() {
        fetchProfileInfo()
    }
    
    func fetchProfileInfo() {
        authService.getUserProfile { [weak self] user in
            DispatchQueue.main.async {
                guard let self = self, let user = user else {
                    print("No user information available.")
                    return
                }
                self.email = user.email
                self.displayName = user.displayName
                self.profilePictureURL = user.photoURL
                print(self.email != nil ?? "No email")
                print(self.displayName != nil ?? "No display name")
                print(self.profilePictureURL ?? "No profile picture")
            }
        }
    }
}
