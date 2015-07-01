//
//  LanguageHelper.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-17.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import Foundation

let languages = [
    "﻿af" : "Afrikaans",
    "sq" : "Albanian",
    "ar" : "Arabic",
    "hy" : "Armenian",
    "eu" : "Basque",
    "bn" : "Bengali",
    "bg" : "Bulgarian",
    "km" : "Cambodian",
    "ca" : "Catalan",
    "zh" : "Chinese (Mandarin)",
    "hr" : "Croatian",
    "cs" : "Czech",
    "da" : "Danish",
    "nl" : "Dutch",
    "en" : "English",
    "ep" : "Esperanto",
    "et" : "Estonian",
    "fj" : "Fijian",
    "fi" : "Finnish",
    "fr" : "French",
    "ka" : "Georgian",
    "de" : "German",
    "el" : "Greek",
    "gu" : "Gurajati",
    "he" : "Hebrew",
    "hi" : "Hindi",
    "hu" : "Hungarian",
    "is" : "Icelandic",
    "id" : "Indonesian",
    "ga" : "Irish (Gaelic)",
    "it" : "Italian",
    "ja" : "Japanese",
    "jw" : "Javanese",
    "ko" : "Korean",
    "la" : "Latin",
    "lv" : "Latvian",
    "lt" : "Lithuanian",
    "mk" : "Macedonian",
    "ms" : "Malay",
    "ml" : "Malayalam",
    "mt" : "Maltese",
    "mi" : "Maori",
    "mr" : "Marathi",
    "mn" : "Mongolian",
    "ne" : "Nepali",
    "no" : "Norwegian",
    "fa" : "Persian (Farsi)",
    "pl" : "Polish",
    "pt" : "Portuguese",
    "pa" : "Punjabi",
    "qu" : "Quechua",
    "ro" : "Romanian",
    "ru" : "Russian",
    "sm" : "Samoan",
    "sr" : "Serbian",
    "sk" : "Slovak",
    "sl" : "Slovenian",
    "es" : "Spanish",
    "sw" : "Swahili",
    "sv" : "Swedish",
    "tg" : "Tagalog",
    "ta" : "Tamil",
    "tt" : "Tatar",
    "th" : "Thai",
    "bo" : "Tibetan",
    "to" : "Tonga",
    "tr" : "Turkish",
    "uk" : "Ukrainian",
    "ur" : "Urdu",
    "uz" : "Uzbek",
    "vi" : "Vietnamese",
    "cy" : "Welsh",
    "xh" : "Xhosa",
    "xx" : "Other"
]

class LanguageHelper : NSObject {
    
    class func allLanguages() -> [String] {
        return (languages as NSDictionary).allValues.map({ $0 as! String }).sorted { $0 < $1 }
    }
    
    class func languageStringFor(code: String) -> String? {
        return languages[code]
    }
    
    class func languageCodeFor(language: String) -> String? {
        var found = false
        var resp:String? = nil
        for (key, value) in languages {
            if language.lowercaseString == value.lowercaseString {
                resp = key
                found = true
                break
            }
        }
        
        if found {
            return resp
        }
        
        //Try a softer match:
        for (key, value) in languages {
            if value.lowercaseString.rangeOfString(language.lowercaseString) != nil {
                return key
            }
        }
       
        return nil
    }
}