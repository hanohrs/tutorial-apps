#!/bin/bash
# Convert xml resource(s) on blank project.
#   ${ARTIFACT_ID}=Artifact ID of tutorial project.
# Parameters:
#   $1 : (Optional) Target project path to convert.

TARGET_DIR=$1
if test -n "${TARGET_DIR}/${ARTIFACT_ID}"; then
  pushd "${TARGET_DIR}/${ARTIFACT_ID}"
fi

# domain/pom.xml
DOMAIN_POM=`find ./${ARTIFACT_ID}-domain -type f -name 'pom.xml'`
sed -i -e 's|</dependencies>|\
        <dependency>\
            <groupId>org.springframework</groupId>\
            <artifactId>spring-web</artifactId>\
        </dependency>\
\
        <dependency>\
            <groupId>com.h2database</groupId>\
            <artifactId>h2</artifactId>\
            <scope>runtime</scope>\
        </dependency>\
\
        <dependency>\
            <groupId>org.projectlombok</groupId>\
            <artifactId>lombok</artifactId>\
            <scope>provided</scope>\
        </dependency>\
\
        <dependency>\
            <groupId>org.passay</groupId>\
            <artifactId>passay</artifactId>\
            <version>1.1.0</version>\
        </dependency>\
\
        <dependency>\
            <groupId>com.sun.mail</groupId>\
            <artifactId>javax.mail</artifactId>\
        </dependency>\
\
        <dependency>\
            <groupId>com.icegreen</groupId>\
            <artifactId>greenmail-spring</artifactId>\
            <version>1.4.1</version>\
        </dependency>\
    </dependencies>|' "$DOMAIN_POM"

# mybatis-config.xml
MYBATIS_CONFIG=`find ./ -type f -name 'mybatis-config.xml'`
sed -i -e 's|</typeAliases>|\
        <package name="com.example.securelogin.infra.mybatis.typehandler" />\
    </typeAliases>|' "$MYBATIS_CONFIG"

sed -i -e 's|</typeHandlers>|\
        <package name="com.example.securelogin.infra.mybatis.typehandler" />\
    </typeHandlers>|' "$MYBATIS_CONFIG"

# -env.xml
SECURE_LOGIN_ENV=`find ./ -type f -name "${ARTIFACT_ID}-env.xml"`
sed -i -e 's|</beans>|\
    <bean id="mailSender" class="org.springframework.mail.javamail.JavaMailSenderImpl">\
        <property name="host" value="${mail.host}" />\
        <property name="port" value="${mail.port}" />\
    </bean>\
\
    <bean id="passwordReissueMessage" class="org.springframework.mail.SimpleMailMessage">\
        <property name="from" value="${mail.from}" />\
        <property name="subject" value="${mail.subject}" />\
    </bean>\
\
    <cache:annotation-driven />\
\
    <bean id="cacheManager" class="org.springframework.cache.support.SimpleCacheManager">\
        <property name="caches">\
            <set>\
                <bean\
                    class="org.springframework.cache.concurrent.ConcurrentMapCacheFactoryBean"\
                    name="isInitialPassword" />\
                <bean\
                    class="org.springframework.cache.concurrent.ConcurrentMapCacheFactoryBean"\
                    name="isCurrentPasswordExpired" />\
            </set>\
        </property>\
    </bean>\
\
    <bean id="greenMailBean" class="com.icegreen.greenmail.spring.GreenMailBean" />\
</beans>|' "$SECURE_LOGIN_ENV"

sed -i -e 's|xsi:schemaLocation|\
    xmlns:cache="http://www.springframework.org/schema/cache"\
    xsi:schemaLocation|' "$SECURE_LOGIN_ENV"

sed -i -e 's|spring-beans\.xsd|spring-beans\.xsd\
        http://www.springframework.org/schema/cache http://www.springframework.org/schema/cache/spring-cache.xsd|' "$SECURE_LOGIN_ENV"

# web/pom.xml
WEB_POM=`find ./${ARTIFACT_ID}-web -type f -name 'pom.xml'`
sed -i -e 's|</dependencies>|\
        <dependency>\
            <groupId>org.terasoluna.gfw</groupId>\
            <artifactId>terasoluna-gfw-validator</artifactId>\
        </dependency>\
\
        <dependency>\
            <groupId>org.projectlombok</groupId>\
            <artifactId>lombok</artifactId>\
            <scope>provided</scope>\
        </dependency>\
\
        <dependency>\
            <groupId>org.passay</groupId>\
            <artifactId>passay</artifactId>\
            <version>1.1.0</version>\
        </dependency>\
    </dependencies>|' "$WEB_POM"

