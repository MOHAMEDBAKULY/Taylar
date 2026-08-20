import { DesignerNav } from "@/components/designer-nav";

export default function DesignerLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <div className="min-h-screen md:flex">
      <DesignerNav />
      <main className="flex-1">{children}</main>
    </div>
  );
}
