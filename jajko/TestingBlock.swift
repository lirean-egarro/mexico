//
//  TestingBlock.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-24.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

class TestingBlock : Block {
    var practiceSize:Int!
    var taskSize:Int!
    var numberOfTests:Int!
    
    override func Size() -> Int {
        return practiceSize + numberOfTests*taskSize
    }
    
    convenience init(condition:BlockCondition,practiceSize:Int,taskSize:Int,andNumberOfTests num:Int) {

        self.init(condition:condition)

        self.practiceSize = practiceSize
        self.taskSize = taskSize
        self.numberOfTests = num
        
        var totalContrasts = count(applicationContrasts)
        
        if condition == .SingleTalker {
            let randomTalker:Int = Int(arc4random_uniform(2)) + 1
            for var i = 0 ; i < practiceSize ; i++ {
                trials.append(Trial(talker: randomTalker, contrastIndex: 0, corpusType:.Test))
            }
            
            for var t = 0 ; t < numberOfTests; t++ {
                for var i = 0 ; i < taskSize ; i++ {
                    var cIdx = t%totalContrasts + 1
                    trials.append(Trial(talker: randomTalker, contrastIndex: cIdx, corpusType:.Test))
                }
            }
            
        } else if condition == .MultiTalker {
            println("Multi-talker Testing Blocks not yet implemented")
        } else {
            println("Only Single-talker Testing Blocks are implemented so far")
        }
    }
}
