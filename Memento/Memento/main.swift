//
//  main.swift
//  Memento
//
//  Created by victor on 2017. 11. 13..
//  Copyright © 2017년 victor. All rights reserved.
//

import Foundation

let ledger = Ledger()

//만약에 엔트리가 100개 이상이라고 하면 99개를 undo한 최초로 추가된 entry로 돌아가려고 할 때 99개에 대한 undoCommand closure를 모두 호출해야 하는 불편함이 있다. 한 번에 할 수 없을까?

ledger.addEntry("Bob", amount: 100.43)
ledger.addEntry("Joe", amount: 200.20)

let memento = ledger.createMemento()

ledger.addEntry("Alice", amount: 500)
ledger.addEntry("Tony", amount: 20)

ledger.printEntries()

ledger.applyMemento(memento: memento)

ledger.printEntries()
