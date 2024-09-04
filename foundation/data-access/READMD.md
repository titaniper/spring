# JPA, Hibernate, QueryDSL 비교

## JPA (Java Persistence API)

- **정의**: 자바 애플리케이션에서 관계형 데이터베이스를 사용하는 방법을 정의한 자바 API
- **역할**: 데이터베이스 작업을 위한 표준 인터페이스 제공
- **비유**: 교육 과정
- **특징**:
  - 인터페이스 집합으로, 직접 사용하지 않음
  - 다양한 구현체가 이 표준을 따름

**예시**:
```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    // getters and setters
}
```

## Hibernate

- **정의**: JPA의 구현체 중 하나
- **역할**: JPA 표준을 실제로 구현하여 데이터베이스 작업 수행
- **비유**: 교과서
- **특징**:
  - JPA 표준 기능 모두 지원
  - 추가적인 편의 기능 제공
  - 가장 널리 사용되는 JPA 구현체

**예시**:
```java
Session session = sessionFactory.openSession();
Transaction tx = session.beginTransaction();

User user = new User("John Doe");
session.save(user);

tx.commit();
session.close();
```

## QueryDSL

- **정의**: 타입-세이프한 SQL 쿼리 생성을 위한 프레임워크
- **역할**: 복잡한 쿼리를 자바 코드로 작성 가능하게 함
- **비유**: 번역기
- **특징**:
  - JPA, Hibernate와 독립적으로 사용 가능
  - 컴파일 시점에 쿼리 오류 검출
  - 동적 쿼리 생성에 강점

**예시**:
```java
JPAQueryFactory queryFactory = new JPAQueryFactory(entityManager);
QUser user = QUser.user;

List<User> users = queryFactory.selectFrom(user)
                                .where(user.age.gt(20))
                                .orderBy(user.name.asc())
                                .fetch();
```

## 정리

- **JPA**: 전체적인 규칙 제공 (인터페이스)
- **Hibernate**: JPA 규칙을 실제로 구현 (구현체)
- **QueryDSL**: 복잡한 쿼리를 쉽게 작성 (보조 도구)

이 세 가지를 함께 사용하면 객체지향적이고, 타입 안전하며, 유지보수가 용이한 데이터베이스 접근 코드를 작성할 수 있습니다.
```

이 마크다운 문서는 각 기술의 정의, 역할, 특징, 그리고 간단한 예시 코드를 포함하고 있어 JPA, Hibernate, QueryDSL의 차이점을 한눈에 파악할 수 있도록 구성되어 있습니다.