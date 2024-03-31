//
//  Pokemon.swift
//  pokemon
//
//  Created by 文 on 2024/3/30.
//

import Foundation

struct Pokemons:Codable {
    var count:Int = 0
    var next:String?
    var previous:String?
    var pokemons:[PokemonOutline]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case pokemons = "results"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(next, forKey: .next)
        try container.encode(previous, forKey: .previous)
        try container.encode(pokemons, forKey: .pokemons)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.previous = try container.decodeIfPresent(String.self, forKey: .previous)
        self.pokemons = try container.decodeIfPresent([PokemonOutline].self, forKey: .pokemons)
    }
}

struct PokemonOutline:Codable,Equatable {
    var id:Int {
        get {
            let components = url.components(separatedBy: "/")
            if (components.count >= 2) {
                return Int(components[components.count - 2])!
            }
            return -1
        }
    }
    var url:String
    var name:String
    
    enum CodingKeys: CodingKey {
        case url
        case name
    }
}
