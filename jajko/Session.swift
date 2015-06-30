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
    var recording:Int? = 0
    
    var contrastIdx:Int! //Index 0 means any random contrast.
    
    var startTime:NSDate?
    var endTime:NSDate?
    
    convenience init(talker:Int,contrastIndex:Int,corpusType:CorpusType,rec:Int) {
        self.init()
        corpus = corpusType
        currentState = .Queued
        talkerID = talker
        recording = rec
        self.contrastIdx = contrastIndex
        self.minimalPair = generatePair(contrastIndex,inCorpus:corpusType)
        
    }
    
    convenience init(mpw:MinimalPair, talker:Int,rec:Int) {
        self.init()
        corpus = mpw.type
        currentState = .Queued
        talkerID = talker
        recording = rec
        self.contrastIdx = mpw.contrastIdx
        self.minimalPair = mpw
    }
    
    func generatePair(contrastIndex:Int,inCorpus type:CorpusType) -> MinimalPair {
        return Corpus.sharedInstance.extractAvailablePairFor(contrastIdx, andType: type)
    }
    
    func audioFileName() -> String {
        return "T" + String(self.talkerID) + self.minimalPair.recordingTag(recording!)
    }
    
    func complementaryFileName() -> String? {
        let r = audioFileName().componentsSeparatedByString("ipa")
        let c = r[1][r[1].startIndex]
        if c == "1" {
            return r[0] + "ipa2" + r[1].substringFromIndex(r[1].startIndex.successor())
        } else if c == "2" {
            return r[0] + "ipa1" + r[1].substringFromIndex(r[1].startIndex.successor())
        }
        return nil
    }
    
    func displayStrings() -> (original: String, value: String?, right: String?, wrong: String?) {
        //Remember MinimalPair object's contrastIdx cannot be zero; it is the number specified on the MinimalPairs.txt file
        let subs = applicationContrasts[minimalPair.contrastIdx - 1]
        let word = minimalPair.ipa1
        
        //Try first occurence from beginning:
        for str in subs {
            let components = split(str) { $0 == "-" }
            let tmpWord1 = word.stringByReplacingOccurrencesOfString(components[0], withString:components[1], options:.LiteralSearch, range:word.rangeOfString(components[0]))
            let tmpWord2 = word.stringByReplacingOccurrencesOfString(components[1], withString:components[0], options:.LiteralSearch, range:word.rangeOfString(components[1]))
            if tmpWord1.lowercaseString == minimalPair.ipa2.lowercaseString {
                let val = word.stringByReplacingOccurrencesOfString(components[0], withString: "❔", options:.LiteralSearch, range:word.rangeOfString(components[0]))
                return (word,val,components[0],components[1])
            } else if tmpWord2.lowercaseString == minimalPair.ipa2.lowercaseString {
                let val = word.stringByReplacingOccurrencesOfString(components[1], withString: "❔", options:.LiteralSearch, range:word.rangeOfString(components[1]))
                return (word,val,components[1],components[0])
            }
        }
        
        //Try first occurence from end:
        for str in subs {
            let components = split(str) { $0 == "-" }
            let tmpWord1 = word.stringByReplacingOccurrencesOfString(components[0], withString:components[1], options:.LiteralSearch, range:word.rangeOfString(components[0], options:.BackwardsSearch))
            let tmpWord2 = word.stringByReplacingOccurrencesOfString(components[1], withString:components[0], options:.LiteralSearch, range:word.rangeOfString(components[1], options:.BackwardsSearch))
            if tmpWord1.lowercaseString == minimalPair.ipa2.lowercaseString {
                let val = word.stringByReplacingOccurrencesOfString(components[0], withString: "❔", options:.LiteralSearch, range:word.rangeOfString(components[0], options:.BackwardsSearch))
                return (word,val,components[0],components[1])
            } else if tmpWord2.lowercaseString == minimalPair.ipa2.lowercaseString {
                let val = word.stringByReplacingOccurrencesOfString(components[1], withString: "❔", options:.LiteralSearch, range:word.rangeOfString(components[1], options:.BackwardsSearch))
                return (word,val,components[1],components[0])
            }
        }
        
        //Try all occurrences!!
        for str in subs {
            let components = split(str) { $0 == "-" }
            let tmpWord1 = word.stringByReplacingOccurrencesOfString(components[0], withString:components[1])
            let tmpWord2 = word.stringByReplacingOccurrencesOfString(components[1], withString:components[0])
            if tmpWord1.lowercaseString == minimalPair.ipa2.lowercaseString {
                let val = word.stringByReplacingOccurrencesOfString(components[0], withString: "❔")
                return (word,val,components[0],components[1])
            } else if tmpWord2.lowercaseString == minimalPair.ipa2.lowercaseString {
                let val = word.stringByReplacingOccurrencesOfString(components[1], withString: "❔")
                return (word,val,components[1],components[0])
            }
        }
        
        return (word,nil,nil,nil)
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
    var trainIdx:Int?
    
    var blocks:[Block]?
    
    convenience init(type:SessionType, trainIdx:Int?) {
        self.init(type: type)
        self.trainIdx = trainIdx
    }
    
    convenience init(type:SessionType) {
        self.init()
        self.type = type
        self.creationDate = NSDate()
        
        self.blocks = [Block]()
        switch type {
        case .Pretest:
#if DEBUG
            blocks!.append(TestingBlock(condition: .SingleTalker, practiceSize: 5, taskSize: 5, andNumberOfTests: 1, isPostTest:false))
#else
            blocks!.append(TestingBlock(condition: .SingleTalker, practiceSize: 10, taskSize: 20, andNumberOfTests: 2, isPostTest:false))
#endif
        case .Training:
#if DEBUG
            blocks!.append(TrainingBlock(condition: .SingleTalker, contrastIndex: 1, andNumberOfMPWs: 2, repeated: 1))
            blocks!.append(TrainingBlock(condition: .SingleTalker, contrastIndex: 2, andNumberOfMPWs: 2, repeated: 1))
#else
            blocks!.append(TrainingBlock(condition: .SingleTalker, contrastIndex: 1, andNumberOfMPWs: 10, repeated: 3))
            blocks!.append(TrainingBlock(condition: .SingleTalker, contrastIndex: 2, andNumberOfMPWs: 10, repeated: 3))
            blocks!.append(TrainingBlock(condition: .SingleTalker, contrastIndex: 1, andNumberOfMPWs: 10, repeated: 3))
            blocks!.append(TrainingBlock(condition: .SingleTalker, contrastIndex: 2, andNumberOfMPWs: 10, repeated: 3))
#endif
        case .Posttest:
#if DEBUG
            blocks!.append(TestingBlock(condition: .SingleTalker, practiceSize: 5, taskSize: 5, andNumberOfTests: 1, isPostTest:true))
#else
            blocks!.append(TestingBlock(condition: .SingleTalker, practiceSize: 10, taskSize: 20, andNumberOfTests: 2, isPostTest:true))
#endif
        }
    }    
}
