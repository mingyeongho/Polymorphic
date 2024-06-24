# Polymorphic component

### as props를 사용하여 여러 태그로 사용할 수 있도록 한다.

    <Button onClick={() => router.push("https://www.naver.com")}>Link</Button>

    버튼에 이런식으로 쓰는 것보다

    <Button as="a" href="https://www.naver.com">Link</Button>

    이런식으로 쓰도록