# applicationContext.xml
APPLICATION_CONTEXT=`find ./ -type f -name 'applicationContext.xml'`
sed -i -e 's|</beans>|\
    <bean id="lengthRule" class="org.passay.LengthRule">\
        <property name="minimumLength" value="${security.passwordMinimumLength}" />\
    </bean>\
\
    <bean id="upperCaseRule" class="org.passay.CharacterRule">\
        <constructor-arg name="data">\
            <util:constant static-field="org.passay.EnglishCharacterData.UpperCase" />\
        </constructor-arg>\
        <constructor-arg name="num" value="1" />\
    </bean>\
\
    <bean id="lowerCaseRule" class="org.passay.CharacterRule">\
        <constructor-arg name="data">\
            <util:constant static-field="org.passay.EnglishCharacterData.LowerCase" />\
        </constructor-arg>\
        <constructor-arg name="num" value="1" />\
    </bean>\
\
    <bean id="digitRule" class="org.passay.CharacterRule">\
        <constructor-arg name="data">\
            <util:constant static-field="org.passay.EnglishCharacterData.Digit" />\
        </constructor-arg>\
        <constructor-arg name="num" value="1" />\
    </bean>\
\
    <bean id="specialCharacterRule" class="org.passay.CharacterRule">\
        <constructor-arg name="data">\
            <util:constant static-field="org.passay.EnglishCharacterData.Special" />\
        </constructor-arg>\
        <constructor-arg name="num" value="1" />\
    </bean>\
\
    <bean id="characterCharacteristicsRule" class="org.passay.CharacterCharacteristicsRule">\
        <property name="rules">\
            <list>\
                <ref bean="upperCaseRule" />\
                <ref bean="lowerCaseRule" />\
                <ref bean="digitRule" />\
                <ref bean="specialCharacterRule" />\
            </list>\
        </property>\
        <property name="numberOfCharacteristics" value="3" />\
    </bean>\
\
    <bean id="usernameRule" class="org.passay.UsernameRule" />\
\
    <bean id="encodedPasswordHistoryRule"\
        class="com.example.securelogin.app.common.validation.rule.EncodedPasswordHistoryRule">\
        <constructor-arg name="passwordEncoder" ref="passwordEncoder" />\
    </bean>\
\
    <bean id="characteristicPasswordValidator" class="org.passay.PasswordValidator">\
        <constructor-arg name="rules">\
            <list>\
                <ref bean="lengthRule" />\
                <ref bean="characterCharacteristicsRule" />\
                <ref bean="usernameRule" />\
            </list>\
        </constructor-arg>\
    </bean>\
\
    <bean id="encodedPasswordHistoryValidator" class="org.passay.PasswordValidator">\
        <constructor-arg name="rules">\
            <list>\
                <ref bean="encodedPasswordHistoryRule" />\
            </list>\
        </constructor-arg>\
    </bean>\
\
    <bean id="passwordGenerator" class="org.passay.PasswordGenerator" />\
\
    <util:list id="passwordGenerationRules">\
        <ref bean="upperCaseRule" />\
        <ref bean="lowerCaseRule" />\
        <ref bean="digitRule" />\
    </util:list>\
\
    <bean id="expiredReissueInfoCleaner"\
        class="com.example.securelogin.domain.common.scheduled.UnnecessaryReissueInfoCleaner" />\
    <task:scheduler id="reissueInfoCleanupTaskScheduler" />\
\
    <task:scheduled-tasks scheduler="reissueInfoCleanupTaskScheduler">\
        <task:scheduled ref="expiredReissueInfoCleaner" method="cleanup"\
            fixed-delay="${security.reissueInfoCleanupSeconds}" />\
    </task:scheduled-tasks>\
</beans>|' "$APPLICATION_CONTEXT"

sed -i -e 's|xsi:schemaLocation|\
    xmlns:task="http://www.springframework.org/schema/task"\
    xmlns:util="http://www.springframework.org/schema/util"\
xsi:schemaLocation|' "$APPLICATION_CONTEXT"

sed -i -e 's|spring-beans\.xsd|spring-beans\.xsd\
        http://www.springframework.org/schema/task http://www.springframework.org/schema/task/spring-task.xsd\
        http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd|' "$APPLICATION_CONTEXT"

sed -i -e 's/e.xx.fw.5001/e.sl.fw.5001/g' "$APPLICATION_CONTEXT"
sed -i -e 's/e.xx.fw.7001/e.sl.fw.7001/g' "$APPLICATION_CONTEXT"
sed -i -e 's/e.xx.fw.8001/e.sl.fw.8001/g' "$APPLICATION_CONTEXT"
sed -i -e 's/e.xx.fw.9001/e.sl.fw.9001/g' "$APPLICATION_CONTEXT"

