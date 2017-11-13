//
//  memento.swift
//  Memento
//
//  Created by victor on 2017. 11. 13..
//  Copyright © 2017년 victor. All rights reserved.
//

import Foundation

protocol Memento {
    // no method properties defined
}

protocol Originator {
    func createMemento() -> Memento
    func applyMemento(memento:Memento)
}

