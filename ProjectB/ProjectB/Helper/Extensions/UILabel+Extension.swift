//
//  UILabel+Extension.swift
//  ProjectB
//
//  Created by Scissors on 18.12.2024.
//

import UIKit

extension UILabel {
    func setHTMLText(_ htmlString: String?, lineSpacing: CGFloat = 4.0, font: UIFont = UIFont.systemFont(ofSize: 12)) {
        guard let htmlString = htmlString, let data = htmlString.data(using: .utf8) else {
            self.text = nil
            return
        }

        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )

            let modifiedString = NSMutableAttributedString(attributedString: attributedString)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing

            modifiedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: modifiedString.length))
            modifiedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: modifiedString.length))

            self.attributedText = modifiedString
        } catch {
            print("HTML parsing error: \(error)")
            self.text = nil
        }
    }
}
