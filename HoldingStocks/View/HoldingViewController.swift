//
//  HoldingViewController.swift
//  HoldingStocks
//
//  Created by Rakesh Kumar on 15/11/24.
//

import UIKit
import Foundation

class HoldingViewController: UIViewController {
    
    private var holding: [UserHolding] = []
    
    private var isExpandable: Bool = false
    private var expandableViewHeightConstraint: NSLayoutConstraint?
    private var currentValue: Double = 0
    private var totalInvest: Double = 0
    private var todayPNLValue: Double = 0
    
    private lazy var holdingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HoldingTableViewCell.self, forCellReuseIdentifier: HoldingTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var navigationSeparator: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var expandableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorCode.expandViewBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = ColorCode.expandViewBorderColor
        return view
    }()
    
    private lazy var currValLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var currentValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var currentValueStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [currValLabel, currentValueLabel].forEach(stackView.addArrangedSubview)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var totalInvestment: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var totalInvestmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var todayPandL: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var todayPandLValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profitLossLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.text = Constants.profitLossText
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: Constants.upwardArrow)
        image?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(arrowButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var profitHorizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        [profitLossLabel, arrowButton].forEach(stackView.addArrangedSubview)
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var profitLossValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private var profitLossPercent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        [holdingTableView, expandableView].forEach(view.addSubview)
        [profitHorizontalStack, profitLossValueLabel, profitLossPercent, currValLabel, currentValueLabel, totalInvestment, totalInvestmentLabel, todayPandL, todayPandLValue, separator].forEach(expandableView.addSubview)
        holdingTableView.delegate = self
        holdingTableView.dataSource = self
        setupConstraits()
        fetchData()
    }
    
    @objc func arrowButtonClicked() {
        isExpandable.toggle()
        
        expandableViewHeightConstraint?.constant = isExpandable ? 230 : 70
        let buttonTitle = isExpandable ? UIImage(systemName: Constants.downwardArrow) : UIImage(systemName: Constants.upwardArrow)
        arrowButton.setImage(buttonTitle, for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        currValLabel.text = isExpandable ? Constants.currentValueText : ""
        currentValueLabel.text = isExpandable ? String(format: "\(Constants.rupeeSign) %.2f", currentValue) : ""
        totalInvestment.text = isExpandable ? Constants.totalInvestmentText : ""
        totalInvestmentLabel.text = isExpandable ? String(format: "\(Constants.rupeeSign) %.2f", totalInvest) : ""
        todayPandL.text = isExpandable ? Constants.todayProfitLossText : ""
    }
    
    private func setupNavigationBar(){
        let personImage = UIImage(systemName: Constants.profileImage)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        let magnifyingGlass = UIImage(systemName: Constants.searchImage)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        let arrow = UIImage(systemName: Constants.upDownArrowImage)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        
        let portfolio = UIBarButtonItem(title: Constants.portfolioText, image: nil, target: self, action: nil)
        portfolio.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(
                image: personImage,
                style: .done,
                target: self,
                action: nil
            ),
            portfolio
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: magnifyingGlass,
                style: .done,
                target: self,
                action: nil
            ),
            UIBarButtonItem(customView: navigationSeparator),
            UIBarButtonItem(
                image: arrow,
                style: .done,
                target: self,
                action: nil
            ),
        ]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ColorCode.appearanceColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupConstraits() {
        expandableViewHeightConstraint = expandableView.heightAnchor.constraint(equalToConstant: 70)
        expandableViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            holdingTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -34),
            holdingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            holdingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            holdingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            expandableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            profitHorizontalStack.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor, constant: -30),
            profitHorizontalStack.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor, constant: 30),
            
            profitLossPercent.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor, constant: -30),
            profitLossPercent.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor, constant: -20),
            
            profitLossValueLabel.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor, constant: -30),
            profitLossValueLabel.trailingAnchor.constraint(equalTo: profitLossPercent.leadingAnchor, constant: -3),
            
            currValLabel.topAnchor.constraint(equalTo: expandableView.topAnchor, constant: 20),
            currValLabel.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor, constant: 20),
            
            currentValueLabel.topAnchor.constraint(equalTo: currValLabel.topAnchor),
            currentValueLabel.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor, constant: -20),
            
            totalInvestment.topAnchor.constraint(equalTo: currValLabel.bottomAnchor, constant: 30),
            totalInvestment.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor, constant: 20),
            
            totalInvestmentLabel.topAnchor.constraint(equalTo: currValLabel.bottomAnchor, constant: 30),
            totalInvestmentLabel.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor, constant: -20),
            
            todayPandL.topAnchor.constraint(equalTo: totalInvestment.bottomAnchor, constant: 30),
            todayPandL.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor, constant: 20),
            
            todayPandLValue.topAnchor.constraint(equalTo: todayPandL.topAnchor),
            todayPandLValue.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor, constant: -20),
            
            separator.topAnchor.constraint(equalTo: todayPandL.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func fetchData() {
        APICaller.shared.fetchHoldingData { [weak self] result in
            switch result {
            case .success(let holding):
                self?.holding = holding
                for value in holding {
                    self?.currentValue += value.ltp * Double(value.quantity)
                    self?.totalInvest += value.avgPrice * Double(value.quantity)
                    self?.todayPNLValue += (value.close - value.ltp) * Double(value.quantity)
                }
                DispatchQueue.main.async {
                    let currentInvestDiff = (self?.currentValue ?? 0.0) - (self?.totalInvest ?? 0.0)
                    let pnlPercent = (currentInvestDiff / (self?.totalInvest ?? 0.0)) * 100
                    self?.profitLossValueLabel.textColor = (currentInvestDiff < 0) ? ColorCode.redPnLTextColor : ColorCode.greenPnLTextColor
                    self?.profitLossPercent.textColor = (currentInvestDiff < 0) ? ColorCode.redPnLTextColor : ColorCode.greenPnLTextColor
                    self?.profitLossValueLabel.text =  String(format: "\(Constants.rupeeSign) %.2f", currentInvestDiff)
                    self?.profitLossPercent.text = "(\(String(format: "%.2f", pnlPercent))%)"
                    self?.todayPandLValue.textColor = (self!.todayPNLValue < 0) ? ColorCode.redPnLTextColor : ColorCode.greenPnLTextColor
                    self?.todayPandLValue.text = String(format: "\(Constants.rupeeSign) %.2f", self?.todayPNLValue ?? 0.0)
                    self?.holdingTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension HoldingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holding.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HoldingTableViewCell.identifier, for: indexPath) as? HoldingTableViewCell else {
            return UITableViewCell()
        }
        let data = holding[indexPath.row]
        cell.configure(with: HoldingViewModel(symbol: data.symbol, quantity: data.quantity, ltp: data.ltp, avgPrice: data.avgPrice))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
