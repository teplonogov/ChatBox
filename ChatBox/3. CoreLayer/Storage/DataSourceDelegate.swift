//
//  DataSourceDelegate.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 19/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol DataSourceDelegate: class {
    func beginUpdates()
    func endUpdates()
    
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}
