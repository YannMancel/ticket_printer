abstract interface class UseCaseWithTwoArguments<R, A1, A2> {
  R call(A1 firstArgument, A2 secondArgument);
}
