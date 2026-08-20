type PagePlaceholderProps = {
  title: string;
  description: string;
  nextSteps?: string[];
};

export function PagePlaceholder({ title, description, nextSteps }: PagePlaceholderProps) {
  return (
    <section className="mx-auto max-w-3xl px-4 py-12">
      <p className="text-xs uppercase tracking-[0.2em] text-[var(--accent)]">Scaffold</p>
      <h1 className="mt-2 font-[family-name:var(--font-display)] text-4xl">{title}</h1>
      <p className="mt-4 text-[var(--muted)]">{description}</p>
      {nextSteps && nextSteps.length > 0 ? (
        <ul className="mt-6 list-disc space-y-2 pl-5 text-sm text-[var(--muted)]">
          {nextSteps.map((step) => (
            <li key={step}>{step}</li>
          ))}
        </ul>
      ) : null}
    </section>
  );
}
