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

final class PokemonAPIsTests: XCTestCase {
    
    private var sut:MockPokemonAPIs!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        sut = MockPokemonAPIs()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPokemonList() throws {
        let exp = expectation(description: "pokemon list")
        var error: Error?
        sut.pokemonList(limit: 20, offset: 10)
            .sink { completion in
                switch completion {
                case .failure(let _error):
                    error = _error
                    exp.fulfill()
                    break
                case .finished:
                    exp.fulfill()
                    break
                }
            } receiveValue: { _ in
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        XCTAssertNil(error)
    }
    
    func testPokemonDetail() throws {
        let exp = expectation(description: "pokemon detail")
        var error:Error?
        
        sut.pokemonDetail(id: 1)
            .sink { completion in
                switch completion {
                case .finished:
                    exp.fulfill()
                    break
                case .failure(let _error):
                    error = _error
                    exp.fulfill()
                    break
                }
                
            } receiveValue: { detail in
                print(detail)
            }.store(in: &cancellables)
        waitForExpectations(timeout: 10)
        XCTAssertNil(error)
    }
}
