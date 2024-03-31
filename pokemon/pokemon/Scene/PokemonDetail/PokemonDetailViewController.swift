//
//  PokemonDetailViewController.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import UIKit
import Combine

class PokemonDetailViewController: UIViewController {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var evolutionChainLabel: UILabel!
    @IBOutlet weak var evolutionChainStackView: UIStackView!
    @IBOutlet weak var descriptionsStackView: UIStackView!
    @IBOutlet weak var descriptionsLabel: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel:PokemonDetailViewModel!
    
    init(pokemon:PokemonDetail) {
        viewModel = PokemonDetailViewModel(_pokemon: pokemon)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }

    private func setupBinding() {
        func bindingViewModelToView() {
            viewModel.$pokemon
                .receive(on: DispatchQueue.main)
                .sink { pokemon in
                    if let pokemon = pokemon {
                        self.idLabel.text = String(pokemon.id)
                        self.nameLabel.text = pokemon.name
                        self.typesLabel.text = pokemon.types.map{$0.name}.joined(separator: ",")
                        self.thumbnailImageView.kf.setImage(with: URL(string: pokemon.sprites.frontImageURL)!)
                        
                        if pokemon.species.evolutionChain != nil {
                            let chain =  pokemon.species.evolutionChain?.chain ?? []
                            let speciesNames = chain.compactMap { $0.species.name }.joined(separator: ", ")
                            self.evolutionChainLabel.text = speciesNames
                        } else {
                            self.evolutionChainStackView.isHidden = true
                        }
                        
                        if pokemon.species.descriptions != nil {
                            self.descriptionsLabel.text = pokemon.species.descriptions
                        } else {
                            self.descriptionsStackView.isHidden = true
                        }
                    }
                }
                .store(in: &cancellables)
        }
        bindingViewModelToView()
    }

}
