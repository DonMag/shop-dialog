//
//  ViewControllerV2.swift
//  shop-dialog
//
//  Created by Don Mag on 4/18/22.
//

import UIKit

class ViewControllerV2: UIViewController {
	
	let PADDING = CGFloat(8.0)
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	private func getLayout() -> UICollectionViewCompositionalLayout {
		// https://stackoverflow.com/questions/69120818/uicollectionviewcompositionallayout-dynamic-height-uicollectionview-cell-what
		
		// Item
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .estimated(44)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
		
		// Group
		let groupSize = itemSize
		//let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
		group.interItemSpacing = .fixed(0)
		
		let section = NSCollectionLayoutSection(group: group)
		// Spacing for collection view's leading & trailing & bottom. For top, it is the spacing between header and item
		section.contentInsets = NSDirectionalEdgeInsets(
			top: PADDING * 2,
			leading: PADDING,
			bottom: PADDING * 2,
			trailing: PADDING
		)
		// Vertical spacing between cards within different group.
		section.interGroupSpacing = PADDING
		
		let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
		
		return compositionalLayout
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "V2"

		// V2 nib
		let collectionViewCell = CollectionViewCellV2.getUINib()
		collectionView.register(collectionViewCell, forCellWithReuseIdentifier: "cell")
		
		collectionView.collectionViewLayout = getLayout()
		
		collectionView.dataSource = self
		collectionView.delegate = self
	}
}

extension ViewControllerV2: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return shops.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCellV2
		
		let shop = shops[indexPath.item]
		
		collectionViewCell.title.text = shop.title
		collectionViewCell._description.text = shop.description
		
		// set expandCollapseConstraint.priority to
		//	.defaultHigh - 1 if cell should be expanded
		//	.defaultHigh + 1 if cell should be collapsed
		collectionViewCell.expandCollapseConstraint.priority = isExpanded[indexPath.item] ? .defaultHigh - 1 : .defaultHigh + 1
		
		return collectionViewCell
	}
	
}

extension ViewControllerV2: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		for i in (0..<isExpanded.count) {
			if i == indexPath.item {
				// ensure always visible
				isExpanded[i] = true
			} else {
				// set all other rows to false
				isExpanded[i] = false
			}
			if let c = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? CollectionViewCellV2 {
				// set expandCollapseConstraint.priority to
				//	.defaultHigh - 1 if cell should be expanded
				//	.defaultHigh + 1 if cell should be collapsed
				c.expandCollapseConstraint.priority = isExpanded[i] ? .defaultHigh - 1 : .defaultHigh + 1
			}
		}
		// adjust animation speed as desired
		UIView.animate(withDuration: 0.5, animations: {
			collectionView.performBatchUpdates(nil, completion: nil)
		})
	}
}

