# 이지 스케쥴러

달력 앱

## 정보

- Flutter 기반
- 타겟: Android, iOS

## 구조

- Clean architecture 기반
- [참고 링크](https://devmuaz.medium.com/flutter-clean-architecture-series-part-1-d2d4c2e75c47)
- 데이터 흐름: data -> domain -> presentation

```text
lib
+- common
|  +- ...
+- data: 로컬/외부 DB 담당
|  +- data_sources: DB 데이터 표현 (Entity)
|  +- mappers: Entity -> Model 변환
|  +- repositories_impl: domain/repositories 구현
+- domain: 비즈니스 로직 담당, data랑 presentation 연결
|  +- models: 앱 내부용 (i.e view용) 데이터 표현
|  +- repositories: 데이터 관련 연산들
|  +- use_cases: 각 비즈니스 로직
+- presentation: View 담당
|  +- widgets: View (및 ViewModel)
|  +- providers: 여러 view들 간의 공통 상태
```

## 기타

스플래시 이미지 업데이트

```
flutter pub run flutter_native_splash:create
```

---
<img src="https://velog.velcdn.com/images/new/post/d58d3132-0a80-4db3-90ae-de3eb3594f50/image.jpg" width="300px">

### 스케쥴 리스트 화면
- 선택한 날짜의 스케쥴 리스트를 보여주는 화면
- 스케쥴 시작 시간 순대로 정렬


### 홈화면

---
<img src="https://velog.velcdn.com/images/new/post/5b77d684-99fe-4604-a4a8-08bf675afece/image.jpg" width="300px">

### 다가올 일정(BottomSheet)

- 오늘과 가장 가까운 일정부터 차례로 간략하게 리스트 형태로 보여줌
- 년월일시를 입력하면 그 날짜에 스케쥴 추가(예: 2025년 11월 28일 첫 출근)
  - 2025년 11월 28일 9시
  - 2025-11-28 9시
  - 2025/11/28 9시
  - 11/28 9시
- 편집 버튼을 통해 일정 수정 및 삭제 가능

---
<img src="https://velog.velcdn.com/images/new/post/3f1917b3-f8bc-4295-a164-3818697c728b/image.jpg" width="300px">

---
<img src="https://velog.velcdn.com/images/new/post/3f1917b3-f8bc-4295-a164-3818697c728b/image.jpg" width="300px">

### 스케쥴 추가/수정 화면
- 스케쥴 시작/종료 시간 설정
- 스케쥴 시작 전 원하는 시간에 스케쥴 알림 기능(10분 전, 30분 전, 1시간 전, 2시간 전, 1일 전)
- 태그 색으로 스케쥴 색 선택

---
<img src="https://velog.velcdn.com/images/new/post/7ea03138-1c94-49d7-8277-b6f32298a8dc/image.jpg" width="300px">

### 스캐쥴 검색 화면

- 스케쥴 검색 기능
- 아이템 터치 시 수정 화면으로 이동
