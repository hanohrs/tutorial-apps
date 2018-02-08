#!/bin/bash
# Convert xml resource(s) on blank project.
# Parameters:
#   $1 : (Optional) Target project path to convert.

TARGET_DIR=$1
if test -n $TARGET_DIR; then
  pushd "$TARGET_DIR"
fi

# web.xml
find ./ -type f -name 'web.xml' | xargs sed -i -e 's|<servlet>|\
    <!-- (1) -->\
    <servlet>\
        <servlet-name>restApiServlet</servlet-name>\
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>\
        <init-param>\
            <param-name>contextConfigLocation</param-name>\
            <!-- ApplicationContext for Spring MVC (REST) -->\
            <param-value>classpath*:META-INF/spring/spring-mvc-rest.xml</param-value>\
        </init-param>\
        <load-on-startup>1</load-on-startup>\
    </servlet>\
\
    <!-- (2) -->\
    <servlet-mapping>\
        <servlet-name>restApiServlet</servlet-name>\
        <url-pattern>/api/v1/*</url-pattern>\
    </servlet-mapping>\
\
    <servlet>|'

# spring-mvc-rest.xml
find ./ -type f -name "spring-mvc.xml" -print0 | while read -r -d '' file; do cp -i "$file" "${file%%spring-mvc.xml}spring-mvc-rest.xml"; done

# spring-mvc-rest.xml
find ./ -type f -name 'spring-mvc-rest.xml' | xargs sed -i -e 's|</mvc:argument-resolvers>|\
        </mvc:argument-resolvers>\
        <mvc:message-converters register-defaults="false">\
            <!-- (1) -->\
            <bean\n\
                class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter">\
                <!-- (2) -->\
                <property name="objectMapper">\n\
                    <bean class="com.fasterxml.jackson.databind.ObjectMapper">\
                        <property name="dateFormat">\
                            <!-- (3) -->\
                            <bean class="com.fasterxml.jackson.databind.util.StdDateFormat" />\
                        </property>\
                    </bean>\
                </property>\
            </bean>\
        </mvc:message-converters>|'

# spring-mvc-rest.xml
find ./ -type f -name 'spring-mvc-rest.xml' | xargs sed -i -e 's|<context:component-scan base-package="com.example.todo.app" />|\
    <context:component-scan base-package="com.example.todo.api" />|'

# spring-security,xml
find ./ -type f -name 'spring-security.xml' | xargs sed -i -e 's|<sec:http pattern="/resources/\*\*" security="none"/>|\
    <sec:http pattern="/resources/**" security="none" />\
\
    <!-- (1) -->\
    <sec:http pattern="/api/v1/**" security="none" />\
|'

if test -n $TARGET_DIR; then
  popd
fi
