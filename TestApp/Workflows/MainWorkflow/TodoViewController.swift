//
//  ViewController.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 25/7/23.
//

import UIKit
import SwipeCellKit

class TodoViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case tasks
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Task>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Task>

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .allEvents)
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.reuseId)
        view.register(
            CalendarHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CalendarHeaderView.reuseId
        )
        view.backgroundColor = .white
        view.delegate = self
        view.refreshControl = refreshControl
        return view
    }()
    
    private lazy var dataSource = makeDataSource()
    private var selectedDate: Date?
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applySnapshot(animatingDifferences: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.configureNavigationStyle(tintColor: .systemBlue)
        let data = DataManager.shared.fetchTasks()
        dataSource.replaceItems(data, in: .tasks)
    }
    
    @objc
    private func refresh() {
        applySnapshot(animatingDifferences: true)
        refreshControl.endRefreshing()
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(section: self.generateHeaderLayout())
    }
    
    func generateHeaderLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.Sizes.padding16
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        let tasks = DataManager.shared.fetchTasks()
        var snapshot = Snapshot()
        snapshot.appendSections([.tasks])
        snapshot.appendItems(tasks, toSection: .tasks)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setup() {
        title = "Events Calendar"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTaskTapped))
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc
    private func addTaskTapped() {
        let task = Task(context: DataManager.shared.persistentContainer.viewContext)
        task.creationDate = selectedDate
        let vc = AddTaskViewController(task: task)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TaskCollectionViewCell.reuseId,
                    for: indexPath
                ) as? TaskCollectionViewCell
                cell?.delegate = self
                cell?.display(item: item)
                return cell
            })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: CalendarHeaderView.reuseId,
                for: indexPath
            ) as? CalendarHeaderView else {
                fatalError("Cell Reuse id is not registered")
            }
            supplementaryView.delegate = self
            let data = DataManager.shared.fetchTasksByDate()
            supplementaryView.diplay(item: data)
            return supplementaryView
        }
        
        return dataSource
    }
}

extension TodoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let task = DataManager.shared.fetchTasks()[indexPath.item]
        let vc = AddTaskViewController(task: task)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TodoViewController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            guard let self = self else {
                return
            }
            let task = self.dataSource.snapshot().itemIdentifiers[indexPath.item]
            DataManager.shared.removeTask(task)
            self.applySnapshot()
        }

        deleteAction.image = UIImage(systemName: "person.fill")
        return [deleteAction]
    }
}

extension TodoViewController: CalendarHeaderViewDelegate {
    func didSelectAt(date: Date) {
        selectedDate = date
    }
    
    func deselectDate() {
        selectedDate = nil
    }
}

extension Calendar {
    private var currentDate: Date { return Date() }
    
    func isDateInDay(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .day)
    }
}

extension UICollectionViewDiffableDataSource {
    func replaceItems(_ items : [ItemIdentifierType], in section: SectionIdentifierType) {
        var currentSnapshot = snapshot()
        let itemsOfSection = currentSnapshot.itemIdentifiers(inSection: section)
        currentSnapshot.deleteItems(itemsOfSection)
        currentSnapshot.appendItems(items, toSection: section)
        currentSnapshot.reloadSections([section])
        apply(currentSnapshot, animatingDifferences: true)
    }
}
