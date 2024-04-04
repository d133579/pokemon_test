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
    @Published private(set) var favoritePokemons = [PokemonDetail]()
    private var service:PokemonAPIsDelegate!
    private var cancellables = Set<AnyCancellable>()
    private var _offset = 0
    
    private let queue = DispatchQueue(label: "offsetQueue", attributes: .concurrent)
    private var offset:Int  {
        get {
            queue.sync {
                _offset
            }
        }
        set {
            queue.async(flags:.barrier) {
                self._offset = newValue
            }
        }
    }
    
    private(set) var isLastPage = false
    static let perPage = 20
    private(set) var detailDic = [Int:PokemonDetail]()
    
    init(service:PokemonAPIsDelegate) {
        self.service = service
    }
    
    func fetchPokemonList() -> AnyPublisher<Pokemons, Error> {
        func savePokemons(pokemons:Pokemons) {
            do {
                let data = try JSONEncoder().encode(pokemons)
                DataService.shared.savePokemons(offset: offset, data: data)
            } catch {
                state = .error(error)
            }
        }
        
        func appendDataToPokemonOutlines(data:Pokemons) {
            if let outlines = data.pokemons {
                pokemonOutlines.append(contentsOf: outlines)
            }
            if (data.next != nil) {
                offset += PokemonListViewModel.perPage
            }
            isLastPage = data.next == nil
        }
        
        state = .loading
        
        if let data = DataService.shared.fetchPokemons(offset: offset) {
            state = .finishedLoading
            return Future<Pokemons, Error> { continuation in
                appendDataToPokemonOutlines(data: data)
                continuation(.success(data))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        }
        
        return service.pokemonList(limit: 10, offset: offset)
            .handleEvents(receiveOutput: { response in
                savePokemons(pokemons: response)
                appendDataToPokemonOutlines(data: response)
            }, receiveCompletion: { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    self.state = .finishedLoading
                case .failure(let error):
                    self.state = .error(error)
                    if offset > 0 {
                        offset -= PokemonListViewModel.perPage
                    }
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail(id:Int) -> AnyPublisher<PokemonDetail,Error> {
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
            return Future<PokemonDetail,Error> {[weak self] continuation in
                guard let self = self else {return}
                detailDic[id] = data
                let index = pokemonOutlines.firstIndex(where: {$0.id == id})
                state = .fetchDetailSuccess(index ?? 0,data)
                continuation(.success(data))
            }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        }
        
        return service.pokemonDetail(id: id)
            .handleEvents(receiveOutput: {[weak self] response in
                guard let self = self else {return}
                savePokemonDetail(pokemonDetail: response)
                self.detailDic[id] = response
            }, receiveCompletion: {[weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error)
                }
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchFavoritePokemons() {
        favoritePokemons = DataService.shared.fetchFavoritePokemons() ?? []
    }
    
    func updateFavoritePokemonDetail(by pokemon:PokemonDetail)  {
        let updatedFavoritePokemon = favoritePokemons.filter { $0.id != pokemon.id }
        favoritePokemons = updatedFavoritePokemon
        detailDic[pokemon.id]?.isFavorite = pokemon.isFavorite
    }
    
    func cleanMemoryCache() {
        detailDic.removeAll()
    }
}
