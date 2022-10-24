//
//  RectJSONFileParser.swift
//  NitroMacTest-sergejp
//
//  Created by Sergej Pershaj on 21/10/2022.
//

import Foundation

struct RectJSONFileParser {
    
    struct JSONRoot: Decodable {
        let rects: [JSONRect]
    }
    
    struct JSONRect: Decodable {
        // x, y coordinates can be negative, hence signed int
        let x: Int
        let y: Int
        // width and height are "never negative", so unsigned int as a type
        let w: UInt
        let h: UInt
    }
    
    func parse(jsonData data: Data) -> Result<[JSONRect], Error> {
        let decoder = JSONDecoder()
        do {
            let jsonRoot = try decoder.decode(JSONRoot.self, from: data)
            return .success(jsonRoot.rects)
        } catch {
            return .failure(error)
        }
    }
    
}
