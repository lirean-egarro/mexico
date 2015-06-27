//
//  Session.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-24.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

enum BlockCondition {
    case SingleTalker
    case SynteticTalker
    case MultiTalker
    case SynteticMultiTalker
}

enum SessionType {
    case Pretest
    case Training
    case Posttest
}

enum TrialState {
    case Right
    case Wrong
    case Queued
    case InProgress
}

class Trial : NSObject {
    var talkerID:Int!
    var minimalPair:MinimalPair!
    var corpus:CorpusType!
    var currentState:TrialState!
    
    var contrastIdx:Int! //Index 0 means any random contrast.
    
    var startTime:NSDate?
    var endTime:NSDate?
    
    convenience init(talker:Int,contrastIndex:Int,corpusType:CorpusType) {
        self.init()
        corpus = corpusType
        currentState = .Queued
        talkerID = talker
        self.contrastIdx = contrastIndex
        self.minimalPair = generatePair(contrastIndex,inCorpus:corpusType)
    }
    
    convenience init(mpw:MinimalPair, talker:Int) {
        self.init()
        corpus = mpw.type
        currentState = .Queued
        talkerID = talker
        self.contrastIdx = mpw.contrastIdx
        self.minimalPair = mpw
    }
    
    func generatePair(contrastIndex:Int,inCorpus type:CorpusType) -> MinimalPair {
        return Corpus.sharedInstance.extractAvailablePairFor(contrastIdx, andType: type)
    }
    
    func displayString() -> String {
        //Remember MinimalPair object's contrastIdx cannot be zero; it is the number specified on the MinimalPairs.txt file
        let subs = applicationContrasts[minimalPair.contrastIdx - 1]
        let word = minimalPair.ipa1
        var newWord = word
        for str in subs {
            let components = split(str) { $0 == "-" }
            let tmpWord = word.stringByReplacingOccurrencesOfString(components[0], withString:components[1])
            if tmpWord == minimalPair.ipa2 {
                var replacementString = ""
                for t in 0..<count(components[0]) {
                    replacementString += "❔"
                }
                newWord = word.stringByReplacingOccurrencesOfString(components[0], withString: replacementString)
                break
            }
        }
        
        return newWord
    }
}

class Block : NSObject {
    var condition:BlockCondition!
    var trials:[Trial]!
    
    convenience init(condition:BlockCondition) {
        self.init()
        self.condition = condition
        self.trials = [Trial]()
    }
    
    func Size() -> Int {
        return 0
    }
}

class Session : NSObject {
    var type:SessionType!
    var creationDate:NSDate?
    var startTime:NSDate?
    var endTime:NSDate?
    
    var blocks:[Block]?
    
    convenience init(type:SessionType) {
        self.init()
        self.type = type
        self.creationDate = NSDate()
        
        self.blocks = [Block]()
        switch type {
        case .Pretest:
            blocks!.append(TestingBlock(condition: .SingleTalker, practiceSize: 10, taskSize: 20, andNumberOfTests: 2))
//          blocks!.append(TestingBlock(condition: .MultiTalker, practiceSize: 10, taskSize: 20, andNumberOfTests: 2))
        case .Training:
            blocks!.append(TrainingBlock(condition: .MultiTalker, contrastIndex: 1, andNumberOfMPWs: 10, repeated: 3))
            blocks!.append(TrainingBlock(condition: .MultiTalker, contrastIndex: 1, andNumberOfMPWs: 10, repeated: 3))
            blocks!.append(TrainingBlock(condition: .MultiTalker, contrastIndex: 1, andNumberOfMPWs: 10, repeated: 3))
            blocks!.append(TrainingBlock(condition: .MultiTalker, contrastIndex: 1, andNumberOfMPWs: 10, repeated: 3))
        case .Posttest:
            blocks!.append(TestingBlock(condition: .SingleTalker, practiceSize: 10, taskSize: 20, andNumberOfTests: 2))
//          blocks!.append(TestingBlock(condition: .MultiTalker, practiceSize: 10, taskSize: 20, andNumberOfTests: 2))
        }
    }    
}
