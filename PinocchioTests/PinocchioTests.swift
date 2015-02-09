//
//  PinocchioTests.swift
//  PinocchioTests
//
//  Created by Ben Cochran on 2/9/15.
//  Copyright (c) 2015 Ben Cochran. All rights reserved.
//

import UIKit
import XCTest
import Pinocchio

class PinocchioTests: XCTestCase {
    var view1: UIView!
    var view2: UIView!
    var viewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        view1 = UIView()
        view2 = UIView()
        viewController = UIViewController()
        var v = viewController.view // make sure the view is loaded
    }
    
    override func tearDown() {
        super.tearDown()
        view1 = nil
        view2 = nil
        viewController = nil
    }
    
    func testEqualConstant() {
        let compact = view1.width == 10
        let massive = NSLayoutConstraint(item: view1,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 0,
            constant: 10);
        AssertEqualConstraints(compact, massive, "view1.width == 10")
    }
    
    func testGreaterThanOrEqualConstant() {
        let compact = view1.width >= 10
        let massive = NSLayoutConstraint(item: view1,
            attribute: .Width,
            relatedBy: .GreaterThanOrEqual,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 0,
            constant: 10);
        AssertEqualConstraints(compact, massive, "view1.width >= 10")
    }
    
    func testGreaterLessOrEqualConstant() {
        let compact = view1.width <= 10
        let massive = NSLayoutConstraint(item: view1,
            attribute: .Width,
            relatedBy: .LessThanOrEqual,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 0,
            constant: 10);
        AssertEqualConstraints(compact, massive, "view1.width <= 10")
    }
    
    func testEqualItem() {
        let compact = view1.height == view2.height
        let massive = NSLayoutConstraint(item: view1,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: view2,
            attribute: .Height,
            multiplier: 1,
            constant: 0);
        AssertEqualConstraints(compact, massive, "view1.height == view2.height")
    }
    
    func testTopLayoutItem() {
        let compact = view1.top == viewController.topLayoutGuideBottom + 10
        let massive = NSLayoutConstraint(item: view1,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: viewController.topLayoutGuide,
            attribute: .Bottom,
            multiplier: 1,
            constant: 10);
        AssertEqualConstraints(compact, massive, "view1.height == view2.height")
    }
    
    
    func testAllAttributes() {
        XCTAssertEqual((view1.left == view2.left).firstAttribute, NSLayoutAttribute.Left, "Got incorrect attribute for .left")
        XCTAssertEqual((view1.right == view2.right).firstAttribute, NSLayoutAttribute.Right, "Got incorrect attribute for .right")
        XCTAssertEqual((view1.top == view2.top).firstAttribute, NSLayoutAttribute.Top, "Got incorrect attribute for .top")
        XCTAssertEqual((view1.bottom == view2.bottom).firstAttribute, NSLayoutAttribute.Bottom, "Got incorrect attribute for .bottom")
        XCTAssertEqual((view1.leading == view2.leading).firstAttribute, NSLayoutAttribute.Leading, "Got incorrect attribute for .leading")
        XCTAssertEqual((view1.trailing == view2.left).firstAttribute, NSLayoutAttribute.Trailing, "Got incorrect attribute for .trailing")
        XCTAssertEqual((view1.width == view2.width).firstAttribute, NSLayoutAttribute.Width, "Got incorrect attribute for .width")
        XCTAssertEqual((view1.height == view2.height).firstAttribute, NSLayoutAttribute.Height, "Got incorrect attribute for .height")
        XCTAssertEqual((view1.centerX == view2.centerX).firstAttribute, NSLayoutAttribute.CenterX, "Got incorrect attribute for .centerX")
        XCTAssertEqual((view1.centerY == view2.centerY).firstAttribute, NSLayoutAttribute.CenterY, "Got incorrect attribute for .centerY")
        XCTAssertEqual((view1.baseline == view2.baseline).firstAttribute, NSLayoutAttribute.Baseline, "Got incorrect attribute for .baseline")
        XCTAssertEqual((view1.firstBaseline == view2.firstBaseline).firstAttribute, NSLayoutAttribute.FirstBaseline, "Got incorrect attribute for .firstBaseline")
    }
    
    func testConstantWithMath() {
        let compact = view1.width == 10 * 2 + 7
        let massive = NSLayoutConstraint(item: view1,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 0,
            constant: 27);
        AssertEqualConstraints(compact, massive, "view1.width == 10 * 2 + 7")
    }
}

// MARK: Helpers

func AssertEqualConstraints(first: NSLayoutConstraint, second: NSLayoutConstraint, testName: String) {
    XCTAssert((first.firstItem === second.firstItem), "Unequal firstItem in '\(testName)' (\(first.firstItem) vs \(second.firstItem))")
    XCTAssertEqual(first.firstAttribute, second.firstAttribute, "Unequal firstAttribute in '\(testName)' (\(first.firstAttribute) vs \(second.firstAttribute))")
    XCTAssertEqual(first.relation, second.relation, "Unequal relation in '\(testName)' (\(first.relation) vs \(second.relation))")
    XCTAssert((first.secondItem === second.secondItem), "Unequal secondItem in '\(testName)' (\(first.secondItem) vs \(second.secondItem))")
    XCTAssertEqual(first.secondAttribute, second.secondAttribute, "Unequal secondAttribute in '\(testName)' (\(first.secondAttribute) vs \(second.secondAttribute))")
    XCTAssertEqual(first.multiplier, second.multiplier, "Unequal multiplier in '\(testName)' (\(first.multiplier) vs \(second.multiplier))")
    XCTAssertEqual(first.constant, second.constant, "Unequal constant in '\(testName)' (\(first.constant) vs \(second.constant))")
    XCTAssertEqual(first.priority, second.priority, "Unequal priority in '\(testName)' (\(first.priority) vs \(second.priority))")
    XCTAssert((first.identifier == second.identifier), "Unequal identifier in '\(testName)' (\(first.identifier) vs \(second.identifier))")
}

