---
title: 阿里云机器翻译踩坑
date: 2020-09-30 20:42:46
tags:
categpries: bug
---
首先，必须吐槽一下阿里翻译文档写的太烂了。而且现在阿里云做的乱七八糟，什么东西都有，使用起来像狗屎一样难用。我觉得一切好用的都应该是'傻瓜式'的，不让用户去猜测你的意思。

<!-- more -->
使用阿里翻译基本上可以归纳为3个步骤：
1. 创建HttpClient
2. 构建Request请求
3. 请求后解析结果Response

翻译分为普通版、专业版。给我的踩坑经历做一个总结：

## 普通版

### CommonRequest
使用CommonRequest请求。
```
@Configuration
@EnableConfigurationProperties({AliCloudProperties.class, AcmProperties.class})
public class AliyunConfiguration {

  @Bean
  public IAcsClient clientBean(AliCloudProperties aliyunProperties, AcmProperties acmProperties) {

    DefaultProfile profile = DefaultProfile.getProfile(
        acmProperties.getEndpoint(),   // 这里其实应该是RegionId
        aliyunProperties.getAccessKey(),
        aliyunProperties.getSecretKey());
    return new DefaultAcsClient(profile);
  }
}
```
构造request
```
  /**
   * 构造请求
   * @return
   */
  public static CommonRequest buildRequest(String str) {
    CommonRequest request = new CommonRequest();

    if (StringUtils.isBlank(str)) {
      return request;
    }
    request.setSysMethod(MethodType.POST);
    request.setSysDomain("mt.cn-hangzhou.aliyuncs.com");
    request.setSysVersion("2020-09-29");
    request.setSysAction("TranslateGeneral");

    request.putQueryParameter("FormatType", "text");
    request.putQueryParameter("Scene", "general");
    request.putQueryParameter("SourceLanguage", "zh");
    request.putQueryParameter("SourceText", str);
    request.putQueryParameter("TargetLanguage", "en");

    return request;
  }
```
调用请求，这种方式返回String字符串，是需要手动去解析的。
```
@Override
public String translateWithAuto(String str) {
  CommonRequest request = AliyunUtils.buildRequest(str);
  String res = str;
  Gson gson = new Gson();
  try {
    log.info("aliyun trans request: {}", gson.toJson(request));

    CommonResponse response = client.getCommonResponse(request);
    if (null != response &&
        TRANS_SUCCESS.equals(response.getHttpStatus())) {
      String responseStr = response.getData();
      TranslateRes translateRes = gson.fromJson(responseStr, TranslateRes.class);
      res = translateRes.getData().getTranslated();
    }

    log.info("aliyun trans response: {}", gson.toJson(response));
  } catch (ClientException e) {
    e.printStackTrace();
  }

  return res;
}
```

### TranslateGeneralRequest
遇到2个错误：
1. 解析错误
  ```
  com.aliyuncs.exceptions.ClientException: SDK.EndpointResolvingError : No such region 'acm.aliyun.com'. Please check your region ID.
  ```
  找了一堆文档，还是不行，换成`cn-hangzhou`继续报错参数错误。

2. 10004 参数错误

**阿里云机器翻译组，我操你妈！一群傻逼！**怒转专业版。

## 专业版
构造client客户端
```
@Configuration
@EnableConfigurationProperties({AliCloudProperties.class, AcmProperties.class})
public class AliyunConfiguration {

  @Bean
  public IAcsClient clientBean(AliCloudProperties aliyunProperties, AcmProperties acmProperties) {

    DefaultProfile profile = DefaultProfile.getProfile(
        "cn-hangzhou",
        aliyunProperties.getAccessKey(),
        aliyunProperties.getSecretKey());
    return new DefaultAcsClient(profile);
  }
}
```
构造请求体
```
  public static TranslateECommerceRequest      buildECommerceRequest(String str, String scene) {
    TranslateECommerceRequest eCommerceRequest = new TranslateECommerceRequest();

    if (StringUtils.isBlank(str)
      || StringUtils.isBlank(scene)) {
      return eCommerceRequest;
    }

    eCommerceRequest.setScene(scene);
    eCommerceRequest.setFormatType("text");
    eCommerceRequest.setSourceLanguage(SOURCE_LANGUAGE);
    eCommerceRequest.setSourceText(str.trim());
    eCommerceRequest.setTargetLanguage(TARGET_LANGUAGE);

    return eCommerceRequest;
  }
```
调用请求
```
  @Override
  public String translateWithAuto(String str) {
    if (StringUtils.isBlank(str)) {
      return str;
    }

    String res = str;
    Gson gson = new Gson();
    try {
      TranslateECommerceRequest request = AliyunUtils
          .buildECommerceRequest(str, TranslateEnum.TITLE.getCode());
      log.info("aliyun trans request: {}", gson.toJson(request));

      TranslateECommerceResponse response = client.getAcsResponse(request);
      log.info("aliyun trans response: {}", gson.toJson(response));

      if (TRANS_SUCCESS.equals(response.getCode())) {
        Data data = response.getData();
        res = data.getTranslated();
      }

    } catch (ClientException e) {
      e.printStackTrace();
    }

    return res;
  }
```
终于成功了，我操你妈！