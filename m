Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50054C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A5CB20700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfC0QDq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:03:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32927 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfC0QDp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 12:03:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id b12so10178436pgk.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Mar 2019 09:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lPWoOzH5YTvnrwVFuW5joRTOY72FphCBaUp1V74GVWQ=;
        b=Shmr3vtjoYx9pZ+yiXWyZiuOm4C//KDokzYhN2q1sGDLKKD6v2xh0zoRh5uObnX1rB
         CUZBWb1ecx0nzthBHNX34X6/uLM9iZNI8Wi5Y8F0Y9oBUls15FSp6xikFWfZZHPe/YVA
         0cn6835gsNL8zBJtScRUlUwdOQd68ovlvbyEdLQTRPAlp8l7N+Bw8n0Sp5qZfnAKDFuT
         5fywHOCxPwhabEKuiEXQIjDD6UTWFeGbc56naAQ7C4V5VwjFKq/uzzYBIGWSvMabnWh6
         qyoti4jJGynGwO3XjptO5axqC8Z/c/zvbkzavywvI5OrD6UDobJ8o2NZGsfLU6nWCsDE
         XVAw==
X-Gm-Message-State: APjAAAVbMABo+eKS3ZP0/HtKErP8NjmKS/604AcvZH9+lSw2dPZC+doZ
        8QXJUpmulrEMiTWg6LYunRtR+kBhIhc=
X-Google-Smtp-Source: APXvYqxEAyyZp16eDeuW2p6a2KY/QHrgT6hlkH+z991RanyoJezhciFCtibPFtOnddw8wibOLmUQSg==
X-Received: by 2002:aa7:8c42:: with SMTP id e2mr6796652pfd.24.1553702625312;
        Wed, 27 Mar 2019 09:03:45 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id p88sm36150806pfa.80.2019.03.27.09.03.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 09:03:44 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [RFC 1/7] kernel-shark: kshark_string_config_alloc() must take no arguments
Date:   Wed, 27 Mar 2019 18:03:17 +0200
Message-Id: <20190327160323.31654-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327160323.31654-1-ykaradzhov@vmware.com>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The function is not meant to have arguments, so it must explicitly
state this. A functions taking unspecified list of parameters will
be a problem for the Pythion interface.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-configio.c | 2 +-
 kernel-shark/src/libkshark.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/libkshark-configio.c b/kernel-shark/src/libkshark-configio.c
index 2bd5600..9106522 100644
--- a/kernel-shark/src/libkshark-configio.c
+++ b/kernel-shark/src/libkshark-configio.c
@@ -369,7 +369,7 @@ kshark_filter_config_new(enum kshark_config_formats format)
  * @returns kshark_config_doc instance on success, otherwise NULL. Use free()
  *	    to free the object.
  */
-struct kshark_config_doc *kshark_string_config_alloc()
+struct kshark_config_doc *kshark_string_config_alloc(void)
 {
 	return kshark_config_alloc(KS_CONFIG_STRING);
 }
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index a1b1f91..c218b61 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -541,7 +541,7 @@ kshark_record_config_new(enum kshark_config_formats);
 struct kshark_config_doc *
 kshark_filter_config_new(enum kshark_config_formats);
 
-struct kshark_config_doc *kshark_string_config_alloc();
+struct kshark_config_doc *kshark_string_config_alloc(void);
 
 bool kshark_type_check(struct kshark_config_doc *conf, const char *type);
 
-- 
2.19.1

