//
//  NetworkManagerTests.swift.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 29/10/23.
//

import XCTest
@testable import proyecto_iOS_avanzado

final class ApiProviderTests: XCTestCase {
    private var sut: NetworkManagerProtocol!

    override func setUp() {
        sut = MockApiService(secureDataProvider: SecureDataManager())
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_givenApiProvider_whenLoginWithUserAndPassword_thenGetValidToken() throws {
        let handler: (Notification) -> Bool = { notification in
            let token = notification.userInfo?[NotificationCenter.tokenKey] as? String
            XCTAssertNotNil(token)
            XCTAssertNotEqual(token ?? "", "")

            return true
        }

        let expectation = self.expectation(
            forNotification: NotificationCenter.loginNotification,
            object: nil,
            handler: handler
        )

        sut.login(email: "pablomaringallardo17@gmail.com", password: "123456")
        wait(for: [expectation], timeout: 10.0)
    }
}
