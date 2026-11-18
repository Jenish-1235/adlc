import { greeting } from "@/lib/greeting"

const steps = [
  { label: "Edit this screen", detail: "src/App.tsx" },
  { label: "Check your work", detail: "just lint && just test" },
  { label: "Start a local database", detail: "just up" },
  { label: "Pair with an agent", detail: "claude" },
] as const

export function App() {
  return (
    <main className="page">
      <section className="card">
        <p className="eyebrow">React · Vite</p>
        <h1>{greeting(new Date().getHours())}</h1>
        <p className="lead">Your app is running. Save a file and this screen updates instantly.</p>
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
