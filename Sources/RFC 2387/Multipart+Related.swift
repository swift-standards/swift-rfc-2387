import RFC_2045
import RFC_2046

// MARK: - RFC 2387: Multipart/Related

extension RFC_2046.Multipart.Subtype {
    /// Related parts that reference each other
    ///
    /// Used for compound objects with internal references.
    /// Common use case: HTML emails with inline images where the
    /// HTML references images via Content-ID.
    ///
    /// **RFC 2387** - The MIME Multipart/Related Content-type
    ///
    /// ## Example
    ///
    /// ```swift
    /// let related = try RFC_2046.Multipart.related(
    ///     rootPart: htmlPart,
    ///     relatedParts: [imagePart]
    /// )
    /// ```
    public static let related = RFC_2046.Multipart.Subtype(rawValue: "related")
}

extension RFC_2046.BodyPart {
    /// Creates an inline image part with Content-ID for multipart/related
    ///
    /// Convenience for creating image parts that can be referenced in HTML via cid:.
    /// Commonly used in HTML emails with embedded images.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let imagePart = RFC_2046.BodyPart.inlineImage(
    ///     contentID: "logo@example.com",
    ///     contentType: RFC_2045.ContentType(type: "image", subtype: "png"),
    ///     content: imageData
    /// )
    ///
    /// // Reference in HTML: <img src="cid:logo@example.com">
    /// ```
    ///
    /// - Parameters:
    ///   - contentID: Unique identifier (without angle brackets, e.g., "logo@example.com")
    ///   - contentType: Image content type
    ///   - transferEncoding: Transfer encoding (defaults to base64 for binary images)
    ///   - content: Image data
    /// - Returns: BodyPart with Content-ID header set
    public static func inlineImage(
        contentID: String,
        contentType: RFC_2045.ContentType,
        transferEncoding: RFC_2045.ContentTransferEncoding = .base64,
        content: Data
    ) -> Self {
        .init(
            contentType: contentType,
            transferEncoding: transferEncoding,
            additionalHeaders: ["Content-ID": "<\(contentID)>"],
            content: content
        )
    }

    /// The Content-ID of this part, if specified
    ///
    /// Used in multipart/related for referencing parts (e.g., inline images).
    /// The value includes angle brackets per RFC 2387: `<id@example.com>`
    public var contentID: String? {
        headers["Content-ID"]
    }
}

extension RFC_2046.Multipart {
    /// Creates a multipart/related message
    ///
    /// Used for compound documents where parts reference each other.
    /// Common use case: HTML email with inline images referenced via Content-ID.
    ///
    /// **RFC 2387** - The MIME Multipart/Related Content-type
    ///
    /// ## Example
    ///
    /// ```swift
    /// let htmlPart = RFC_2046.BodyPart(
    ///     contentType: .textHTMLUTF8,
    ///     text: "<img src='cid:logo@example.com'>"
    /// )
    ///
    /// let imagePart = RFC_2046.BodyPart.inlineImage(
    ///     contentID: "logo@example.com",
    ///     contentType: RFC_2045.ContentType(type: "image", subtype: "png"),
    ///     content: imageData
    /// )
    ///
    /// let related = try RFC_2046.Multipart.related(
    ///     rootPart: htmlPart,
    ///     relatedParts: [imagePart]
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - rootPart: The root part (typically HTML)
    ///   - relatedParts: Parts referenced by the root (e.g., images)
    ///   - rootType: Content-Type of root part (optional, auto-detected from rootPart)
    ///   - startContentID: Content-ID of root part (optional, per RFC 2387)
    ///   - boundary: Custom boundary (auto-generated if nil)
    /// - Throws: `RFC_2046.Multipart.Error` if validation fails
    public static func related(
        rootPart: RFC_2046.BodyPart,
        relatedParts: [RFC_2046.BodyPart],
        rootType: RFC_2045.ContentType? = nil,
        startContentID: String? = nil,
        boundary: String? = nil
    ) throws -> Self {
        let allParts = [rootPart] + relatedParts

        // RFC 2387: Auto-detect type from root part if not provided
        let detectedRootType = rootType ?? rootPart.contentType

        // Build parameters
        var parameters: [String: String] = [:]
        if let type = detectedRootType {
            parameters["type"] = "\"\(type.headerValue)\""
        }
        if let start = startContentID {
            parameters["start"] = "\"\(start)\""
        }

        return try Self(
            subtype: .related,
            parts: allParts,
            boundary: boundary,
            additionalParameters: parameters
        )
    }
}
