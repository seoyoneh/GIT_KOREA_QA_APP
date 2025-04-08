# 초중품관리 앱 개발 문서
**(주의) 모바일 앱 특성상 버전 업데이트가 빈번합니다. SDK 업데이트, 패키지 업데이트를 게을리하면 앱 스토어에서 블록 당할 수 있으므로 매주 어플리케이션 버전을 체크하는 것을 잊지마세요.**  

*본 문서는 Visual Studio Code 개발환경을 상정하고 작성된 문서입니다.*

## 0.프로젝트 개요
서연이화 초중품관리앱은 OEM 및 협력사를 위한 초품/중품 외관 검사 결과를 관리하는 모바일 애플리케이션입니다.

## 1. 어플리케이션 개요
- Language : Dart
- Platform : Flutter(3.29.2)
- Java : 21.0.5
- Gradle : 8.4

## 2. SDK
- [Flutter](https://docs.flutter.dev/release/archive)
- [JDK](https://www.oracle.com/kr/java/technologies/downloads/#java21)
- [Gradle](https://services.gradle.org/distributions/gradle-8.4-all.zip)

## 3. IDE Tool
- [Android Studio](https://developer.android.com/studio?hl=ko)
- [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
- [Visual Studio Code](https://code.visualstudio.com/download)

## 4. 기술 스택
- Flutter SDK: ^3.6.0
- 상태관리: flutter_riverpod ^2.6.1
- 라우팅: go_router ^14.8.1
- 다국어: easy_localization ^3.0.7+1
- 로컬 DB: hive_flutter ^1.1.0
- HTTP 통신: dio ^5.8.0+1
- 카메라: camera ^0.11.1
- PDF 뷰어: flutter_pdfview ^1.4.0

## 5. 개발환경 세팅
⚡️이번 챕터는 위에 2, 3번에 기술한 SDK, IDE툴을 모두 다운로드 완료했다는 것을 전제로 합니다.  
⚡️이번 챕터는 GIT_KOREA_QA_APP 의 development 브랜치 소스를 로컬환경에 다운로드 했다는 것을 전제로 합니다.  
⚡️iOS 앱도 함께 개발해야하므로 사용하는 운영체제는 MacOS로 고정합니다.

### 5.1. 환경변수 설정
위에서 다운로드 한 각 SDK 압축파일을 적당한 곳에 압축을 해제한다.  
ex) ~/development/sdk/flutter

앞으로의 설명은 최신 MacOS는 Zshell(zsh)을 사용하므로 zsh기준으로 설명한다.  
```bash
$ vi ~/.zshrc
```
터미널에서 위의 명령을 실행하여 vi 에디터를 실행한다.(vi에디터 사용방법은 [https://blockdmask.tistory.com/25](https://blockdmask.tistory.com/25)에서 확인한다.)  
.zshrc 파일 제일 하단에 아래의 내용을 추가한다.
```sh
export DEV_SDK="$HOME/development/sdk"

#JDK
export JAVA_HOME="$DEV_SDK/jdk/jdk-21.0.5.jdk/Contents/Home"
export PATH="JAVA_HOME/bin:$PATH"

# Flutter SDK Path
export FLUTTER_HOME="$DEV_SDK/flutter"
export PATH="$PATH:$FLUTTER_HOME/bin"
```
위 내용을 작성하고 저장한 뒤 vi 에디터를 종료한 뒤 아래의 명령어를 실행한다.
```bash
$ source ~/.zshrc
```
```bash
$ flutter --version
Flutter 3.29.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision c236373904 (3 weeks ago) • 2025-03-13 16:17:06 -0400
Engine • revision 18b71d647a
Tools • Dart 3.7.2 • DevTools 2.42.3
```
이렇게 flutter 버전이 나오면 정상적으로 Flutter 환경변수가 설정되었다고 보면 된다.  
P.S) java -version 을 실행하면 JDK의 버전을 확인할 수 있다.


### 5.2. 가상머신(Simulator) 생성
#### Android Simulator
Android Studio에서 비어있는 아무 Flutter 프로젝트를 생성한다.  
생성된 프로젝트의 메뉴 중 Tools > Device Manager를 선택하면 Device Manager 사이드 창이 활성화 된다. '+' 버튼을 누르고 'Create Virtual Device' 메뉴를 선택하면 가상 디바이스를 생성할 수 있다.

#### iOS Simulator
터미널에서 아래의 명령어를 입력한다.
```bash
$ open -a simulator
```
아이폰 시뮬레이터가 실행되지 않을 경우 XCode가 정상적으로 설치되었고 실행되는지 확인한다.

### 5.3. 앱 실행
본 자료는 Visual Studio Code를 사용하여 테스트 하는 것을 기본으로 한다.  
Visual Studio Code를 실행하고 Cmd + p 를 입력한 뒤 '>show extensions'라고 입력하면 확장 툴 브라우저가 나오는데 여기서 'Flutter' 확장팩을 설치한다.

확장팩이 설치 된 후에 다시 Cmd + P를 입력한 뒤에 '>Flutter Run Flutter Doctor'를 입력하면 Flutter Doctor라는 프로그램이 실행되는 데 이때 맨 마지막에 "No issues found!' 라는 메시지가 나와야하며 문제가 있다면 출력된 가이드에 따라 문제를 해결한다.  

*(P.S: 출력된 가이드가 굉장히 상세하게 나오므로 가이드에 따라 조치하면 왠만한 문제는 해결할 수 있다. 이 가이드 문서에서 누락된 부분도 해결할 수 있도록 가이드 해준다.)*

모든 문제를 해결했다면 다시 Cmd + P를 입력하고 '>flutter: Launch Emulator'라고 입력하면 앞서 생성한 Simulator 목록이 나오게 된다.  
원하는 환경을 선택하면 Simulator가 실행된다. 그리고 F5키를 입력하면 코드가 컴파일 되고 앱이 실행된다.

## 6. 개발환경변수(ENV)
모든 웹, 어플리케이션은 환경변수가 필요하다. 개발환경, 운영환경에 따라서 서로 다른 환경변수가 필요하기 때문인데 이는 어플리케이션에 취약점을 만들게 된다. 이를 위해 이 프로그램은 모든 환경변수를 AES로 암호화하여 컴파일 하고 런타임 중에 복호화하여 사용하게 된다. 이것은 어플리케이션 파일(예컨데 안드로이드의 apk파일과 같은)을 디컴파일하여 앱의 치명적인 정보를 취득해 악용할 것을 미연에 방지하기 위함이다.

프로젝트 루트 디렉토리엔 세개의 환경변수 파일이 있는데 아래와 같다.
- .env.local.decrypt : 로컬개발환경 환경변수 평문 파일
- .env.dev.decrypt : 개발환경 환경변수 평문 파일
- .env.prod.decrypt : 운영환경 환경변수 평문 파일

그리고 test 디렉토리 안에 env_encrypt_test.dart 파일이 있는데 여기에 환경변수 파일을 암호화 하여 assets/env 디렉토리에 저장하는 기능을 수행한다. env_encrypt_test.dart 파일을 열고 *main()* 진입점 위에 *Run/Debug* 라고 표시가 나타날 텐데 여기서 Run을 클릭하면 암호화 프로그램이 실행되며 자동으로 assets/env에 암호화된 파일을 저장하는 역할을 수행한다.

## 7. 주요 기능
- OEM/협력사 구분 로그인
- 초품/중품 외관 검사 결과 등록
- 카메라를 통한 이미지 업로드
- 검사 기준서 확인
- 다국어 지원 (한국어/영어)

## 8. 주요 화면
- 앱 접근 권한 안내 (QIS002)
- OEM/협력사 선택 (QIS003)
- 로그인 (QIS004/QIS005)
- 사용자 정보 입력 (QIS006/QIS007)
- 검사 결과 등록 (QIS008/QIS009)
- 검사 기준서 확인 (QIS012)

## 9. 프로젝트 구조
```
lib/
├── components/     # 재사용 가능한 UI 컴포넌트
├── constants/      # 상수 정의
├── core/          # 핵심 기능 (라우팅, 테마 등)
├── models/        # 데이터 모델
├── services/      # 비즈니스 로직
├── utils/         # 유틸리티 함수
└── views/         # 화면 UI
```

각 클래스들의 역할들은 아래에 정리하겠다.

## 라이선스
이 프로젝트는 서연이화의 자산이며, 무단 복제 및 배포를 금지합니다.