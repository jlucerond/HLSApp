//
//  StreamViewModel.swift
//  SampleHLSApp
//
//  Created by Joe Lucero on 4/21/19.
//  Copyright © 2019 iOSDevelopr. All rights reserved.
//

import UIKit

struct StreamViewModel {
    let stream: SkinnyStream

    // again, this is terrible design, but in MVVM, the title and subtitle would be
    // reading SOMETHING about the stream model to determine what to properly display
    let title: String
    let subtitle: String

    var heightForCell: CGFloat {
        let spacing: CGFloat = 20

        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.text = title
        let titleHeight = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - spacing * 2, height: .infinity)).height

        label.text = subtitle
        label.font = UIFont.systemFont(ofSize: 17.0)
        let subtitleHeight = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - spacing * 2, height: .infinity)).height

        let value = spacing + titleHeight + spacing + subtitleHeight + spacing
        return value
    }
}
