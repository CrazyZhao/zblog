/*
Navicat MySQL Data Transfer

Source Server         : 118.31.70.84-阿里云
Source Server Version : 50725
Source Host           : 118.31.70.84:3306
Source Database       : zblog

Target Server Type    : MYSQL
Target Server Version : 50725
File Encoding         : 65001

Date: 2019-04-23 15:17:12
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoryId` int(11) NOT NULL COMMENT '分类Id',
  `title` varchar(40) NOT NULL COMMENT '标题',
  `content` longtext NOT NULL COMMENT '内容',
  `description` varchar(500) NOT NULL COMMENT '文章简介  用于列表显示',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0：正常  1：不可用',
  `author` varchar(15) DEFAULT 'Coriger' COMMENT '作者',
  `createTime` datetime NOT NULL COMMENT '发表时间',
  `updateTime` datetime DEFAULT NULL COMMENT '发表时间',
  `showCount` int(11) NOT NULL DEFAULT '0' COMMENT '浏览量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=259926 DEFAULT CHARSET=utf8 COMMENT='文章表';

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES ('251432', '10000', '分库分表开源中间件之Sharding-JDBC使用体验', '## 分库分表开源中间件之Sharding-JDBC使用体验\n### 数据库分片思想\n#### 垂直切分\n垂直切分就是把表按模块划分到不同数据库表中，单表大数据量依然存在性能瓶颈。\n#### 水平切分\n水平切分就是把一个表按照某种规则（比如按用户Id取模）把数据划分到不同表和数据库里。\n\n垂直切分更能清晰化模块划分，区分治理，水平切分能解决大数据量性能瓶颈问题，因此常常会把两者结合使用。\n\n### Sharding-JDBC简介\n> Sharding-JDBC是一个开源的适用于微服务的分布式数据访问的数据库水平切分框架。\n\nSharding-JDBC是当当应用框架ddframe中，从关系型数据库dd-rdb中分离出来的数据库水平切分框架，实现透明化数据库分库分表访问。Sharding-JDBC是继dubbox和elastic-job之后，ddframe系列开源的第三个项目。项目源码地址：https://github.com/shardingjdbc/sharding-jdbc\n\n架构图如下：\n![架构图.png](http://upload-images.jianshu.io/upload_images/6979456-bb19a33c744052a4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\nSharding-JDBC直接封装JDBC-API，可以理解为增强版的JDBC驱动，旧代码迁移成本几乎为零：\n* 可适用于任何基于Java的ORM框架，如JPA、Hibernate、MyBatis、Spring JDBC Template或直接使用JDBC。\n* 可基于任何第三方的数据库连接池，如DBCP、C3P0、BoneCP、Druid等。\n* 理论上可支持任意实现JDBC规范的数据库。目前支持MySQL，Oracle，SQLServer和PostgreSQL。\n\nSharding-JDBC功能列表：\n* 分库分表\n* 读写分离\n* 柔性事务\n* 分布式主键\n* 分布式治理能力（2.0新功能）\n    * 配置集中化与动态化，可支持数据源、表与分片策略的动态切换(2.0.0.M1)\n    * 客户端的数据库治理，数据源失效自动切换(2.0.0.M2)\n    * 基于Open Tracing协议的APM信息输出(2.0.0.M3)\n\nSharding-JDBC定位为轻量Java框架，使用客户端直连数据库，以jar包形式提供服务，无proxy代理层，无需额外部署，无其他依赖，DBA也无需改变原有的运维方式。\n\nSharding-JDBC分片策略灵活，可支持等号、between、in等多维度分片，也可支持多分片键。\n\nSQL解析功能完善，支持聚合、分组、排序、limit、or等查询，并支持Binding Table以及笛卡尔积表查询。\n\n### 使用体验\n下面的例子使用Spring Boot + Mybatis + Druid + Sharding-JDBC\n\n#### 项目结构\n![项目结构.png](http://upload-images.jianshu.io/upload_images/6979456-11b8870cb0f24f3d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n* Application是项目启动的入口。\n* DataSourceConfig是数据源配置，包括如何结合Sharding-JDBC设置分库分表。\n* algorithm下面是设置的分库分表策略，实现相关接口即可。\n* UserMapper是Mybatis的接口，采用了全注解配置，所以没有Mapper文件。\n* druid下面是druid的监控页面配置。\n\nPOM依赖[外加Spring Boot相关依赖]\n```xml\n<dependency>\n    <groupId>com.dangdang</groupId>\n    <artifactId>sharding-jdbc-core</artifactId>\n    <version>1.5.4.1</version>\n</dependency>\n```\n\n#### 数据源配置\n```java\n@Configuration\n@ConfigurationProperties(prefix = DataSourceConstants.DATASOURCE_PREFIX)\n@MapperScan(basePackages = { DataSourceConstants.MAPPER_PACKAGE }, sqlSessionFactoryRef = \"mybatisSqlSessionFactory\")\npublic class DataSourceConfig {\n\n    private String url;\n\n    private String username;\n\n    private String password;\n\n    @Bean(name = \"mybatisDataSource\")\n    public DataSource getDataSource() throws SQLException {\n        //设置分库映射\n        Map<String, DataSource> dataSourceMap = new HashMap<>(2);\n        dataSourceMap.put(\"springboot_0\", mybatisDataSource(\"springboot\"));\n        dataSourceMap.put(\"springboot_1\", mybatisDataSource(\"springboot2\"));\n\n        //设置默认库，两个库以上时必须设置默认库。默认库的数据源名称必须是dataSourceMap的key之一\n        DataSourceRule dataSourceRule = new DataSourceRule(dataSourceMap, \"springboot_0\");\n\n        //设置分表映射\n        TableRule userTableRule = TableRule.builder(\"user\")\n                .generateKeyColumn(\"user_id\") //将user_id作为分布式主键\n                .actualTables(Arrays.asList(\"user_0\", \"user_1\"))\n                .dataSourceRule(dataSourceRule)\n                .build();\n\n        //具体分库分表策略\n        ShardingRule shardingRule = ShardingRule.builder()\n                .dataSourceRule(dataSourceRule)\n                .tableRules(Collections.singletonList(userTableRule))\n                .databaseShardingStrategy(new DatabaseShardingStrategy(\"city_id\", new ModuloDatabaseShardingAlgorithm()))\n                .tableShardingStrategy(new TableShardingStrategy(\"user_id\", new ModuloTableShardingAlgorithm())).build();\n\n        DataSource dataSource = ShardingDataSourceFactory.createDataSource(shardingRule);\n\n        //return new ShardingDataSource(shardingRule);\n        return dataSource;\n    }\n\n    private DataSource mybatisDataSource(final String dataSourceName) throws SQLException {\n        DruidDataSource dataSource = new DruidDataSource();\n        dataSource.setDriverClassName(DataSourceConstants.DRIVER_CLASS);\n        dataSource.setUrl(String.format(url, dataSourceName));\n        dataSource.setUsername(username);\n        dataSource.setPassword(password);\n\n        /* 配置初始化大小、最小、最大 */\n        dataSource.setInitialSize(1);\n        dataSource.setMinIdle(1);\n        dataSource.setMaxActive(20);\n\n        /* 配置获取连接等待超时的时间 */\n        dataSource.setMaxWait(60000);\n\n        /* 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒 */\n        dataSource.setTimeBetweenEvictionRunsMillis(60000);\n\n        /* 配置一个连接在池中最小生存的时间，单位是毫秒 */\n        dataSource.setMinEvictableIdleTimeMillis(300000);\n\n        dataSource.setValidationQuery(\"SELECT \'x\'\");\n        dataSource.setTestWhileIdle(true);\n        dataSource.setTestOnBorrow(false);\n        dataSource.setTestOnReturn(false);\n\n        /* 打开PSCache，并且指定每个连接上PSCache的大小。\n           如果用Oracle，则把poolPreparedStatements配置为true，\n           mysql可以配置为false。分库分表较多的数据库，建议配置为false */\n        dataSource.setPoolPreparedStatements(false);\n        dataSource.setMaxPoolPreparedStatementPerConnectionSize(20);\n\n        /* 配置监控统计拦截的filters */\n        dataSource.setFilters(\"stat,wall,log4j\");\n        return dataSource;\n    }\n\n    /**\n     * Sharding-jdbc的事务支持\n     *\n     * @return\n     */\n    @Bean(name = \"mybatisTransactionManager\")\n    public DataSourceTransactionManager mybatisTransactionManager(@Qualifier(\"mybatisDataSource\") DataSource dataSource) throws SQLException {\n        return new DataSourceTransactionManager(dataSource);\n    }\n\n    @Bean(name = \"mybatisSqlSessionFactory\")\n    public SqlSessionFactory mybatisSqlSessionFactory(@Qualifier(\"mybatisDataSource\") DataSource mybatisDataSource)\n            throws Exception {\n        final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();\n        sessionFactory.setDataSource(mybatisDataSource);\n        return sessionFactory.getObject();\n    }\n\n    // 省略setter、getter\n\n}\n\n```\n\n如上，指定了两个数据库springboot和springboot2，对应的key分别是springboot_0和springboot_1，在具体执行数据库写入的时候会先根据分库算法【实现SingleKeyDatabaseShardingAlgorithm接口】确定写入到哪个库，再根据分表算法【实现SingleKeyTableShardingAlgorithm接口】最终确定写入到哪个表（user_0或user_1）。所以这两个数据库都有两个表，表结构如下：\n``` xml\nCREATE TABLE `user` (\n  `id` bigint(20) NOT NULL AUTO_INCREMENT,\n  `user_id` bigint(20) NOT NULL COMMENT \'用户id\',\n  `city_id` int(11) DEFAULT NULL COMMENT \'城市id\',\n  `user_name` varchar(15) DEFAULT NULL,\n  `age` int(11) DEFAULT NULL COMMENT \'年龄\',\n  `birth` date DEFAULT NULL COMMENT \'生日\',\n  PRIMARY KEY (`id`)\n) ENGINE=InnoDB DEFAULT CHARSET=latin1\n```\n\n以上，按照city_id分库，user_id分表：\n> 如果cityId mod 2 为0，则落在springboot_0，也就是springboot库；如果cityId mod 2为1，则落在springboot_1，也就是springboot2库。\n\n> 如果userId mod 2为0，则落在user_0表；如果userId mod 2为1，则落在user_1表。\n\n在设置分表映射的时候，我们将user_id作为分布式主键，但是却将id作为了自增主键。因为在同一个逻辑表（user表）内的不同实际表（user_0和user_1）之间的自增键是无法互相感知的，这样会造成重复I\nd的生成。而Sharding-JDBC的分布式主键保证了数据库进行分库分表后主键（userId）一定是唯一不重复的，这样就解决了生成重复Id的问题。\n\n#### 测试\n如果插入下面这条数据，因为cityId模2余1，所以肯定落在springboot2库，但是无法实现确定落在哪个表，因为我们将user_id作为了分布式主键，主键由Sharding-JDBC内部生成，所以可能会落在user_0或user_1。\n\n```java\n@Test\npublic void getOneSlave() throws Exception {\n    UserEntity user = new UserEntity();\n    user.setCityId(1);//1 mod 2 = 1，所以会落在springboot2库中\n    user.setUserName(\"insertTest\");\n    user.setAge(10);\n    user.setBirth(new Date());\n    assertTrue(userMapper.insertSlave(user) > 0);\n    Long userId = user.getUserId();\n    System.out.println(\"Generated Key--userId:\" + userId + \"mod:\" + 1 % 2);\n    UserEntity one = userMapper.getOne(userId);\n    System.out.println(\"Generated User:\" + one);\n    assertEquals(\"insertTest\", one.getUserName());\n}\n```\n\n表数据如下：\n\n![表数据.png](http://upload-images.jianshu.io/upload_images/6979456-118567c9f0463aeb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n> 总结：分表规则的一些思考\n>* 根据用户Id进行分配\n>\n>   这种方式能够确保同一个用户的所有数据在同一个数据表中。如果经常按用户Id查询数据，推荐用这种方法。\n>* 根据主键进行分配\n>\n>   这种方式能够实现最平均的分配方法，每生成一条新数据，会依次保存到下一个数据表中。\n>* 根据时间进行分配\n>\n>   适用于一些经常按时间段进行查询的数据，将一个时间段内的数据保存在同一个数据表中。\n\n\n> 欢迎微信扫码关注微信公众号：后端开发者中心，不定期推送服务端各类技术文章。\n![](http://upload-images.jianshu.io/upload_images/6979456-3a58c49e2bbd704d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)', 'Sharding-JDBC是一个开源的适用于微服务的分布式数据访问的数据库水平切分框架。', '1', 'Coriger', '2019-02-12 10:48:10', null, '152');
INSERT INTO `article` VALUES ('255205', '9999', 'Spring Cloud微服务实战', '## Spring Cloud微服务实战：手把手带你整合eureka&zuul&feign&hystrix\n\n\n### Spring Cloud简介\nSpring Cloud是一个基于Spring Boot实现的微服务架构开发工具。它为微服务架构中涉及的配置管理、服务治理、断路器、智能路由、微代理、控制总线、全局锁、决策竞选、分布式会话和集群状态管理等操作提供了一种简单的开发方式。  \n\nSpring Cloud包含了多个子项目，比如Spring Cloud Config、Spring Cloud Netflix、Spring Cloud Bus、Spring Cloud Stream、Spring Cloud Zookeeper等等。  \n\n本文介绍基于Spring Boot 2.0.5版本，Spring Cloud Finchley.SR1版本的微服务搭建，包括eureka&zuul&feign&hystrix的整合。\n\n### 最终项目结构 \n![项目结构.png](https://upload-images.jianshu.io/upload_images/6979456-2788158fd526b727.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n文末附源码地址。\n\n### 服务注册发现模块\n该模块对应本次搭建项目中的cloud-eureka，eureka作为服务发现注册中心首先搭建，因为后面的服务都要注册到上面。当然服务发现还可以用zookeeper、consul等等，最近阿里也启动了新的服务发现开源项目Nacos，各种服务注册发现中间件真是层出不穷。\n\n首先使用idea生成多模块maven主工程，新建一个空白标准的maven project（不要选择Create from archetype选项）  \n![多模块maven主工程.png](https://upload-images.jianshu.io/upload_images/6979456-c192375c84d00c0c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n在主工程上新建module，选择Spring Initializr  \n![idea构建spring boot初始化模块.png](https://upload-images.jianshu.io/upload_images/6979456-082904d54e341b6a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n输入cloud-eureka服务注册中心模块信息  \n![新建eureka服务注册中心模块.png](https://upload-images.jianshu.io/upload_images/6979456-6a2d90ee429aded1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n选择Cloud Discovery中的Eureka Server依赖  \n![eureka服务注册中心依赖选择.png](https://upload-images.jianshu.io/upload_images/6979456-c8c4d040f536cff5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n生成的pom文件部分配置：\n``` xml\n<dependencies>\n	<dependency>\n		<groupId>org.springframework.cloud</groupId>\n		<artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>\n	</dependency>\n\n	<dependency>\n		<groupId>org.springframework.boot</groupId>\n		<artifactId>spring-boot-starter-test</artifactId>\n		<scope>test</scope>\n	</dependency>\n</dependencies>\n\n<dependencyManagement>\n	<dependencies>\n		<dependency>\n			<groupId>org.springframework.cloud</groupId>\n			<artifactId>spring-cloud-dependencies</artifactId>\n			<version>${spring-cloud.version}</version>\n			<type>pom</type>\n			<scope>import</scope>\n		</dependency>\n	</dependencies>\n</dependencyManagement>\n```\n\n启动类，加上@EnableEurekaServer注解：\n``` java\n@SpringBootApplication\n@EnableEurekaServer\npublic class CloudEurekaApplication {\n\n	public static void main(String[] args) {\n		SpringApplication.run(CloudEurekaApplication.class, args);\n	}\n}\n```  \n\n默认情况下服务注册中心会将自己作为客户端注册到Eureka Server，所以需要禁用它的客户端注册行为，配置文件application.properties添加如下配置：\n``` \n#端口号.\nserver.port=8070\n#关闭自我保护.\neureka.server.enable-self-preservation=false\n#清理服务器时间间隔[5s]\neureka.server.eviction-interval-timer-in-ms=5000\n\n#主机名.\neureka.instance.hostname=localhost\n#是否将自己作为客户端注册到Eureka Server[当前模块只是作为Eureka Server服务端所以设为false]\neureka.client.register-with-eureka=false\n#是否从Eureka Server获取注册信息[当前是单点的Eureka Server所以不需要同步其它节点的数据]\neureka.client.fetch-registry=false\n\n#Eureka Server[查询注册服务]地址.\neureka.client.serviceUrl.defaultZone=http://${eureka.instance.hostname}:${server.port}/eureka\n```\n\n启动工程访问：http://localhost/8070/ ，可看到如下界面，其中还没有服务实例 \n![spring boot控制台无服务实例.png](https://upload-images.jianshu.io/upload_images/6979456-7bb3b3e292169ac7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n### 客服端模块（服务提供者）\n该模块对应本次搭建项目中的cloud-provider，其作为服务提供者客户端在注册中心进行注册。搭建过程和cloud-eureka类似，在主工程上新建module并选择Spring Initializr即可，唯一区别是依赖选择Cloud Discovery中的Eureka Discovery：  \n![服务注册客户端依赖选择.png](https://upload-images.jianshu.io/upload_images/6979456-87dfb30d8056c2fc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\npom文件依赖配置如下：\n```  \n<dependencies>\n	<dependency>\n		<groupId>org.springframework.cloud</groupId>\n		<artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>\n	</dependency>\n\n	<dependency>\n		<groupId>org.springframework.boot</groupId>\n		<artifactId>spring-boot-starter-web</artifactId>\n	</dependency>\n\n	<dependency>\n		<groupId>org.springframework.boot</groupId>\n		<artifactId>spring-boot-starter-test</artifactId>\n		<scope>test</scope>\n	</dependency>\n</dependencies>\n```\n\n启动类，加上@EnableDiscoveryClient，表示其作为服务发现客户端  \n``` \n@SpringBootApplication\n@EnableDiscoveryClient\npublic class CloudProviderApplication {\n    public static void main(String[] args) {\n        SpringApplication.run(CloudProviderApplication.class, args);\n    }\n}\n```\n\napplication.properties添加如下配置:\n``` \n#应用名称.\nspring.application.name=cloud-provider\n#应用端口号.\nserver.port=8080\n#Eureka Server服务器地址.\neureka.client.serviceUrl.defaultZone=http://localhost:8070/eureka/\n```\n通过spring.application.name指定微服务服务提供者的名称，后续使用该名称便可以访问该服务。  \neureka.client.serviceUrl.defaultZone指定服务注册中心地址。  \n\n启动该工程，再次访问：http://localhost/8070/ ， 可以看到出现了启动的CLOUD-PROVIDER服务：  \n![服务注册中心客户端实例.png](https://upload-images.jianshu.io/upload_images/6979456-8183d52fcc3926b2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n定义MyController类，使用Rest风格请求，添加info方法如下：  \n```  java\n@RestController\npublic class MyController {\n\n    @RequestMapping(value = \"/info\", method = RequestMethod.GET)\n    public String info() {\n        try {\n            //休眠2秒，测试超时服务熔断[直接关闭服务提供者亦可]\n            Thread.sleep(2000);\n        } catch (InterruptedException e) {\n            e.printStackTrace();\n        }\n        return \"Hello, cloud-provider\";\n    }\n}\n```  \n\n访问：http://127.0.0.1:8080/info ， 返回信息如下  \n![cloud-provider REST请求.jpg](https://upload-images.jianshu.io/upload_images/6979456-e63ec5b20ecae596.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n### 声明式服务调用组件Feign及服务熔断组件Hystrix整合\n新建服务消费者模块，该模块对应本次搭建项目中的cloud-consumer。同样，新建过程和上述模块类似，这里不再赘述。本模块将通过Feign组件调用上一个模块服务的info方法，并通过Hystrix实现服务调用失败时的服务熔断。\n\nmaven依赖配置：  \n```  \n<dependencies>\n	<dependency>\n		<groupId>org.springframework.cloud</groupId>\n		<artifactId>spring-cloud-starter-openfeign</artifactId>\n	</dependency>\n\n	<dependency>\n		<groupId>org.springframework.cloud</groupId>\n		<artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>\n	</dependency>\n\n	<dependency>\n		<groupId>org.springframework.boot</groupId>\n		<artifactId>spring-boot-starter-web</artifactId>\n	</dependency>\n\n	<dependency>\n		<groupId>org.springframework.boot</groupId>\n		<artifactId>spring-boot-starter-test</artifactId>\n		<scope>test</scope>\n	</dependency>\n</dependencies>\n```\n\n启动类，加上@EnableFeignClients和@EnableEurekaClient\n```  \n@SpringBootApplication\n@EnableFeignClients //调用者启动时，打开Feign开关\n@EnableEurekaClient\npublic class CloudConsumerApplication {\n\n    public static void main(String[] args) {\n        SpringApplication.run(CloudConsumerApplication.class, args);\n    }\n}\n```\n\napplication.properties添加如下配置:  \n```  \n#应用名称.\nspring.application.name=cloud-consumer\n#端口号.\nserver.port=8081\n#Eureka Server服务器地址.\neureka.client.serviceUrl.defaultZone=http://localhost:8070/eureka/\n\n#高版本spring-cloud-openfeign请求分为两层，先ribbon控制，后hystrix控制.\n#ribbon请求处理的超时时间.\nribbon.ReadTimeout=5000\n#ribbon请求连接的超时时间\nribbon.ConnectionTimeout=5000\n\n##设置服务熔断超时时间[默认1s]\nhystrix.command.default.execution.isolation.thread.timeoutInMilliseconds=10000\n\n#开启Hystrix以支持服务熔断[高版本默认false关闭]，如果置为false，则请求超时交给ribbon控制.\n#feign.hystrix.enabled=true\n```\n\n定义服务接口类InfoClient，作为调用远程服务的本地入口：\n```  \n//1.name为被调用的服务应用名称.\n//2.InfoFallBack作为熔断实现，当请求cloud-provider失败时调用其中的方法.\n//3.feign配置.\n@FeignClient(name = \"cloud-provider\", fallback = InfoFallBack.class, configuration = MyFeignConfig.class)\npublic interface InfoClient {\n\n    //被请求微服务的地址\n    @RequestMapping(\"/info\")\n    String info();\n}\n\n```\n\n定义熔断类InfoFallBack，如果远程服务无法成功请求，则调用指定的本地逻辑方法：\n```  \n@Component\npublic class InfoFallBack implements InfoClient {\n    @Override\n    public String info() {\n        return \"fallback info\";\n    }\n}\n```\n\n定义个性化的feign配置类MyFeignConfig：  \n```  \n@Configuration\npublic class MyFeignConfig {\n\n    /**\n     * feign打印日志等级\n     * @return\n     */\n    @Bean\n    Logger.Level feignLoggerLeval(){\n        return Logger.Level.FULL;\n    }\n}\n```\n\n定义服务调用类ConsumerController,通过本地方法入口调用远程服务：\n```  \n@RestController\n@Configuration\npublic class ConsumerController {\n\n    @Autowired\n    InfoClient infoClient;\n\n    @RequestMapping(value = \"/consumerInfo\", method = RequestMethod.GET)\n    public String consumerInfo(){\n        return infoClient.info();\n    }\n}\n```\n\n启动工程，访问：http://127.0.0.1:8081/consumerInfo ， 成功调用远程服务：  \n![通过feign成功调用远程服务.jpg](https://upload-images.jianshu.io/upload_images/6979456-9ec4532426c2e1ae.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n服务熔断测试，application.properties配置修改如下:\n1. feign.hystrix.enabled=true注释打开，开启Hystrix以支持服务熔断，这边高版本默认为false\n2. 关闭cloud-provider服务或者去除ribbon请求处理超时时间及服务熔断超时时间的配置\n\n重新启动cloud-consumer服务，再次访问，服务熔断成功调用了本地的方法：  \n![服务成功熔断.jpg](https://upload-images.jianshu.io/upload_images/6979456-25f6304ba270a356.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n### 服务网关组件Zuul整合\n该组件提供了智能路由以及访问过滤等功能。新建服务网关模块cloud-zuul，过程和以上同样类似，这里省略。\n\nmaven依赖配置：\n```  \n<dependencies>\n	<dependency>\n		<groupId>org.springframework.cloud</groupId>\n		<artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>\n	</dependency>\n	<dependency>\n		<groupId>org.springframework.cloud</groupId>\n		<artifactId>spring-cloud-starter-netflix-zuul</artifactId>\n	</dependency>\n\n	<dependency>\n		<groupId>org.springframework.boot</groupId>\n		<artifactId>spring-boot-starter-test</artifactId>\n		<scope>test</scope>\n	</dependency>\n</dependencies>\n```\n\n启动类，加上@EnableZuulProxy和@EnableEurekaClient注解：\n```  \n@SpringBootApplication\n@EnableZuulProxy //开启网关Zuul\n@EnableEurekaClient\npublic class CloudZuulApplication {\n\n    public static void main(String[] args) {\n        SpringApplication.run(CloudZuulApplication.class, args);\n    }\n}\n```\n\napplication.properties添加如下配置:   \n```  \n#应用名称.\nspring.application.name=cloud-zuul\n#应用端口号.\nserver.port=8071\n#Eureka Server服务器地址.\neureka.client.serviceUrl.defaultZone=http://localhost:8070/eureka/\n\n#通过指定URL配置了Zuul路由，则配置以下两个超时时间.\n#zuul.host.connect-timeout-millis=5000\n#zuul.host.socket-timeout-millis=5000\n\n#zuul使用服务发现的方式[通过serviceId路由服务]，得配置ribbon的超时时间.\n#官网文档已说明：http://cloud.spring.io/spring-cloud-netflix/single/spring-cloud-netflix.html#_zuul_timeouts\n#ribbon请求处理的超时时间.\nribbon.ReadTimeout=5000\n#ribbon请求连接的超时时间.\nribbon.ConnectionTimeout=5000\n\n##设置服务熔断超时时间[默认1s]\nhystrix.command.default.execution.isolation.thread.timeoutInMilliseconds=10000\n\n#只要访问以/api/开头的多层目录都可以路由到服务名为cloud-provider的服务上.\nzuul.routes.cloud-provider=/api/**\n```\n注意zuul.routes.cloud-provider表示要访问的服务以何种路径方式路由。\n\n定义网关过滤器AccessFilter，根据过滤器的不同生命周期在调用服务时调用过滤器中的方法逻辑。  \n```  \n/**\n * 服务网关过滤器\n */\n@Component\npublic class AccessFilter extends ZuulFilter {\n\n    /**\n     * 返回一个字符串代表过滤器的类型，在zuul中定义了四种不同生命周期的过滤器类型：\n     *  pre：可以在请求被路由之前调用\n     *  route：在路由请求时候被调用\n     *  post：在route和error过滤器之后被调用\n     *  error：处理请求时发生错误时被调用\n     * @return\n     */\n    @Override\n    public String filterType() {\n        return \"pre\"; //前置过滤器\n    }\n\n    @Override\n    public int filterOrder() {\n        return 0; //过滤器的执行顺序，数字越大优先级越低\n    }\n\n    @Override\n    public boolean shouldFilter() {\n        return true;//是否执行该过滤器，此处为true，说明需要过滤\n    }\n\n    /**\n     * 过滤器具体逻辑\n     * @return\n     * @throws ZuulException\n     */\n    @Override\n    public Object run() throws ZuulException {\n        RequestContext ctx = RequestContext.getCurrentContext();\n        HttpServletRequest request = ctx.getRequest();\n        System.out.println(String.format(\"%s demoFilter request to %s\", request.getMethod(), request.getRequestURL().toString()));\n        String username = request.getParameter(\"username\");// 获取请求的参数\n        if(!StringUtils.isEmpty(username)&&username.equals(\"bright\")){//当请求参数username为“bright”时通过\n            ctx.setSendZuulResponse(true);// 对该请求进行路由\n            ctx.setResponseStatusCode(200);\n            ctx.set(\"isSuccess\", true);// 设值，让下一个Filter看到上一个Filter的状态\n            return null;\n        }else{\n            ctx.setSendZuulResponse(false);// 过滤该请求，不对其进行路由\n            ctx.setResponseStatusCode(401);// 返回错误码\n            ctx.setResponseBody(\"{\\\"result\\\":\\\"username is not correct!\\\"}\");// 返回错误内容\n            ctx.set(\"isSuccess\", false);\n            return null;\n        }\n    }\n}\n```\n\n启动该工程，访问：http://127.0.0.1:8071/api/info ， 成功执行网关过滤器中的方法逻辑，请求被过滤，没有调用远程服务返回了设置的错误内容：  \n![zuul服务被过滤.jpg](https://upload-images.jianshu.io/upload_images/6979456-8d29bc37792e03fa.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n访问：http://127.0.0.1:8071/api/info?username=bright ，执行网关过滤器中的方法逻辑，请求参数合法，所以请求没有被过滤成功调用了远程服务：  \n![网关过滤合法.jpg](https://upload-images.jianshu.io/upload_images/6979456-113a451e0c338d42.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n[项目源码](https://github.com/CrazyZhao/bright_cloud)\n\n> 欢迎微信扫码关注微信公众号：后端开发者中心，不定期推送服务端各类技术文章。\n![](http://upload-images.jianshu.io/upload_images/6979456-3a58c49e2bbd704d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)', 'Spring Cloud是一个基于Spring Boot实现的微服务架构开发工具。它为微服务架构中涉及的配置管理、服务治理、断路器、智能路由、微代理、控制总线、全局锁、决策竞选、分布式会话和集群状态管理等操作提供了一种简单的开发方式。', '1', 'Coriger', '2019-02-12 10:42:21', '2019-02-12 10:44:45', '60');

-- ----------------------------
-- Table structure for articletag
-- ----------------------------
DROP TABLE IF EXISTS `articletag`;
CREATE TABLE `articletag` (
  `articleId` int(11) NOT NULL COMMENT '文章Id',
  `tagId` int(11) NOT NULL COMMENT '标签Id',
  `tagName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章标签中间表';

-- ----------------------------
-- Records of articletag
-- ----------------------------
INSERT INTO `articletag` VALUES ('255897', '9999', 'default');
INSERT INTO `articletag` VALUES ('255544', '9999', 'default');
INSERT INTO `articletag` VALUES ('255205', '9999', 'default');
INSERT INTO `articletag` VALUES ('251432', '10001', 'Database');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(20) NOT NULL COMMENT '分类名称  唯一',
  `aliasName` varchar(20) NOT NULL COMMENT '别名  唯一  比如新闻 就用News 代替  栏目Id不显示在url中',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序 （0-10）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `aliasName_UNIQUE` (`aliasName`),
  UNIQUE KEY `categoryName_UNIQUE` (`categoryName`)
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8 COMMENT='分类表  只支持一级分类  如果需要分多个层次 用标签来协助实现';

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('9999', '微服务', '微服务', '0');
INSERT INTO `category` VALUES ('10000', '数据库', '数据库', '1');

-- ----------------------------
-- Table structure for log
-- ----------------------------
DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `url` varchar(1024) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `method` varchar(255) DEFAULT NULL,
  `args` varchar(255) DEFAULT NULL,
  `classMethod` varchar(255) DEFAULT NULL,
  `exception` varchar(2000) DEFAULT NULL,
  `operateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of log
-- ----------------------------

-- ----------------------------
-- Table structure for partner
-- ----------------------------
DROP TABLE IF EXISTS `partner`;
CREATE TABLE `partner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteName` varchar(15) NOT NULL COMMENT '站点名',
  `siteUrl` varchar(45) NOT NULL COMMENT '站点地址',
  `siteDesc` varchar(45) NOT NULL COMMENT '站点描述  简单备注 ',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='合作伙伴';

-- ----------------------------
-- Records of partner
-- ----------------------------
INSERT INTO `partner` VALUES ('1', '百度', 'http://www.baidu.com', '百度', '1');
INSERT INTO `partner` VALUES ('2', '谷歌', 'http://www.google.com', '谷歌', '1');

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tagName` varchar(25) NOT NULL COMMENT '标签名称  唯一',
  `aliasName` varchar(20) NOT NULL COMMENT '标签别名 唯一',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tagName_UNIQUE` (`tagName`)
) ENGINE=InnoDB AUTO_INCREMENT=10002 DEFAULT CHARSET=utf8 COMMENT='标签表';

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES ('9999', 'default', 'default');
INSERT INTO `tag` VALUES ('10000', 'Microservice', 'Microservice');
INSERT INTO `tag` VALUES ('10001', 'Database', 'Database');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `enabled` varchar(5) DEFAULT '0' COMMENT '是否被禁用',
  `credential` varchar(5) DEFAULT '0' COMMENT '凭证是否过期',
  `locked` varchar(5) DEFAULT '0' COMMENT '是否被锁',
  `expired` varchar(5) DEFAULT '0' COMMENT '是否过期',
  `createTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'admin', 'FA5A66466E9006215E3F54BF5B2BEEA3', 'false', 'false', 'false', 'false', '2017-05-17 14:32:13');

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info` (
  `username` varchar(20) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `nickname` varchar(20) DEFAULT 'EumJi' COMMENT '昵称',
  `phone` char(11) DEFAULT NULL COMMENT '电话号码',
  `email` varchar(50) DEFAULT 'eumji025@gmail.com' COMMENT '邮箱',
  `signature` varchar(2000) DEFAULT NULL COMMENT '个性签名',
  `address` varchar(50) DEFAULT NULL COMMENT '地址',
  `announcement` varchar(2000) DEFAULT NULL COMMENT '公告',
  `telegram` varchar(20) DEFAULT '18574406580' COMMENT 'telegram账号',
  `wechart` varchar(20) DEFAULT 'jo__18' COMMENT '微信账号',
  UNIQUE KEY `user_info_username_uindex` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息表';

-- ----------------------------
-- Records of user_info
-- ----------------------------
INSERT INTO `user_info` VALUES ('admin', 'https://user-images.githubusercontent.com/7402213/52606979-83fc1100-2eaf-11e9-9065-a65a2642ceee.jpg', 'Bright', '13277926876', 'bright_zhaobl@outlook.com', '有些东西，看似离我们很近，但却很远，努力向它靠近，也许能触及到，也许触及不到，顺其自然，平常心对待，其他的都交给时间，或迟或早，都会有一个结果。', '中国 - 苏州', '一个简单的个人博客。', '', '271381573');
