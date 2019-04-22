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

    var player: AVPlayer? {
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

    var isPlayerPaused: Bool {
        return player?.rate == 0
    }

    var timeWatched: CMTime? {
        return player?.currentTime()
    }

    var totalTime: CMTime? {
        return player?.currentItem?.asset.duration
    }

    var percentComplete: Float? {
        guard let timeWatched = timeWatched, let totalTime = totalTime else { return nil }
        let timeWatchedAsFloat = Float(CMTimeGetSeconds(timeWatched))
        let totalTimeAsFloat = Float(CMTimeGetSeconds(totalTime))
        return timeWatchedAsFloat / totalTimeAsFloat
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

    func moveTo(percentCompleted: Double) {
        guard let totalTime = totalTime, totalTime.isValid else { return }
        let totalTimeAsDouble = Double(CMTimeGetSeconds(totalTime))
        let timeToMoveToAsDouble = totalTimeAsDouble * percentCompleted
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let timeToSeek = CMTime(seconds: timeToMoveToAsDouble, preferredTimescale: timeScale)
        player?.seek(to: timeToSeek)
    }
}
