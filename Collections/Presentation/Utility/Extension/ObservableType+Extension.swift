import RxSwift

extension ObservableType {

    func validate<V: ValidatorProtocol>(
        _ validator: V.Type
    ) -> Observable<ValidationResult<V.ErrorType>> where V.ValueType == Self.Element {
        return map { validator.validate($0) }
    }
}
