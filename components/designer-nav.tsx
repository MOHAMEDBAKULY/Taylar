import Link from "next/link";
import { APP_NAME, DESIGNER_NAV } from "@/lib/constants";

export function DesignerNav() {
  return (
    <aside className="border-b border-stone-200 bg-stone-50 p-4 md:min-h-screen md:w-56 md:border-b-0 md:border-r">
      <Link href="/designer" className="font-[family-name:var(--font-display)] text-xl">
        {APP_NAME}
      </Link>
      <p className="mt-1 text-xs uppercase tracking-wide text-[var(--muted)]">Designer</p>
      <nav className="mt-6 flex flex-col gap-2 text-sm">
        {DESIGNER_NAV.map((item) => (
          <Link key={item.href} href={item.href} className="text-[var(--muted)] hover:text-[var(--foreground)]">
            {item.label}
          </Link>
        ))}
        <Link href="/" className="mt-4 text-[var(--accent)]">
          View storefront
        </Link>
      </nav>
    </aside>
  );
}
