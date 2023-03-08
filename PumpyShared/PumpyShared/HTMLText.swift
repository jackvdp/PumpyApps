//
//  HTMLText.swift
//  PumpyShared
//
//  Created by Jack Vanderpump on 08/03/2023.
//

import SwiftUI

public struct HTMLText: View {
    
    private let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        Text(text.convertHTMLToMarkdown())
    }
}

extension String {
    
    fileprivate func convertHTMLToMarkdown() -> AttributedString {
        var markdown = self
        
        // Convert headings
        markdown = markdown.replacingOccurrences(of: "<h1>(.+?)</h1>", with: "# $1\n", options: .regularExpression)
        markdown = markdown.replacingOccurrences(of: "<h2>(.+?)</h2>", with: "## $1\n", options: .regularExpression)
        markdown = markdown.replacingOccurrences(of: "<h3>(.+?)</h3>", with: "### $1\n", options: .regularExpression)
        markdown = markdown.replacingOccurrences(of: "<h4>(.+?)</h4>", with: "#### $1\n", options: .regularExpression)
        markdown = markdown.replacingOccurrences(of: "<h5>(.+?)</h5>", with: "##### $1\n", options: .regularExpression)
        markdown = markdown.replacingOccurrences(of: "<h6>(.+?)</h6>", with: "###### $1\n", options: .regularExpression)
        
        // Convert bold and italic text
        markdown = markdown.replacingOccurrences(of: "<b>(.+?)</b>", with: "**$1**", options: .regularExpression)
        markdown = markdown.replacingOccurrences(of: "<i>(.+?)</i>", with: "*$1*", options: .regularExpression)
        markdown = markdown.replacingOccurrences(of: "<strong>(.+?)</strong>", with: "**$1**", options: .regularExpression)
        markdown = markdown.replacingOccurrences(of: "<em>(.+?)</em>", with: "*$1*", options: .regularExpression)
        
        // Convert links
        markdown = markdown.replacingOccurrences(of: "<a href=\"(.+?)\">(.+?)</a>", with: "[$2]($1)", options: .regularExpression)
        
        // Convert images
        markdown = markdown.replacingOccurrences(of: "<img src=\"(.+?)\" alt=\"(.+?)\">", with: "![$2]($1)", options: .regularExpression)
        
        // Convert line breaks
        markdown = markdown.replacingOccurrences(of: "<br>", with: "  \n")
        
        // Convert paragraphs
        markdown = markdown.replacingOccurrences(of: "<p>(.+?)</p>", with: "$1\n\n", options: .regularExpression)
        
        // Remove remaining HTML tags
        markdown = markdown.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        
        
        if let data = markdown.data(using: .utf8),
           let text = try? AttributedString(markdown: data, options:
                                                AttributedString.MarkdownParsingOptions(interpretedSyntax:
                                                        .inlineOnlyPreservingWhitespace)) {
            return text
        } else {
            return AttributedString(markdown)
        }
    }
}
