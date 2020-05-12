//
//  InitialViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 09/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

enum InitialViewData {
    case button(String)
    case tree
}

class InitialViewController: UIViewController {
    
    var data: [InitialViewData] = ["Read", "Language", "Skills", "Tree", "Exercise", "Food", "Sleep"].map {
        if $0 == "Tree" {
            return InitialViewData.tree
        }
        return InitialViewData.button($0)
    }
    
    var viewModel: DayInformationViewModel?
    
    lazy var collectionView: UICollectionView = {
        let layout = InitialColectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .purple
        collectionView.register(InitialCollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: InitialCollectionViewCell.self))
        collectionView.register(TreeViewCell.self,
                                forCellWithReuseIdentifier: String(describing: TreeViewCell.self))
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
    }
    
    fileprivate func setupViews() {
        collectionView.fill(view: view)
    }
    
    fileprivate func setupViewModel() {
        if let context = view.context {
            viewModel = DayInformationViewModel(context: context)
        }
    }
    
}

extension InitialViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch data[indexPath.item] {
        case .tree:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TreeViewCell.self),
                                                          for: indexPath)
            cell.layer.cornerRadius = 50
            cell.layer.masksToBounds = true
            (cell as? TreeViewCell)?.treeView.branchesScore = viewModel?.branchesScore ?? 0
            (cell as? TreeViewCell)?.treeView.soilScore = viewModel?.soilScore ?? 0
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InitialCollectionViewCell.self),
                                                          for: indexPath)
            cell.layer.cornerRadius = 50
            cell.layer.masksToBounds = true
            return cell
        }
    }
    
}

class TreeViewCell: UICollectionViewCell {
    
    lazy var treeView = TreeView().notTranslating()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(branchesScore: Double, soilScore: Double) {
        treeView.branchesScore = branchesScore
        treeView.soilScore = soilScore
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        treeView.fill(view: contentView)
    }
    
}

class InitialCollectionViewCell: UICollectionViewCell {
    
    lazy var titleView = SimpleTitleView(title: "").notTranslating()
    
    func setup(data: String) {
        titleView.title = data
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        titleView.fill(view: contentView)
    }
    
}

class InitialColectionViewLayout: UICollectionViewLayout {
    
    let deviceWidth = UIScreen.main.bounds.width
    lazy var deviceHeight: CGFloat = {
        return self.collectionView?.frame.height ?? UIScreen.main.bounds.height
    }()
    let treeSize = CGFloat(100)
    let cellSize = CGFloat(100)
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate lazy var yOffsets = {
        return [
            CGFloat(50), CGFloat(20), CGFloat(50),
            CGFloat(self.deviceHeight / 2 - self.treeSize / 2),
            CGFloat(self.deviceHeight - (50 + self.cellSize)),
            CGFloat(self.deviceHeight - (20 + self.cellSize)),
            CGFloat(self.deviceHeight - (50 + self.cellSize))
        ]
    }()
    
    fileprivate lazy var xOffsets = {
        return [
            CGFloat(20), CGFloat(self.deviceWidth / 2 - self.cellSize / 2), CGFloat(self.deviceWidth - (cellSize + 20)),
            CGFloat(self.deviceWidth / 2 - self.treeSize / 2),
            CGFloat(20), CGFloat(self.deviceWidth / 2 - self.cellSize / 2), CGFloat(self.deviceWidth - (cellSize + 20)),
        ]
    }()
    
    override func prepare() {
        guard cache.isEmpty,
            let collectionView = collectionView
            else {
                return
        }
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let frame = CGRect(x: xOffsets[indexPath.item],
                               y: yOffsets[indexPath.item],
                               width: 100,
                               height: 100)
            let insetFrame = frame.insetBy(dx: 0, dy: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: deviceWidth, height: collectionView?.frame.height ?? 0)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var displayedAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
          if attributes.frame.intersects(rect) {
            displayedAttributes.append(attributes)
          }
        }
        
        return displayedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes()
        attributes.size = CGSize(width: 100, height: 100)
        cache.append(attributes)
        return attributes
    }
    
}
