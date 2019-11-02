---
title: ZooKeeper选举算法基础(三)
date: 2019-06-06 13:52:31
tags: ZooKeeper
categpries: ZooKeeper
---
选举算法有多种

<!-- more -->
## 选举算法
electionAlg配置：

1. 0：基于UDP的LeaderElection
2. 1：基于UDP的FastLeaderElection
3. 2：基于UDP和认证的FastLeaderElection
4. 3：基于TCP的FastLeaderElection(新版本默认算法)

