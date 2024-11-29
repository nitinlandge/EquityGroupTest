//
//  ViewController.swift
//  EquityGroupTest
//
//  Created by administrator on 25/11/24.
//

import UIKit

class CoinListViewController: UIViewController {
    
    enum FilterType {
        case none
        case highestPrice
        case bestPerformance
    }
    private var coins: [Coin] = []
    private var filteredCoins: [Coin] = []
    private var page = 0
    private var isLoading = false
    private var currentFilter: FilterType = .none
    private var favorites: [Coin] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coins"
        tableViewSetUp()
        setupFilterButton()
        fetchCoins()
    }
    
    private func tableViewSetUp(){
        tableView.register(UINib(nibName: "CoinTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupFilterButton() {
        if let filterIcon = UIImage(systemName: "line.horizontal.3.decrease.circle"),
           let favoriteIcon = UIImage(systemName: "star.fill") {
            let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(showFilterOptions))
            let favoriteButton = UIBarButtonItem(image: favoriteIcon, style: .plain, target: self, action: #selector(showFavorites))
            navigationItem.rightBarButtonItems = [filterButton,favoriteButton]
        }
    }
    //MARK: Button Actions
    @objc private func showFilterOptions() {
        let alertController = UIAlertController(title: "Filter Options", message: "", preferredStyle: .actionSheet)
        
        let noneAction = UIAlertAction(title: "None", style: .default) { _ in
            self.currentFilter = .none
            self.applyFilter()
        }
        
        let highestPriceAction = UIAlertAction(title: "Highest Price", style: .default) { _ in
            self.currentFilter = .highestPrice
            self.applyFilter()
        }
        
        let bestPerformanceAction = UIAlertAction(title: "Best 24h Performance", style: .default) { _ in
            self.currentFilter = .bestPerformance
            self.applyFilter()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(noneAction)
        alertController.addAction(highestPriceAction)
        alertController.addAction(bestPerformanceAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    @objc private func showFavorites() {
        let favVC = FavoritesViewController()
        favVC.favorites = self.favorites
        favVC.delegate = self
        navigationController?.pushViewController(favVC, animated: true)
        
    }
    //MARK: Filter
    private func applyFilter() {
        switch currentFilter {
        case .none:
            filteredCoins = coins
        case .highestPrice:
            filteredCoins = coins.sorted { Double($0.price) ?? 0 > Double($1.price) ?? 0 }
        case .bestPerformance:
            filteredCoins = coins.sorted { Double($0.change) ?? 0 > Double($1.change) ?? 0 }
        }
        
        tableView.reloadData()
    }
    
    //MARK: API call
    private func fetchCoins() {
        guard !isLoading else { return }
        isLoading = true
//        if page > 4
        if filteredCoins.count >= 100 {
            print("Limit: 100 is completed")
            return
        }
        
        NetworkManager.shared.fetchCoins(page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let newCoins):
                    self.coins.append(contentsOf: newCoins)
                    self.applyFilter() // Reapply filter when new data is fetched
                case .failure(let error):
                    print("Error fetching coins: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
//MARK: TableView Delegate & DataSource methods
extension CoinListViewController: UITableViewDelegate,UITableViewDataSource{
    
    // Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell", for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        let coin = filteredCoins[indexPath.row]
        cell.setData(with: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == coins.count - 1 {
            page += 1
            fetchCoins()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = filteredCoins[indexPath.row]
        let detailsVC = CoinDetailViewController()
        detailsVC.coin = coin
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // MARK: - Swipe Actions for Row
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let coin = self.coins[indexPath.row]
            if !self.favorites.contains(where: { $0.uuid == coin.uuid }) {
                self.favorites.append(coin)
            }
            completionHandler(true)
        }
        favoriteAction.backgroundColor = .systemBlue
        favoriteAction.image = UIImage(systemName: "star.fill") // Optional: Add an icon for better UI
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
}
extension CoinListViewController: FavoritesVCProtocol{
    func removeFavorate(with indexPath: Int) {
        self.favorites.remove(at: indexPath)
    }
}
