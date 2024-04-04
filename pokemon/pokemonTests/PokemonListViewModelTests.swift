//
//  PokemonListTests.swift
//  pokemonTests
//
//  Created by 文 on 2024/3/31.
//

import XCTest
import Combine

@testable import pokemon

final class PokemonListViewModelTests: XCTestCase {
    final var sut:PokemonListViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        sut = PokemonListViewModel(service: MockPokemonAPIs())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchPokemonList() throws {
        let exp = expectation(description: "pokemon list")
        var error: Error?
        
        sut.fetchPokemonList()
            .sink { completion in
                switch completion {
                case .failure(let _error):
                    error = _error
                    exp.fulfill()
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
    
    func testFetchPokemonDetail() throws {
        let exp = expectation(description: "pokemon detail")
        var error: Error?
        sut.fetchPokemonDetail(id: 1)
            .sink { completion in
                switch completion {
                case .failure(let _error):
                    error = _error
                    exp.fulfill()
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
}
