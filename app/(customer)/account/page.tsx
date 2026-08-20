import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Account" };

export default function AccountPage() {
  return (
    <PagePlaceholder
      title="Account"
      description="Your profile, saved delivery city, and contact details. Authentication is required."
      nextSteps={["Load GET /api/me", "Edit delivery address and phone"]}
    />
  );
}
