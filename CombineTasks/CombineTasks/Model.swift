//
//  Model.swift
//  CombineTasks
//
//  Created by Игорь Девин on 28.05.2024.
//

import Foundation

 struct RickMortyEpisode: Decodable {
     let results: [Episode]
 }

 struct Episode: Decodable {
     let id: Int
     let name: String
     let airDate: String
     let episode: String
     let characters: [String]
     let url: String
     let created: String

     enum CodingKeys: String, CodingKey {
         case id, name
         case airDate = "air_date"
         case episode, characters, url, created
     }
 }

 struct RickMortyCharacters: Decodable {
     let results: [Characters]
 }

 struct Characters: Decodable {
     let id: Int
     let name: String
     let image: String
     let episode: [String]
 }

