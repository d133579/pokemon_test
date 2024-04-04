//
//  PokemonListViewController.swift
//  pokemon
//
//  Created by 文 on 2024/3/31.
//

import UIKit
import Combine
import MJRefresh

protocol PokemonListViewControllerDelegate:AnyObject {
    func goToPokemonDetail(model:PokemonDetail,updateHandler: (() -> Void)?)
}

class PokemonListViewController: UIViewController {
    lazy var tableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var isFavoriteLabel:UILabel = {
        let label = UILabel()
        label.text = "Is Favorite"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var isFavoriteSwitch:UISwitch = {
        let btn = UISwitch()
        btn.accessibilityIdentifier = "favoriteSwitch"
        btn.addTarget(self, action: #selector(isFavoriteTapped(sender: )), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var isFavoriteContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel = PokemonListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let cellIdentifier = "cell"
    weak var delegate:PokemonListViewControllerDelegate?
    var updateHandler:(() -> Void)?
    
    init (updateHandler: (() -> Void)?) {
        self.updateHandler = updateHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupUI()
        setupBinding()
        viewModel.fetchPokemonList()
            .sink { _ in
            } receiveValue: { _ in
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func didReceiveMemoryWarning() {
        viewModel.cleanMemoryCache()
        tableView.reloadData()
    }
    
    private func setupUI() {
        func setupIsFavoriteBtn() {
            view.addSubview(isFavoriteContainerView)
            isFavoriteContainerView.addSubview(isFavoriteLabel)
            isFavoriteContainerView.addSubview(isFavoriteSwitch)

            NSLayoutConstraint.activate([
                isFavoriteContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                isFavoriteContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                isFavoriteContainerView.heightAnchor.constraint(equalToConstant: 50),
            ])

            NSLayoutConstraint.activate([
                isFavoriteLabel.leadingAnchor.constraint(equalTo: isFavoriteContainerView.leadingAnchor),
                isFavoriteLabel.topAnchor.constraint(equalTo: isFavoriteContainerView.topAnchor),
                isFavoriteLabel.bottomAnchor.constraint(equalTo: isFavoriteContainerView.bottomAnchor),
                isFavoriteLabel.trailingAnchor.constraint(equalTo: isFavoriteSwitch.leadingAnchor, constant: -10),
            ])

            NSLayoutConstraint.activate([
                isFavoriteSwitch.centerYAnchor.constraint(equalTo: isFavoriteContainerView.centerYAnchor),
                isFavoriteSwitch.trailingAnchor.constraint(equalTo: isFavoriteContainerView.trailingAnchor, constant: -5),
            ])
        }
        
        func setupTableView() {
            view.addSubview(tableView)
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: isFavoriteContainerView.bottomAnchor, constant: 0),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
            
            tableView.register(UINib(nibName: "PokemonListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            
            let footer = MJRefreshAutoNormalFooter { [weak self] in
                guard let self = self else {return}
                self.viewModel.fetchPokemonList()
                    .sink { _ in
                    } receiveValue: { _ in
                        self.tableView.reloadData()
                    }
                    .store(in: &cancellables)

            }
            footer.loadingView?.color = .black
            tableView.mj_footer = footer
        }
        setupIsFavoriteBtn()
        setupTableView()
    }
    
    private func setupBinding() {
        func bindingViewModelToView() {
            viewModel.$state
                .receive(on: DispatchQueue.main)
                .sink { state in
                    switch state {

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
            
            viewModel.$favoritePokemons
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    if self.isFavoriteSwitch.isOn {
                        self.tableView.reloadData()
                    }
                }
                .store(in: &cancellables)
        }
        
        func bindingBlock() {
            updateHandler = { [weak self] in
                DispatchQueue.main.async {
                    self?.viewModel.fetchFavoritePokemons()
                    self?.tableView.reloadData()
                }
            }
        }
        bindingViewModelToView()
        bindingBlock()
    }
    
    @objc func isFavoriteTapped(sender:UISwitch) {
        if sender.isOn {
            viewModel.fetchFavoritePokemons()
            tableView.mj_footer?.endRefreshingWithNoMoreData()
        } else {
            tableView.reloadData()
            self.tableView.mj_footer?.endRefreshing()
        }
    }
}

extension PokemonListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavoriteSwitch.isOn {
            return viewModel.favoritePokemons.count
        }
        return viewModel.pokemonOutlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFavoriteSwitch.isOn {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! PokemonListTableViewCell
            cell.setupDetail(_pokemonDetail: viewModel.favoritePokemons[indexPath.row])
            cell.updateFavoriteHandler = {[weak self] pokemon in
                self?.viewModel.updateFavoritePokemonDetail(by: pokemon)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! PokemonListTableViewCell
        cell.configure(_pokemonOutline: viewModel.pokemonOutlines[indexPath.row], detailHandler: { id in
            viewModel.fetchPokemonDetail(id: id)
                .sink { _ in
                } receiveValue: { data in
                    if let index = self.viewModel.pokemonOutlines.firstIndex(where: {$0.id == id}), let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PokemonListTableViewCell {
                        cell.setupDetail(_pokemonDetail: data)
                    }
                }
                .store(in: &cancellables)
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFavoriteSwitch.isOn {
            delegate?.goToPokemonDetail(model: viewModel.favoritePokemons[indexPath.row],updateHandler: updateHandler)
        } else {
            if let detail = viewModel.detailDic[viewModel.pokemonOutlines[indexPath.row].id] {
                delegate?.goToPokemonDetail(model: detail,updateHandler: updateHandler)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
