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
        "https://random.dog/doggos".url?.request?.callPersistCodable(fetchStrategy: .alwaysUseCacheIfAvailable) { [weak self] (ids: [String]?) in
            self?.items = ids?
                .map { Profile($0)}
                .filter { $0.name.components(separatedBy: ".").last != "mp4"} ?? self?.items ?? []
//            print("screen shot file size: ", UIImage(named: "screenShot")?.fileSizeInKB)
//            print("screen shot resized: ", UIImage(named: "screenShot")?.resizeImage(targetSize: CGSize(width: 10, height: 10))?.fileSizeInKB)
//            print("original file: ", UIImage(named: "screenShot")?.fileSizeInKB, " should be one fourth", UIImage(named: "screenShot")?.resizeImage(multiplier: 0.5)?.fileSizeInKB)
//            print("original file: ", UIImage(named: "screenShot")?.fileSizeInKB, " should be one fourth", UIImage(named: "screenShot")?.resizeImage(multiplier: 0.5)?.fileSizeInKB)
//            print(self?.items[0].url, self?.items[1].url, self?.items[2].url, self?.items[3].url)
            print(
                "original file: ",
                UIImage(named: "screenShot")?.size,
                " should be one fourth",
                UIImage(named: "screenShot")?.resize(to: 0.5)?.size
                    // .resizeImage(to: 0.5)?.size
            )
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
        print(Thread.isMainThread)
//        for row in indexPaths.map(\.row) {
//            tasks[row] = items[row].url.url?.request?.callPersistDownloadData(fetchStrategy: .alwaysUseCacheIfAvailable)
//        }
//        for indexPath in indexPaths {
//            let url = items[indexPath].url
//            guard tasks.index(where: { $0.originalRequest?.url == url }) == nil else {
//                return
//            }
//            let task = URLSession.shared.downloadTask(with: url.request) { data, response, error in
//                DispatchQueue.main.async {
//                    if let data = data, let image = UIImage(data: data) {
//                        self.items[indexPath].image = image
//
//                        let indexPath = IndexPath(row: indexPath, section: 0)
//                        if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
//                            self.tableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .fade)
//                        }
//                    }
//                }
//            }
//            task.resume()
//            tasks.append(task)
//        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print(Thread.isMainThread)
//        for row in indexPaths.map(\.row) {
//            tasks[row]?.cancel()
//            tasks[row] = nil
//        }
//        for index in indexPaths {
//            let url = items[index].url
//            guard let taskIndex = tasks.index(where: { $0.originalRequest.url == url }) else {
//                return
//            }
//            let task = tasks[taskIndex]
//            task.cancel()
//            tasks.remove(at: taskIndex)
//        }
    }
}


extension UIImage {
    
    /// 100x100 -> max 10x10, then 10x10
    /// 100x100 -> max 20x10 then 10x10
    /// 100x100 -> max 5x10 then 5x5
    func resizeImageProportionately(maxSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = maxSize.width  / size.width
        let heightRatio = maxSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        return resizeExact(targetSize: newSize)
    }
    
    func resize(to multiplier: Double) -> UIImage? {
        resizeExact(targetSize: CGSize(width: size.width * multiplier, height: size.height * multiplier))
    }
    
    func resizeExact(targetSize: CGSize) -> UIImage? {
        let rect: CGRect = .init(origin: .zero, size: targetSize)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    var fileSizeInKB: Double? {
        (jpegData(compressionQuality: 1) ?? pngData()).map {
            Double(NSData(data: $0).count) / 1000.0
        }
    }
}
