//
//  PokemonListViewModel.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import Foundation
import Combine

enum PokemonListViewModelState {
    case loading
    case finishedLoading
    case fetchDetailSuccess(Int,PokemonDetail)
    case error(Error)
}

final class PokemonListViewModel {
    @Published private(set) var state:PokemonListViewModelState = .loading
    @Published private(set) var pokemonOutlines = [PokemonOutline]()
    private let service = PokemonAPIs()
    private var cancellables = Set<AnyCancellable>()
    private var offset = 0
    private(set) var isLastPage = false
    private let perPage = 20
    private(set) var detailDic = [Int:PokemonDetail]()
    
    func fetchPokemonList() {
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            guard let self = self else {return}
            switch completion {
            case .finished:
                self.state = .finishedLoading
            case .failure(let error):
                self.state = .error(error)
                if offset > 0 {
                    offset -= perPage
                }
            }
        }
        
        let valueHandler:(Pokemons) -> Void = { [weak self] response in
            guard let self = self else {return}
            savePokemons(pokemons: response)
            
            if let outlines = response.pokemons {
                pokemonOutlines.append(contentsOf: outlines)
            }
            if (response.next != nil) {
                offset += perPage
            }
            isLastPage = response.next == nil
        }
        
        func savePokemons(pokemons:Pokemons) {
            do {
                let data = try JSONEncoder().encode(pokemons)
                DataService.shared.savePokemons(offset: offset, data: data)
            } catch {
                state = .error(error)
            }
        }
        
        state = .loading
        
        if let data = DataService.shared.fetchPokemons(offset: offset) {
            state = .finishedLoading
            if let outlines = data.pokemons {
                pokemonOutlines.append(contentsOf: outlines)
            }
            if (data.next != nil) {
                offset += perPage
            }
            isLastPage = data.next == nil
        } else {
            service.pokemonList(offset: offset)
                .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
                .store(in: &cancellables)
        }
    }
    
    func fetchPokemonDetail(id:Int) {
        if let detail = detailDic[id] {
            let index = pokemonOutlines.firstIndex(where: {$0.id == id})
            state = .fetchDetailSuccess(index!,detail)
            return
        }

        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            guard let self = self else {return}
            switch completion {
            case .finished:
                self.state = .finishedLoading
            case .failure(let error):
                self.state = .error(error)
            }
        }
        
        let valueHandler:(PokemonDetail) -> Void = { [weak self] response in
            guard let self = self else {return}
            savePokemonDetail(pokemonDetail: response)
            detailDic[id] = response
            let index = pokemonOutlines.firstIndex(where: {$0.id == id})
            state = .fetchDetailSuccess(index ?? 0,response)
        }
        
        func savePokemonDetail(pokemonDetail:PokemonDetail) {
            do {
                let data = try JSONEncoder().encode(pokemonDetail)
                DataService.shared.savePokemonDetail(pokedex: pokemonDetail.id, data: data)
            } catch {
                state = .error(error)
            }
        }
        
        state = .loading
        
        if let data = DataService.shared.fetchPokemonDetail(pokedex: id) {
            detailDic[id] = data
            let index = pokemonOutlines.firstIndex(where: {$0.id == id})
            state = .fetchDetailSuccess(index ?? 0,data)
        } else {
            service.pokemonDetail(id: id)
                .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
                .store(in: &cancellables)
        }
    }
    
    func cleanMemoryCache() {
        detailDic.removeAll()
    }
}
