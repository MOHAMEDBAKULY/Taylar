import Link from "next/link";
import { CUSTOMER_NAV } from "@/lib/constants";

export function CustomerNav() {
  return (
    <nav className="flex flex-wrap gap-3 border-b border-stone-200 px-4 py-3 text-sm">
      {CUSTOMER_NAV.map((item) => (
        <Link key={item.href} href={item.href} className="text-[var(--muted)] hover:text-[var(--foreground)]">
          {item.label}
        </Link>
      ))}
    </nav>
  );
}
