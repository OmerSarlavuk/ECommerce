//
//  BaseViewState.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

enum BaseViewState {
    case startLoadingIndicator
    case removeLoadingIndicator
    case failureService(errorMessage: String)
}
