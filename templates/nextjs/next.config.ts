import type { NextConfig } from "next"

// Hostnames allowed to load the dev server besides localhost, e.g. when it runs
// on a remote dev machine: DEV_ALLOWED_HOSTS="devbox,*.apps.example.dev".
const devAllowedHosts = (process.env.DEV_ALLOWED_HOSTS ?? "")
  .split(",")
  .map((host) => host.trim())
  .filter((host) => host !== "")

const config: NextConfig = {
  cacheComponents: true,
  typedRoutes: true,
  allowedDevOrigins: devAllowedHosts,
}

export default config
