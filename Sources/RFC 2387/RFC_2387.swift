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

/// RFC 2387: The MIME Multipart/Related Content-type
///
/// Defines the multipart/related media type for compound objects consisting of
/// several inter-related body parts. The body parts are typically HTML content
/// with inline images referenced via Content-ID.
///
/// ## Key Types
///
/// - ``Related``: Container for creating multipart/related messages
///
/// ## Example
///
/// ```swift
/// let htmlPart = RFC_2046.BodyPart(
///     contentType: .textHTMLUTF8,
///     text: "<img src='cid:logo@example.com'>"
/// )
///
/// let imagePart = RFC_2387.Related.inlineImage(
///     contentID: "logo@example.com",
///     contentType: RFC_2045.ContentType(type: "image", subtype: "png"),
///     content: imageData
/// )
///
/// let related = try RFC_2387.Related.multipart(
///     rootPart: htmlPart,
///     relatedParts: [imagePart]
/// )
/// ```
///
/// ## See Also
///
/// - [RFC 2387](https://www.rfc-editor.org/rfc/rfc2387)
/// - ``RFC_2046/Multipart``
public enum RFC_2387 {}
