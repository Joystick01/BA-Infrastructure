output "STORAGE_ACCOUNT_URL" {
  value = module.storage.STORAGE_ACCOUNT_URL
}

output "STORAGE_ACCOUNT_KEY" {
  value = nonsensitive(module.storage.STORAGE_ACCOUNT_KEY)
}

output "STORAGE_FILESYSTEM_NAME" {
  value = module.storage.STORAGE_FILESYSTEM_NAME
}