# spring-mvc.xml
SPRING_MVC=`find ./ -type f -name 'spring-mvc.xml'`
sed -i -e 's|</beans>|\
    <mvc:view-controller path="/login" view-name="login/login" />\
</beans>|' "$SPRING_MVC"

sed -i -e 's|</mvc:interceptors>|\
        <mvc:interceptor>\
            <mvc:mapping path="/**" />\
            <mvc:exclude-mapping path="/password/**" />\
            <mvc:exclude-mapping path="/reissue/**" />\
            <mvc:exclude-mapping path="/resources/**" />\
            <mvc:exclude-mapping path="/**/*.html" />\
            <bean\
                class="com.example.securelogin.app.common.interceptor.PasswordExpirationCheckInterceptor" />\
        </mvc:interceptor>\
    </mvc:interceptors>|' "$SPRING_MVC"

# spring-security.xml
SPRING_SECURITY=`find ./ -type f -name 'spring-security.xml'`
sed -i -e 's|</beans>|\
    <bean id="logoutSuccessHandler"\
        class="com.example.securelogin.app.common.security.CacheClearLogoutSuccessHandler">\
        <constructor-arg value="/" />\
    </bean>\
</beans>|' "$SPRING_SECURITY"

sed -i -e "s|</sec:http>|\
        <sec:intercept-url pattern=\"/login\" access=\"permitAll\" />\
        <sec:intercept-url pattern=\"/reissue/**\" access=\"permitAll\" />\
        <sec:intercept-url pattern=\"/api/receivedmail\" access=\"permitAll\" />\
        <sec:intercept-url pattern=\"/unlock/**\" access=\"hasRole('ADMIN')\" />\
        <sec:intercept-url pattern=\"/**\" access=\"isAuthenticated()\" />\
</sec:http>|" "$SPRING_SECURITY"

sed -i -e 's|<sec:form-login.*/>|<sec:form-login login-page="/login"\
            authentication-failure-url="/login?error=true"\
            login-processing-url="/login" username-parameter="username"\
            password-parameter="password" />|' "$SPRING_SECURITY"

sed -i -e 's|<sec:logout.*/>|<sec:logout logout-url="/logout" success-handler-ref="logoutSuccessHandler"\
            delete-cookies="JSESSIONID" />|' "$SPRING_SECURITY"

sed -i -e 's|<sec:authentication-manager.*/>|<sec:authentication-manager>\
        <sec:authentication-provider\
            user-service-ref="loggedInUserDetailsService">\
            <sec:password-encoder ref="passwordEncoder" />\
        </sec:authentication-provider>\
    </sec:authentication-manager>|' "$SPRING_SECURITY"

# web.xml
WEB_XML=`find ./ -type f -name 'web.xml'`
sed -i -e '/<?xml version="1.0" encoding="UTF-8"?>/,/<listener>/s|<listener>|<context-param>\
        <param-name>db.url</param-name>\
        <param-value>jdbc:h2:mem:'"${ARTIFACT_ID}"';DB_CLOSE_DELAY=-1;INIT=RUNSCRIPT FROM '"'"'classpath:logback-ddl.sql'"'"'</param-value>\
    </context-param>\
\
    <context-param>\
        <param-name>db.user</param-name>\
        <param-value>sa</param-value>\
    </context-param>\
\
    <context-param>\
        <param-name>db.password</param-name>\
        <param-value></param-value>\
    </context-param>\
\
    <context-param>\
        <param-name>db.tcpServer</param-name>\
        <param-value>-tcpAllowOthers -tcpPort 9212</param-value>\
    </context-param>\
\
    <listener>\
        <listener-class>org.h2.server.web.DbStarter</listener-class>\
    </listener>\
\
    <servlet>\
        <servlet-name>H2Console</servlet-name>\
        <servlet-class>org.h2.server.web.WebServlet</servlet-class>\
        <init-param>\
            <param-name>-webAllowOthers</param-name>\
            <param-value>true</param-value>\
        </init-param>\
        <load-on-startup>2</load-on-startup>\
    </servlet>\
\
    <servlet-mapping>\
        <servlet-name>H2Console</servlet-name>\
        <url-pattern>/admin/h2/*</url-pattern>\
    </servlet-mapping>\
    <listener>|' "$WEB_XML"

if test -n "${TARGET_DIR}/${ARTIFACT_ID}"; then
  popd
fi
