//
//  AgeRangeCell.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 7.04.2023.
//

import UIKit

final class AgeRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let minLabel: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.text = "Min: "
        return label
    }()
    let maxLabel: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.text = "Max:"
        return label
    }()
    
    final class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel,minSlider]),
            UIStackView(arrangedSubviews: [maxLabel,maxSlider]),
        ])
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        contentView.addSubview(overallStackView)
        overallStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
