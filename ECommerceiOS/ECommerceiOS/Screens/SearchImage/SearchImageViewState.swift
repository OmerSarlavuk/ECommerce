//
//  SearchImageViewState.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

enum SearchImageViewState {
    case base(BaseViewState)
    case snapshot(horizontal: [SearchImageViewItem])
}
