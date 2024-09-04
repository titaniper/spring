#!/bin/bash

# JPA 디렉토리 생성
mkdir -p jpa

# Markdown 파일 생성 함수
create_md_file() {
    local file="jpa/$1.md"
    echo "# $2" > "$file"
    echo "" >> "$file"
    echo "$3" >> "$file"
    echo "" >> "$file"
    echo "## 예시" >> "$file"
    echo "" >> "$file"
    echo '```java' >> "$file"
    echo "$4" >> "$file"
    echo '```' >> "$file"
    echo "" >> "$file"
    echo "Markdown 파일 생성됨: $file"
}

# 각 Markdown 파일 생성
create_md_file "introduction" "JPA 소개" "JPA(Java Persistence API)는 자바 애플리케이션에서 관계형 데이터베이스를 사용하는 방식을 정의한 인터페이스입니다." "@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    
    // getters and setters
}"

create_md_file "entity-mapping" "엔티티 매핑" "JPA에서 엔티티는 데이터베이스 테이블과 매핑되는 자바 객체입니다." "@Entity
@Table(name = \"users\")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = \"username\", nullable = false, length = 50)
    private String username;
    
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    
    // getters and setters
}"

create_md_file "relationships" "관계 매핑" "JPA에서는 엔티티 간의 관계를 다양한 방식으로 매핑할 수 있습니다." "@Entity
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    
    @ManyToOne
    @JoinColumn(name = \"user_id\")
    private User author;
    
    @OneToMany(mappedBy = \"post\", cascade = CascadeType.ALL)
    private List<Comment> comments;
    
    // getters and setters
}"

create_md_file "jpql" "JPQL (Java Persistence Query Language)" "JPQL은 엔티티 객체를 대상으로 하는 객체지향 쿼리 언어입니다." "String jpql = \"SELECT u FROM User u WHERE u.username LIKE :username\";
TypedQuery<User> query = em.createQuery(jpql, User.class);
query.setParameter(\"username\", \"john%\");
List<User> users = query.getResultList();"

create_md_file "criteria-api" "Criteria API" "Criteria API는 프로그래밍 방식으로 JPQL 쿼리를 생성할 수 있게 해주는 API입니다." "CriteriaBuilder cb = em.getCriteriaBuilder();
CriteriaQuery<User> cq = cb.createQuery(User.class);
Root<User> root = cq.from(User.class);
cq.select(root).where(cb.like(root.get(\"username\"), \"john%\"));

TypedQuery<User> query = em.createQuery(cq);
List<User> users = query.getResultList();"

create_md_file "persistence-context" "영속성 컨텍스트" "영속성 컨텍스트는 엔티티를 영구 저장하는 환경으로, 엔티티 매니저를 통해 엔티티를 저장하거나 조회하면 영속성 컨텍스트에 엔티티를 보관하고 관리합니다." "EntityManager em = emf.createEntityManager();
EntityTransaction tx = em.getTransaction();

try {
    tx.begin();
    
    User user = new User();
    user.setUsername(\"john\");
    
    em.persist(user);  // 영속성 컨텍스트에 저장
    
    tx.commit();  // 실제 DB에 반영
} catch (Exception e) {
    tx.rollback();
} finally {
    em.close();
}"

create_md_file "transactions" "트랜잭션 관리" "JPA에서 트랜잭션은 데이터베이스의 상태를 변화시키기 위해 수행하는 작업의 단위입니다." "@Transactional
public void createUser(String username) {
    User user = new User();
    user.setUsername(username);
    entityManager.persist(user);
}"

echo "모든 JPA Markdown 파일이 생성되었습니다."