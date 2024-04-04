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
    @IBOutlet weak var favoriteBtn: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel:PokemonDetailViewModel!
    
    var updateHandler:(() -> Void)?
    
    init(pokemon:PokemonDetail, _updateHandler:(() -> Void)?) {
        viewModel = PokemonDetailViewModel(_pokemon: pokemon)
        updateHandler = _updateHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateHandler?()
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
    
    private func setupUI() {
        func setupFavoriteBtnIcon() {
            favoriteBtn.setImage(UIImage(systemName: "star.fill"), for: .selected)
            favoriteBtn.setImage(UIImage(systemName: "star"), for: .normal)
            favoriteBtn.isSelected = viewModel.pokemon.isFavorite
        }
        setupFavoriteBtnIcon()
    }

    @IBAction func favoriteTapped(_ sender: Any) {
        viewModel.pokemon.isFavorite = !viewModel.pokemon.isFavorite
        favoriteBtn.isSelected = viewModel.pokemon.isFavorite
        DataService.shared.updatePokemonDetail(pokedex: viewModel.pokemon.id, with: viewModel.pokemon.isFavorite)
    }
}
