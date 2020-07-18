//
//  OnboardingCollectionView.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 17/07/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

final class OnboardingView: UIView {
    var nav:UINavigationController?
    private lazy var gameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Organize seus jogos favoritos"
        return label
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CONTINUE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 4
        return button
    }()

    private lazy var termsAndConditionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Terms & Conditions"
        label.textAlignment = .center
        return label
    }()

    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.translatesAutoresizingMaskIntoConstraints = false
        page.currentPage = 0
        page.currentPageIndicatorTintColor = .blue
        page.pageIndicatorTintColor = .gray
        return page
    }()

    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground

        configuregameLabel()
        configureBottomStack()
        configureCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Constraints extension
private extension OnboardingView {

    func configuregameLabel() {
        addSubview(gameLabel)
        gameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        gameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
    }

    func configureCollectionView() {
        addSubview(collectionView)
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: gameLabel.bottomAnchor, constant: 45).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomStack.topAnchor, constant: -45).isActive = true
    }

    func configureBottomStack() {
        addSubview(bottomStack)
        bottomStack.addArrangedSubview(pageControl)
        bottomStack.addArrangedSubview(continueButton)
        bottomStack.addArrangedSubview(termsAndConditionsLabel)

        bottomStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        bottomStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true

        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.addTarget(self,
        action: #selector(continueClick),
        for: .touchUpInside)
    }
    
    @objc func continueClick(){
        nav?.dismiss(animated: true, completion: nil)
    }
}

