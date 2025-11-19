import RFC_2045
import RFC_2046
import Testing

@testable import RFC_2387

@Suite
struct `README Verification` {

    @Test
    func `Example from source: Creating multipart/related with HTML and inline image`() throws {
        // From Multipart+Related.swift line 85-99
        let htmlContent = "<img src='cid:logo@example.com'>"
        let htmlPart = RFC_2046.BodyPart(
            contentType: .textHTMLUTF8,
            text: htmlContent
        )

        let imageData = Data([0x89, 0x50, 0x4E, 0x47])  // PNG magic bytes
        let imagePart = RFC_2046.BodyPart.inlineImage(
            contentID: "logo@example.com",
            contentType: RFC_2045.ContentType(type: "image", subtype: "png"),
            content: imageData
        )

        let related = try RFC_2046.Multipart.related(
            rootPart: htmlPart,
            relatedParts: [imagePart]
        )

        #expect(related.subtype == .related)
        #expect(related.parts.count == 2)
    }

    @Test
    func `Example from source: Using inlineImage convenience initializer`() {
        // From Multipart+Related.swift line 36-43
        let imageData = Data([0xFF, 0xD8, 0xFF, 0xE0])  // JPEG magic bytes
        let imagePart = RFC_2046.BodyPart.inlineImage(
            contentID: "logo@example.com",
            contentType: RFC_2045.ContentType(type: "image", subtype: "png"),
            content: imageData
        )

        // Reference in HTML: <img src="cid:logo@example.com">
        #expect(imagePart.contentID == "<logo@example.com>")
        #expect(imagePart.contentType?.type == "image")
        #expect(imagePart.contentType?.subtype == "png")
    }

    @Test
    func `Example from source: Related subtype constant`() {
        // From Multipart+Related.swift line 24
        let related = RFC_2046.Multipart.Subtype.related
        #expect(related.rawValue == "related")
    }

    @Test
    func `Example from source: ContentID accessor`() {
        // From Multipart+Related.swift line 69-71
        let imagePart = RFC_2046.BodyPart.inlineImage(
            contentID: "test@example.com",
            contentType: RFC_2045.ContentType(type: "image", subtype: "gif"),
            content: Data()
        )

        let contentID = imagePart.contentID
        #expect(contentID == "<test@example.com>")
    }

    @Test
    func `Multipart/related with root type parameter`() throws {
        let htmlPart = RFC_2046.BodyPart(
            contentType: .textHTMLUTF8,
            text: "<p>Test</p>"
        )

        let imagePart = RFC_2046.BodyPart.inlineImage(
            contentID: "img@example.com",
            contentType: RFC_2045.ContentType(type: "image", subtype: "jpeg"),
            content: Data()
        )

        let related = try RFC_2046.Multipart.related(
            rootPart: htmlPart,
            relatedParts: [imagePart],
            rootType: .textHTMLUTF8
        )

        #expect(related.subtype == .related)
        #expect(related.parts.count == 2)
    }

    @Test
    func `Multipart/related with start Content-ID parameter`() throws {
        let htmlPart = RFC_2046.BodyPart(
            contentType: .textHTMLUTF8,
            text: "<html><body>Test</body></html>"
        )

        let related = try RFC_2046.Multipart.related(
            rootPart: htmlPart,
            relatedParts: [],
            startContentID: "root@example.com"
        )

        #expect(related.subtype == .related)
        #expect(related.parts.count == 1)
    }

    @Test
    func `Multipart/related with custom boundary`() throws {
        let htmlPart = RFC_2046.BodyPart(
            contentType: .textHTMLUTF8,
            text: "<p>Content</p>"
        )

        let customBoundary = "CustomBoundary123"
        let related = try RFC_2046.Multipart.related(
            rootPart: htmlPart,
            relatedParts: [],
            boundary: customBoundary
        )

        #expect(related.boundary == customBoundary)
    }

    @Test
    func `Multiple inline images in multipart/related`() throws {
        let htmlContent = """
            <html>
                <img src="cid:logo@example.com">
                <img src="cid:banner@example.com">
            </html>
            """
        let htmlPart = RFC_2046.BodyPart(
            contentType: .textHTMLUTF8,
            text: htmlContent
        )

        let logoPart = RFC_2046.BodyPart.inlineImage(
            contentID: "logo@example.com",
            contentType: RFC_2045.ContentType(type: "image", subtype: "png"),
            content: Data([0x89, 0x50, 0x4E, 0x47])
        )

        let bannerPart = RFC_2046.BodyPart.inlineImage(
            contentID: "banner@example.com",
            contentType: RFC_2045.ContentType(type: "image", subtype: "jpeg"),
            content: Data([0xFF, 0xD8, 0xFF, 0xE0])
        )

        let related = try RFC_2046.Multipart.related(
            rootPart: htmlPart,
            relatedParts: [logoPart, bannerPart]
        )

        #expect(related.parts.count == 3)
        #expect(related.parts[1].contentID == "<logo@example.com>")
        #expect(related.parts[2].contentID == "<banner@example.com>")
    }
}
