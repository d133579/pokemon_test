//
//  MockPokemonAPIs.swift
//  pokemonTests
//
//  Created by 文 on 2024/4/4.
//

import Foundation
import Combine

@testable import pokemon

class MockPokemonAPIs:PokemonAPIsDelegate {
    func pokemonList(limit: Int, offset: Int) -> AnyPublisher<pokemon.Pokemons, any Error> {
        let fakeJson = MockAPIData.pokemonList

        return Future<Pokemons,Error> { continuation in
            let data = Data(fakeJson.utf8)
            do {
                let response = try JSONDecoder().decode(Pokemons.self, from: data)
                continuation(.success(response))
            } catch {
                continuation(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func pokemonDetail(id: Int) -> AnyPublisher<pokemon.PokemonDetail, any Error> {
        let fakeJson = MockAPIData.pokemonDetail

        return Future<PokemonDetail,Error> { continuation in
            let data = Data(fakeJson.utf8)
            do {
                let response = try JSONDecoder().decode(PokemonDetail.self, from: data)
                continuation(.success(response))
            } catch {
                continuation(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
