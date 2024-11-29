//
//  CoinTableViewCell.swift
//  EquityGroupTest
//
//  Created by administrator on 26/11/24.
//

import UIKit
import SDWebImage

class CoinTableViewCell: UITableViewCell {

    @IBOutlet weak var imageView_icon: UIImageView!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_24hrPerformance: UILabel!
    @IBOutlet weak var label_currentPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(with coin: Coin) {
        label_name.text = coin.name
        label_currentPrice.text = "Price: \(coin.price)"
        label_24hrPerformance.text = "24hr Change: \(coin.change)%"
        imageView_icon.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let pngConverted = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        imageView_icon.sd_setImage(with: URL(string: pngConverted), placeholderImage: UIImage(), completed: nil)
    }
    
}
