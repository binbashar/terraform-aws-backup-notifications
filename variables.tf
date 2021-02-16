variable "enabled" {
  description = "Change to false to avoid deploying any AWS Backup notification resources."
  type        = bool
  default     = true
}

variable "backup_vault_name" {
  description = "The name of the AWS Backup Vault to which the notifications will be attached to."
  type        = string
  default     = "Default"
}

variable "backup_vault_events" {
  description = "A list of backup events that you would like to be notified about. Leave it empty to disable notifications."
  type        = list
  default     = []
}

variable "sns_topic_name" {
  description = "The name of the SNS topic that will be created to receive AWS Backup Vault notifications."
  type        = string
  default     = "backup-events"
}

variable "sns_topic_arn" {
  description = "An optional SNS Topic ARN, should you choose to use an existing one."
  type        = string
  default     = ""
}

variable "topic_subscriptions" {
  description = "A map of subscriptions you would like to subscribe to the SNS topic."
  type = map(object({
    # The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially supported, see below) (email is an option but is unsupported, see below).
    protocol = string
    # The endpoint to send data to, the contents will vary with the protocol. (see below for more information)
    endpoint = string
    # Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty (default is false)
    endpoint_auto_confirms = bool
    # Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property)
    raw_message_delivery = bool
  }))
  default     = {}
}
