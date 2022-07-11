//
//  ViewController.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/10/22.
//

import UIKit
import TableMVVM
import Callable

struct Profile {
    var name: String
    var url: String
}

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var items: [Profile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell? = tableView.dequeueReusableCell(withIdentifier: ProfileCell.className, for: indexPath) as? ProfileCell
        cell?.set(item: items[indexPath.row])
        return cell ?? .init()
    }
}
