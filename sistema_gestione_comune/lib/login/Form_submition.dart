abstract class Form_submissin_status {
  const Form_submissin_status();
}

class InitialFormStatus extends Form_submissin_status {
  const InitialFormStatus();
}

class FormsSubmitting extends Form_submissin_status {}

class SubmissionSucces extends Form_submissin_status {}

class SubmissionFailed extends Form_submissin_status {
  final Object exception;
  SubmissionFailed(this.exception);
}
