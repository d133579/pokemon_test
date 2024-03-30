//
//  PokemonDetail.swift
//  pokemon
//
//  Created by 文 on 2024/3/30.
//

import Foundation


struct PokemonDetail: Codable {
    var id: Int
    var name: String
    var types: [PokemonType]
    var sprites: Sprites
    var species: Species
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
        case types
        case species
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(sprites, forKey: .sprites)
        try container.encode(types, forKey: .types)
        try container.encode(species, forKey: .species)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.sprites = try container.decode(Sprites.self, forKey: .sprites)
        self.types = try container.decode([PokemonType].self, forKey: .types)
        self.species = try container.decode(Species.self, forKey: .species)
    }
}

struct PokemonType:Codable {
    var slot:Int
    var name:String
    
    enum CodingKeys: CodingKey {
        case slot
        case type
        enum NestedCodingKeys:CodingKey {
            case name
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(slot, forKey: .slot)
        var typeContainer = container.nestedContainer(keyedBy: CodingKeys.NestedCodingKeys.self, forKey: .type)
        try typeContainer.encode(name, forKey: .name)
    }
    
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.slot = try container.decode(Int.self, forKey: .slot)
        let typeContainer = try container.nestedContainer(keyedBy: CodingKeys.NestedCodingKeys.self, forKey: .type)
        self.name = try typeContainer.decode(String.self, forKey: .name)
    }
}

struct Sprites:Codable {
    var frontImageURL:String
    
    enum CodingKeys: String, CodingKey {
        case frontImageURL = "front_default"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(frontImageURL, forKey: .frontImageURL)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.frontImageURL = try container.decode(String.self, forKey: .frontImageURL)
    }
}

struct Species:Codable {
    var name:String
    var evolutionChain:EvolutionChain?
    
    enum CodingKeys:String, CodingKey {
        case name
        case evolutionChain = "evolution_chain"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.evolutionChain, forKey: .evolutionChain)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.evolutionChain = try container.decodeIfPresent(EvolutionChain.self, forKey: .evolutionChain)
    }
}

struct EvolutionChain:Codable {
    var id:Int
    var chain:[ChainLink]?
}

struct ChainLink:Codable {
    var species:Species
}
