//
//  ListHeroesTableViewController.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 20/10/23.
//

import UIKit
import CoreData

// MARK: - Protocol -
protocol ListHeroesTableViewControllerDelegate {
    
    var viewState: ((HeroesViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    var heroes: Heroes { get set }
    
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
    func logOut()
    func deleteCoreData()
}

// MARK: - View State -
enum HeroesViewState {
    case updateData
    case navigateToLogin
    case navigateToNext(_ hero: Hero)
}

// MARK: - Class -
class ListHeroesTableViewController: UITableViewController, UISearchBarDelegate {
    
    //    MARK: - Public Properties -
    var viewModel: ListHeroesTableViewControllerDelegate?
    var searchBar: UISearchBar!
    
    //    MARK: - Lifecyle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObserver()
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Buscar"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        //                tableView.tableHeaderView = searchBar
        viewModel?.onViewAppear()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let logOutButton = UIBarButtonItem(
            image: UIImage(systemName: "power"),
            style: .plain,
            target: self,
            action: #selector(onLogOutPressed)
        )
        
        let deleteCoreData = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(onDeleteCoreDataPressed)
        )
        
        
        navigationItem.rightBarButtonItems = [logOutButton]
        navigationItem.leftBarButtonItem = deleteCoreData
        navigationItem.title = "Lista de héroes"
    }
    
    //    MARK: - Public functions -
    @objc func onLogOutPressed() {
        viewModel?.logOut()
        viewModel?.viewState?(.navigateToLogin)
    }
    
    @objc func onDeleteCoreDataPressed() {
        viewModel?.deleteCoreData()
        viewModel?.viewState?(.updateData)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var herosFiltered: Heroes = []
        
        viewModel?.heroes.forEach {
            if (($0.name?.lowercased().contains(searchText.lowercased())) != nil) {
                herosFiltered.append($0)
            }
        }
        
        viewModel?.heroes = []
//        viewModel?.heroes = herosFiltered
        viewModel?.viewState?(.updateData)
    }
    
    //    MARK: - Private functions -
    private func initViews() {
        tableView.register(
            UINib(nibName: ListHeroesTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ListHeroesTableViewCell.identifier
        )
    }
    
    private func setObserver() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    
                case .updateData:
                    self?.tableView.reloadData()
                    
                case .navigateToLogin:
                    let loginViewController = LoginViewController()
                    loginViewController.viewModel = LoginViewModel(
                        networkManager: NetworkManager(),
                        secureData: SecureDataManager()
                    )
                    DispatchQueue.main.async {
                        
                        UIApplication
                            .shared
                            .connectedScenes
                            .compactMap{
                                ($0 as? UIWindowScene)?.keyWindow
                            }
                            .first?
                            .rootViewController = loginViewController
                    }
                    
                case .navigateToNext(let hero):
                    let detailViewController = DetailViewController()
                    detailViewController.viewModel = DetailViewModel(
                        hero: hero,
                        networkManager: NetworkManager(),
                        secureDataManager: SecureDataManager()
                    )
                    self?.navigationController?.pushViewController(detailViewController, animated: true)
                }
            }
            
        }
    }
}

// MARK: - Table view data source

extension ListHeroesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.heroesCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ListHeroesTableViewCell.estimatedHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListHeroesTableViewCell.identifier,
            for: indexPath) as? ListHeroesTableViewCell else {
            return UITableViewCell()
        }
        
        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.updateView(
                name: hero.name,
                photo: hero.photo,
                description: hero.description
            )
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let hero = self.viewModel?.heroes[indexPath.row] {
            self.viewModel?.viewState?(.navigateToNext(hero))
        }
    }
}

