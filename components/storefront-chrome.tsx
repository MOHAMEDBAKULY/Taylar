import Link from "next/link";
import { APP_NAME, STOREFRONT_NAV } from "@/lib/constants";

export function StorefrontHeader() {
  return (
    <header className="border-b border-stone-200 bg-[var(--background)]">
      <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-4 py-4">
        <Link href="/" className="font-[family-name:var(--font-display)] text-2xl tracking-tight">
          {APP_NAME}
        </Link>
        <nav className="flex flex-wrap items-center gap-4 text-sm">
          {STOREFRONT_NAV.map((item) => (
            <Link key={item.href} href={item.href} className="text-[var(--muted)] hover:text-[var(--foreground)]">
              {item.label}
            </Link>
          ))}
          <Link
            href="/login"
            className="rounded-full bg-[var(--accent)] px-4 py-1.5 text-white hover:opacity-90"
          >
            Sign in
          </Link>
        </nav>
      </div>
    </header>
  );
}

export function StorefrontFooter() {
  return (
    <footer className="mt-16 border-t border-stone-200 py-8 text-center text-sm text-[var(--muted)]">
      {APP_NAME} · Custom clothing in KES · Mombasa, Nairobi, Nakuru
    </footer>
  );
}
