트랜잭션 격리 수준(Isolation Level)

트랜잭션 격리 수준은 동시에 실행되는 트랜잭션들이 서로에게 어떤 영향을 미치는지를 제어하는 설정입니다. Spring의 `@Transactional` 어노테이션에서 사용할 수 있는 격리 수준 옵션들은 다음과 같습니다:

| 격리 수준 | 설명 | 문제 해결 |
|-----------|------|-----------|
| DEFAULT | 데이터베이스의 기본 격리 수준 사용 | - |
| READ_UNCOMMITTED | 커밋되지 않은 데이터 읽기 가능 | Dirty Read 발생 가능 |
| READ_COMMITTED | 커밋된 데이터만 읽기 가능 | Dirty Read 방지 |
| REPEATABLE_READ | 트랜잭션 내에서 같은 데이터를 여러 번 읽어도 동일한 결과 보장 | Non-repeatable Read 방지 |
| SERIALIZABLE | 가장 높은 격리 수준, 완벽한 데이터 일관성 보장 | Phantom Read 방지 |

각 격리 수준에 대한 예시:

1. DEFAULT
```java
@Transactional(isolation = Isolation.DEFAULT)
public void defaultIsolationExample() {
    // 데이터베이스의 기본 격리 수준 사용
}
```

2. READ_UNCOMMITTED
```java
@Transactional(isolation = Isolation.READ_UNCOMMITTED)
public void readUncommittedExample() {
    // 커밋되지 않은 데이터도 읽을 수 있음
    // 성능은 좋지만 데이터 불일치 위험이 높음
}
```

3. READ_COMMITTED
```java
@Transactional(isolation = Isolation.READ_COMMITTED)
public void readCommittedExample() {
    // 커밋된 데이터만 읽을 수 있음
    // Dirty Read는 방지되지만 Non-repeatable Read 발생 가능
}
```

4. REPEATABLE_READ
```java
@Transactional(isolation = Isolation.REPEATABLE_READ)
public void repeatableReadExample() {
    // 트랜잭션 내에서 같은 데이터를 여러 번 읽어도 동일한 결과
    // Non-repeatable Read 방지, 但 Phantom Read 발생 가능
}
```

5. SERIALIZABLE
```java
@Transactional(isolation = Isolation.SERIALIZABLE)
public void serializableExample() {
    // 가장 높은 격리 수준, 완벽한 데이터 일관성 보장
    // 성능이 가장 낮음
}
```

실제 사용 예시:

```java
@Service
public class BankAccountService {

    @Autowired
    private BankAccountRepository repository;

    @Transactional(isolation = Isolation.READ_COMMITTED)
    public void transfer(Long fromId, Long toId, BigDecimal amount) {
        BankAccount fromAccount = repository.findById(fromId).orElseThrow();
        BankAccount toAccount = repository.findById(toId).orElseThrow();

        fromAccount.withdraw(amount);
        toAccount.deposit(amount);

        repository.save(fromAccount);
        repository.save(toAccount);
    }

    @Transactional(isolation = Isolation.REPEATABLE_READ)
    public BigDecimal getBalance(Long accountId) {
        BankAccount account = repository.findById(accountId).orElseThrow();
        // 이 트랜잭션 내에서 계좌 잔액을 여러 번 읽어도 동일한 값 보장
        return account.getBalance();
    }

    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void auditAccounts() {
        // 중요한 감사 작업, 완벽한 데이터 일관성 필요
        List<BankAccount> accounts = repository.findAll();
        // 감사 로직...
    }
}
```

격리 수준을 선택할 때는 데이터 일관성과 성능 사이의 균형을 고려해야 합니다. 높은 격리 수준은 더 나은 데이터 일관성을 제공하지만, 동시성이 떨어져 성능이 저하될 수 있습니다. 반대로 낮은 격리 수준은 성능은 좋지만 데이터 불일치 문제가 발생할 수 있습니다. 

따라서 각 비즈니스 로직의 요구사항에 맞는 적절한 격리 수준을 선택하는 것이 중요합니다. 대부분의 경우 READ_COMMITTED나 REPEATABLE_READ가 좋은 선택이 될 수 있습니다.

# 문제 해결

