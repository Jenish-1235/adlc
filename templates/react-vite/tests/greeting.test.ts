import { describe, expect, it } from "vitest"
import { greeting } from "@/lib/greeting"

describe("greeting", () => {
  it.each([
    [2, "Working late?"],
    [9, "Good morning"],
    [14, "Good afternoon"],
    [20, "Good evening"],
  ])("greeting(%i) = %j", (hour, want) => {
    expect(greeting(hour)).toBe(want)
  })
})
