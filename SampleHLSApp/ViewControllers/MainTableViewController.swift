//
//  MainTableViewController.swift
//  SampleHLSApp
//
//  Created by Joe Lucero on 4/21/19.
//  Copyright © 2019 iOSDevelopr. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    private var streams: [StreamViewModel] = []

    override func viewDidLoad() {
        self.streams = StreamModelController.streams()
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streams.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StreamCell", for: indexPath) as? StreamTableViewCell, indexPath.row < streams.count else {
            assertionFailure("Did fail to dequeue a Stream Cell")
            return UITableViewCell()
        }

        cell.setUpWith(streamViewModel: streams[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < streams.count else { return 0.0 }
        let streamViewModel = streams[indexPath.row]
        return streamViewModel.heightForCell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPlayerVC",
            let indexPath = tableView.indexPathForSelectedRow,
            indexPath.row < streams.count,
            let playerVC = segue.destination as? PlayerViewController {
            let selectedStream = streams[indexPath.row]
            playerVC.setUpWith(skinnyStream: selectedStream.stream)
        }
    }
}
