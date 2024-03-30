//
//  pokemonTests.swift
//  pokemonTests
//
//  Created by 文 on 2024/3/29.
//

import XCTest
import Moya
import Combine

@testable import pokemon

final class pokemonTests: XCTestCase {
    
    private let service = PokemonAPIs()
    var cancallables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPokemonList() throws {
        let exp = expectation(description: "pokemon list")
        var error: Error?
        service.pokemonList(offset: 0)
            .sink { comletion in
                switch comletion {
                case .finished:
                    break
                case .failure(let _error):
                    error = _error
                }
                exp.fulfill()
            } receiveValue: { pokemons in
                print("")
            }.store(in: &cancallables)
        waitForExpectations(timeout: 10)
        XCTAssertNil(error)
    }
}
