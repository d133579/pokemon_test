//
//  PokemonAPIs.swift
//  pokemon
//
//  Created by 文 on 2024/3/30.
//

import Foundation
import Moya
import Combine
import CombineMoya

final class PokemonAPIs {
    let provider = MoyaProvider<PokemanService>()
    
    func pokemonList(limit:Int = 20, offset:Int) -> AnyPublisher<Pokemons,Error> {
        return provider.requestPublisher(.PokemonList(limit: limit, offset: offset))
            .map{$0.data}
            .decode(type: Pokemons.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
