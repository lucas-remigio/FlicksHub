//
//  MovieProtocol.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 03/11/2024.
//

protocol MovieProtocol {
    var title: String { get }
    var overview: String { get }
    var posterPath: String? { get }
}

extension Movie: MovieProtocol {}
extension MovieDetail: MovieProtocol {}
