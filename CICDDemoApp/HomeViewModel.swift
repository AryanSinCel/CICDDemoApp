//
//  HomeViewModel.swift
//  CICDDemoApp
//
//  Created by Aryan Singh on 28/04/26.
//
import Foundation

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [String]
}

final class HomeViewModel: ObservableObject {
    @Published var users: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: UserServiceProtocol

    init(service: UserServiceProtocol) {
        self.service = service
    }

    func fetchUsers() async {
        isLoading = true
        errorMessage = nil

        do {
            users = try await service.fetchUsers()
        } catch {
            errorMessage = "Failed to load users"
        }

        isLoading = false
    }
}


final class MockUserService: UserServiceProtocol {

    var shouldFail = false

    func fetchUsers() async throws -> [String] {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return ["Aryan", "John"]
    }
}
