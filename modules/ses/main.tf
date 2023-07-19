resource "aws_ses_template" "comfirm_link" {
  name = "verification_email"
  subject = "Verify User"
  html    = file("${path.module}/comfirm_email_form.html")
}
resource "aws_ses_template" "reset_link" {
  name = "reset_password"
  subject = "Reset Password"
  html    = file("${path.module}/reset_password_form.html")
}
