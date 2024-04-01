//
//  PokemonDetailCoordinator.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import Foundation
import UIKit

class PokemonDetailCoordinator:Coordinator {
    private let presenter:PokemonListViewController
    private let pokemonDetail:PokemonDetail
    private var pokemonDetailVC:PokemonDetailViewController?
    
    
    init(presenter: PokemonListViewController,pokemonDetail:PokemonDetail) {
        self.presenter = presenter
        self.pokemonDetail = pokemonDetail
    }
    
    func start() {
        pokemonDetailVC = PokemonDetailViewController(pokemon: pokemonDetail,_updateHandler: {
            DispatchQueue.main.async {
                self.presenter.tableView.reloadData()
            }
        })
        presenter.navigationController!.pushViewController(pokemonDetailVC!, animated: true)
    }
}
