enum LoadingState<T: Equatable, E: Error> {
    case standby
    case loading
    case failed(E)
    case done(T)
}
