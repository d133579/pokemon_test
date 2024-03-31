//
//  ApplicationCoordinator.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

class ApplicationCoordinator:Coordinator {
    let window:UIWindow
    
    private var pokemonListCoordinator:PokemonListCoordinator
    
    init(window: UIWindow) {
        self.window = window
        self.pokemonListCoordinator = PokemonListCoordinator(presenter: window)
    }
    
    func start() {
        pokemonListCoordinator.start()
        window.makeKeyAndVisible()
    }
}
