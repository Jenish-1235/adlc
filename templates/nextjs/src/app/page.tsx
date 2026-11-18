import { projectTitle } from "@/lib/project"

const steps = [
  { label: "Edit this page", detail: "src/app/page.tsx" },
  { label: "Check your work", detail: "just lint && just test" },
  { label: "Start a local database", detail: "just up" },
  { label: "Pair with an agent", detail: "claude" },
] as const

export default function Home() {
  const title = projectTitle(process.env.APP_NAME ?? "")

  return (
    <main className="page">
      <section className="card">
        <p className="eyebrow">Next.js · App Router</p>
        <h1>{title}</h1>
        <p className="lead">Your app is running. Save a file and this page updates instantly.</p>
        <ol className="steps">
          {steps.map((step) => (
            <li key={step.label}>
              <span>{step.label}</span>
              <code>{step.detail}</code>
            </li>
          ))}
        </ol>
      </section>
    </main>
  )
}
