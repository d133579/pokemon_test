//
//  PokemanService.swift
//  pokemon
//
//  Created by 文 on 2024/3/30.
//

import Foundation
import Moya

enum PokemanService {
    case PokemonList(limit:Int,offset:Int)
    case PokemonInfo(id:String)
}

extension PokemanService:CustomTargetType {
    
    var baseURL: URL {
        return URL(string: URLDomain.pokemonCenter())!
    }
    var path: String {
        switch self {
        case .PokemonList:
            return "pokemon"
        case .PokemonInfo(let id):
            return "pokemon/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .PokemonList, .PokemonInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .PokemonList(let limit, let offset):
            return .requestParameters(parameters: ["limit" : limit,"offset":offset], encoding: URLEncoding.default)
        case .PokemonInfo(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json; charset=utf-8"]
    }
    
    var showProgessHUDIfNeeded: Bool {
        return true
    }
}
