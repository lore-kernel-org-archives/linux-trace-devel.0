Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F88C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C252C61248
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbhIQPWc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 11:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241411AbhIQPWI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 11:22:08 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC83DC0613E2
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 08:16:41 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id c21so31030796edj.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 08:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qdRP+S5joetPVUch9/SeJ+zgj23hWt4gtcuRnFZANnY=;
        b=c8vodFdic8a9q8sAUXMmSdoFy2Z/HP4d0GIV11WQ9/w7Ylyl6AKQ6Ra0ew/+uCsNUE
         HFvT0UK5A7GKVcJ55GJOpKQdFc+pZ/ZRGQqXXDmnc8IWk6jq7ryYQ/K08zSyuWqe9VH7
         qPSwqx68YH0JtVtzNKCcXnPgk0JKBbhDz03ENA4WOREk7Vh00FKlor6y89zK4Z7ucV3c
         ITwG2hEzWpsdX8/0scpt5a1I9hR9CcUTxDJ9z5WbN9ySmltfCM+BNV6rnsl29IDOlEAe
         /pXSfd7LSJSCZnH9qKOs0AIIhL/YFtnRaVzc7be/cN9iKkmGJ2eioOrlUFL6nZZMH0qn
         5k/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qdRP+S5joetPVUch9/SeJ+zgj23hWt4gtcuRnFZANnY=;
        b=aukVNlzB3YNrnlS5IVuuHWZJK+yJ1uVI5p18NjHSI5jXO6V93nMgcXmCPWLH5kaZgN
         FauvEcyKugGReK6tRc27T5Oki+W4L9r6ZnPJ4UEXYY3pCgLqW4lJG3YZMJmZMr4QH624
         8hiI0a7AhJEazp2F+5ex7kRuqo+mTSK7FrFe/PUmLmM6mivWl5bBL10kwYL0VIabc26d
         P96Au6CGTvKebZ/PhwBX5qm1Xm072haivfDMIRoxXvN2XRZjyeKjWvFRlfg3yfIDAAr1
         76CZBAzcTKZQ9ohK4JsZT19vut43cd9yau4jQQ+DfeWoM6LARbF9eIYwqC6I6QEbpGCr
         scwQ==
X-Gm-Message-State: AOAM533mhGRrs/12PDDrwW5le52hoVJley/VeyisRBgTQWuGBKpBa7cp
        8Xy5T5VvgZsM6lCz354K3vHe3S6C3Co=
X-Google-Smtp-Source: ABdhPJwwttLiZeh3agn7hoXJGg0fflpQS+y1pouZquCxTI67VB+ue4qYlD068GZ7mEgRDKUMMEw6JQ==
X-Received: by 2002:aa7:c459:: with SMTP id n25mr12717229edr.29.1631891800332;
        Fri, 17 Sep 2021 08:16:40 -0700 (PDT)
Received: from crow.. ([95.87.199.246])
        by smtp.gmail.com with ESMTPSA id i6sm2382550ejr.68.2021.09.17.08.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 08:16:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] trace-cruncher: Fix get_comm_from_pid()
Date:   Fri, 17 Sep 2021 18:16:24 +0300
Message-Id: <20210917151624.574040-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make sure that the buffer string is properly initialized and that
the new line at the end is removed.

Fixes: defe053 (trace-cruncher: Add generic methods for printing)
SignedFixes: -off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 58f543a..7b1ff1b 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -384,10 +384,16 @@ static bool init_print_seq(void)
 	return true;
 }
 
+static inline void trim_new_line(char *val)
+{
+	if (val[strlen(val) - 1] == '\n')
+		val[strlen(val) - 1] = '\0';
+}
+
 static char *get_comm_from_pid(int pid)
 {
 	char *comm_file, *comm = NULL;
-	char buff[PATH_MAX];
+	char buff[PATH_MAX] = {0};
 	int fd, r;
 
 	if (asprintf(&comm_file, "/proc/%i/comm", pid) <= 0) {
@@ -409,6 +415,7 @@ static char *get_comm_from_pid(int pid)
 	if (r <= 0)
 		return NULL;
 
+	trim_new_line(buff);
 	comm = strdup(buff);
 	if (!comm)
 		MEM_ERROR;
@@ -654,11 +661,6 @@ static int read_from_file(struct tracefs_instance *instance,
 	return size;
 }
 
-static inline void trim_new_line(char *val)
-{
-	val[strlen(val) - 1] = '\0';
-}
-
 static bool write_to_file_and_check(struct tracefs_instance *instance,
 				    const char *file,
 				    const char *val)
-- 
2.30.2

