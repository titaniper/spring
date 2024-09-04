스프링의 `@Transactional` 어노테이션은 메서드나 클래스에 트랜잭션 경계를 선언적으로 정의할 수 있게 해주는 기능입니다. 
이를 통해 데이터베이스 작업의 원자성, 일관성, 격리성, 지속성(ACID 속성)을 보장할 수 있습니다.

다음은 `@Transactional`의 모든 옵션에 대한 정리 테이블입니다:
기본적으로는 상위 트랜잭션에 속합니다.

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| value / transactionManager | 사용할 트랜잭션 관리자 | "" |
| propagation | 트랜잭션 전파 방식 | Propagation.REQUIRED |
| isolation | 트랜잭션 격리 수준 | Isolation.DEFAULT |
| timeout | 트랜잭션 타임아웃 (초 단위) | -1 (DB 기본값 사용) |
| readOnly | 읽기 전용 트랜잭션 여부 | false |
| rollbackFor | 롤백을 유발하는 예외 클래스 목록 | {} |
| rollbackForClassName | 롤백을 유발하는 예외 클래스 이름 목록 | {} |
| noRollbackFor | 롤백을 유발하지 않는 예외 클래스 목록 | {} |
| noRollbackForClassName | 롤백을 유발하지 않는 예외 클래스 이름 목록 | {} |

각 옵션에 대한 예시:

1. value / transactionManager
```java
@Transactional("customTransactionManager")
public void someMethod() {
    // 메서드 내용
}
```

2. propagation
```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void someMethod() {
    // 항상 새로운 트랜잭션 시작
}
```

3. isolation
```java
@Transactional(isolation = Isolation.SERIALIZABLE)
public void someMethod() {
    // 가장 높은 격리 수준으로 실행
}
```

4. timeout
```java
@Transactional(timeout = 30)
public void someMethod() {
    // 30초 후 트랜잭션 타임아웃
}
```

5. readOnly
```java
@Transactional(readOnly = true)
public List<User> getAllUsers() {
    // 읽기 전용 트랜잭션으로 실행
}
```

6. rollbackFor
```java
@Transactional(rollbackFor = {SQLException.class, IOException.class})
public void someMethod() throws SQLException, IOException {
    // SQLException 또는 IOException 발생 시 롤백
}
```

7. rollbackForClassName
```java
@Transactional(rollbackForClassName = {"java.sql.SQLException", "java.io.IOException"})
public void someMethod() throws SQLException, IOException {
    // SQLException 또는 IOException 발생 시 롤백
}
```

8. noRollbackFor
```java
@Transactional(noRollbackFor = {IllegalArgumentException.class})
public void someMethod() {
    // IllegalArgumentException 발생 시 롤백하지 않음
}
```

9. noRollbackForClassName
```java
@Transactional(noRollbackForClassName = {"java.lang.IllegalArgumentException"})
public void someMethod() {
    // IllegalArgumentException 발생 시 롤백하지 않음
}
```

이러한 옵션들을 조합하여 사용하면 트랜잭션의 동작을 세밀하게 제어할 수 있습니다. 각 옵션은 특정 상황에 맞게 선택적으로 사용될 수 있으며, 대부분의 경우 기본값으로도 충분히 동작합니다.