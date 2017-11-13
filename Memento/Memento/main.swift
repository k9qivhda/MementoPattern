//
//  main.swift
//  Memento
//
//  Created by victor on 2017. 11. 13..
//  Copyright © 2017년 victor. All rights reserved.
//

import Foundation

let ledger = Ledger()


let undoCommand1 = ledger.addEntry("Bob", amount: 100.43)
ledger.addEntry("Joe", amount: 200.20)
let undoCommand2 = ledger.addEntry("Alice", amount: 500)
ledger.addEntry("Tony", amount: 20)

ledger.printEntries()
undoCommand1.execute()
ledger.printEntries()
undoCommand2.execute()
ledger.printEntries()

