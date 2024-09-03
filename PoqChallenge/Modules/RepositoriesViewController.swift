//
//  ViewController.swift
//  PoqChallenge
//
//  Created by Ilya Shytsko on 14/07/2024.
//

import UIKit

final class RepositoriesViewController: UIViewController {
    
    //MARK: - Properties
    
    var dataSource: UICollectionViewDiffableDataSource<Sections, RepositoryModel>! = nil
    var collectionView: UICollectionView! = nil
    
    lazy var placeholderErrorView: PlaceholderErrorView = {
        let view = PlaceholderErrorView.instance()
        view.onRefreshData = { [weak self] in
            self?.getRepositories()
        }
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRepositories()
    }
    
    //MARK: - Private
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.allowsSelection = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func getRepositories() {
        placeholderErrorView.isLoading = true
        collectionView.backgroundView = placeholderErrorView
        Task {
            do {
                let repositories: [RepositoryModel] = try await NetworkService.GithubService.fetchRepositories()
                updateCollectionView(with: repositories)
            }
            catch {
                showError(error)
            }
        }
    }
    
    func updateCollectionView(with data: [RepositoryModel]) {
        placeholderErrorView.isLoading = false
        collectionView.backgroundView = nil
        performDataSourceUpdate(with: data)
    }
    
    func showError(_ error: Error) {
        placeholderErrorView.isLoading = false
        placeholderErrorView.error = error
        collectionView.backgroundView = placeholderErrorView
    }
}

//MARK: - UICollectionViewDelegate, DataSource

extension RepositoriesViewController: UICollectionViewDelegate {
    
    enum Sections: Hashable { case main }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, RepositoryModel> { (cell, indexPath, item) in
            
            var content = cell.defaultContentConfiguration()
            content.text = "\(item.name)"
            content.textProperties.font = .boldSystemFont(ofSize: 18)
            
            if let description = item.description {
                content.secondaryText = description
            }
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, RepositoryModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: RepositoryModel) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    func performDataSourceUpdate(with data: [RepositoryModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, RepositoryModel>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
