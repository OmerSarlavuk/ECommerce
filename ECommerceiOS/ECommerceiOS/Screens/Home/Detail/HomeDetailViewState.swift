//
//  HomeDetailViewState.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 4.08.2025.
//

enum HomeDetailViewState {
    case base(BaseViewState)
    case snapshot(top: [HomeDetailViewItem],
                  horizontal: [HomeDetailViewItem])
}
