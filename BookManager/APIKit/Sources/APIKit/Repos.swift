public struct Repos {
    public struct Account {
        public typealias Signup = Repository<SignupRequest>
        public typealias Login = Repository<LoginRequest>
        public typealias Logout = Repository<LogoutRequest>
    }

    public struct Book {
        public typealias Get = Repository<BookListRequest>
        public typealias Post = Repository<AddBookRequest>
        public typealias Put = Repository<EditBookRequest>
    }

    public struct Onboarding {
        public typealias GetIsFinished = Repository<GetOnboardingFinishedRequest>
        public typealias SetIsFinished = Repository<SetOnboardingFinishedRequest>
    }
}

extension Repos {
    public struct Result<T: DataStructure>: DataStructure {
        public var status: Int
        public var result: T
    }
}
