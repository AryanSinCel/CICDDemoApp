//
//  HomeViewModelTests.swift
//  CICDDemoAppTests
//
//  Created by Aryan Singh on 28/04/26.
//

import XCTest
@testable import CICDDemoApp

final class HomeViewModelTests: XCTestCase {

    func testFetchUsersSuccess() async {
        let mockService = MockUserService()
        mockService.shouldFail = false
        let viewModel = HomeViewModel(service: mockService)

        await viewModel.fetchUsers()

        XCTAssertEqual(viewModel.users, ["Aryan", "John"])
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchUsersFailureSetsErrorAndStopsLoading() async {
        let mockService = MockUserService()
        mockService.shouldFail = true
        let viewModel = HomeViewModel(service: mockService)

        await viewModel.fetchUsers()

        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load users")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testFetchUsersSuccessAfterFailureClearsError() async {
        let mockService = MockUserService()
        let viewModel = HomeViewModel(service: mockService)

        mockService.shouldFail = true
        await viewModel.fetchUsers()
        XCTAssertEqual(viewModel.errorMessage, "Failed to load users")

        mockService.shouldFail = false
        await viewModel.fetchUsers()

        XCTAssertEqual(viewModel.users, ["Aryan", "John"])
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
}
