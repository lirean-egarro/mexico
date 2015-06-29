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
    var isPostTest:Bool!
    
    override func Size() -> Int {
        return practiceSize + numberOfTests*taskSize
    }
    
    convenience init(condition:BlockCondition,practiceSize:Int,taskSize:Int,andNumberOfTests num:Int,isPostTest:Bool) {

        self.init(condition:condition)

        self.practiceSize = practiceSize
        self.taskSize = taskSize
        self.numberOfTests = num
        self.isPostTest = isPostTest
        
        var totalContrasts = count(applicationContrasts)
        
        if condition == .SingleTalker {
            let rTalker:Int = Int(arc4random_uniform(4)) + 3
            var base:Int = 1
            for var i = 0 ; i < practiceSize ; i++ {
                trials.append(Trial(talker: rTalker, contrastIndex: 0, corpusType:.Training, rec:(i%2)+base))
            }

            let randomTalker:Int = Int(arc4random_uniform(2)) + 1
            base = 1
            if isPostTest {
                //Use recordings "3 & 4"
                base = 3
            }
            for var t = 0 ; t < numberOfTests; t++ {
                for var i = 0 ; i < taskSize ; i++ {
                    var cIdx = t%totalContrasts + 1
                    trials.append(Trial(talker: randomTalker, contrastIndex: cIdx, corpusType:.Test, rec:((t+1)%2)+base))
                }
            }
            
        } else if condition == .MultiTalker {
            println("Multi-talker Testing Blocks not yet implemented")
        } else {
            println("Only Single-talker Testing Blocks are implemented so far")
        }
    }
}
