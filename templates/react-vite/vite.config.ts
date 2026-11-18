import react from "@vitejs/plugin-react"
import { loadEnv } from "vite"
import { defineConfig } from "vitest/config"

export default defineConfig(({ mode }) => {
  // Hostnames allowed to load the dev server besides localhost, e.g. when it runs
  // on a remote dev machine: DEV_ALLOWED_HOSTS="devbox,*.apps.example.dev".
  const env = loadEnv(mode, ".", "DEV_")
  const allowedHosts = (env.DEV_ALLOWED_HOSTS ?? "")
    .split(",")
    .map((host) => host.trim().replace(/^\*\./, "."))
    .filter((host) => host !== "")

  return {
    plugins: [react()],
    resolve: { alias: { "@": new URL("./src", import.meta.url).pathname } },
    server: { allowedHosts },
  }
})
