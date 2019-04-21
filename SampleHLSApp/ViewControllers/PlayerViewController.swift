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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView?.play()
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        playerView?.frame = CGRect(origin: .zero, size: size)
    }

    func setUpWith(skinnyStream: SkinnyStream) {
        let playerView = PlayerView(frame: view.frame)
        playerView.setUpWith(stream: skinnyStream)
        view.addSubview(playerView)
        self.playerView = playerView
    }
}
