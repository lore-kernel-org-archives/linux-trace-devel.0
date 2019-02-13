Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE02DC282C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7848D20700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404350AbfBMQNJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:13:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56134 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404347AbfBMQNJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 11:13:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id r17so3085671wmh.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Feb 2019 08:13:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fC08RJNBECFF0zrX5WZNBuB/w7yIiuy3nkjIvVmaKJk=;
        b=D2IG/w+PdB2MaHmyjFvvkObXS/Pw6Ytzb7HXEnKMfs3jsZwQ+2DoMtA+aZpGOw26ge
         /xwS9V/j44BuWH8YABRpZ5Zv659RMupfnWi0vmQO5IXXEjP/u5XTEff46TkXMIuIGThK
         DjBFnaibaJ2X45eNWezO7VZlgQtGfc8szSLRyOPCIfgQHW3tycHDo2iv39e5yz4M+yfz
         VBxNvZZmcWKxh9BgFsRSAoI3n/5fkU9h5Rjvtx8PDbg053wWc7/jysktW8sLMAurDODZ
         1Q5Jh+o8iGRJDAfcdQbHmBUaFjDxA+Fq8r8huTDgKI1RuTIoh+MS/R352s1lUqOIcOkr
         CE6w==
X-Gm-Message-State: AHQUAubpBK7cEkt9I9ZfFBQ0t/U199UypkcW1xLSEXFnEfANZK3JAc+D
        WarJUtfirLNwRuC9u6vh4Wc=
X-Google-Smtp-Source: AHgI3IbP4JzHpfMXzBt3yk+WsXDSzYXgH/X9jHtnf+xIhWbVx+5ovx1bUmgJfcUJ8MCSPklBgtHcGQ==
X-Received: by 2002:a1c:47:: with SMTP id 68mr865591wma.89.1550074387116;
        Wed, 13 Feb 2019 08:13:07 -0800 (PST)
Received: from localhost.localdomain ([95.87.211.218])
        by smtp.gmail.com with ESMTPSA id h9sm3111631wrv.11.2019.02.13.08.13.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 08:13:06 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 8/8] kernel-shark: Version 1.0.0
Date:   Wed, 13 Feb 2019 18:12:16 +0200
Message-Id: <20190213161216.14438-9-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213161216.14438-1-ykaradzhov@vmware.com>
References: <20190213161216.14438-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 9460026..a1859af 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -4,9 +4,9 @@ cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 # Set the name and version of the project
 project(kernel-shark)
 
-set(KS_VERSION_MAJOR 0)
-set(KS_VERSION_MINOR 9)
-set(KS_VERSION_PATCH 8)
+set(KS_VERSION_MAJOR 1)
+set(KS_VERSION_MINOR 0)
+set(KS_VERSION_PATCH 0)
 set(KS_VERSION_STRING ${KS_VERSION_MAJOR}.${KS_VERSION_MINOR}.${KS_VERSION_PATCH})
 message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
-- 
2.17.1

