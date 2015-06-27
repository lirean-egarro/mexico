//
//  Corpus.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-23.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

typealias Contrast = [String]

let contrast1:Contrast = ["ś-sz","si-szi","ć-cz"]
let contrast2:Contrast = ["ź-ż","zi-żi"]

let applicationContrasts = [contrast1,contrast2]

enum CorpusType: Int {
    case Training = 0, Test
}

enum MPWOrder:Int {
    case Original = 0, Reversed
}

struct MinimalPair : Hashable {
    var uid:Int
    var mpw:Int
    var ipa1:String
    var ipa2:String
    var type:CorpusType
    var contrastIdx:Int // <-- Minimal Pair contrastIdx cannot be zero.
    var order:MPWOrder
    
    init(uid: Int, mpw:Int,ipa1:String,ipa2:String,type:CorpusType,contrastIndex:Int,order:MPWOrder) {
        self.uid = uid
        self.mpw = mpw
        self.ipa1 = ipa1
        self.ipa2 = ipa2
        self.type = type
        self.contrastIdx = contrastIndex
        self.order = order
    }
    
    func recordingTag() -> String {
        var resp = "ct" + String(contrastIdx) + "mpw"
        
        switch (type, order) {
        case (.Training, .Original):
            resp += String(format: "%02dipa1rec", mpw)
        case (.Training, .Reversed):
            resp += String(format: "%02dipa2rec", mpw)
        case (.Test, .Original):
            resp += String(format: "%dipa1rec", mpw)
        case (.Test, .Reversed):
            resp += String(format: "%dipa2rec", mpw)
        default:
            println("(type,order) = (\(type),\(order)) not found")
        }
        
        return resp
    }
    
    var hashValue: Int {
        return self.uid
    }
}

//This is our Corpus singleton:
class Corpus: NSObject {
    var usedPairs:[MinimalPair]!
    var minimalPairWords:[MinimalPair]!
    
    override init() {
        //Read the file and fill in the corpus:
        usedPairs = [MinimalPair]()
        minimalPairWords = [MinimalPair]()
        
        if let txtPath = NSBundle.mainBundle().pathForResource("MinimalPairs", ofType: "txt") {
            if let file = String(contentsOfFile: txtPath, encoding: NSUTF8StringEncoding, error: nil) {
                let allLines = file.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "\r\n"))
                var i = 0
                for line in allLines {
                    let tmpPieces = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter({!isEmpty($0)})
                    if count(tmpPieces) > 5 {
                        let mpw = tmpPieces[0].toInt()
                        let ipa1 = tmpPieces[1]
                        let ipa2 = tmpPieces[3]
                        let contrast = tmpPieces[5].toInt()
                        
                        var pair:MinimalPair?
                        switch tmpPieces[4] {
                        case "test":
                            pair = MinimalPair(uid:i, mpw: mpw!, ipa1: ipa1, ipa2: ipa2, type: .Test, contrastIndex: contrast!,order:.Original)
                            minimalPairWords.append(pair!)
                        case "train":
                            pair = MinimalPair(uid:i, mpw: mpw!, ipa1: ipa1, ipa2: ipa2, type: .Training, contrastIndex: contrast!,order:.Original)
                            minimalPairWords.append(pair!)
                        default:
                            println("Unknown Type found for minimal pair word: \(tmpPieces[4])")
                        }
                        
                        //Also append the reversed words:
                        minimalPairWords.append(~(pair!))
                        i++
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
                
        super.init()
    }

    class var sharedInstance : Corpus {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : Corpus? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Corpus()
        }
        return Static.instance!
    }

    func reset() {
        println("WARNING: Reseting corpus")
        for tmp in usedPairs {
            minimalPairWords.append(tmp)
        }
        usedPairs.removeAll(keepCapacity: false)
    }
    
    func extractAvailablePairFor(contrast:Int,andType type:CorpusType) -> MinimalPair {
        //Remember that contrast = 0 means any contrast index!
        if minimalPairWords.count == 0 {
            println("WARNING: No more mpw's available in the corpus and requesting one. Calling Corpus.reset()!")
            self.reset()
        }
        
        var filteringClosure = { (mp:MinimalPair) -> Bool in
            return mp.contrastIdx == contrast && mp.type == type
        }
        
        if contrast == 0 {
            filteringClosure = { (mp:MinimalPair) -> Bool in
                return mp.type == type
            }
        }
        
        let filteredPool = Set(minimalPairWords.filter(filteringClosure))
        let discardPool = Set(usedPairs)
        let possiblePairs = filteredPool.subtract(discardPool)
        if possiblePairs.count == 0 {
            println("WARNING: Cannot find a mpw with contrast \(contrast) and type \(type.rawValue) in the remaining corpus \(usedPairs.count)/\(minimalPairWords.count). Calling Corpus.reset() and trying again!")
            self.reset()
            return self.extractAvailablePairFor(contrast,andType:type)
        }
        
        let resp = randomElement(possiblePairs)
        usedPairs.append(resp)
        minimalPairWords = minimalPairWords.filter({ $0.uid != resp.uid })
        
        return resp
    }
    
    func allMinimalPairWords(type:CorpusType,limit:Int) -> [MinimalPair] {
        self.reset()
        if limit < 0 {
            return minimalPairWords.filter({ $0.type == type })
        }
        
        var subSet: ArraySlice<MinimalPair> = minimalPairWords.filter({ $0.type == type })[0..<limit]
        return Array(subSet)
    }
    
    func sizeOfCorpus(type:CorpusType) -> Int {
        return allMinimalPairWords(type, limit:-1).count
    }
    
}