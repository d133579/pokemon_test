//
//  PokemonListViewController.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import UIKit
import Combine

class PokemonListViewController: UIViewController {
    lazy var tableView:UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let viewModel = PokemonListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupUI()
        setupBinding()
        viewModel.fetchPokemonList()
    }
    
    private func setupUI() {
        func setupTableView() {
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            tableView.register(UINib(nibName: "PokemonListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        
        setupTableView()
    }
    
    private func setupBinding() {
        func bindingViewModelToView() {
            viewModel.$state
                .receive(on: DispatchQueue.main)
                .sink { state in
                    switch state {
                    case .fetchDetailSuccess(let index,let detail):
                        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! PokemonListTableViewCell
                        cell.setupDetail(_pokemonDetail: detail)
                    default:
                        break
                    }
                }
                .store(in: &cancellables)
            
            viewModel.$pokemonOutlines
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    self.tableView.reloadData()
                }
                .store(in: &cancellables)
        }
        bindingViewModelToView()
    }
    
}

extension PokemonListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonOutlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! PokemonListTableViewCell
        cell.configure(_pokemonOutline: viewModel.pokemonOutlines[indexPath.row], detailHandler: { id in
            viewModel.fetchPokemonDetail(id: id)
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
