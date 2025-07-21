//
//  Numeric+Extensions.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/22/25.
//

import Foundation

extension Numeric {
    var moneyString: String {
        // Int로 들어온 값을 Formatter로 관리. 숫자 사이에 콤마 넣고 String으로 반환
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return (formatter.string(for: self) ?? "") + "원"
    }
}
