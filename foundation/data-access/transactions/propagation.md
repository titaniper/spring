트랜잭션 전파(Transaction Propagation)

트랜잭션 전파 옵션 테이블:

| 전파 옵션 | 설명 |
|-----------|------|
| REQUIRED | 현재 트랜잭션을 지원하고, 없으면 새로운 트랜잭션 시작 |
| SUPPORTS | 현재 트랜잭션을 지원하고, 없으면 비트랜잭션으로 실행 |
| MANDATORY | 현재 트랜잭션을 지원하고, 없으면 예외 발생 |
| REQUIRES_NEW | 항상 새로운 트랜잭션 시작, 기존 트랜잭션 일시 중단 |
| NOT_SUPPORTED | 비트랜잭션으로 실행, 기존 트랜잭션 일시 중단 |
| NEVER | 비트랜잭션으로 실행, 기존 트랜잭션이 있으면 예외 발생 |
| NESTED | 현재 트랜잭션이 있으면 중첩 트랜잭션 실행, 없으면 REQUIRED와 동일 |

각 전파 옵션에 대한 예시:

1. REQUIRED (기본값)
```java
@Transactional(propagation = Propagation.REQUIRED)
public void requiredExample() {
    // 기존 트랜잭션이 있으면 참여, 없으면 새로 시작
}
```

2. SUPPORTS
```java
@Transactional(propagation = Propagation.SUPPORTS)
public void supportsExample() {
    // 기존 트랜잭션이 있으면 참여, 없어도 실행 (트랜잭션 없이)
}
```

3. MANDATORY
```java
@Transactional(propagation = Propagation.MANDATORY)
public void mandatoryExample() {
    // 반드시 기존 트랜잭션 내에서 실행되어야 함, 없으면 예외 발생
}
```

4. REQUIRES_NEW
```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void requiresNewExample() {
    // 항상 새로운 트랜잭션을 시작, 기존 트랜잭션은 일시 중단
}
```

5. NOT_SUPPORTED
```java
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public void notSupportedExample() {
    // 트랜잭션 없이 실행, 기존 트랜잭션이 있다면 일시 중단
}
```

6. NEVER
```java
@Transactional(propagation = Propagation.NEVER)
public void neverExample() {
    // 트랜잭션 없이 실행, 기존 트랜잭션이 있으면 예외 발생
}
```

7. NESTED
```java
@Transactional(propagation = Propagation.NESTED)
public void nestedExample() {
    // 기존 트랜잭션 내에서 중첩 트랜잭션 실행, 없으면 새로 시작
}
```

실제 사용 예시:

```java
@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Transactional(propagation = Propagation.REQUIRED)
    public void createUser(User user) {
        userRepository.save(user);
        sendWelcomeEmail(user); // 이 메서드가 새 트랜잭션을 시작함
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void sendWelcomeEmail(User user) {
        // 이메일 전송 로직
        // 이 메서드는 항상 새로운 트랜잭션에서 실행됨
    }

    @Transactional(propagation = Propagation.SUPPORTS)
    public User getUser(Long id) {
        // 읽기 작업은 트랜잭션이 꼭 필요하지 않을 수 있음
        return userRepository.findById(id).orElse(null);
    }

    @Transactional(propagation = Propagation.MANDATORY)
    public void updateUserStatus(Long userId, String status) {
        // 이 메서드는 반드시 기존 트랜잭션 내에서 호출되어야 함
        User user = userRepository.findById(userId).orElseThrow();
        user.setStatus(status);
        userRepository.save(user);
    }
}
```

이러한 전파 옵션을 적절히 사용하면 복잡한 비즈니스 로직에서 트랜잭션을 효과적으로 관리할 수 있습니다. 각 상황에 맞는 전파 옵션을 선택하여 데이터 일관성과 성능을 최적화할 수 있습니다.


# NESTED vs REQUIRES_NEW

1. 트랜잭션 일시 중단 (NOT_SUPPORTED)

- 의미: 현재 실행 중인 트랜잭션을 일시적으로 중단하고, 해당 메서드를 트랜잭션 없이 실행합니다.
- 특징:
  - 기존 트랜잭션은 잠시 중단되고, 메서드 실행이 끝나면 다시 재개됩니다.
  - 메서드 내부의 작업은 트랜잭션 없이 실행됩니다.
- 사용 예: 트랜잭션이 필요 없는 읽기 전용 작업이나 외부 시스템과의 통신 등

```java
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public void someNonTransactionalWork() {
    // 트랜잭션 없이 실행되는 코드
}
```

2. REQUIRES_NEW

- 의미: 항상 새로운 트랜잭션을 시작합니다.
- 특징:
  - 기존 트랜잭션이 있다면 일시 중단되고, 완전히 새로운 트랜잭션이 시작됩니다.
  - 새 트랜잭션은 기존 트랜잭션과 완전히 독립적입니다.
  - 새 트랜잭션이 완료된 후 기존 트랜잭션이 재개됩니다.
- 사용 예: 기존 트랜잭션의 성공/실패와 관계없이 반드시 수행되어야 하는 작업

```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void independentTransactionalWork() {
    // 새로운, 독립적인 트랜잭션에서 실행되는 코드
}
```

3. NESTED

- 의미: 현재 트랜잭션 내에서 중첩된(내부) 트랜잭션을 시작합니다.
- 특징:
  - 기존 트랜잭션 내에서 savepoint를 만들고 그 지점부터 새로운 트랜잭션을 시작합니다.
  - 중첩된 트랜잭션은 기존 트랜잭션에 종속적입니다.
  - 중첩된 트랜잭션이 롤백되어도 외부 트랜잭션은 계속될 수 있습니다.
- 사용 예: 특정 작업의 부분적 롤백이 필요한 경우

```java
@Transactional(propagation = Propagation.NESTED)
public void nestedTransactionalWork() {
    // 중첩된 트랜잭션에서 실행되는 코드
}
```

주요 차이점:

1. 트랜잭션 범위:
   - NOT_SUPPORTED: 트랜잭션 없이 실행
   - REQUIRES_NEW: 완전히 새로운, 독립적인 트랜잭션
   - NESTED: 기존 트랜잭션 내의 중첩된 트랜잭션

2. 기존 트랜잭션과의 관계:
   - NOT_SUPPORTED: 기존 트랜잭션을 일시 중단하고 무시
   - REQUIRES_NEW: 기존 트랜잭션과 완전히 독립적
   - NESTED: 기존 트랜잭션에 종속적이지만 부분적으로 독립적

3. 롤백의 영향:
   - NOT_SUPPORTED: 롤백 없음 (트랜잭션이 없으므로)
   - REQUIRES_NEW: 새 트랜잭션만 롤백, 기존 트랜잭션에 영향 없음
   - NESTED: 중첩 트랜잭션만 롤백 가능, 외부 트랜잭션은 선택적으로 영향

4. 성능과 리소스:
   - NOT_SUPPORTED: 가장 가벼움
   - REQUIRES_NEW: 새로운 트랜잭션 시작으로 인한 오버헤드 있음
   - NESTED: savepoint 사용으로 인한 약간의 오버헤드

실제 사용 시에는 각 상황의 요구사항에 맞는 옵션을 선택해야 합니다. 예를 들어, 로깅과 같은 작업은 NOT_SUPPORTED를, 독립적인 결제 처리는 REQUIRES_NEW를, 복잡한 주문 처리의 일부 단계는 NESTED를 사용할 수 있습니다.