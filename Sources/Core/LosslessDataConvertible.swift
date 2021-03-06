/// A type that can be created from `Data` in a lossless, unambiguous way.
public protocol LosslessDataConvertible {
    /// Losslessly converts `Data` to this type.
    init?(_ data: Data)
}

/// A type that can be converted to `Data`
public protocol CustomDataConvertible {
    /// Losslessly converts this type to `Data`.
    func convertToData() -> Data
}

extension Data {
    /// Converts this `Data` to a `LosslessDataConvertible` type.
    ///
    ///     let string = Data([0x68, 0x69]).convert(to: String.self)
    ///     print(string) // "hi"
    ///
    /// - parameters:
    ///     - type: The `LosslessDataConvertible` to convert to.
    /// - returns: Instance of the `LosslessDataConvertible` type.
    public func convert<T>(to type: T.Type = T.self) -> T? where T: LosslessDataConvertible {
        return T.init(self)
    }
}

extension String: LosslessDataConvertible, CustomDataConvertible {
    /// Converts this `String` to data using `.utf8`.
    public func convertToData() -> Data {
        return Data(utf8)
    }

    /// Converts `Data` to a `utf8` encoded String.
    ///
    /// - throws: Error if String is not UTF8 encoded.
    public init?(_ data: Data) {
        guard let string = String(data: data, encoding: .utf8) else {
            /// FIXME: string convert _from_ data is not actually lossless.
            /// this should really only conform to a `LosslessDataRepresentable` protocol.
            return nil
        }
        self = string
    }
}

extension Array: LosslessDataConvertible, CustomDataConvertible where Element == UInt8 {
    /// Converts this `[UInt8]` to `Data`.
    public func convertToData() -> Data {
        return Data(bytes: self)
    }

    /// Converts `Data` to `[UInt8]`.
    public init?(_ data: Data) {
        self = .init(data)
    }
}

extension Data: LosslessDataConvertible, CustomDataConvertible {
    /// `LosslessDataConvertible` conformance.
    public func convertToData() -> Data {
        return self
    }

    /// `LosslessDataConvertible` conformance.
    public init?(_ data: Data) {
        self = data
    }
}
