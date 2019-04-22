//
//  PlayerViewController.swift
//  SampleHLSApp
//
//  Created by Joe Lucero on 4/21/19.
//  Copyright © 2019 iOSDevelopr. All rights reserved.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController {
    private var playerView: PlayerView?
    private var playerControlsVC: PlayerControlsViewController?
    private var dimmingAnimationTime: TimeInterval = 1.5
    private var isTimeRemainingLabelSet: Bool = false
    private var timeSinceUserInteraction: TimeInterval = 0

    var timeObserverToken: Any?
    lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlayerControls()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackgroundDim()
        addPeriodicTimeObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removePeriodicTimeObserver()
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        playerView?.frame = CGRect(origin: .zero, size: size)
    }

    func setUpPlayerWith(skinnyStream: SkinnyStream) {
        let playerView = PlayerView(frame: view.frame)
        playerView.setUpWith(stream: skinnyStream)
        view.addSubview(playerView)
        view.sendSubviewToBack(playerView)
        self.playerView = playerView
    }

    @IBAction func viewWasTapped() {
        timeSinceUserInteraction = 0
        UIView.animate(withDuration: 1.0) { [weak self] in
            guard let self = self else { return }
            self.playerControlsVC?.view.alpha = 1.0
        }
    }

    func addPeriodicTimeObserver() {
        guard let player = playerView?.player else { return }
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1.0, preferredTimescale: timeScale)
        let callBack: (CMTime) -> Void = { [weak self] (timeWatched: CMTime) in
            guard let self = self else { return }

            // Set Time Watched
            self.setTimeWatchedLabel(time: timeWatched)

            // Set Time Remaining if needed
            // I placed this in here because I needed a spot where the player view has successfully
            // figured out how long the asset is, but I didn't want to continuously update the label
            if !self.isTimeRemainingLabelSet {
                if let totalTime = self.playerView?.totalTime {
                    let totalTimeInterval = CMTimeGetSeconds(totalTime)
                    if !totalTimeInterval.isNaN, let totalTimeIntervalAsString = self.formatter.string(from: totalTimeInterval) {
                        self.playerControlsVC?.updateTimeRemainingLabelWith(totalTimeIntervalAsString)
                        self.isTimeRemainingLabelSet = true
                    }
                }
            }

            // Decide whether to display controls to user
            self.timeSinceUserInteraction += 1
            if self.timeSinceUserInteraction > 3 {
                UIView.animate(withDuration: 1, animations: { [weak self] in
                    guard let self = self else { return }
                    self.playerControlsVC?.view.alpha = 0
                })
            }

            // update scrubber thumbnail
            if let percentComplete = self.playerView?.percentComplete {
                self.playerControlsVC?.updateScrubber(percentCompleted: percentComplete)
            }
        }
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main, using: callBack)
    }

    func removePeriodicTimeObserver() {
        guard let player = playerView?.player else { return }

        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    func setTimeWatchedLabel(time: CMTime) {
        let timeWatched = CMTimeGetSeconds(time)
        if !timeWatched.isNaN, let timeWatchedAsString = self.formatter.string(from: timeWatched) {
            self.playerControlsVC?.updateTimeWatchedLabelWith(timeWatchedAsString)
        }
    }
}

// MARK: - PlayerControlsViewControllerDelegate Methods
extension PlayerViewController: PlayerControlsViewControllerDelegate {
    func playPauseButtonTapped() {
        timeSinceUserInteraction = 0
        guard let playerView = playerView else { return }
        playerView.isPlayerPaused ? playerView.play() : playerView.pause()
    }

    func closeButtonTapped() {
        timeSinceUserInteraction = 0
        dismiss(animated: true, completion: nil)
    }

    func scrubberMovedTo(percentComplete: Double) {
        timeSinceUserInteraction = 0
        guard let playerView = playerView else { return }
        playerView.moveTo(percentCompleted: percentComplete)

        // Update label
        guard let totalTime = playerView.totalTime, totalTime.isValid else { return }
        let totalTimeAsDouble = Double(CMTimeGetSeconds(totalTime))
        let timeToMoveToAsDouble = totalTimeAsDouble * percentComplete
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: timeToMoveToAsDouble, preferredTimescale: timeScale)
        setTimeWatchedLabel(time: time)
    }
}

// MARK: - Private helper methods
private extension PlayerViewController {
    func setUpPlayerControls() {
        if let playerControlsViewController = storyboard?.instantiateViewController(withIdentifier: "PlayerControlsVC") as? PlayerControlsViewController,
            let playerControlsView = playerControlsViewController.view {
            playerControlsViewController.delegate = self
            self.playerControlsVC = playerControlsViewController
            self.setTimeWatchedLabel(time: CMTime.zero)
            addChild(playerControlsViewController)
            view.addSubview(playerControlsView)
            playerControlsView.translatesAutoresizingMaskIntoConstraints = false
            playerControlsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
            playerControlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10.0).isActive = true
            playerControlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
            playerControlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10.0).isActive = true
        }
    }

    func animateBackgroundDim() {
        let animation: (() -> Void) = {
            self.view.backgroundColor = .black
        }

        let completion: ((Bool) -> Void) = { _ in
            self.playerView?.play()
        }

        UIView.animate(withDuration: dimmingAnimationTime, animations: animation, completion: completion)
    }

}
