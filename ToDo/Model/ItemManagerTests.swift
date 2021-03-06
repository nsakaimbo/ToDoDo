//
//  ItemManagerTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/2/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemManagerTests: XCTestCase {

    var sut: ItemManager!
   
    override func setUp() {
        sut = ItemManager()
    }
    
    override func tearDown() {
        sut.removeAllItems()
        sut = nil
    }
    
    func testToDoCount_Initially_ShouldBeZero() {
        
        XCTAssertEqual(sut.toDoCount, 0, "Initially toDo count should be 0")
    }
    
    func testDoneCount_Initially_ShouldBeZero() {
        
        XCTAssertEqual(sut.doneCount, 0, "Initially Done count should be 0")
    }
    
    func testToDoCount_AfterAddingOneItem_IsOne() {
        sut.addItem(ToDoItem(title: "test title"))
        
        XCTAssertEqual(sut.toDoCount, 1, "ToDo count should be 1")
    }
    
    func testItemAtIndex_ShouldReturnPreviouslyAddedItem() {
        let item = ToDoItem(title: "item")
        sut.addItem(item)
        
        let returnedItem = sut.itemAtIndex(0)
        
    XCTAssertEqual(item.title, returnedItem.title, "Items should be equal")
    }
    
    func testCheckingItem_ChangesCountOfToDoAndDoneItems() {
        
        let item = ToDoItem(title: "item")
        sut.addItem(item)
        
        sut.checkItemAtIndex(0)
        
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 1, "doneCount should be 1")
    }
    
    func testCheckingItem_RemovesItemFromToDoList() {
        let firstItem = ToDoItem(title: "first")
        let secondItem = ToDoItem(title: "second")
        
        sut.addItem(firstItem)
        sut.addItem(secondItem)
        
        sut.checkItemAtIndex(0)
        
        XCTAssertEqual(sut.itemAtIndex(0).title, secondItem.title)
    }
    
    func testDoneItemAtIndex_ShouldReturnPreviouslyCheckedItem() {
        let item = ToDoItem(title: "item")
        
        sut.addItem(item)
        
        sut.checkItemAtIndex(0)
        
        let doneItem = sut.doneItemAtIndex(0)
        
        XCTAssertEqual(item.title, doneItem.title)
    }
    
    func testRemoveAllItems_ShouldResultInCountsBeZero() {
        sut.addItem(ToDoItem(title: "first"))
        sut.addItem(ToDoItem(title: "second"))
        sut.checkItemAtIndex(0)
        
        XCTAssertEqual(sut.toDoCount, 1, "toDoCount should be 1")
        XCTAssertEqual(sut.doneCount, 1, "doneCount should be 1")
        
        sut.removeAllItems()
        
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be 0")
        XCTAssertEqual(sut.toDoCount, 0, "doneCount should be 0")
    }
    
    // Ensure uniqueness
    func testAddingTheSameItem_DoesNotIncreaseCount() {
        sut.addItem(ToDoItem(title: "first"))
        sut.addItem(ToDoItem(title: "first"))
        
        XCTAssertEqual(sut.toDoCount, 1)
    }
    
    // MARK: Serialization and Deserialization
    func test_ToDoItemGetsSerialized() {
        var itemManager: ItemManager? = ItemManager()
        
        let firstItem = ToDoItem(title: "first")
        itemManager?.addItem(firstItem)
        
        let secondItem = ToDoItem(title: "second")
        itemManager?.addItem(secondItem)
        
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        itemManager = nil
        XCTAssertNil(itemManager)
        
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.toDoCount, 2)
        XCTAssertEqual(itemManager?.itemAtIndex(0), firstItem)
        XCTAssertEqual(itemManager?.itemAtIndex(1), secondItem)
    }
    
    func test_DoneItemGetsSerialized() {
        var itemManager: ItemManager? = ItemManager()
        
        let firstItem = ToDoItem(title: "first")
        itemManager?.addItem(firstItem)
        
        let secondItem = ToDoItem(title: "second")
        itemManager?.addItem(secondItem)
        
        itemManager?.checkItemAtIndex(1)
        
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        itemManager = nil
        XCTAssertNil(itemManager)
        
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.toDoCount, 1)
        XCTAssertEqual(itemManager?.doneCount, 1)
        XCTAssertEqual(itemManager?.itemAtIndex(0), firstItem)
        XCTAssertEqual(itemManager?.doneItemAtIndex(0), secondItem)
    }
}

