# 🔁 Cross-Tenant Azure Resource Deployment

This project demonstrates how to securely deploy and access Azure resources across two separate Azure Active Directory tenants using Service Principals, Azure Key Vault, and Terraform. This setup mimics a real-world enterprise scenario where resources are isolated by tenant but need controlled cross-access.

---

## 📁 Project Structure
4.Cross-Tenant-Azure-Resource-Deployment/
├── tenant-a-deployment/         # Terraform code for Tenant A (SP, permissions)
│   ├── main.tf
│   ├── provider.tf
├── tenant-b-deployment/         # Terraform code for Tenant B (Key Vault, secret)
│   ├── main.tf
│   ├── provider.tf
├── README.md

---

## 🎯 Goal

From **Tenant A**, access a secret stored in **Tenant B’s** Azure Key Vault using:
- OAuth 2.0 client credentials flow
- Proper Key Vault access policies
- REST API with Bearer token
- Terraform infrastructure-as-code

---

## 🧰 Tools & Services

- Azure Active Directory (AAD)
- Azure Key Vault
- Azure Service Principals (App Registrations)
- Azure CLI
- Terraform
- GitHub

---

## 🛠️ Setup Overview

### 🔹 Tenant A (`allisonlancedevops@gmail.com`)
- Created App Registration `tf-tenant-a`
- Generated client secret
- Added API permission: `Azure Key Vault > Delegated > user_impersonation`
- Granted admin consent

### 🔹 Tenant B (`hafeezdevopsengineer@gmail.com`)
- Created App Registration `tf-tenant-b` (optional)
- Created Azure Key Vault `tenantb-kv-86577`
- Created a secret `allisonsecret`
- Created access policy for `tf-tenant-a` to allow `Get` access to secrets
- Verified Key Vault networking is open to public access

---

## 🔐 Environment Variables (used in REST call)

```bash
export CLIENT_ID="0910e006-000f-471c-81d4-7d059fb2040a"
export CLIENT_SECRET="your-actual-secret-value"
export TENANT_ID="f30b55b1-c7e1-4871-80b1-c2fa47512900"
export VAULT_NAME="tenantb-kv-86577"
export SECRET_NAME="allisonsecret"

🔄 How Secret is Retrieved
CCESS_TOKEN=$(curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&scope=https://vault.azure.net/.default" \
  https://login.microsoftonline.com/${TENANT_ID}/oauth2/v2.0/token | jq -r '.access_token')

curl -s -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  "https://${VAULT_NAME}.vault.azure.net/secrets/${SECRET_NAME}?api-version=7.4"

Expected response:
{
  "value": "cross-tenant-test-value",
  "id": "https://tenantb-kv-86577.vault.azure.net/secrets/allisonsecret/..."
}

🔹 Notes

This project uses the .default scope to access the default permissions granted to the app.

The Key Vault permission model must be set to Vault access policy, not RBAC.

Tenant A authenticates against Tenant B's token endpoint to retrieve the access token.
