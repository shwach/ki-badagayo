# 기받아가요 — Firebase 설정 & 배포 가이드

---

## 1단계: Firebase 프로젝트 만들기

1. https://console.firebase.google.com 접속 (구글 계정으로 로그인)
2. **"프로젝트 추가"** 클릭 → 이름: `ki-badagayo`
3. Google 애널리틱스는 선택사항, 건너뛰어도 됨

---

## 2단계: Google 로그인 활성화

1. 왼쪽 메뉴 → **Authentication** → **시작하기**
2. **Sign-in method** 탭 → **Google** 클릭 → **사용 설정** 토글 ON
3. 프로젝트 공개용 이름 입력 → **저장**

---

## 3단계: Firestore 데이터베이스 만들기

1. 왼쪽 메뉴 → **Firestore Database** → **데이터베이스 만들기**
2. **프로덕션 모드**로 시작 → 위치는 `asia-northeast3 (서울)` 선택
3. **완료** 클릭

---

## 4단계: Firestore 보안 규칙 적용

1. Firestore → **규칙** 탭
2. `firestore.rules` 파일의 내용을 전체 복사해서 붙여넣기
3. **게시** 클릭

---

## 5단계: Firebase 설정값 복사하기

1. Firebase 콘솔 → ⚙️(톱니바퀴) → **프로젝트 설정**
2. 아래로 스크롤 → **내 앱** 섹션 → `</>` (웹) 버튼 클릭
3. 앱 닉네임 입력 후 **앱 등록**
4. 표시되는 `firebaseConfig` 객체 복사

`index.html` 파일을 열고, 아래 부분을 찾아 복사한 값으로 교체:

```javascript
const firebaseConfig = {
  apiKey:            "여기에_붙여넣기",
  authDomain:        "여기에_붙여넣기",
  projectId:         "여기에_붙여넣기",
  storageBucket:     "여기에_붙여넣기",
  messagingSenderId: "여기에_붙여넣기",
  appId:             "여기에_붙여넣기"
};
```

---

## 6단계: GitHub Pages로 배포 (무료 호스팅)

1. https://github.com 회원가입 → 새 저장소 생성 (이름: `ki-badagayo`, Public)
2. 이 폴더의 파일 전부 업로드 (drag & drop)
3. Settings → Pages → Source: `main` 브랜치 → **Save**
4. 몇 분 후 `https://[내아이디].github.io/ki-badagayo` 접속 확인

### Firebase에 도메인 허용 추가 (필수!)

GitHub Pages URL을 Firebase에 등록해야 Google 로그인이 작동합니다.

1. Firebase 콘솔 → Authentication → **설정** 탭
2. **승인된 도메인** → **도메인 추가**
3. `[내아이디].github.io` 입력 → **추가**

---

## 7단계: Play Store 배포

1. 위 GitHub Pages URL이 잘 작동하는 것 확인
2. https://www.pwabuilder.com 접속 → URL 입력
3. Android → **Store Package** 다운로드 (`.aab` 파일)
4. https://play.google.com/console 개발자 등록 ($25 1회)
5. 새 앱 → 프로덕션 트랙 → `.aab` 업로드 → 심사 제출

---

## 아이콘 생성

`icons/generate.html` 파일을 Chrome으로 열어서 버튼 클릭 → 다운로드된 파일을 `icons/` 폴더에 넣기

---

## 파일 구조

```
기받아가요/
├── index.html           ← 앱 본체 (Firebase 설정값 여기에)
├── manifest.json        ← PWA 설정
├── sw.js                ← 오프라인 지원
├── firestore.rules      ← Firestore 보안 규칙 (콘솔에 붙여넣기)
└── icons/
    ├── generate.html    ← 아이콘 생성기
    ├── icon-192.png     ← 생성 후 여기에
    └── icon-512.png     ← 생성 후 여기에
```

---

## 데이터 구조 (참고)

```
Firestore
├── users/{uid}
│   ├── displayName      : string
│   ├── photoURL         : string
│   ├── kiBalance        : number     ← 보유 기
│   ├── lastDailyKi      : 'YYYY-MM-DD' ← 마지막 일일 기 수령일
│   ├── dailyAssignment  : { date, postId } ← 오늘 배정된 자랑글
│   └── lastPostKi       : 'YYYY-MM-DD' ← 마지막 자랑글 기 수령일
│
└── posts/{postId}
    ├── authorId         : string
    ├── authorName       : string
    ├── content          : string (최대 300자)
    ├── date             : 'YYYY-MM-DD'
    └── createdAt        : timestamp
```
