import { Text as MyText } from "@/components";

export default function Home() {
  return (
    <main>
      <MyText>Text</MyText>
      <MyText as="h2">Text</MyText>
    </main>
  );
}
