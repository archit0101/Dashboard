//
//  ReusableView.swift
//  OpenInApp
//
//  Created by Archit Gupta on 19/06/23.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        String(describing: self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableHeader<T: UIView>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let headerView = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
                fatalError("Could not dequeue header with identifier: \(T.defaultReuseIdentifier)")
            }
        return headerView
    }
    
    func dequeueReusableFooter<T: UIView>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let footerView = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
                fatalError("Could not dequeue header with identifier: \(T.defaultReuseIdentifier)")
            }
        return footerView
    }

    func registerHeader<T: UIView>(_: T.Type) where T: ReusableView {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.defaultReuseIdentifier
        )
    }
    
    func registerFooter<T: UIView>(_: T.Type) where T: ReusableView {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.defaultReuseIdentifier
        )
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func registerDefaultCell() {
        self.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: String(
                describing: UICollectionViewCell.self
            )
        )
    }
    
    func dequeDefaultCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = dequeueReusableCell(
            withReuseIdentifier: String(describing: UICollectionViewCell.self),
            for: indexPath
        )
        return cell
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func registerDefaultCell() {
        self.register(
            UITableViewCell.self,
            forCellReuseIdentifier: String(describing: UITableViewCell.self)
        )
    }
    
    func dequeDefaultCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = dequeueReusableCell(
            withIdentifier: String(describing: UITableViewCell.self),
            for: indexPath
        )
        return cell
    }
}

