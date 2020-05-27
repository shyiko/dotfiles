function mvnw-init() {
  curl -sL https://github.com/shyiko/mvnw/releases/download/0.1.0/mvnw.tar.gz | tar xvz
  (MAVEN_VERSION=3.2.5 &&
    sed -iEe "s/[0-9]\+[.][0-9]\+[.][0-9]\+/${MAVEN_VERSION}/g" .mvn/wrapper/maven-wrapper.properties)
}
