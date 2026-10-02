output "guardduty_detector_id" {
  value = var.enable_guardduty ? aws_guardduty_detector.this.id : null
}
