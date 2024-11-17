//
//  HoldingTableViewCell.swift
//  HoldingStocks
//
//  Created by Rakesh Kumar on 15/11/24.
//

import UIKit

class HoldingTableViewCell: UITableViewCell {
    static let identifier = "HoldingTableViewCell"
        
    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private var quantity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = Constants.netQuantity
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private var ltp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = Constants.ltpText
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private var ltpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var ltpHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.axis = .horizontal
        [ltp, ltpLabel].forEach(stack.addArrangedSubview)
        return stack
    }()
    
    private lazy var quantityHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.axis = .horizontal
        [quantity, quantityLabel].forEach(stack.addArrangedSubview)
        return stack
    }()
    
    private var pnlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = Constants.pnlText
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private var pnlCalculationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var pAndLHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.axis = .horizontal
        [pnlLabel, pnlCalculationLabel].forEach(stack.addArrangedSubview)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [symbolLabel, ltpHorizontalStack, quantityHorizontalStack, pAndLHorizontalStack].forEach(contentView.addSubview)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            ltpHorizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            ltpHorizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            quantityHorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            quantityHorizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            pAndLHorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            pAndLHorizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func configure(with model: HoldingViewModel) {
        symbolLabel.text = model.symbol
        ltpLabel.text = "\(Constants.rupeeSign) \(model.ltp)"
        quantityLabel.text = "\(model.quantity)"
        calculation(with: model)
    }
    
    func calculation(with model: HoldingViewModel) {
        let currVal = model.ltp * Double(model.quantity)
        let totalInvest = model.avgPrice * Double(model.quantity)
        let totalPNL = currVal - totalInvest
        let formattedPNL = String(format: "%.2f", totalPNL)
        pnlCalculationLabel.text = "\(Constants.rupeeSign) \(formattedPNL)"
        pnlCalculationLabel.textColor = (totalPNL < 0) ? ColorCode.redPnLTextColor : ColorCode.greenPnLTextColor
    }
}
