//
//  UICollectionView+.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

// ************************************************
// MARK: - UICollectionReusableView
// ************************************************

extension UICollectionReusableView {

	public static var identifier: String {
		return String(describing: self)
	}

	public static var nibName: String {
		return self.identifier
	}

	public static var nib: UINib {
		return UINib(nibName: nibName, bundle: nil)
	}
}

// ************************************************
// MARK: - UICollectionView
// ************************************************

extension UICollectionView {

	enum ElementKind {
		case header
		case cell
		case footer

		var identifier: String {
			switch self {
			case .header: return UICollectionView.elementKindSectionHeader
			case .cell: return "elementKindCell"
			case .footer: return UICollectionView.elementKindSectionFooter
			}
		}

		init?(identifier: String) {
			switch identifier {
			case ElementKind.header.identifier: self = .header
			case ElementKind.cell.identifier: self = .cell
			case ElementKind.footer.identifier: self = .footer
			default: return nil
			}
		}
	}

	func registerCell<CellType: UICollectionViewCell>(_: CellType.Type) {
		self.register(CellType.nib, forCellWithReuseIdentifier: CellType.identifier)
	}

	func registerSupplementaryView<ViewType: UICollectionReusableView>(_: ViewType.Type, kind: ElementKind) {
		self.register(ViewType.nib, forSupplementaryViewOfKind: kind.identifier, withReuseIdentifier: ViewType.identifier)
	}

	func dequeueReusableCell<CellType: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> CellType {
		guard let cell = self.dequeueReusableCell(withReuseIdentifier: CellType.identifier, for: indexPath) as? CellType else {
			fatalError("Could not dequeue cell with identifier: \(CellType.identifier)")
		}
		return cell
	}

	func dequeueReusableSupplementaryView<ViewType: UICollectionReusableView>(_ kind: ElementKind, forIndexPath indexPath: IndexPath) -> ViewType {
		guard  let cell = self.dequeueReusableSupplementaryView(ofKind: kind.identifier, withReuseIdentifier: ViewType.identifier, for: indexPath) as? ViewType else {
			fatalError("Could not dequeue supplementary view with identifier: \(ViewType.identifier)")
		}
		return cell
	}
}
