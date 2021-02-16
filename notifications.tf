locals {
    # Whether to enable notifications or not
    enable_notifications = var.enabled && length(var.backup_vault_events) > 0 ? true : false
}

resource "aws_sns_topic" "backup_events" {
  count  = local.enable_notifications && var.sns_topic_arn == "" ? 1 : 0
  name = var.sns_topic_name
}

data "aws_iam_policy_document" "backup_events" {
  statement {
    actions = [
      "SNS:Publish",
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
    resources = [
      local.enable_notifications && var.sns_topic_arn == "" ? aws_sns_topic.backup_events[0].arn : var.sns_topic_arn
    ]
    sid = "BackupPublishEvents"
  }
}

resource "aws_sns_topic_policy" "backup_events" {
  count  = local.enable_notifications ? 1 : 0
  arn = local.enable_notifications && var.sns_topic_arn == "" ? aws_sns_topic.backup_events[0].arn : var.sns_topic_arn
  policy = data.aws_iam_policy_document.backup_events.json
}

resource "aws_backup_vault_notifications" "backup_events" {
  count               = local.enable_notifications ? 1 : 0
  backup_vault_name   = var.backup_vault_name
  sns_topic_arn = local.enable_notifications && var.sns_topic_arn == "" ? aws_sns_topic.backup_events[0].arn : var.sns_topic_arn
  backup_vault_events = var.backup_vault_events
}

resource "aws_sns_topic_subscription" "backup_events" {
  for_each = var.topic_subscriptions

  topic_arn              = local.enable_notifications && var.sns_topic_arn == "" ? aws_sns_topic.backup_events[0].arn : var.sns_topic_arn
  protocol               = var.topic_subscriptions[each.key].protocol
  endpoint               = var.topic_subscriptions[each.key].endpoint
  endpoint_auto_confirms = var.topic_subscriptions[each.key].endpoint_auto_confirms
  raw_message_delivery   = var.topic_subscriptions[each.key].raw_message_delivery
}