1. Dirty Read (더티 리드)
   - 현상: 한 트랜잭션이 아직 커밋되지 않은 다른 트랜잭션의 변경사항을 읽는 현상
   - 예시:
     - 트랜잭션 A가 데이터를 수정하고 있음
     - 트랜잭션 B가 A가 수정 중인(커밋되지 않은) 데이터를 읽음
     - 트랜잭션 A가 롤백됨
     - 결과적으로 트랜잭션 B는 유효하지 않은(never existed) 데이터를 사용하게 됨
   - 문제점: 데이터 불일치, 잘못된 비즈니스 결정 가능성
   - 해결: READ_COMMITTED 이상의 격리 수준 사용

2. Non-repeatable Read (반복 불가능한 읽기)
   - 현상: 한 트랜잭션 내에서 같은 데이터를 여러 번 읽을 때 그 결과가 다른 현상
   - 예시:
     - 트랜잭션 A가 데이터를 읽음
     - 트랜잭션 B가 같은 데이터를 수정하고 커밋함
     - 트랜잭션 A가 같은 데이터를 다시 읽으면 다른 결과를 얻게 됨
   - 문제점: 데이터 일관성 훼손, 잘못된 계산 결과 도출 가능성
   - 해결: REPEATABLE_READ 이상의 격리 수준 사용

3. Phantom Read (팬텀 리드)
   - 현상: 한 트랜잭션에서 같은 쿼리를 실행했을 때 이전에 없던 레코드가 나타나는 현상
   - 예시:
     - 트랜잭션 A가 특정 조건으로 데이터를 조회함
     - 트랜잭션 B가 새로운 데이터를 삽입하고 커밋함
     - 트랜잭션 A가 같은 조건으로 다시 조회하면 이전에 없던 레코드가 결과에 포함됨
   - 문제점: 집계 함수의 결과 불일치, 페이지네이션 오류 등
   - 해결: SERIALIZABLE 격리 수준 사용

각 격리 수준별 문제 해결 능력:

1. READ_UNCOMMITTED
   - Dirty Read, Non-repeatable Read, Phantom Read 모두 발생 가능
   - 성능은 가장 좋지만 데이터 일관성이 매우 낮음

2. READ_COMMITTED
   - Dirty Read 방지
   - Non-repeatable Read, Phantom Read는 여전히 발생 가능
   - 대부분의 데이터베이스의 기본 격리 수준

3. REPEATABLE_READ
   - Dirty Read, Non-repeatable Read 방지
   - Phantom Read는 여전히 발생 가능
   - 대부분의 상황에서 좋은 균형을 제공

4. SERIALIZABLE
   - Dirty Read, Non-repeatable Read, Phantom Read 모두 방지
   - 완벽한 데이터 일관성 제공
   - 성능이 가장 낮고 동시성이 떨어짐

실제 사용 예시와 고려사항:

```java
@Service
public class ProductService {

    @Autowired
    private ProductRepository repository;

    @Transactional(isolation = Isolation.READ_COMMITTED)
    public void updateProductPrice(Long productId, BigDecimal newPrice) {
        Product product = repository.findById(productId).orElseThrow();
        product.setPrice(newPrice);
        repository.save(product);
        // READ_COMMITTED는 다른 트랜잭션의 커밋된 변경사항을 읽을 수 있어,
        // 가격 업데이트 시 최신 정보를 반영할 수 있습니다.
    }

    @Transactional(isolation = Isolation.REPEATABLE_READ)
    public BigDecimal calculateTotalValue() {
        List<Product> products = repository.findAll();
        // REPEATABLE_READ는 이 트랜잭션 동안 product 목록이 변경되지 않음을 보장합니다.
        // 따라서 총 가치 계산 시 일관된 결과를 얻을 수 있습니다.
        return products.stream()
                .map(p -> p.getPrice().multiply(new BigDecimal(p.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void performCriticalInventoryAdjustment() {
        // SERIALIZABLE은 완벽한 일관성을 제공하지만, 성능이 낮아집니다.
        // 매우 중요한 재고 조정 같은 작업에만 사용하는 것이 좋습니다.
        List<Product> products = repository.findAll();
        for (Product product : products) {
            // 복잡한 재고 조정 로직...
        }
    }
}
```

적절한 격리 수준을 선택하는 것은 데이터의 일관성 요구사항과 성능 사이의 균형을 맞추는 과정입니다. 대부분의 경우 READ_COMMITTED나 REPEATABLE_READ가 좋은 선택이 될 수 있으며, 특별히 높은 일관성이 필요한 경우에만 SERIALIZABLE을 고려하는 것이 좋습니다.