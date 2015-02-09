//
//  Pinocchio.swift
//  Pinocchio
//
//  Created by Ben Cochran on 2/8/15.
//  Copyright (c) 2015 Ben Cochran. All rights reserved.
//

import UIKit

// MARK: Assignment

public func ==(left: ConstantConstrainable, right: CGFloat) -> NSLayoutConstraint {
    return left.constraintTo(right, relation: .Equal)
}

public func ==(left: Constrainable, right: Comparable) -> NSLayoutConstraint {
    return left == right.constraint
}

public func ==(left: Constrainable, right: Comparison) -> NSLayoutConstraint {
    return left.constraintTo(right, relation: .Equal)
}

public func >=(left: ConstantConstrainable, right: CGFloat) -> NSLayoutConstraint {
    return left.constraintTo(right, relation: .GreaterThanOrEqual)
}

public func >=(left: Constrainable, right: Comparable) -> NSLayoutConstraint {
    return left >= right.constraint
}

public func >=(left: Constrainable, right: Comparison) -> NSLayoutConstraint {
    return left.constraintTo(right, relation: .GreaterThanOrEqual)
}

public func <=(left: ConstantConstrainable, right: CGFloat) -> NSLayoutConstraint {
    return left.constraintTo(right, relation: .LessThanOrEqual)
}

public func <=(left: Constrainable, right: Comparable) -> NSLayoutConstraint {
    return left <= right.constraint
}

public func <=(left: Constrainable, right: Comparison) -> NSLayoutConstraint {
    return left.constraintTo(right, relation: .LessThanOrEqual)
}

// MARK: Math Operators

public func +(left: Comparable, right: CGFloat) -> Comparison
{
    var constraint = left.constraint
    constraint.constant = right
    return constraint
}

public func -(left: Comparable, right: CGFloat) -> Comparison
{
    var constraint = left.constraint
    constraint.constant = -right
    return constraint
}

public func *(left: Comparable, right: CGFloat) -> Comparison
{
    var constraint = left.constraint
    constraint.multiplier = right
    return constraint
}

public func /(left: Comparable, right: CGFloat) -> Comparison
{
    var constraint = left.constraint
    constraint.multiplier = 1/right
    return constraint
}

public func +(left: Comparison, right: CGFloat) -> Comparison
{
    var constraint = left
    constraint.multiplier = right
    return constraint
}

public func -(left: Comparison, right: CGFloat) -> Comparison
{
    var constraint = left
    constraint.multiplier = -right
    return constraint
}

// MARK: Priority Operator

infix operator % { associativity left precedence 90 }

public func %(left: NSLayoutConstraint, right: UILayoutPriority) -> NSLayoutConstraint {
    let constraint = left.copyContraint()
    constraint.priority = right
    return constraint
}

// MARK: Comment Operator

infix operator || { associativity left precedence 90 }

public func ||(left: NSLayoutConstraint, right: String) -> NSLayoutConstraint {
    let constraint = left.copyContraint()
    constraint.identifier = right
    return constraint
}

// MARK: UIView support

public extension UIView {
    public var left: Constrainable {
        return ViewProperty(self, .Left)
    }
    public var right: Constrainable {
        return ViewProperty(self, .Right)
    }
    public var top: Constrainable {
        return ViewProperty(self, .Top)
    }
    public var bottom: Constrainable {
        return ViewProperty(self, .Bottom)
    }
    public var leading: Constrainable {
        return ViewProperty(self, .Leading)
    }
    public var trailing: Constrainable {
        return ViewProperty(self, .Trailing)
    }
    public var width: ConstantConstrainable {
        return ViewProperty(self, .Width)
    }
    public var height: ConstantConstrainable {
        return ViewProperty(self, .Height)
    }
    public var centerX: Constrainable {
        return ViewProperty(self, .CenterX)
    }
    public var centerY: Constrainable {
        return ViewProperty(self, .CenterY)
    }
    public var baseline: Constrainable {
        return ViewProperty(self, .Baseline)
    }
    public var firstBaseline: Constrainable {
        return ViewProperty(self, .FirstBaseline)
    }
}

// MARK: UIViewController support

public extension UIViewController {
    public var topLayoutGuideTop: Comparable {
        return LayoutSupportProperty(self.topLayoutGuide, .Top)
    }
    public var topLayoutGuideBottom: Comparable {
        return LayoutSupportProperty(self.topLayoutGuide, .Bottom)
    }
    public var topLayoutGuideCenterY: Comparable {
        return LayoutSupportProperty(self.topLayoutGuide, .CenterY)
    }
    public var bottomLayoutGuideTop: Comparable {
        return LayoutSupportProperty(self.bottomLayoutGuide, .Top)
    }
    public var bottomLayoutGuideBottom: Comparable {
        return LayoutSupportProperty(self.bottomLayoutGuide, .Bottom)
    }
    public var bottomLayoutGuideCenterY: Comparable {
        return LayoutSupportProperty(self.bottomLayoutGuide, .CenterY)
    }
}

// MARK: Data Types

public enum ComparableSubject {
    case View(UIView)
    case LayoutSupport(UILayoutSupport)
    
    private var constraintItem: AnyObject {
        switch self {
        case .View(let view):
            return view
        case .LayoutSupport(let layoutSupport):
            return layoutSupport
        }
    }
}

public protocol Constrainable: Comparable {
    var view: UIView { get }
    var attribute: NSLayoutAttribute { get }
    
    func constraintTo(constraint: Comparison, relation: NSLayoutRelation) -> NSLayoutConstraint
}

public protocol ConstantConstrainable: Constrainable {
    func constraintTo(constant: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint
}

public protocol Comparable {
    var item: ComparableSubject { get }
    var attribute: NSLayoutAttribute { get }
    
    var constraint: Comparison { get }
}

public struct Comparison {
    let item: ComparableSubject
    let attribute: NSLayoutAttribute
    var multiplier: CGFloat
    var constant: CGFloat
}

// MARK: Private Data Structures

private struct ViewProperty: Constrainable, ConstantConstrainable, Comparable {
    let view: UIView
    let attribute: NSLayoutAttribute
    var item: ComparableSubject { return .View(view) }
    
    init(_ view: UIView, _ attribute: NSLayoutAttribute)
    {
        self.view = view
        self.attribute = attribute
    }
    
    var constraint: Comparison {
        return Comparison(item: .View(view), attribute: attribute, multiplier: 1, constant: 0)
    }
    
    func constraintTo(constraint: Comparison, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view,
            attribute: attribute,
            relatedBy: relation,
            toItem: constraint.item.constraintItem,
            attribute: constraint.attribute,
            multiplier: constraint.multiplier,
            constant: constraint.constant)
    }
    
    func constraintTo(constant: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view,
            attribute: attribute,
            relatedBy: relation,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 0,
            constant: constant)
    }
}

private struct LayoutSupportProperty: Comparable {
    let item: ComparableSubject
    let attribute: NSLayoutAttribute
    
    init(_ layoutSupport: UILayoutSupport, _ attribute: NSLayoutAttribute)
    {
        self.item = .LayoutSupport(layoutSupport)
        self.attribute = attribute
    }
    
    var constraint: Comparison {
        return Comparison(item: item, attribute: attribute, multiplier: 1, constant: 0)
    }
}

// MARK: Private Helpers

private extension NSLayoutConstraint {
    func copyContraint() -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        constraint.priority = priority
        constraint.identifier = identifier
        return constraint
    }
}

