//
//  DataService.swift
//  pokemon
//
//  Created by 文 on 2024/4/1.
//

import Foundation
import CoreData
import UIKit

class DataService {
    static let shared = DataService()
    private let pokemonsEntityName = "PokemonsEntity"
    private let pokemonDetailEntityName = "PokemonDetailEntity"
    
    func getContext() -> NSManagedObjectContext? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }
    
    func savePokemons(offset:Int, data:Data) {
        DispatchQueue.main.async { [self] in
            guard let context = getContext() else {return}
            let entity = NSEntityDescription.entity(forEntityName: pokemonsEntityName, in: context)
            let pokemons = NSManagedObject(entity: entity!, insertInto: context) as! PokemonsEntity
            pokemons.offset = Int16(offset)
            pokemons.jsonData = data
            
            do {
                try context.save()
            } catch {
                print("Error saving pokemons context:\(error.localizedDescription)")
            }
        }
    }
    
    func fetchPokemons(offset:Int) -> Pokemons? {
        guard let context = getContext() else {return nil}
        let fetchRequest: NSFetchRequest<PokemonsEntity> = PokemonsEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "offset == %d", offset)
        
        do {
            let result = try context.fetch(fetchRequest).first
            if let result = result , let data = result.jsonData{
                let decoder = JSONDecoder()
                let pokemons = try decoder.decode(Pokemons.self, from: data)
                return pokemons
            }
        } catch {
            print("Error fetch pokemons context:\(error.localizedDescription)")
        }
        return nil
    }
    
    func savePokemonDetail(pokedex:Int,data:Data) {
        DispatchQueue.main.async { [self] in
            guard let context = getContext() else {return}
            let entity = NSEntityDescription.entity(forEntityName: pokemonDetailEntityName, in: context)
            let pokemons = NSManagedObject(entity: entity!, insertInto: context) as! PokemonDetailEntity
            pokemons.pokedex = Int16(pokedex)
            pokemons.jsonData = data
            
            do {
                try context.save()
            } catch {
                print("Error saving pokemon detail context:\(error.localizedDescription)")
            }
        }
    }
    
    func fetchPokemonDetail(pokedex:Int) ->PokemonDetail? {
        guard let context = getContext() else {return nil}
        let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pokedex == %d", pokedex)
        
        do {
            let result = try context.fetch(fetchRequest).first
            if let result = result , let data = result.jsonData{
                let decoder = JSONDecoder()
                let detail = try decoder.decode(PokemonDetail.self, from: data)
                detail.isFavorite = result.isFavorite
                return detail
            }
        } catch {
            print("Error fetch pokemon detail context:\(error.localizedDescription)")
        }
        return nil
    }
    
    func updatePokemonDetail(pokedex: Int, with favorite: Bool) {
        guard let context = getContext() else { return }
        let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pokedex == %d", pokedex)
        
        do {
            if let pokemonDetailEntity = try context.fetch(fetchRequest).first {
                pokemonDetailEntity.isFavorite = favorite
                try context.save()
            }
        } catch {
            print("Error updating pokemon detail: \(error.localizedDescription)")
        }
    }
}
