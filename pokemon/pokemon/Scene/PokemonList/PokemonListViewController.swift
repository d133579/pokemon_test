//
//  PokemonListViewController.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import UIKit
import Combine
import MJRefresh

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
            
            let footer = MJRefreshAutoNormalFooter { [weak self] in
                guard let self = self else {return}
                self.viewModel.fetchPokemonList()
            }
            footer.loadingView?.color = .black
            tableView.mj_footer = footer
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
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PokemonListTableViewCell {
                            cell.setupDetail(_pokemonDetail: detail)
                        }
                    default:
                        break
                    }
                }
                .store(in: &cancellables)
            
            viewModel.$pokemonOutlines
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    self.tableView.reloadData()
                    self.tableView.mj_footer?.endRefreshing()
                    if self.viewModel.isLastPage {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detail = viewModel.detailDic[viewModel.pokemonOutlines[indexPath.row].id] {
            let vc = PokemonDetailViewController(pokemon: detail)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
