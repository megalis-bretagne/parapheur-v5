# This section grants all access on "secret/*". Further restrictions can be
# applied to this broad policy, as shown below.
path "secret/*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete",
    "list"
  ]
}

