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
    
    func pokemonDetail(id:Int) ->AnyPublisher<PokemonDetail,Error> {
        return provider.requestPublisher(.PokemonInfo(id: id))
            .map{$0.data}
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
