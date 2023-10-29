//
//  ValidationFieldsTests.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 29/10/23.
//

import XCTest
@testable import proyecto_iOS_avanzado

final class ValidationFieldsTests: XCTestCase {
    private var sut: LoginViewModel!

    override  func setUp() {
        let secureData = SecureDataManager()
        sut = LoginViewModel(
            networkManager: NetworkManager(),
            secureData: SecureDataManager()
        )
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_givenValidEmail_whenIsValid_thenTrue() throws {
        let validEmail = "pablomaringallardo17@gmail.com"
//        let isEmailValid = sut.isValid(email: validEmail)

//        XCTAssertTrue(isEmailValid)
    }

    func test_givenValidEmail_whenNotValid_thenFalse() throws {
        let invalidEmail = "pablomaringallardo17gmail.com"
//        let isEmailValid = sut.isValid(email: invalidEmail)

//        XCTAssertFalse(isEmailValid)
    }
}
