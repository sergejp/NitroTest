//
//  MainViewModel.swift
//  NitroMacTest-sergejp
//
//  Created by Sergej Pershaj on 21/10/2022.
//

import Foundation

final class MainViewModel {

    enum FileType: String, CaseIterable {
        case json
    }
    
    private let allowedFileTypes = [
        FileType.json.rawValue,
    ]
    
    enum FindIntersectionsError: Error {
        case loadFileError(URL, Error)
        case parseFileError(URL, Error)

        var description: String {
            switch self {
            case .loadFileError(let url, let error):
                return "Couldn't load file located at \"\(url)\". Underlying error: \(error)"
            case .parseFileError(let url, let error):
                return "Couldn't parse file located at \"\(url)\". Underlying error: \(error)"
            }
        }
    }
    
    struct FindIntersectionsResult {
        let log: String
        let totalRects: String
        let totalIntersections: String
    }
    
    private let rectsProcessingLimit = 10
    
    func findIntersections(inRectsFrom url: URL) -> Result<FindIntersectionsResult, FindIntersectionsError> {
        do {
            let data = try Data(contentsOf: url)
            let result = RectJSONFileParser().parse(jsonData: data)
            switch result {
            case .success(let jsonRects):
                var rects = [Rect]()
                let itemsCount = min(rectsProcessingLimit, jsonRects.count);
                for (i, jsonRect) in jsonRects[..<itemsCount].enumerated() {
                    let rect = Rect(id: UInt(i + 1), x: jsonRect.x, y: jsonRect.y, w: jsonRect.w, h: jsonRect.h)
                    rects.append(rect)
                }
                
                let finder = RectIntersectionFinder()
                let intersections = finder.find(in: rects)
                
                let totalRects = "\(rects.count)"
                let totalIntersections = "\(intersections.count)"
                let log = produceHumanReadableLog(from: rects, and: intersections)
                
                return .success(FindIntersectionsResult(
                        log: log,
                        totalRects: totalRects,
                        totalIntersections: totalIntersections))
            case .failure(let error):
                return .failure(.parseFileError(url, error))
            }
        } catch {
            return .failure(.loadFileError(url, error))
        }
    }
    
    private func produceHumanReadableLog(from rects: [Rect], and intersections: Set<RectIntersection>) -> String {
        var log = ""
        let padding = "    "
        log += "Input:\n"
        
        guard !rects.isEmpty else {
            log += "\(padding)No rectangles were loaded from the file. Please select another file.\n"
            return log
        }
        
        for (index, rect) in rects.enumerated() {
            log += "\(padding)\(index + 1): Rectangle at (\(rect.x), \(rect.y)), w=\(rect.w), h=\(rect.h).\n"
        }
        
        log += "\n"
        log += "Intersections:\n"
        
        guard !intersections.isEmpty else {
            log += "\(padding)There are no intersections for the provided rectangles.\n"
            return log
        }
        
        for intersection in intersections {
            var participatingRects = ""
            var intersectionRects = Array(intersection.rects)
            intersectionRects.sort()
            let lastIndex = intersectionRects.count - 1
            for (index, rect) in intersectionRects[..<lastIndex].enumerated() {
                participatingRects += "\(rect.id)\(index < lastIndex - 1 ? ", " : " ")"
            }
            participatingRects += "and \(intersectionRects[lastIndex].id)"
            log += "    Between rectangle \(participatingRects) at (\(intersection.area.x), \(intersection.area.y)), w=\(intersection.area.w), h=\(intersection.area.h).\n"
        }
        return log
    }
    
    func shouldAllow(openPanelFileSelection url: URL) -> Bool {
        // a deeper file introspection would be needed if it's security sensitive
        for type in allowedFileTypes {
            if url.pathExtension == type {
                return true
            }
        }
        return false
    }
    
}
