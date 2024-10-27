//
//  FavoritesView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 10/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with back button and edit icon
            HStack {
                Text("Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    viewModel.isEditing = true  // Present the edit view
                }) {
                    Image(systemName: "pencil")
                        .font(.title)
                        .padding()
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            
            // Show loading icon when updating profile
            if viewModel.isLoadingUpdatedProfile {
                ProgressView("Updating profile...")
                    .padding()
                    .background(
                        Color("AccentColor").opacity(0.5).ignoresSafeArea()
                    )
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .foregroundColor(.white)
            }

            // Profile Picture
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

            // Username Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .foregroundColor(.gray)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "person.fill")
                    Text(viewModel.displayName ?? "No username")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
            
            Button(action: { viewModel.logout() }) {
                Text("Logout")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)  // Makes the button stretch horizontally
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(20)
                    .shadow(color: .red.opacity(0.4), radius: 10, x: 0, y: 5)  // Adds a subtle shadow
            }
            .padding(.horizontal, 100)  // Adds padding on both sides
            .padding(.top, 20)
            .padding(.bottom, 50)
        }
        .background(Color("MidnightColor").ignoresSafeArea())
        .sheet(isPresented: $viewModel.isEditing) {
            ProfileEditView(viewModel: viewModel)  // Pass viewModel for editing
        }
    }
}


#Preview {
    ProfileView()
}
