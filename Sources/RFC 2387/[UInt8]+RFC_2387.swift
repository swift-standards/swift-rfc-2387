// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-rfc-2387 open source project
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

import RFC_2046

extension [UInt8] {
    /// Creates ASCII bytes from RFC 2387 Related message
    ///
    /// Serialization delegates to the underlying RFC_2046.Multipart.
    /// The Content-Type header includes RFC 2387 parameters (type, start, start-info).
    ///
    /// ## Category Theory
    ///
    /// Serialization (natural transformation):
    /// - **Domain**: RFC_2387.Related (structured data)
    /// - **Codomain**: [UInt8] (ASCII bytes with embedded binary)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let related = try RFC_2387.Related(
    ///     rootPart: htmlPart,
    ///     relatedParts: [imagePart],
    ///     boundary: try RFC_2046.Boundary("----=_Part_123")
    /// )
    /// let bytes = [UInt8](related)
    /// ```
    ///
    /// - Parameter related: The multipart/related message to serialize
    public init(_ related: RFC_2387.Related) {
        // Delegate to RFC_2046.Multipart serialization
        self = [UInt8](related.multipart)
    }
}
