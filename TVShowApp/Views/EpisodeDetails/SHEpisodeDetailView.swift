//
//  SHEpisodeDetailView.swift
//  TVShowApp
//
//  Created by Sergei on 08.09.2023.
//

import UIKit

class SHEpisodeDetailView: UIView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([

        ])
        
    }
}
