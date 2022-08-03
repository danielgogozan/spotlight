//
//  LoadingTableCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 28.02.2022.
//

import Foundation
import UIKit

class LoadingTableCell: UITableViewCell {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.color = Asset.Colors.primary.color
        activityIndicator.style = .medium
    }
    
    deinit {
        stopLoading()
    }
    
    func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
