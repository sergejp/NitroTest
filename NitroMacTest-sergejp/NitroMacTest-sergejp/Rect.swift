//
//  Rect.swift
//  NitroMacTest-sergejp
//
//  Created by Sergej Pershaj on 21/10/2022.
//

import Foundation

struct Rect: Hashable, Comparable, RectRepresentable {
    static func < (lhs: Rect, rhs: Rect) -> Bool {
        lhs.id < rhs.id
    }
    
    let id: UInt
    // x, y coordinates can be negative, hence signed int
    let x: Int
    let y: Int
    // width and height are "never negative", so unsigned int as a type
    let w: UInt
    let h: UInt
}

struct Area: Hashable, RectRepresentable {
    let x: Int
    let y: Int
    let w: UInt
    let h: UInt
}

struct RectIntersection: Hashable {
    let area: Area
    let rects: Set<Rect>
}

protocol RectRepresentable: Hashable {
    var x: Int { get }
    var y: Int { get }
    var w: UInt { get }
    var h: UInt { get }
}

extension RectRepresentable {
    
    func hasZeroArea() -> Bool {
        w == 0 || h == 0
    }
    
    func intersectionArea<T: RectRepresentable>(with other: T) -> Area? {
        guard !self.hasZeroArea() && !other.hasZeroArea() else {
            return nil
        }
        
        let rightEdge = self.x + Int(self.w)
        guard other.x < rightEdge else {
            return nil
        }
        
        let bottomEdge = self.y + Int(self.h)
        guard other.y < bottomEdge else {
            return nil
        }
        
        guard other.x + Int(other.w) > self.x else {
            return nil
        }
        
        guard other.y + Int(other.h) > self.y else {
            return nil
        }
        
        return Area(
            x: max(self.x, other.x),
            y: max(self.y, other.y),
            w: UInt(min(rightEdge, other.x + Int(other.w)) - max(self.x, other.x)),
            h: UInt(min(bottomEdge, other.y + Int(other.h)) - max(self.y, other.y)))
    }
    
}
