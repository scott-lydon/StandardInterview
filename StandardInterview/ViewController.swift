//
//  ViewController.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/10/22.
//

import UIKit
import TableMVVM

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var items: [Profile] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var tasks: [Int: URLSessionDownloadTask] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.prefetchDataSource = self
        "https://random.dog/doggos"
            .url?
            .request?
            .callPersistCodable(fetchStrategy: .alwaysUseCacheIfAvailable) { [weak self] (ids: [String]?) in
            self?.items = ids?
                .map { Profile($0)}
                .filter { $0.name.components(separatedBy: ".").last != "mp4"} ?? self?.items ?? []
        }
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

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        DispatchQueue.global(qos: .background).async {
            for indexPath in indexPaths {
                // indexPath ->
                // try getting image dimensions
                // url using indexPath.
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        DispatchQueue.global(qos: .background).async {
            for indexPath in indexPaths {
                IndexPathDataTaskCache.shared[indexPath]?.cancel()
                IndexPathDataTaskCache.shared[indexPath] = nil
            }
        }
    }
}
