abstract interface class UseCaseWithOneArgument<R, A> {
  R call(A argument);
}
