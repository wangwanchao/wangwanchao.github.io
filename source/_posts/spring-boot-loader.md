---
title: Spring boot注解自动装配原理分析
date: 2018-07-12 10:34:03
tags: java, springboot, 源码
categories: SpringBoot
---
熟悉Spring Boot项目搭建的同学都知道基本的配置。

<!-- more -->

## 原理 ##

首先看Application main类需要基本的注解@SpringBootApplication：

	@RestController
	@SpringBootApplication
	public class AutoconfigDemoTestApplication {
	
		public static void main(String[] args) {
			SpringApplication.run(AutoconfigDemoTestApplication.class, args);
		}
	}


进入@SpringBootApplication可以看到：

	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Inherited
	@SpringBootConfiguration
	@EnableAutoConfiguration
	@ComponentScan(excludeFilters = {
			@Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class),
			@Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class) })
	public @interface SpringBootApplication {
	
	}

除去基本的元注解，进入@SpringBootConfiguration，可以看到是一些基本的注解：

	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Configuration
	public @interface SpringBootConfiguration {
	
	}

进入注解@EnableAutoConfiguration，可以看到除了注解@AutoConfigurationPackage，还有一个@Import(AutoConfigurationImportSelector.class)：

	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Inherited
	@AutoConfigurationPackage
	@Import(AutoConfigurationImportSelector.class)
	public @interface EnableAutoConfiguration {
	
		String ENABLED_OVERRIDE_PROPERTY = "spring.boot.enableautoconfiguration";
	
		//
		Class<?>[] exclude() default {};
	
		//
		String[] excludeName() default {};
	
	}

@AutoConfigurationPackage是一些：

	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Inherited
	@Import(AutoConfigurationPackages.Registrar.class)
	public @interface AutoConfigurationPackage {
	
	}

进入AutoConfigurationImportSelector类，可以看到方法selectImports来确定要导入的类：

	@Override
	public String[] selectImports(AnnotationMetadata annotationMetadata) {
		if (!isEnabled(annotationMetadata)) {
			return NO_IMPORTS;
		}
		// 加载"META-INF/spring-autoconfigure-metadata.properties"
		AutoConfigurationMetadata autoConfigurationMetadata = AutoConfigurationMetadataLoader
				.loadMetadata(this.beanClassLoader);
		//
		AnnotationAttributes attributes = getAttributes(annotationMetadata);
		List<String> configurations = getCandidateConfigurations(annotationMetadata,
				attributes);
		configurations = removeDuplicates(configurations);
		Set<String> exclusions = getExclusions(annotationMetadata, attributes);
		checkExcludedClasses(configurations, exclusions);
		configurations.removeAll(exclusions);
		configurations = filter(configurations, autoConfigurationMetadata);
		fireAutoConfigurationImportEvents(configurations, exclusions);
		return StringUtils.toStringArray(configurations);
	}

先看方法getCandidateConfigurations，回头有时间再慢慢分析其它方法：
	
	protected List<String> getCandidateConfigurations(AnnotationMetadata metadata,
			AnnotationAttributes attributes) {
		List<String> configurations = SpringFactoriesLoader.loadFactoryNames(
				getSpringFactoriesLoaderFactoryClass(), getBeanClassLoader());
		Assert.notEmpty(configurations,
				"No auto configuration classes found in META-INF/spring.factories. If you "
						+ "are using a custom packaging, make sure that file is correct.");
		return configurations;
	}

再看SpringFactoriesLoader.loadFactoryNames，可以知道最终读取的是所有jar包META-INF目录下的spring.factories文件：
	public static final String FACTORIES_RESOURCE_LOCATION = "META-INF/spring.factories";

	public static List<String> loadFactoryNames(Class<?> factoryClass, @Nullable ClassLoader classLoader) {
		String factoryClassName = factoryClass.getName();
		return loadSpringFactories(classLoader).getOrDefault(factoryClassName, Collections.emptyList());
	}

	private static Map<String, List<String>> loadSpringFactories(@Nullable ClassLoader classLoader) {
		MultiValueMap<String, String> result = cache.get(classLoader);
		if (result != null) {
			return result;
		}

		try {
			Enumeration<URL> urls = (classLoader != null ?
					classLoader.getResources(FACTORIES_RESOURCE_LOCATION) :
					ClassLoader.getSystemResources(FACTORIES_RESOURCE_LOCATION));
			result = new LinkedMultiValueMap<>();
			while (urls.hasMoreElements()) {
				URL url = urls.nextElement();
				UrlResource resource = new UrlResource(url);
				Properties properties = PropertiesLoaderUtils.loadProperties(resource);
				for (Map.Entry<?, ?> entry : properties.entrySet()) {
					List<String> factoryClassNames = Arrays.asList(
							StringUtils.commaDelimitedListToStringArray((String) entry.getValue()));
					result.addAll((String) entry.getKey(), factoryClassNames);
				}
			}
			cache.put(classLoader, result);
			return result;
		}
		catch (IOException ex) {
			throw new IllegalArgumentException("Unable to load factories from location [" +
					FACTORIES_RESOURCE_LOCATION + "]", ex);
		}
	}

## Fat jar ##

### PropertiesLauncher加载规则： ###

> loader.properties属性，先在loader.home中查找； 再去classpath根路径查找； 最后到`classpath:/BOOT-INF/classes`中查找;第一次找到的即使用
> 
> 如果loader.config.location没有配置，loader.home下的属性文件会覆盖默认的属性文件
> loader.path可以包括目录、文件路径、jar包中的目录`dependencies.jar!/lib`、正则匹配；文件路径可以是loader.home指定的路径或者文件系统中以`jar:file:`前缀开头的路径
> 
> loader.path如果为空，默认放在`BOOT-INF/lib`下，同时loader.path不能用来配置loader.properties的存放路径
> 
> 变量的搜索路径顺序：环境变量、系统变量、loader.properties、外部的manifest文件、内部的manifest文件

### 打包限制规则： ###

1. zip压缩，必须使用ZipEntry.STORED方法压缩
2. SystemClassLoader，加载class文件使用Thread.getContextClassLoader()，使用ClassLoader.getSystemClassLoader()加载会导致失败，由于java.util.Logging类使用SystemClassLoader加载，所以需要重写Logging的继承类


### 可执行jar的其他构建方法 ###

1. Maven Shade Plugin
2. JarClassLoader
3. OneJar
4. Gradle Shadow Plugin
