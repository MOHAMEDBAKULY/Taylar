import Stripe from "stripe";

export function getStripe() {
  const secret = process.env.STRIPE_SECRET_KEY;
  if (!secret) {
    throw new Error("Missing STRIPE_SECRET_KEY");
  }

  return new Stripe(secret);
}
