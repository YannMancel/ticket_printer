abstract interface class UseCaseWithOneNullableArgument<R, A extends Object?> {
  R call({A argument});
}
