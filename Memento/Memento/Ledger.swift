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

class LedgerMemento:Memento {
    var jsonData:String?
    
    init(ledger:Ledger) {
        self.jsonData = stringify(ledger: ledger)
        print(self.jsonData)
    }
    
    init(json:String?) {
        self.jsonData = json
    }
    
    private func stringify(ledger:Ledger)->String? {
        var dict = NSMutableDictionary()
        dict["total"] = ledger.total
        dict["nextId"] = ledger.nextId
        dict["entries"] = Array(ledger.entries.values.map{$0})

        var entryArray = [NSDictionary]()
        
        for entry in ledger.entries.values {
            var entryDict = NSMutableDictionary()
            entryArray.append(entryDict)
            //entryDict의 값을 append 후에 변경해도 적용되는가?
            entryDict["id"] = entry.id
            entryDict["counterParty"] = entry.counterParty
            entryDict["amount"] = entry.amount
        }
        
        dict["entries"] = entryArray
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
        }
        return nil
    }
    
    func apply(ledger:Ledger) {
        if let data = jsonData?.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                ledger.total = dict!["total"] as! Float
                ledger.nextId = dict!["nextId"] as! Int
                ledger.entries.removeAll(keepingCapacity: true)
                if let entryDicts = dict!["entries"] as? [NSDictionary] {
                    for dict in entryDicts {
                        let id = dict["id"] as! Int
                        let counterParty = dict["counterParty"] as! String
                        let amount = dict["amount"] as! Float
                        ledger.entries[id] = LedgerEntry(id: id, counterParty: counterParty, amount: amount)
                    }
                }
            }
        }
        
    }
}
/*class LedgerMemento:Memento {
    private let entries:[LedgerEntry]
    private let total:Float
    private let nextId:Int

    init(ledger:Ledger) {
        self.entries = Array(ledger.entries.values.map{$0})
        self.total = ledger.total
        self.nextId = ledger.nextId
    }
    
    func apply(ledger:Ledger) {
        ledger.total = self.total
        ledger.nextId = self.nextId
        ledger.entries.removeAll(keepingCapacity: true)
        for entry in self.entries {
            ledger.entries[entry.id] = entry
        }
    }
}*/

/*class LedgerCommand {
    private let instructions:(Ledger) -> Void
    private let receiver:Ledger
    
    init(instructions:@escaping (Ledger) -> Void, receiver:Ledger) {
        self.instructions = instructions; self.receiver = receiver
    }
    
    func execute() {
        self.instructions(self.receiver)
    }
}*/

class Ledger:Originator { //(은행, 사업체 등에서 거래 내역을 적은) 원장, 금전 출납부
    fileprivate var entries = [Int:LedgerEntry]()
    fileprivate var nextId = 1
    var total:Float = 0
    
    func addEntry(_ counterParty:String, amount:Float) /*-> LedgerCommand*/ {
        let entry = LedgerEntry(id: nextId, counterParty: counterParty, amount: amount)
        entries[entry.id] = entry
        total += amount
        nextId += 1
        /*return createUndoCommand(entry)*/
    }
    
    func createMemento() -> Memento {
        return LedgerMemento(ledger: self)
    }
    
    func applyMemento(memento: Memento) {
        if let m = memento as? LedgerMemento {
            m.apply(ledger: self)
        }
    }
    
//    private func createUndoCommand(_ entry:LedgerEntry) -> LedgerCommand {
//        return LedgerCommand(instructions: { target in //target에 자동으로 Ledger가 들어가는 이유? -> receiver 를 인자로 넘기기 때문
//            let removed = target.entries.removeValue(forKey: entry.id)
//            if removed != nil {
//                target.total -= removed!.amount
//            }
//        }, receiver: self)
//    }
    
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
