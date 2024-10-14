//
//  ProfileViewModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 14/10/2024.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseStorage

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
    
    // Update profile with new display name and profile picture
    func updateProfile(displayName: String, profileImage: UIImage?) {
        guard let user = Auth.auth().currentUser else { return }
        
        // Update display name in Firebase
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        
        // Check if a new profile image is provided
        if let profileImage = profileImage {
            uploadProfileImage(profileImage) { [weak self] url in
                guard let self = self, let url = url else { return }
                
                // Update profile picture URL in Firebase
                changeRequest.photoURL = url
                
                // Commit changes (display name and photo URL)
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Failed to update profile: \(error.localizedDescription)")
                        return
                    }
                    
                    // Update local properties on success
                    DispatchQueue.main.async {
                        self.displayName = displayName
                        self.profilePictureURL = url
                    }
                }
            }
        } else {
            // If only display name is updated
            changeRequest.commitChanges { [weak self] error in
                if let error = error {
                    print("Failed to update profile: \(error.localizedDescription)")
                    return
                }
                
                // Update local display name on success
                DispatchQueue.main.async {
                    self?.displayName = displayName
                }
            }
        }
    }
    
    // Helper function to upload profile image to Firebase Storage
    private func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference().child(
            "profileImages/\(authService.getSavedUID() ?? UUID().uuidString).jpg"
        )
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Retrieve the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to get download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    }
}
