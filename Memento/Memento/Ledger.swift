//
//  Ledger.swift
//  Memento
//
//  Created by victor on 2017. 11. 13..
//  Copyright © 2017년 victor. All rights reserved.
//

import Foundation

class LedgerEntry {//(사전, 장부, 일기 등의 개별) 항목
    let id:Int
    let counterParty:String //(계약 등의) 한쪽 당사자, 거래 상대방
    let amount:Float
    
    init(id:Int, counterParty:String, amount:Float) {
        self.id = id; self.counterParty = counterParty; self.amount = amount
    }
}

class LedgerCommand {
    private let instructions:(Ledger) -> Void
    private let receiver:Ledger
    
    init(instructions:@escaping (Ledger) -> Void, receiver:Ledger) {
        self.instructions = instructions; self.receiver = receiver
    }
    
    func execute() {
        self.instructions(self.receiver)
    }
}

class Ledger { //(은행, 사업체 등에서 거래 내역을 적은) 원장, 금전 출납부
    private var entries = [Int:LedgerEntry]()
    private var nextId = 1
    var total:Float = 0
    
    func addEntry(_ counterParty:String, amount:Float) -> LedgerCommand {
        let entry = LedgerEntry(id: nextId, counterParty: counterParty, amount: amount)
        entries[entry.id] = entry
        total += amount
        nextId += 1
        return createUndoCommand(entry)
    }
    
    private func createUndoCommand(_ entry:LedgerEntry) -> LedgerCommand {
        return LedgerCommand(instructions: { target in //target에 자동으로 Ledger가 들어가는 이유? -> receiver 를 인자로 넘기기 때문
            let removed = target.entries.removeValue(forKey: entry.id)
            if removed != nil {
                target.total -= removed!.amount
            }
        }, receiver: self)
    }
    
    func printEntries() {
        for id in entries.keys.sorted(by: <){ //순서대로 저장했지만 왜 정렬이 되어 있지 않나? 해쉬 함수와 관련 있는 것인가?
            if let entry = entries[id] {
                print("#\(id): \(entry.counterParty) $\(entry.amount)")
            }
        }
        print("Total: $\(total)")
        print("----")
    }
}
