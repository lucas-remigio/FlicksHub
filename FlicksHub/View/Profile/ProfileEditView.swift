//
//  ProfileEditView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 14/10/2024.
//
import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @ObservedObject var viewModel: ProfileViewModel  // Pass the original viewModel for updates
    @State private var newDisplayName: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false  // Control the image picker presentation
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Profile")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            // Editable Profile Picture
            Button(action: {
                showImagePicker = true  // Show image picker when button tapped
            }) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                } else {
                    if let profilePictureURL = viewModel.profilePictureURL {
                        AsyncImage(url: profilePictureURL) { phase in
                            switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 250, height: 250)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 250, height: 250)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                        .shadow(radius: 10)
                                case .failure:
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 250, height: 250)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                        .shadow(radius: 10)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 250, height: 250)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                        .shadow(radius: 10)
                                        .foregroundColor(.gray)
                            }
                        }
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .foregroundColor(.gray)
                    }
                }
            }

            // Editable Username Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .foregroundColor(.gray)
                    .font(.headline)
                
                TextField("Enter new username", text: $newDisplayName)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)

            // Save Button
            Button(action: {
                viewModel.updateProfile(displayName: newDisplayName, profileImage: selectedImage)
            }) {
                Text("Save Changes")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color("MidnightColor").ignoresSafeArea())
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)  // Custom image picker implementation
        }
        .onAppear {
            newDisplayName = viewModel.displayName ?? ""  // Prepopulate the current username
        }
    }
}

#Preview {
    ProfileEditView(viewModel: ProfileViewModel())
}
