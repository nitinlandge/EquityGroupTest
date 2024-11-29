//
//  CoinDetailViewController.swift
//  EquityGroupTest
//
//  Created by administrator on 25/11/24.
//



import UIKit
import Charts

class CoinDetailViewController: UIViewController {
    var coin: Coin? // Coin passed from the previous view controller

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let statsLabel = UILabel()
    private let performanceChart = LineChartView()
    private let performanceFilterSegmentedControl = UISegmentedControl(items: ["1D", "1W", "1M"])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        title = coin?.name ?? "Details"
        setupUI()
        setupChart()
        updateUI()
    }

    private func setupUI() {
        // Name Label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Price Label
        priceLabel.font = UIFont.systemFont(ofSize: 20)
        priceLabel.textAlignment = .center
        view.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Stats Label
        statsLabel.numberOfLines = 0
        statsLabel.font = UIFont.systemFont(ofSize: 16)
        statsLabel.textAlignment = .center
        view.addSubview(statsLabel)
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statsLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Segmented Control for Performance Filters
        performanceFilterSegmentedControl.selectedSegmentIndex = 0
        performanceFilterSegmentedControl.addTarget(self, action: #selector(performanceFilterChanged), for: .valueChanged)
        view.addSubview(performanceFilterSegmentedControl)
        performanceFilterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            performanceFilterSegmentedControl.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 16),
            performanceFilterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            performanceFilterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Performance Chart
        performanceChart.noDataText = "Loading performance data..."
        view.addSubview(performanceChart)
        performanceChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            performanceChart.topAnchor.constraint(equalTo: performanceFilterSegmentedControl.bottomAnchor, constant: 16),
            performanceChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            performanceChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            performanceChart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    private func setupChart() {
        performanceChart.rightAxis.enabled = false
        let leftAxis = performanceChart.leftAxis
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        leftAxis.labelTextColor = .gray

        let xAxis = performanceChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.labelTextColor = .gray
        xAxis.drawGridLinesEnabled = false
    }

    private func updateUI() {
        guard let coin = coin else { return }

        nameLabel.text = coin.name
        priceLabel.text = "Price: $\(coin.price)"
        statsLabel.text = """
        Market Cap: \(coin.marketCap)
        24h Volume: \(coin.volume24h)
        Rank: \(coin.rank)
        """
        updateChart(for: "1D") // Default to 1D data
    }
    //MARK: Segmented Control Action
    @objc private func performanceFilterChanged() {
        let selectedFilter = performanceFilterSegmentedControl.titleForSegment(at: performanceFilterSegmentedControl.selectedSegmentIndex)
        updateChart(for: selectedFilter ?? "1D")
    }

    private func updateChart(for filter: String) {
        guard let sparklineData = coin?.sparkline.compactMap({ Double($0 ?? "") }) else { return }

        var dataPoints: [Double]
        switch filter {
        case "1W":
            dataPoints = Array(sparklineData.prefix(7)) // Example for 7 points
        case "1M":
            dataPoints = Array(sparklineData.prefix(30)) // Example for 30 points
        default:
            dataPoints = Array(sparklineData.prefix(24)) // Example for 24 points (1D)
        }

        var chartEntries: [ChartDataEntry] = []
        for (index, value) in dataPoints.enumerated() {
            chartEntries.append(ChartDataEntry(x: Double(index), y: value))
        }

        let dataSet = LineChartDataSet(entries: chartEntries, label: "Performance")
        dataSet.colors = [.systemBlue]
        dataSet.circleColors = [.systemBlue]
        dataSet.circleRadius = 3
        dataSet.lineWidth = 2
        dataSet.drawValuesEnabled = false

        let data = LineChartData(dataSet: dataSet)
        performanceChart.data = data
    }
}
