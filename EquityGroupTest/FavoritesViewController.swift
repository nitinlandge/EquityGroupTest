//
//  FavoritesViewController.swift
//  EquityGroupTest
//
//  Created by administrator on 25/11/24.
//


import UIKit

protocol FavoritesVCProtocol{
    func removeFavorate(with indexPath: Int)
}
class FavoritesViewController: UITableViewController {
    var favorites: [Coin] = []
    var delegate: FavoritesVCProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        tableView.register(UINib(nibName: "CoinTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinTableViewCell")

    }
}

extension FavoritesViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell", for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        let coin = favorites[indexPath.row]
        cell.setData(with: coin)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = favorites[indexPath.row]
        let detailsVC = CoinDetailViewController()
        detailsVC.coin = coin
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    // MARK: - Swipe Actions for Row

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let unfavoriteAction = UITableViewRowAction(style: .destructive, title: "Unfavorite") { _, indexPath in
            self.favorites.remove(at: indexPath.row)
            self.delegate?.removeFavorate(with: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [unfavoriteAction]
    }
    
}
