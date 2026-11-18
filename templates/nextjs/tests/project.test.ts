import { describe, expect, it } from "vitest"
import { projectTitle } from "@/lib/project"

describe("projectTitle", () => {
  it.each([
    ["recipe-box", "Recipe Box"],
    ["api_server", "Api Server"],
    ["app", "App"],
    ["", "Your App"],
  ])("projectTitle(%j) = %j", (input, want) => {
    expect(projectTitle(input)).toBe(want)
  })
})
