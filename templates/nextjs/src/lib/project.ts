// Turns a package name like "recipe-box" into a display title like "Recipe Box".
export function projectTitle(packageName: string): string {
  const words = packageName.split(/[-_\s]+/).filter((word) => word !== "")
  if (words.length === 0) return "Your App"
  return words.map((word) => word.charAt(0).toUpperCase() + word.slice(1)).join(" ")
}
