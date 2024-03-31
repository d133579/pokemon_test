//
//  PokemonListCoordinator.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import Foundation
import UIKit

class PokemonListCoordinator:Coordinator {
    private let presenter:UIWindow
    private var pokemonListVC:PokemonListViewController?
    private var pokemonDetailCoordinator:PokemonDetailCoordinator?
    private var nav:UINavigationController!
    
    init(presenter: UIWindow) {
        self.presenter = presenter
    }
    
    func start() {
        pokemonListVC = PokemonListViewController()
        pokemonListVC?.delegate = self
        nav = UINavigationController(rootViewController: pokemonListVC!)
        presenter.rootViewController = nav
    }
}

extension PokemonListCoordinator:PokemonListViewControllerDelegate {
    func goToPokemonDetail(model: PokemonDetail) {
        pokemonDetailCoordinator = PokemonDetailCoordinator(presenter: nav, pokemonDetail: model)
        pokemonDetailCoordinator?.start()
    }
}
