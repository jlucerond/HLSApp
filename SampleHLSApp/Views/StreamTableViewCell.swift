//
//  StreamTableViewCell.swift
//  SampleHLSApp
//
//  Created by Joe Lucero on 4/21/19.
//  Copyright © 2019 iOSDevelopr. All rights reserved.
//

import UIKit

class StreamTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    func setUpWith(streamViewModel: StreamViewModel) {
        self.titleLabel.text = streamViewModel.title
        self.subtitleLabel.text = streamViewModel.subtitle
    }
}
