//
//  String+Extensions.swift
//  YMMisc
//
//  Created by Yakov Manshin on 1/12/19.
//  Copyright © 2019 Yakov Manshin. See the LICENSE file for license info.
//

import Foundation

// MARK: - Transformation

extension String {
    
    /**
     Returns a new string by applying a sequence of transforms to the string.
     + Transforms are applied in the order they’re specified in.
     + For the list of available transforms, see `StringTransform`.
    */
    @available(*, deprecated, message: "This method is deprecated and will be removed")
    public func applyingTransformChain(_ transformChain: [StringTransform]) -> String? {
        var transformedString: String? = self
        
        for transform in transformChain {
            transformedString = transformedString?.applyingTransform(transform, reverse: false)
        }
        
        return transformedString
    }
    
}

// MARK: - Comparison

extension String {
    
    /**
     Creates a string suitable for comparison by removing insignificant distinctions from the string.
     + To specify more options, call `folding(options:locale:)` on the string instead.
     + For the full list of options, see `NSString.CompareOptions`.
     - Returns: A string created by calling `folding(options:locale:)` with options `caseInsensitive`, `diacriticInsensitive`, and `numeric` on the string.
    */
    @available(*, deprecated, message: "This property is deprecated and will be removed")
    public var suitableForComparison: String {
        return self.folding(options: [.caseInsensitive, .diacriticInsensitive, .numeric], locale: .current)
    }
    
}

// MARK: - Matching Against Regular Expressions

extension String {
    
    /// Indicates whether the string fully matches (i.e. has exactly one match with) the specified regular expression.
    ///
    /// - Parameter regularExpression: *Required.* Regular expression to match the string against.
    /// - Parameter matchingOptions: *Optional.* Matching options to use. See `NSRegularExpression.MatchingOptions`. Default is `[]`.
    ///
    /// - Returns: `Bool`. Matching result.
    @available(*, deprecated, message: "This method is deprecated and will be removed")
    public func matches(
        _ regularExpression: NSRegularExpression,
        withOptions matchingOptions: NSRegularExpression.MatchingOptions = []
    ) -> Bool {
        return regularExpression.numberOfMatches(
            in: self,
            options: matchingOptions,
            range: NSRange(location: 0, length: self.count)
        ) == 1
    }
    
    /// Indicates whether the string fully matches (i.e. has exactly one match with) a regular expression initialized with the specified pattern with options.
    ///
    /// - Parameter regularExpressionPattern: *Required.* Regular expression pattern to initialize an `NSRegularExpression` from.
    /// - Parameter options: *Optional.* `NSRegularExpression.Options` to use when initializing an `NSRegularExpression`; default is `[]`.
    @available(*, deprecated, message: "This method is deprecated and will be removed")
    public func matchesRegularExpressionThrowing(
        fromPattern regularExpressionPattern: String,
        withOptions options: NSRegularExpression.Options = []
    ) throws -> Bool {
        let regularExpression = try NSRegularExpression(
            pattern: regularExpressionPattern,
            options: options
        )
        
        return self.matches(regularExpression)
    }
    
    /// Indicates whether the string fully matches (i.e. has exactly one match with) a regular expression initialized with the specified pattern with options.
    ///
    /// - Parameter regularExpressionPattern: *Required.* Regular expression pattern to initialize an `NSRegularExpression` from.
    /// - Parameter options: *Optional.* `NSRegularExpression.Options` to use when initializing an `NSRegularExpression`; default is `[]`.
    ///
    /// - Returns: `Bool?`. Matching result, if regular expression initialized successfully; otherwise, `nil`.
    @available(*, deprecated, message: "This method is deprecated and will be removed")
    public func matchesRegularExpression(
        fromPattern regularExpressionPattern: String,
        withOptions options: NSRegularExpression.Options = []
    ) -> Bool? {
        return try? self.matchesRegularExpressionThrowing(
            fromPattern: regularExpressionPattern,
            withOptions: options
        )
    }
    
}
