import { StorefrontFooter, StorefrontHeader } from "@/components/storefront-chrome";
import { CustomerNav } from "@/components/customer-nav";

export default function CustomerLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <div className="min-h-screen">
      <StorefrontHeader />
      <CustomerNav />
      <main>{children}</main>
      <StorefrontFooter />
    </div>
  );
}
