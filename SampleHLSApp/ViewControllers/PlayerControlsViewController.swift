//
//  PlayerControlsViewController.swift
//  SampleHLSApp
//
//  Created by Joe Lucero on 4/21/19.
//  Copyright © 2019 iOSDevelopr. All rights reserved.
//

import UIKit

protocol PlayerControlsViewControllerDelegate: class {
    func playPauseButtonTapped()
    func closeButtonTapped()
    func scrubberMovedTo(percentComplete: Double)
}

class PlayerControlsViewController: UIViewController {
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeWatchedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeScrubber: UISlider!

    weak var delegate: PlayerControlsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let tintableImage = UIImage(named: "playPauseIcon")?.withRenderingMode(.alwaysTemplate)
        playPauseButton.setImage(tintableImage, for: .normal)
        playPauseButton.imageView?.tintColor = view.tintColor
        timeWatchedLabel.isHidden = true
        timeRemainingLabel.isHidden = true
    }

    @IBAction func playPauseButtonTapped(_ sender: Any) {
        delegate?.playPauseButtonTapped()
    }

    @IBAction func scrubberValueChanged(_ sender: UISlider) {
        let percentComplete = Double(sender.value / sender.maximumValue)
        delegate?.scrubberMovedTo(percentComplete: percentComplete)
    }
    @IBAction func closeButtonTapped() {
        delegate?.closeButtonTapped()
    }

    func updateTimeWatchedLabelWith(_ timeWatched: String) {
        timeWatchedLabel.text = timeWatched
    }

    func updateTimeRemainingLabelWith(_ timeRemaining: String) {
        timeWatchedLabel.isHidden = false
        timeRemainingLabel.isHidden = false
        timeRemainingLabel.text = timeRemaining
    }

    func updateScrubber(percentCompleted: Float) {
        timeScrubber.value = percentCompleted
    }
}
