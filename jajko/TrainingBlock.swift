//
//  Training.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-24.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

class TrainingBlock : Block {
    static var multitalkerPool = Array(count:Corpus.sharedInstance.sizeOfCorpus(.Training), repeatedValue:[3,4,5,6])
    static var talkersPool = [3,4,5,6]
    
    var contrastIdx:Int!
    var sizeMPWs:Int!
    var repetitions:Int!
    
    var activeCorpus: [MinimalPair]?
    
    override func Size() -> Int {
        return sizeMPWs * 2 * repetitions
    }
    
    class func reset() {
        resetTalkersPool()
        resetMultiTalkersPool()
    }
    
    convenience init(condition:BlockCondition,contrastIndex:Int,andNumberOfMPWs num:Int, repeated times:Int) {
        self.init(condition:condition)
        
        self.contrastIdx = contrastIndex
        self.sizeMPWs = num
        self.repetitions = times
                
        if condition == .SingleTalker {
            var allTalkers:Int = TrainingBlock.talkersPool.count
            if allTalkers == 0 {
                println("WARNING: Important design error. No more talkers available while creating Single-Talker Training Block. Reseting talkersPool and moving on...")
                TrainingBlock.resetTalkersPool()
                allTalkers = TrainingBlock.talkersPool.count
            }
            let randomIdx:Int = Int(arc4random_uniform(UInt32(allTalkers)))
            let randomTalker = TrainingBlock.talkersPool[randomIdx]
            TrainingBlock.talkersPool.removeAtIndex(randomIdx)
            
            for var r = 0 ; r < repetitions ; r++ {
                for var i = 0 ; i < 2*sizeMPWs ; i++ {
                    trials.append(Trial(talker: randomTalker, contrastIndex: contrastIdx, corpusType:.Training))
                }
            }
        } else if condition == .MultiTalker {
            activeCorpus = Corpus.sharedInstance.allMinimalPairWords(.Training,limit:sizeMPWs)
            //Initialize the multitalkerPool:
            var projectedTrials = [Trial]()
            for var i = 0 ; i < activeCorpus!.count ; i++ {
                var talkerPool = TrainingBlock.multitalkerPool[i]
                var allTalkers:Int = talkerPool.count
                if allTalkers == 0 {
                    println("WARNING: Important design error. No more talkers available while creating Multi-Talker Training Block. Reseting multitalkerPool and moving on...")
                    TrainingBlock.resetMultiTalkersPool()
                    talkerPool = TrainingBlock.multitalkerPool[i]
                    allTalkers = talkerPool.count
                }
                let randomIdx:Int = Int(arc4random_uniform(UInt32(allTalkers)))
                let randomTalker = talkerPool[randomIdx]
                talkerPool.removeAtIndex(randomIdx)
                TrainingBlock.multitalkerPool[i] = talkerPool
                
                projectedTrials.append(Trial(mpw: activeCorpus![i], talker: randomTalker))
            }
            
            for var r = 0 ; r < self.repetitions ; r++ {
                let mixedup = projectedTrials.shuffled()
                trials.extend(mixedup)
            }
        } else {
            println("Only Single-talker and Multi-talker Training Blocks are implemented!")
        }
    }
    
    class func resetTalkersPool() {
        TrainingBlock.talkersPool = [3,4,5,6]
    }
    
    class func resetMultiTalkersPool() {
        TrainingBlock.multitalkerPool = Array(count:Corpus.sharedInstance.sizeOfCorpus(.Training), repeatedValue:[3,4,5,6])
    }
}
