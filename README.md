# Terraform AWS Backup Notifications
Terraform module to enable notifications support on AWS Backup events.

## Examples
The following example shows how to use an existing SNS Topic to receive AWS Backups notifications:
```
module "backup_example" {
  source = "./terraform-aws-backup-notifications"

  enabled             = true
  backup_vault_events = [
    "BACKUP_JOB_STARTED",
    "BACKUP_JOB_FAILED",
    "BACKUP_JOB_SUCCESSFUL",
  ]

  # You can either pass the ARN of an existing SNS Topic
  sns_topic_arn = aws_sns_topic.example.arn
}
```

And the following shows how to let the module create a new SNS Topic along with a list of subscriptors that will be notified about AWS Backup events:
```
module "backup_example" {
  source = "./terraform-aws-backup-notifications"

  enabled             = true
  backup_vault_events = [
    "BACKUP_JOB_STARTED",
    "BACKUP_JOB_FAILED",
    "BACKUP_JOB_SUCCESSFUL",
  ]

  # If you don't provide a SNS Topic ARN, the module will create one and then create the given subscriptions
  topic_subscriptions = {
    notify_slack = {
      protocol               = "lambda"
      endpoint               = aws_lambda_function.example.arn
      endpoint_auto_confirms = true
      raw_message_delivery   = true
    }
  }
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enabled | Change to false to avoid deploying any AWS Backup notification resources. | bool | true | no |
| backup_vault_name | The name of the AWS Backup Vault to which the notifications will be attached to. | string | `"Default"` | no |
| backup_vault_events | A list of backup events that you would like to be notified about. Leave it empty to disable notifications. | list | `[]` | no |
| sns_topic_name | The name of the SNS topic that will be created to receive AWS Backup Vault notifications. | string | `"backup-events"` | no |
| sns_topic_arn | An optional SNS Topic ARN, should you choose to use an existing one. | string | `""` | no |
| topic_subscriptions | A map of subscriptions you would like to subscribe to the SNS topic. | map(...) | `{}` | no |


## Outputs

| Name | Description |
|------|-------------|
