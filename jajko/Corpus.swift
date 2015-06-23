//
//  Corpus.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-23.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

enum CorpusType {
    case Training
    case Test
}

class MinimalPair : NSObject {
    var mpw:Int!
    var ipa1:String!
    var ipa2:String!
    var type:CorpusType!
    var contrast:Int!
    
    convenience init(mpw:Int,ipa1:String,ipa2:String,type:CorpusType,contrast:Int) {
        self.init()
        self.mpw = mpw
        self.ipa1 = ipa1
        self.ipa2 = ipa2
        self.type = type
        self.contrast = contrast
    }
    
    func recordingID(ipa:Int) -> String {
        var resp = "ct" + String(contrast) + "mpw"
        
        switch (type!) {
        case .Training:
            resp += String(format: "%02dipa%drec", mpw,ipa)
        case .Test:
            resp += String(format: "%dipa%drec", mpw,ipa)
        default:
            println("CorpusType not found")
        }
        
        return resp
    }
}


class Corpus: NSObject {
    let contrast1 = ["ś-sz","si-szi","ć-cz"]
    let contrast2 = ["ź-ż","zi-żi"]
    
    var contrasts:[Array<String>]!
    var minimalPairWords:[MinimalPair]!
    
    override init() {
        contrasts = [contrast1,contrast2]
        //Read the file and fill in the corpus:
        minimalPairWords = [MinimalPair]()
        
        if let txtPath = NSBundle.mainBundle().pathForResource("MinimalPairs", ofType: "txt") {
            if let file = String(contentsOfFile: txtPath, encoding: NSUTF8StringEncoding, error: nil) {
                let allLines = file.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "\r\n"))
                for line in allLines {
                    let tmpPieces = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter({!isEmpty($0)})
                    if count(tmpPieces) > 5 {
                        let mpw = tmpPieces[0].toInt()
                        let ipa1 = tmpPieces[1]
                        let ipa2 = tmpPieces[3]
                        let contrast = tmpPieces[5].toInt()
                        
                        switch tmpPieces[4] {
                            case "test":
                                minimalPairWords.append(MinimalPair(mpw: mpw!, ipa1: ipa1, ipa2: ipa2, type: .Test, contrast: contrast!))
                            case "train":
                                minimalPairWords.append(MinimalPair(mpw: mpw!, ipa1: ipa1, ipa2: ipa2, type: .Training, contrast: contrast!))
                            default:
                                println("Unknown Type found for minimal pair word: \(tmpPieces[4])")
                        }
                    } else {
                        println("Cannot process line from file: \(line)")
                    }
                }
            } else {
                println("Problems interpreting MinimalPairs.txt into String")
            }
        } else {
            println("Problems reading file MinimalPairs.txt from Bundle")
        }
        
        println("MinimalPair words: \(count(minimalPairWords))")
        super.init()
    }

    
}