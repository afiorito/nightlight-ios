func clip<T: Comparable>(_ x0: T, _ x1: T, _ v: T) -> T {
    return max(x0, min(x1, v))
}
