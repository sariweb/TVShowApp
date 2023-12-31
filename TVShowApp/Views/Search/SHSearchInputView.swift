//
//  SHSearchInputView.swift
//  TVShowApp
//
//  Created by Sergei on 26.10.2023.
//

import UIKit

protocol SHSearchInputViewDelegate: AnyObject {
    func shSearchInputView(_ inputView: SHSearchInputView, didSelect option: SearchOption)
    func shSearchInputView(_ inputView: SHSearchInputView, textDidChange searchText: String)
    func shSearchInputViewDidTapSearchButton(_ inputView: SHSearchInputView)
}

/// View for top part of search screen with search bar
final class SHSearchInputView: UIView {
    weak var delegate: SHSearchInputViewDelegate?
    
    private var viewModel: SHSearchInputViewViewModel? {
        didSet {
            guard let viewModel, viewModel.hasDynamicOptions else { return }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        
        return searchBar
    }()
    
    private var stackView: UIStackView?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        addConstraints()
        
        searchBar.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58),
        ])
    }
    
    private func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 6
        addSubviews(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        return stackView
    }
    
    private func createButton(with option: SearchOption, tag: Int) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: option.rawValue,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.label
                ])
            ,
            for: .normal
        )
        button.backgroundColor = .secondarySystemFill
        button.addTarget(self, action: #selector(didTabButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        
        return button
    }
    
    private func createOptionSelectionViews(options: [SearchOption]) {
        let stackView = createOptionStackView()
        self.stackView = stackView
        for i in 0..<options.count {
            let option = options[i]
            let button = createButton(with: option, tag: i)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func didTabButton(_ sender: UIButton) {
        guard let options = viewModel?.options else { return }
        let tag = sender.tag
        let selected = options[tag]
        
        delegate?.shSearchInputView(self, didSelect: selected)
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: SHSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    public func update(option: SearchOption, value: String) {
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let options = viewModel?.options,
              let index = options.firstIndex(of: option) else { return }
        
        buttons[index].setAttributedTitle(
            NSAttributedString(
                string: value.uppercased(),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.link
                ])
            ,
            for: .normal
        )
    }
}

// MARK: - UISearchBarDelegate

extension SHSearchInputView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // notify delegate search text changed
        delegate?.shSearchInputView(self, textDidChange: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // notify delegate search bar btn tapped
        searchBar.resignFirstResponder()
        delegate?.shSearchInputViewDidTapSearchButton(self)
    }
}
