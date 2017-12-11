//
//  VocabDB.swift
//  Boggle
//
//  Created by Shuo Huang on 10/28/17.
//  Copyright © 2017 Shuo Huang. All rights reserved.
//

import Foundation

let alphaIndex: [Character: Int] = ["a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5, "g": 6, "h": 7, "i": 8, "j": 9, "k": 10, "l": 11, "m": 12, "n": 13, "o": 14, "p": 15, "q": 16, "r": 17, "s": 18, "t": 19, "u": 20, "v": 21, "w": 22, "x": 23, "y": 24, "z": 25]

class TrieNode {
    var children = [TrieNode?](repeating: nil, count: 26)
    var isWord = false
}
let node = TrieNode()

class Trie {
    let root = TrieNode()
    
    func insert(word: String) {
        var node = root
        for c in word {
            if node.children[alphaIndex[c]!] == nil {
                node.children[alphaIndex[c]!] = TrieNode()
            }
            node = node.children[alphaIndex[c]!]!
        }
        
        node.isWord = true
    }
    
    func search(word: String) -> Bool {
        var node = root
        for c in word.lowercased() {
            if node.children[alphaIndex[c]!] == nil {
                return false
            }
            
            node = node.children[alphaIndex[c]!]!
        }
        return node.isWord
    }
}

class VocabDB {
    static var sharedDB = VocabDB(fileName: "corpus")
    var dictTrie = Trie()
    init(fileName: String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let vocabList = data.components(separatedBy: .newlines)
                for vocab in vocabList {
                    dictTrie.insert(word: vocab)
                }
            } catch {
                print(error)
            }
        }
    }
}
