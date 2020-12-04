//
//  ViewController.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 3/12/20.
//

import UIKit
import SDWebImage

/// Only screen to show tabular data.
class MainViewController: UIViewController {

    var viewModel: MainViewModel?
    
    private let mainCellReuseIdentifier = "MainTableViewCell"

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .singleLine
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44
        table.tableFooterView = UIView()
        table.register(MainTableViewCell.self, forCellReuseIdentifier: mainCellReuseIdentifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.delegate = self
        refreshView()
        
        self.view.addSubview(tableView)
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
                                                                    UIBarButtonItem.SystemItem.refresh, target: self, action:
                                                                        #selector(refreshView))
    }
    
    func setupTableView() {
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func updateLoadingState() {
        
        if viewModel?.isLoading == true {
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.dismiss(animated: false, completion: {
                    self?.title = self?.viewModel?.title
                    self?.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func refreshView() {
        viewModel?.refresh()
        updateLoadingState()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate methods
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rowsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainCellReuseIdentifier, for: indexPath) as! MainTableViewCell
        
        if let rowsArray = viewModel?.rowsArray {
            cell.titleLabel.text = (rowsArray[indexPath.row]).title
            cell.descriptionLabel.text = (rowsArray[indexPath.row]).description
            if let imageHref = (rowsArray[indexPath.row]).imageHref {
                cell.imageHref.sd_setImage(with: URL(string: imageHref), placeholderImage: UIImage(named: "PlaceholderImage"))
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - MainViewModelDelegate methods
extension MainViewController: MainViewModelDelegate {
    
    func viewModel(_ viewModel: MainViewModel, loadingStateDidChange isLoading: Bool) {
        updateLoadingState()
    }
    
    
}
