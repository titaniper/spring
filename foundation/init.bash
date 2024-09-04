#!/bin/bash

# # 서브디렉토리 생성
# mkdir -p basics/{ioc-container,dependency-injection,aop}
# mkdir -p web/{spring-mvc,rest-api,websocket}
# mkdir -p data-access/{jdbc,jpa,transactions}
# mkdir -p security/{authentication,authorization}
# mkdir -p testing/{unit-tests,integration-tests}
# mkdir -p boot/{auto-configuration,actuator}
# mkdir -p cloud/{config,eureka,gateway}
# mkdir -p advanced/{caching,messaging,batch}

# 서브디렉토리 생성 및 .gitkeep 파일 추가 함수
create_dir_with_gitkeep() {
    mkdir -p "$1"
    touch "$1/.gitkeep"
}

# 디렉토리 생성 및 .gitkeep 파일 추가
create_dir_with_gitkeep "basics/ioc-container"
create_dir_with_gitkeep "basics/dependency-injection"
create_dir_with_gitkeep "basics/aop"

create_dir_with_gitkeep "web/spring-mvc"
create_dir_with_gitkeep "web/rest-api"
create_dir_with_gitkeep "web/websocket"

create_dir_with_gitkeep "data-access/jdbc"
create_dir_with_gitkeep "data-access/jpa"
create_dir_with_gitkeep "data-access/transactions"

create_dir_with_gitkeep "security/authentication"
create_dir_with_gitkeep "security/authorization"

create_dir_with_gitkeep "testing/unit-tests"
create_dir_with_gitkeep "testing/integration-tests"

create_dir_with_gitkeep "boot/auto-configuration"
create_dir_with_gitkeep "boot/actuator"

create_dir_with_gitkeep "cloud/config"
create_dir_with_gitkeep "cloud/eureka"
create_dir_with_gitkeep "cloud/gateway"

create_dir_with_gitkeep "advanced/caching"
create_dir_with_gitkeep "advanced/messaging"
create_dir_with_gitkeep "advanced/batch"

echo "Spring study directory structure created successfully!"