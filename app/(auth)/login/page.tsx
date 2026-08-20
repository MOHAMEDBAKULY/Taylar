"use client";

import { useState } from "react";
import { createClient } from "@/lib/supabase/client";

export default function LoginPage() {
  const [error, setError] = useState<string | null>(null);
  const [pending, setPending] = useState(false);

  async function signInWithGoogle() {
    setError(null);
    setPending(true);

    try {
      const supabase = createClient();
      const next = new URLSearchParams(window.location.search).get("next") ?? "/";
      const { error: oauthError } = await supabase.auth.signInWithOAuth({
        provider: "google",
        options: {
          redirectTo: `${window.location.origin}/auth/callback?next=${encodeURIComponent(next)}`,
        },
      });

      if (oauthError) {
        setError(oauthError.message);
        setPending(false);
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unable to start Google sign-in");
      setPending(false);
    }
  }

  return (
    <section className="mx-auto max-w-md px-4 py-16 text-center">
      <h1 className="font-[family-name:var(--font-display)] text-4xl">Sign in</h1>
      <p className="mt-3 text-[var(--muted)]">
        Use Google to save measurements, place orders, pay, track production, and leave a review after
        delivery. Guests can still browse the store.
      </p>
      <button
        type="button"
        onClick={signInWithGoogle}
        disabled={pending}
        className="mt-8 w-full rounded-full bg-[var(--accent)] px-6 py-3 text-white disabled:opacity-60"
      >
        {pending ? "Redirecting…" : "Continue with Google"}
      </button>
      {error ? <p className="mt-4 text-sm text-red-700">{error}</p> : null}
    </section>
  );
}
