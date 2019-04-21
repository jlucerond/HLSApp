//
//  StreamModelController.swift
//  SampleHLSApp
//
//  Created by Joe Lucero on 4/21/19.
//  Copyright © 2019 iOSDevelopr. All rights reserved.
//

import Foundation

class StreamModelController {
    static func streams() -> [StreamViewModel] {
        var streams = [StreamViewModel]()

        if let bigBuckBunnyURL = URL(string: "https://video-dev.github.io/streams/x36xhzz/x36xhzz.m3u8") {
            let stream = SkinnyStream(url: bigBuckBunnyURL)
            let title = "Big Buck Bunny"
            let subtitle = "A large and lovable rabbit deals with three tiny bullies, led by a flying squirrel, who are determined to squelch his happiness."
            let bigBuckViewModel = StreamViewModel(stream: stream, title: title, subtitle: subtitle)
            streams.append(bigBuckViewModel)
        }

        if let  arteChinaURL = URL(string: "https://video-dev.github.io/streams/test_001/stream.m3u8") {
            let stream = SkinnyStream(url: arteChinaURL)
            let title = "Arte China"
            let subtitle = "Chinese art is visual art that, whether ancient or modern, originated in or is practiced in China or by Chinese artists. The Chinese art in the Republic of China (Taiwan) and that of overseas Chinese can also be considered part of Chinese art where it is based in or draws on Chinese heritage and Chinese culture."
            let arteChinaViewModel = StreamViewModel(stream: stream, title: title, subtitle: subtitle)
            streams.append(arteChinaViewModel)
        }

        return streams
    }
}
