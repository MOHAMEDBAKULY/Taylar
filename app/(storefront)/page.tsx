import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Custom clothing, made to measure",
};

export default function HomePage() {
  return (
    <div>
      <section className="mx-auto max-w-6xl px-4 py-16">
        <p className="text-xs uppercase tracking-[0.2em] text-[var(--accent)]">For women and girls</p>
        <h1 className="mt-3 max-w-2xl font-[family-name:var(--font-display)] text-5xl leading-tight">
          Custom-made clothes, ordered from home
        </h1>
        <p className="mt-4 max-w-xl text-lg text-[var(--muted)]">
          Choose a design, add measurements in centimetres, pick fabric and color, then see the price
          and timeline before you pay in Kenyan Shillings.
        </p>
        <div className="mt-8 flex flex-wrap gap-3">
          <Link
            href="/designers"
            className="rounded-full bg-[var(--accent)] px-6 py-2.5 text-white hover:opacity-90"
          >
            Start shopping
          </Link>
          <Link href="/search" className="rounded-full border border-stone-300 px-6 py-2.5">
            Search designs
          </Link>
        </div>
      </section>

      <section className="mx-auto grid max-w-6xl gap-6 px-4 pb-16 md:grid-cols-3">
        {[
          { title: "Featured designs", href: "/designs/ffffffff-ffff-ffff-ffff-ffffffff0001", body: "Evening dresses, skirts, and more from the designer catalog." },
          { title: "Categories", href: "/categories/dresses", body: "Dresses, suits, skirts, tops, trousers, and other women's clothing." },
          { title: "Designer discovery", href: "/designers", body: "Browse the designer store. MVP starts with one atelier, marketplace-ready." },
        ].map((card) => (
          <Link key={card.title} href={card.href} className="rounded-2xl border border-stone-200 p-6 hover:border-[var(--accent)]">
            <h2 className="font-[family-name:var(--font-display)] text-2xl">{card.title}</h2>
            <p className="mt-2 text-sm text-[var(--muted)]">{card.body}</p>
          </Link>
        ))}
      </section>
    </div>
  );
}
