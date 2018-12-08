---
title: web中身份验证和授权
date: 2018-12-06 13:01:23
tags: Auth
categpries: Auth
---

## OpenAPI2.0


## OpenAPI3.0
```
components:
	securitySchemes:
	
		BasicAuth:
			type: http
			scheme: basic
		BearerAuth:
			type: http
			scheme: bearer
		
		ApiKeyAuth:
			type: apikey
			in: header
			name: X-API-Key
		
		OAuth2:
			type: oauth2
			flows:
				authorizationCode:
					authorizationUrl: https://
					tokenUrl: https://
					scopes:
						read: Grants read access
						write: Grants write access
						admin: Grants access to admin operations
		
		OpenID:
			type: openIdConnect
			openIdConnectUrl: http://xxx

```


### HTTP认证方案

### 标头中的API密钥
用于API密钥和cookie认证，

### OAuth2.0

### OpenID Connect实现

## Shiro

## JWT

### 基本思路：

1. 用户首次访问提供用户名 + 密码到认证服务器
2. 服务器验证用户提交信息的合法性，如果验证成功，生成一个token到客户端
3. 客户端每次访问携带token

token包含信息：

1. header：

	typ声明类型
	
	alg生成签名的算法

		{ "alg" :"AES256", "typ" :"JWT"}
	
2. claims

	sub
	
	name
	
	admin

		{ "sub":"1234567890", "name":"John Doe", "admin":true}

3. signature

### JWT和OAuth2.0、Shiro

Shiro: 


