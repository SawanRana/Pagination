//
//  ViewController.swift
//  Pagination
//
//  Created by Sawan Rana on 05/03/23.
//

import UIKit

class ViewController: UIViewController {
    private var data = [String]()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pagination"
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        makeRequest()
    }
    
    private func createSpinnerView() -> UIView {
        let activityIndicator = UIActivityIndicatorView()
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        activityIndicator.center = footer.center
        footer.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return footer
    }
    
    private func makeRequest(isPagiantion: Bool = false) {
        APICaller.shared.request(isPagination: isPagiantion) { [weak self] result in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
            }
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.size.width, height: view.frame.size.height - 50)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 50 - scrollView.frame.size.height) {
            if APICaller.shared.isPaginationOn() == false {
                tableView.tableFooterView = createSpinnerView()
                makeRequest(isPagiantion: true)
            }
        }
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text =  "\(indexPath.row + 1).) " + data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class APICaller {
    static let shared = APICaller()
    private init() {
        print("Apicaller is genarated")
        isPaginationSet = false
    }
    
    private var isPaginationSet: Bool
    
    func request(isPagination: Bool, completion: @escaping (Result<[String], Error>) -> Void) {
        if isPagination {
            self.isPaginationSet = true
        }
        let paginationRandomTime = Double.random(in: 0..<3)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + (isPagination ? paginationRandomTime : 2)) {
            let data = [
                "Hello welcome!",
                "Delhi is the historical place",
                "Storm is needed"
            ]
            
            let pagintionData = [
                "Hello welcome!",
                "Pagination concept implementation",
                "This is basic implementation of the pagination"
            ]
            
            completion(.success(isPagination ? pagintionData : data))
            if isPagination {
                self.isPaginationSet = false
            }
            
        }
    }
    
    func isPaginationOn() -> Bool {
        return isPaginationSet
    }
}
