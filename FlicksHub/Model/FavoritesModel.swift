//
//  FavoritesModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 27/10/2024.
//

import Foundation
import FirebaseFirestore

struct Playlist: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var name: String
    var movies: [Int]
}
