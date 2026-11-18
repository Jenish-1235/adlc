// A greeting for the hour of the day (0–23).
export function greeting(hour: number): string {
  if (hour < 5) return "Working late?"
  if (hour < 12) return "Good morning"
  if (hour < 17) return "Good afternoon"
  return "Good evening"
}
