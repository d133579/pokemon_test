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
    
    private var pokemonOutline:PokemonOutline!
    private var pokemonDetail:PokemonDetail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
