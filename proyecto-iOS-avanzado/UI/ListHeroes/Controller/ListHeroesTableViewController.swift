//
//  ListHeroesTableViewController.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 20/10/23.
//

import UIKit

protocol ListHeroesTableViewControllerDelegate: AnyObject {
    func didPressLogout()
}

class ListHeroesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let logOutButton = UIBarButtonItem(
            image: UIImage(systemName: "power"),
            style: .plain,
            target: self,
            action: #selector(onLogOutPressed)
        )
        
        navigationItem.rightBarButtonItems = [logOutButton]
    }
    
    @objc func onLogOutPressed() {
        SecureDataManager().deleteToken()
    }
    
    private func initViews() {
        tableView.register(
            UINib(nibName: ListHeroesTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ListHeroesTableViewCell.identifier
        )
    }
}

// MARK: - Table view data source

extension ListHeroesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        ListHeroesTableViewCell.estimatedHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListHeroesTableViewCell.identifier,
            for: indexPath) as? ListHeroesTableViewCell else {
            return UITableViewCell()
        }
        
//        TODO: Llamar a cell.update
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        TODO: Navegar a la vista del detalle
    }
}

