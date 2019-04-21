//
//  PlayerView.swift
//  SampleHLSApp
//
//  Created by Joe Lucero on 4/21/19.
//  Copyright © 2019 iOSDevelopr. All rights reserved.
//

import UIKit
import AVKit

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    private var player: AVPlayer? {
        get {
            return playerLayer?.player
        }
        set {
            playerLayer?.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }

    func setUpWith(stream: SkinnyStream) {
        player = AVPlayer(url: stream.url)
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }
}
