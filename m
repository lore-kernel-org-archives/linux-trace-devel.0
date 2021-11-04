Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38583C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E87F61205
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhKDLNf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhKDLNe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 07:13:34 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88823C061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 04:10:56 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id t30so7966556wra.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 04:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OnP2VjY0ZX3gBmFr+H8D5ibXcblWgVa3omW3UjP1sH0=;
        b=EMS8nbmnY2bl/pcwG4tL2bjAYWUSt+rTQt0eIUk8Yd1DrHNCrb2bKLXC/Ij5yC5XnL
         izDiXqr49KVlnLBorA8i5odS7ovQvG96rGq/oHhGJ3VZ/L/j5QfelZblJ52slqUKU8O2
         a1Jf6QkoVnYLlFAjgrksTJI+tldKzCuiuZ7v6AtWJWdOyh9UV5Zljitc/N86XfnTDt+o
         XD45tB46fY9hX8Rvu/1IFaiOHaUV+fWb2QlwLZV486Pbjvu9VVqre9uf2YeIGLZ2B6hM
         XwITbuunvQVFveuX4xOjpAQm8Bf7M4TCH3y0E1VVLwaBFxrDhT35HHSNha6BHtZm2DeC
         CRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OnP2VjY0ZX3gBmFr+H8D5ibXcblWgVa3omW3UjP1sH0=;
        b=l6Rbp1P4t7YzGIFUQhdAO+KNDmmDvokn3QSW+6rcw/AMgbALfkkvWFDupoAkf+g/OH
         lg6c8wJ6Hx7imTk0HmyKR+FPidViYV2K+mGW11R1E5lWzgncVuRpDQ3vWcs1g2Q7LHTB
         vWuJlYz7Xi5RHDdNs3qnNhRkltGgy0YZ7bTJVaX5qVoPTtd8OQgOknkvC7Q0LUI1TN+V
         7bfArml9w1ZG68ul5mn8xdXRwY1y0NzPq+kMDHoyXipY+t6zFzTcI3muPBtyEZAF3QQZ
         EY10V0gIlWJsxNRPJ4GSrcoeP4r1JfbnL20/cBqW+FgyB26nJtLRLWoM0kOInSMeu8De
         QhkQ==
X-Gm-Message-State: AOAM532ptN8Ik2H2b4BuZGeJONjXw2xIXxiywrwB9H+lEIr81HT3ACNI
        wstbTixjILC22MquUQZC1O4=
X-Google-Smtp-Source: ABdhPJyiZCiYOAMatTx55qOCOQz7BWDciLhvmubSir2rA0vkApcS/DcnP/ZJKqAK5RUZ9DDOUCfYRA==
X-Received: by 2002:adf:e742:: with SMTP id c2mr36780687wrn.232.1636024255136;
        Thu, 04 Nov 2021 04:10:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm5080843wrt.81.2021.11.04.04.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:10:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 05/10] libtracefs: Reimplement kprobe raw APIs
Date:   Thu,  4 Nov 2021 13:10:42 +0200
Message-Id: <20211104111047.302660-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104111047.302660-1-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to unify the code and use the new dynamic event helpers, these
kprobe APIs are rewritten:
 kracefs_kprobe_raw()
 kracefs_kretprobe_raw()
The definition and logic of the APIs remain the same.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-kprobes.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index a391637..f152b67 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -129,37 +129,20 @@ error:
 	return NULL;
 }
 
-static int insert_kprobe(const char *type, const char *system,
-			 const char *event, const char *addr,
-			 const char *format)
+static int kprobe_raw(enum tracefs_dynevent_type type, const char *system,
+		      const char *event, const char *addr, const char *format)
 {
-	char *str;
+	static struct tracefs_dynevent *kp;
 	int ret;
 
-	if (!tracefs_file_exists(NULL, KPROBE_EVENTS))
-		return -1;
-
-	errno = EBADMSG;
-	if (!addr || !format)
-		return -1;
-
-	if (!event)
-		event = addr;
-
-	if (system)
-		ret = asprintf(&str, "%s:%s/%s %s %s\n",
-			       type, system, event, addr, format);
-	else
-		ret = asprintf(&str, "%s:%s %s %s\n",
-			       type, event, addr, format);
-
-	if (ret < 0)
+	kp = kprobe_alloc(type, system, event, addr, format);
+	if (!kp)
 		return -1;
 
-	ret = tracefs_instance_file_append(NULL, KPROBE_EVENTS, str);
-	free(str);
+	ret = tracefs_dynevent_create(kp);
+	tracefs_dynevent_free(kp);
 
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 /**
@@ -185,7 +168,7 @@ static int insert_kprobe(const char *type, const char *system,
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format)
 {
-	return insert_kprobe("p", system, event, addr, format);
+	return kprobe_raw(TRACEFS_DYNEVENT_KPROBE, system, event, addr, format);
 }
 
 /**
@@ -211,7 +194,7 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format)
 {
-	return insert_kprobe("r", system, event, addr, format);
+	return kprobe_raw(TRACEFS_DYNEVENT_KRETPROBE, system, event, addr, format);
 }
 
 /**
-- 
2.31.1

