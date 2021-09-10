Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840A6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BB62611F0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229466AbhIJQbc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhIJQbc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 12:31:32 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB29C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:30:21 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s25so3334079edw.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VWXMnj/4bycUbYJdqDLb08aYTY1j7UbIKEMdtzV/w4E=;
        b=W07qfVtoDQVyHBmc/nS0Y3w3UpzMqEym4unySpmc7M92iqHDEfbnyMT0fbWAYMKNKy
         H663zAng2keEqZM1A8uGOTyB0+x/SlE6RyDi86MFbOnV7XtQV5fbzRkEbt4uST7n5hHr
         pycISaJe5N2k6b+nXdGMOIyPl67mz9Itq3tnK/ScHH9BVeDhEMXcnRaDgAcGRPV+WMdE
         OVcHfdW0PhCkNvfL2u+oCBpYnIhz0b+WaOJJla2P1S9jX0qac/uaILi96eHY7WM7xIQF
         PNB0drRLnU4noO6W/pawGoiC+v0kRfo9JoLrZA+XFtjtecpimNNenOQFrgFYIlf6AkIU
         DkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VWXMnj/4bycUbYJdqDLb08aYTY1j7UbIKEMdtzV/w4E=;
        b=50jT+ajhwPQRTWCDwKVF2RuhExpLoyW4leyIzW7IP59QCx23bUf0oIHK+4s7q14r0Y
         evl/e1QDhuq6ElHbqhEw4ZJjp5f4cS/y5CTbvbf95H7+N00AG92Onx53DbMWq0Liph9U
         WwbwxxWXsFpjmEtgHuUox7a3ygMqG+PVmCgaeRd1BMuZZv6/EKBROP6E5eqjKD8ljxeg
         IHvXismhLyKeuwq1BIK6FNGdM1TVmTNw2kjmAni7lGpjCXCEkUFBPRXOHpqxrmNm34iB
         4I5yYNkZUznAZWmi6XvVigYozTbCqTbiw8GWoFhDfFXghl51Djl0yU4Hn8yLqcY/3CtG
         J8OA==
X-Gm-Message-State: AOAM5334zIg5fUEpb6pJd+Ow/W1TdCfYnEVg8xJIFXTvS8kf8macz00+
        kP6+ZJ9/TfHDuhH2aVhNzUTJwJlF0vI=
X-Google-Smtp-Source: ABdhPJyNgbRTyxr3+8CDapJeDKduPuiIwlfINtY91hN4wuE2T5qA9ELS1FdF3i3O54hLW4WUoY61Sg==
X-Received: by 2002:aa7:dd57:: with SMTP id o23mr9952462edw.385.1631291419760;
        Fri, 10 Sep 2021 09:30:19 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id c25sm2654484ejm.9.2021.09.10.09.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:30:19 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Fix code indentation
Date:   Fri, 10 Sep 2021 19:30:07 +0300
Message-Id: <20210910163007.324033-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a code style fix. No functional changes are introduced.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h  |  7 +++----
 src/tracefs-hist.c | 12 ++++++------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 9cfd257..b4aa75d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -279,12 +279,11 @@ enum tracefs_hist_sort_direction {
 
 struct tracefs_hist;
 
-void tracefs_hist_free
-(struct tracefs_hist *hist);
+void tracefs_hist_free(struct tracefs_hist *hist);
 struct tracefs_hist *
 tracefs_hist_alloc(struct tracefs_instance * instance,
-		       const char *system, const char *event,
-		       const char *key, enum tracefs_hist_key_type type);
+		   const char *system, const char *event,
+		   const char *key, enum tracefs_hist_key_type type);
 int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 8b90787..6519f7e 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -158,8 +158,8 @@ void tracefs_hist_free(struct tracefs_hist *hist)
  */
 struct tracefs_hist *
 tracefs_hist_alloc(struct tracefs_instance * instance,
-			const char *system, const char *event,
-			const char *key, enum tracefs_hist_key_type type)
+		   const char *system, const char *event,
+		   const char *key, enum tracefs_hist_key_type type)
 {
 	struct tracefs_hist *hist;
 	int ret;
@@ -385,10 +385,10 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
 
 	if (!key_list[i]) {
 		for (i = 0; val_list[i]; i++) {
-		if (strcmp(val_list[i], sort_key) == 0)
-			break;
-		if (!val_list[i])
-			return NULL;
+			if (strcmp(val_list[i], sort_key) == 0)
+				break;
+			if (!val_list[i])
+				return NULL;
 		}
 	}
 
-- 
2.30.2

