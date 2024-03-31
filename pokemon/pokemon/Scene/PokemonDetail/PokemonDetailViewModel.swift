//
//  PokemonDetailViewModel.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import Foundation
import Combine
class PokemonDetailViewModel {
    @Published private(set) var pokemon:PokemonDetail!
    
    init (_pokemon:PokemonDetail) {
        pokemon = _pokemon
    }
}
