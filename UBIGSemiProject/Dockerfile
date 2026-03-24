# 1단계: 빌드 단계 (Maven + Java 11)
FROM maven:3.8.1-openjdk-11-slim AS build
WORKDIR /app

# 라이브러리 캐싱을 위해 pom.xml 먼저 복사 및 다운로드
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 소스 코드 복사 및 빌드 실행 (테스트 생략)
COPY src ./src
RUN mvn clean package -DskipTests -B

# 2단계: 실행 단계 (Tomcat 9)
FROM tomcat:9.0-jdk11-openjdk-slim

# 톰맷의 webapps 디렉토리 비우기
RUN rm -rf /usr/local/tomcat/webapps/*

# 빌드 단계에서 생성된 war 파일을 톰캣의 ROOT.war로 복사
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 환경 변수 설정
ENV LANG C.UTF-8
ENV TZ Asia/Seoul

# 8080 포트 노출
EXPOSE 8080

# 톰맷 실행
CMD ["catalina.sh", "run"]
