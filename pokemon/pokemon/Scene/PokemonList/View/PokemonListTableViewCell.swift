//
//  PokemonListTableViewCell.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import UIKit
import Kingfisher

class PokemonListTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    private var pokemonOutline:PokemonOutline!
    private var pokemonDetail:PokemonDetail!
    var updateFavoriteHandler:((PokemonDetail)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favoriteBtn.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favoriteBtn.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        idLabel.text = ""
        nameLabel.text = ""
        typesLabel.text = ""
        favoriteBtn.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_pokemonOutline:PokemonOutline, detailHandler:(Int) -> Void) {
        pokemonOutline = _pokemonOutline
        idLabel.text = String(pokemonOutline.id)
        nameLabel.text = pokemonOutline.name
        detailHandler(pokemonOutline.id)
    }
    
    func setupDetail(_pokemonDetail:PokemonDetail) {
        pokemonDetail = _pokemonDetail
        thumbnailImageView.kf.setImage(with: URL(string: pokemonDetail.sprites.frontImageURL))
        typesLabel.text = pokemonDetail.types.map{$0.name}.joined(separator: ",")
        idLabel.text = String(pokemonDetail.id)
        nameLabel.text = pokemonDetail.name
        favoriteBtn.isSelected = pokemonDetail.isFavorite
        
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        pokemonDetail.isFavorite = !pokemonDetail.isFavorite
        favoriteBtn.isSelected = pokemonDetail.isFavorite
        DataService.shared.updatePokemonDetail(pokedex: pokemonDetail.id, with: pokemonDetail.isFavorite)
        updateFavoriteHandler?(pokemonDetail)
    }
}
