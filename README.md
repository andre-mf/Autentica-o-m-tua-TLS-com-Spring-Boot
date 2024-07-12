# 🔑 Autenticação mútua TLS no Spring Boot

A autenticação mútua TLS requer que tanto o servidor quanto o cliente apresentem certificados válidos para estabelecer uma conexão segura. Aqui estão os passos gerais para configurar MTLS em um aplicativo Spring Boot:

## Passo 1: Gerar Certificados

Você precisará de um certificado de servidor e um certificado de cliente. Pode usar keytool para gerar esses certificados.

#### Gerar o Keystore do Servidor

```bash
keytool -genkeypair -alias server -keyalg RSA -keysize 2048 -keystore server-keystore.jks -validity 3650  
```

#### Gerar o Keystore do Cliente

```bash
keytool -genkeypair -alias client -keyalg RSA -keysize 2048 -keystore client-keystore.jks -validity 3650  
```

### Exportar Certificado do Cliente

```bash
keytool -export -alias client -keystore client-keystore.jks -file client-cert.cer  
```

#### Importar Certificado do Cliente no Truststore do Servidor

```bash
keytool -import -alias client -file client-cert.cer -keystore server-truststore.jks  
```

## Passo 2: Configurar o Application Properties

Adicione as seguintes configurações no application.properties ou application.yml:

```properties
 server.port=8443
 server.ssl.key-store=classpath:server-keystore.jks
 server.ssl.key-store-password=password
 server.ssl.key-password=password
 server.ssl.trust-store=classpath:server-truststore.jks
 server.ssl.trust-store-password=password
 server.ssl.client-auth=need
```

## Passo 3: Configurar o Servidor

Certifique-se de que o keystore e o truststore estão incluídos no classpath do seu projeto (por exemplo, /src/main/resources/).

## Passo 4: Configurar o Cliente

Para testar a conexão MTLS, você pode usar o curl ou configurar outro cliente HTTP que suporte MTLS.

##### Usando Curl

```bash
curl -v --cert client-keystore.jks --key client-keystore.jks --pass password https://localhost:8443  
```

## Passo 5: Configurar Segurança no Spring Boot

Se estiver usando Spring Security, certifique-se de configurar a segurança corretamente:

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
            .anyRequest().authenticated()
            .and()
            .requiresChannel()
            .anyRequest().requiresSecure();
    }
}
```

Para verificar se a configuração está funcionando corretamente, você pode iniciar a aplicação e tentar acessar os  endpoints com e sem o certificado de cliente. Apenas clientes com o certificado correto devem conseguir acessar os  endpoints seguros.

#### Conclusão

Esses passos permitem configurar a autenticação mútua TLS em um aplicativo Spring Boot, garantindo que apenas clientes  com certificados válidos possam acessar os endpoints da aplicação.
