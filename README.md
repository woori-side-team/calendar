# calendar

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
