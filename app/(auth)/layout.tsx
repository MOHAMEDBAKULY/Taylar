import type { Metadata } from "next";
import { StorefrontFooter, StorefrontHeader } from "@/components/storefront-chrome";

export const metadata: Metadata = { title: "Sign in" };

export default function AuthLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <div className="min-h-screen">
      <StorefrontHeader />
      <main>{children}</main>
      <StorefrontFooter />
    </div>
  );
}
