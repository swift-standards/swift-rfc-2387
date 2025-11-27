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

public import RFC_5322

extension RFC_2387 {
    /// Content-ID header value per RFC 2387
    ///
    /// RFC 2387 Content-ID uses the same msg-id format as RFC 5322 Message-ID:
    /// `<unique-string@domain>`
    ///
    /// Content-ID is used to reference body parts in multipart/related messages,
    /// typically via `cid:` URLs in HTML content.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let contentID: RFC_2387.ContentID = "logo@example.com"
    /// // Serializes as: <logo@example.com>
    /// // Reference in HTML: <img src="cid:logo@example.com">
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``RFC_5322/Message/ID``
    /// - [RFC 2387](https://www.rfc-editor.org/rfc/rfc2387)
    public typealias ContentID = RFC_5322.Message.ID
}
