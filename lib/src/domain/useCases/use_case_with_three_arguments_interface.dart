abstract interface class UseCaseWithThreeArguments<R, A1, A2, A3> {
  R call(A1 firstArgument, A2 secondArgument, A3 thirdArgument);
}
