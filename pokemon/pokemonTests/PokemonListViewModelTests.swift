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
    final var viewModel:PokemonListViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        viewModel = PokemonListViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchPokemonList() throws {
        let exp = expectation(description: "pokemon list")
        var error: Error?
        
        viewModel.$pokemonOutlines
            .receive(on: DispatchQueue.main)
            .sink { a in
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .error(let _error):
                    error = _error
                case .finishedLoading:
                    
                    break
                default:
                    break
                }
                
            }.store(in: &cancellables)
        viewModel.fetchPokemonList()
        waitForExpectations(timeout: 10)
        XCTAssertNil(error)
    }
    
    func testFetchPokemonDetail() throws {
        let exp = expectation(description: "pokemon detail")
        var error: Error?
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .error(let _error):
                    error = _error
                case .fetchDetailSuccess(_, _):
                    exp.fulfill()
                    break
                default:
                    break
                }
                
            }.store(in: &cancellables)
        viewModel.fetchPokemonDetail(id: 1)
        waitForExpectations(timeout: 10)
        XCTAssertNil(error)
    }
}
