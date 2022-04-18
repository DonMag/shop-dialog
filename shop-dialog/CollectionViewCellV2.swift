//
//  CollectionViewCellV2.swift
//  shop-dialog
//
//  Created by Don Mag on 4/18/22.
//

import UIKit

class CollectionViewCellV2: UICollectionViewCell {
	
	@IBOutlet weak var title: UILabel!
	
	@IBOutlet weak var _description: UILabel!
	
	@IBOutlet weak var innerView: UIView!
	
	@IBOutlet var expandCollapseConstraint: NSLayoutConstraint!
	
	static func getUINib() -> UINib {
		return UINib(nibName: String(describing: self), bundle: nil)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.black.cgColor
	}
	
}
