//
//  CollectionViewGridLayout.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

class CollectionViewGridLayout: UICollectionViewFlowLayout {

	private let _numberOfColumns: CGFloat
	private let _cellPadding: CGFloat

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(numberOfColumns: CGFloat, cellPadding: CGFloat) {
		_numberOfColumns = numberOfColumns
		_cellPadding = cellPadding

		super.init()

		self.scrollDirection = .vertical
		self.minimumLineSpacing = minimumLineSpacing
		self.minimumInteritemSpacing = minimumLineSpacing
	}

	func cellSize(forItemAt indexPath: IndexPath) -> CGSize {
		guard let collectionView = self.collectionView else { return CGSize.zero }

		let contentWidth = collectionView.bounds.width
		let cellSize = (contentWidth / _numberOfColumns) - _cellPadding
		return CGSize(width: cellSize, height: cellSize)
	}
}
