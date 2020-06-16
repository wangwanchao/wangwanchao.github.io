---
title: 跨域请求
date: 2018-12-13 01:12:29
tags: 
categpries: js
---
[Spring跨域文档](https://spring.io/blog/2015/06/08/cors-support-in-spring-framework)

<!-- more -->
## 跨域原理 ##


## 前端方案 ##


## 后端方案 ##

### 1. 局部跨域 ###

1. 添加在Cotroller上
2. 添加在Method上
3. 同时添加在Controller + Method上

**注意：**

如果使用到Spring Security框架，确保在Spring Security层次上配置，同时允许使用Spring MVC层面的配置

	@EnableWebSecurity
	public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

		@Override
		protected void configure(HttpSecurity http) throws Exception {
			http.cors().and()...
		}
	}


### 2. 全局跨域 ###

#### 1. 基于JavaConfig方式 ####

使用全局方式

	@Configuration
	@EnableWebMvc
	public class WebConfig extends WebMvcConfigurerAdapter {

		@Override
		public void addCorsMappings(CorsRegistry registry) {
			registry.addMapping("/**");
		}
	}

如果使用Spring Boot，推荐：

	@Configuration
	public class MyConfiguration {
	
	    @Bean
	    public WebMvcConfigurer corsConfigurer() {
	        return new WebMvcConfigurerAdapter() {
	            @Override
	            public void addCorsMappings(CorsRegistry registry) {
	                registry.addMapping("/**");
	            }
	        };
	    }
	}

CORS跨域的规则可以自由定制：

	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/api/**")
			.allowedOrigins("http://domain2.com")
			.allowedMethods("PUT", "DELETE")
				.allowedHeaders("header1", "header2", "header3")
			.exposedHeaders("header1", "header2")
			.allowCredentials(false).maxAge(3600);
	}

**注意：如果使用Spring Security，配置方式和局部跨域中相同**

2. 基于XML方式

```
<mvc:cors>
	<mvc:mapping path="/api/**"
		allowed-origins="http://domain1.com, http://domain2.com"
		allowed-methods="GET, PUT"
		allowed-headers="header1, header2, header3"
		exposed-headers="header1, header2" allow-credentials="false"
		max-age="123" />
	
	<mvc:mapping path="/resources/**"
		allowed-origins="http://domain1.com" />	
</mvc:cors>
```
**注意：使用Spring Security**

	<http>
		<!-- Default to Spring MVC's CORS configuration -->
		<cors />
		...
	</http>

3. 基于Filter方式

```
@Configuration
public class MyConfiguration {
	
	@Bean
	public FilterRegistrationBean corsFilter() {
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		CorsConfiguration config = new CorsConfiguration();
		config.setAllowCredentials(true);
		config.addAllowedOrigin("http://domain1.com");
		config.addAllowedHeader("*");
		config.addAllowedMethod("*");
		source.registerCorsConfiguration("/**", config);
		FilterRegistrationBean bean = new FilterRegistrationBean(new CorsFilter(source));
		bean.setOrder(0);
		return bean;
	}
}
```
[参考1](https://www.jianshu.com/p/87e1ef68794c)

[参考2](https://blog.csdn.net/pinebud55/article/details/60874725)

**注意：使用Spring Security**

	@EnableWebSecurity
	public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
	
	    @Override
	    protected void configure(HttpSecurity http) throws Exception {
	        http
	            // by default uses a Bean by the name of corsConfigurationSource
	            .cors().and()
	            ...
	    }
	
	    @Bean
	    CorsConfigurationSource corsConfigurationSource() {
	        CorsConfiguration configuration = new CorsConfiguration();
	        configuration.setAllowedOrigins(Arrays.asList("https://example.com"));
	        configuration.setAllowedMethods(Arrays.asList("GET","POST"));
	        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
	        source.registerCorsConfiguration("/**", configuration);
	        return source;
	    }
	}
