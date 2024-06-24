import RootStyleRegistry from "@/provider/emotionRegistry";
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "@radix-ui/themes/styles.css";
import { Theme } from "@radix-ui/themes";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Polymorphic",
  description: "example polymorphic component",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <RootStyleRegistry>
      <Theme>
        <html lang="kr">
          <body className={inter.className}>{children}</body>
        </html>
      </Theme>
    </RootStyleRegistry>
  );
}
