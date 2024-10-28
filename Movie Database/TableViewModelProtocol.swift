//
//  TableViewModelProtocol.swift
//  Movie Database
//
//  Created by Charan Ganesh on 26/10/24.
//

import UIKit


protocol RegisterableTableViewCellProtocol {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
    static func dequeueReusably(for tableView: UITableView, at indexPath: IndexPath) -> Self
}

extension RegisterableTableViewCellProtocol where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    static func dequeueReusably(for tableView: UITableView, at indexPath: IndexPath) -> Self {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Self else {
            fatalError("Error dequeuing cell with identifier: \(reuseIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell: RegisterableTableViewCellProtocol {}

extension UITableView {
    func register(cells: [RegisterableTableViewCellProtocol.Type]) {
        cells.forEach { cell in
            self.register(
                UINib(nibName: cell.reuseIdentifier, bundle: nil),
                forCellReuseIdentifier: cell.reuseIdentifier
            )
        }
    }
}



protocol TableViewModelProtocol: AnyObject {
    var sections: [TableViewSection] { get }
    var registerableCells: [RegisterableTableViewCellProtocol.Type] { get }
    func cellViewModel(for section: Int, row: Int) -> any TableViewCellViewModelProtocol
}

extension TableViewModelProtocol {
    func cellViewModel(for section: Int, row: Int) -> any TableViewCellViewModelProtocol {
        return sections[section].items[row]
    }
}

protocol TableViewCellViewModelProtocol {
    associatedtype CellType: UITableViewCell
    
    func configureCell(_ cell: CellType)
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> CellType
}

extension TableViewCellViewModelProtocol {
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> CellType {
        let cell = CellType.dequeueReusably(for: tableView, at: indexPath)
        configureCell(cell)
        cell.selectionStyle = .none
        return cell
    }
}

struct TableViewSection {
    let title: String?
    let footerText: String?
    var items: [any TableViewCellViewModelProtocol]
    var isExpanded: Bool = true
    
    init(
        title: String? = nil,
        footerText: String? = nil,
        items: [any TableViewCellViewModelProtocol]
    ) {
        self.title = title
        self.footerText = footerText
        self.items = items
    }
}




