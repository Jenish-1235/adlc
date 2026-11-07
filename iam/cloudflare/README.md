# Cloudflare agent tokens

Cloudflare API tokens grant permission groups, each Read or Edit. The API calls Edit "Write", for example `DNS Write`. Use group IDs from `GET /accounts/{account_id}/tokens/permission_groups`, because Cloudflare says group names can change.

## read-only (staging and production accounts)

| Scope | Permission groups |
|---|---|
| Account | Account Settings Read, Workers Scripts Read, Cloudflare Pages Read, Cloudflare Tunnel Read, Hyperdrive Read, Queues Read, Account Rulesets Read, Load Balancing: Monitors and Pools Read, Notifications Read |
| Zone | Zone Read, DNS Read, Zone Settings Read, SSL and Certificates Read, Firewall Services Read, Zone WAF Read, Cache Rules Read, Workers Routes Read, Load Balancers Read, Analytics Read |

Never grant these, even as Read:

- **Workers KV Storage Read**: returns stored values.
- **Workers R2 Storage Read**: reads and lists objects.
- **D1 Read**: accepted by the D1 query endpoint, which runs any SQL you send.
- **Logs Read, Workers Tail Read, Zero Trust: PII Read**: request data and personal data.
- **Billing Read and Edit, Account Settings Edit, any API Tokens or Memberships group**: billing and access control.

Workers Scripts Read returns script code and plain-text `vars`. Secret binding values are not returned. Queues Read cannot pull messages, because pulling requires Queues Write.

## write-no-delete: not achievable

Edit always includes delete. `DELETE /zones/{zone_id}/dns_records/{id}` requires `DNS Write`, the same group used to create records. `DELETE .../workers/scripts/{name}` requires `Workers Scripts Write`. Token policies can say `"effect": "deny"`, but only for a whole permission group, not for one HTTP method. A proxy that blocks `DELETE` won't work either, because some deletes are POSTs, such as `POST /zones/{zone_id}/dns_records/batch` with `deletes`.

The safest alternative:

1. Put sandbox work in a separate Cloudflare account.
2. Give the agent an account-owned token for that account only. Add the read set above, plus Workers Scripts Edit, Workers KV Storage Edit, Workers R2 Storage Edit, D1 Edit, Queues Edit, Cloudflare Pages Edit, and Hyperdrive Edit. Add zone-level Workers Routes Edit and DNS Edit for the sandbox zone only.
3. Treat deletes in the sandbox as accepted risk. Everywhere else, the agent gets only the read-only token, and a human applies changes with their own credentials.

## Scope, IP range, and TTL

Prefer account-owned tokens (Manage account > Account API tokens). They aren't tied to a person, and they use the scannable `cfat_` prefix. Page Rules, Turnstile, and Registrar don't support them yet. Account groups only apply to account resources, and zone groups only to zones, so use one policy for each. Dashboard expiry dates are 00:00 UTC; the API takes exact timestamps. IP filtering doesn't apply to the Verify Token endpoint.

```sh
curl "https://api.cloudflare.com/client/v4/accounts/<account-id>/tokens" \
  -H "Authorization: Bearer <token-with-Account-API-Tokens-Edit>" \
  -H "Content-Type: application/json" \
  --data '{
    "name": "agent-read-only",
    "policies": [
      {"effect": "allow",
       "resources": {"com.cloudflare.api.account.<account-id>": "*"},
       "permission_groups": [{"id": "<account-group-id>"}]},
      {"effect": "allow",
       "resources": {"com.cloudflare.api.account.zone.<zone-id>": "*"},
       "permission_groups": [{"id": "c8fed203ed3043cba015a93ad1616f1f"}, {"id": "82e64a83756745bbbb1c9c2701bf816b"}]}
    ],
    "expires_on": "2026-12-07T00:00:00Z",
    "condition": {"request.ip": {"in": ["<agent-egress-cidr>"]}}
  }'
```

The two zone group IDs are Zone Read and DNS Read, taken from Cloudflare's docs. To cover all zones in an account, replace the zone resource with `"com.cloudflare.api.account.<account-id>": {"com.cloudflare.api.account.zone.*": "*"}`.
