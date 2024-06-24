import RootStyleRegistry from "@/provider/emotionRegistry";
import type { Metadata } from "next";
import { Inter } from "next/font/google";

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
      <html lang="kr">
        <body className={inter.className}>{children}</body>
      </html>
    </RootStyleRegistry>
  );
}
