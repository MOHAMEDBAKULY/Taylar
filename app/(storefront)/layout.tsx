import { StorefrontFooter, StorefrontHeader } from "@/components/storefront-chrome";

export default function StorefrontLayout({
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
