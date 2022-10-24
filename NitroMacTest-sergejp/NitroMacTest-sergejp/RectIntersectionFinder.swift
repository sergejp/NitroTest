//
//  RectIntersectionFinder.swift
//  NitroMacTest-sergejp
//
//  Created by Sergej Pershaj on 21/10/2022.
//

import Foundation

struct RectIntersectionFinder {
    
    func find(in rects: [Rect]) -> Set<RectIntersection> {
        // duplicates will be dismissed automatically with a Set
        var result = Set<RectIntersection>()
        var elements = Array(rects[...])
        var rectsWithIntersections = Set<Rect>()
        // first pass computes basic intersections between rects
        // i.e. rect pairs with common areas
        // O(n^2)
        while let r1 = elements.popLast() {
            for r2 in elements {
                // kinda O(1), although there is quite a bit of ops inside `intersectionArea`
                guard let area = r1.intersectionArea(with: r2) else {
                    continue
                }
                let newIntersection = RectIntersection(area: area, rects: [r1, r2])
                // O(1) on avg
                result.insert(newIntersection)
                // O(1) on avg
                rectsWithIntersections.insert(r1)
                rectsWithIntersections.insert(r2)
            }
        }
        
        // second pass computes intersections between rects and intersections
        // already in the result
        var intersections = Set(result[...])
        
        // Correctness
        // Comes from the fact that this is exhaustive search as it goes
        // through ALL intersections progressively and checks each of them
        // against ALL rects available
        //
        // Time complexity
        // The number of max intersections between rects grows ~exponentially
        // It is basically a number of possible combinations where we make
        // unordered selection like (rect1, rect2), (rect1, rect2, rect3), ... (rect1, rect2, ... rectN)
        // So for 3 rects it is 4 intersections max (i.e. upper bound 2^3)
        // for 4 rects it is 11 intersections max (i.e. upper bound 2^4)
        // for 5 rects it is 26 intersections max (i.e. upper bound 2^5)
        // for 6 rects it is 57 intersections max (i.e. upper bound 2^6)
        // So it seems the max number of inner loop iterations here is O(2^n * n),
        // where `2^n` is the max number of intersections and `n` is the number of rects
        // Ouch!
        while let intersection = intersections.popFirst() {
            for rect in rectsWithIntersections {
                // don't compute for rects which have already been added to the intersection
                // O(1)
                guard !intersection.rects.contains(rect) else {
                    continue
                }
                // kinda O(1), see `intersectionArea` for number of ops
                guard let area = rect.intersectionArea(with: intersection.area) else {
                    continue
                }
                
                // hard to find time complexity for Set's union operation, but logically
                // it should be `insert` for each item in the `other` set, so in this case
                // it would be O(1) as it's only one element in the `other` set
                let newIntersection = RectIntersection(area: area, rects: intersection.rects.union([rect]))
                
                // we add intersection inside the loop, so the loop extends all the time
                intersections.insert(newIntersection)
                
                // add intersection to final result as well
                result.insert(newIntersection)
            }
        }

        return result
    }
    
}
