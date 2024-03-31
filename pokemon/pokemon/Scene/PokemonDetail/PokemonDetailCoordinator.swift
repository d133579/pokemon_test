//
//  PokemonDetailCoordinator.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import Foundation
import UIKit

class PokemonDetailCoordinator:Coordinator {
    private let presenter:UINavigationController
    private let pokemonDetail:PokemonDetail
    private var pokemonDetailVC:PokemonDetailViewController?
    
    
    init(presenter: UINavigationController,pokemonDetail:PokemonDetail) {
        self.presenter = presenter
        self.pokemonDetail = pokemonDetail
    }
    
    func start() {
        pokemonDetailVC = PokemonDetailViewController(pokemon: pokemonDetail)
        presenter.pushViewController(pokemonDetailVC!, animated: true)
    }
}
