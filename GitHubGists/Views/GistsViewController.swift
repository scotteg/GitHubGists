//
//  GistsViewController.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/8/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import UIKit
import SafariServices

final class GistsViewController: UIViewController {
    lazy var tableView = UITableView()
    lazy var viewModel = GistsViewModel()
    lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        title = "GitHub Gists"
        
        let vStack = UIStackView()
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        let searchBar = UISearchBar()
        searchBar.searchTextField.autocapitalizationType = .none
        searchBar.placeholder = "Enter GitHub username"
        searchBar.delegate = self
        vStack.addArrangedSubview(searchBar)
        
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GistCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 128
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = dataSource
        tableView.delegate = self
        vStack.addArrangedSubview(tableView)
    }
}

extension GistsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Debounce.input(searchText, current: searchBar.text ?? "") { [weak self] in
            self?.viewModel.fetchGists(for: $0) { [weak self] in
                self?.update()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension GistsViewController {
    enum Section {
        case main
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Gist> {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, gist in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GistCell
            cell.set(gist)
            return cell
        }
    }
    
    private func update() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Gist>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.gists)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension GistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SFSafariViewController(url: viewModel.gists[indexPath.row].htmlURL)
        present(controller, animated: true)
    }
}

enum Debounce<T: Equatable> {
    static func input(_ input: T, delay: TimeInterval = 0.3, current: @escaping @autoclosure () -> T, perform: @escaping (T) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard input == current() else { return }
            perform(input)
        }
    }
}
