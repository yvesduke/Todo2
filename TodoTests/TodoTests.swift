//
//  TodoTests.swift
//  TodoTests
//
//  Created by Yves Dukuze on 14/11/2023.
//

import XCTest
@testable import Todo

final class TodoTests: XCTestCase {
    
    
    var vm: TodoViewModel!
    var mockNetworkManager: MockedTodoNetworkManager!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockedTodoNetworkManager()
        vm = TodoViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        vm = nil
        mockNetworkManager = nil
    }
    
    func testGetTodoSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Get Todos Successful")
        
        // Act
        vm.getTodos()
        
        //Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertEqual(self.vm.todos.count, 4)
            XCTAssertNil(self.vm.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 9.0)
        
    }
    
    
    func testAddTodoSuccess() {
        
        let networkManager = MockedTodoNetworkManager()
        let viewModel = TodoViewModel(networkManager: networkManager)
        
        let todo = Todo(createdAt: "2023-11-25", title: "Test Todo", Description: "Test Description", Completed: false, id: "8")
        
        networkManager.isApiSuccessful = true
        
        viewModel.addTodo(todo)
        
        XCTAssertNil(viewModel.error)
    }
    
    func testUpdateTodoSuccess() {
        
        let networkManager = MockedTodoNetworkManager()
        let viewModel = TodoViewModel(networkManager: networkManager)
        
        let todoToUpdate = Todo(createdAt: "2023-11-25", title: "Test Updated todo", Description: "Updated Todo Description", Completed: true, id: "1")
        let expectation = XCTestExpectation(description: "Update Todo Successful")
        
        viewModel.updateTodo(todo: todoToUpdate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNil(viewModel.error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDeleteTodoSuccess() {
        
        let networkManager = MockedTodoNetworkManager()
        let viewModel = TodoViewModel(networkManager: networkManager)
        
        let todoIdToDelete = "4"
        let expectation = XCTestExpectation(description: "Delete Todo Successful")

        viewModel.deleteTodo(id: todoIdToDelete)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(viewModel.todos.count, 0)
            XCTAssertNil(viewModel.error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    
}
