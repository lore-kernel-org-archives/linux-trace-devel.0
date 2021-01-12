Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5728C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0CD922EBE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbhALJVK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390589AbhALJVK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 04:21:10 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8846DC061794
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:29 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id f4so1394666ejx.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CJhW/KrXWYGV+GkPUysTu7VogU8uThk+O/ZrLvtDg2w=;
        b=a9y8Xq1TDAE3CdCYOUb5SC7B5K0fIP3HAD0DflbtHxNpPFlIZdZ7N7Fej18BIhx7x5
         vJTEeg0YYCwcGSZ/04cqE/6cdXyfFyYfowrtrySdgE+czZ5CUAz+v9oOVeGNVIkxsdm8
         ISsZjaohwNhsRH5S3aUU78+FUL6fBpAu9YlMygvUBQ4K/65raQu4M5wGxYktx61mUIrz
         HSouIcEVr8QLwVGwKuRmHATUa7hjaP/ZJBhSHfbjRK3IN2GKJHbOZnPHh3nVOvyzcGar
         fW0yMNjCDMserwbpyMIVJIgMv1hn0TWFpo/uck9Rp/hQAAUz+jtUfJjppPclUKLop0n8
         /eFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CJhW/KrXWYGV+GkPUysTu7VogU8uThk+O/ZrLvtDg2w=;
        b=JKGxD8Mqr99cSUKHri4iw4qWJxETIX0NwHk3MYsUCYg+KYsbRRKwvkaUC8Dw/57FP6
         Y2L3bj1n1csYFLlleUQySqd6Rm1qNrKBU2P4LqKBsvHJaAFOJ7cievqLfOlp2ytQWKfC
         PtkSkzN5b4X1oAQANefH1k4qE33QuUD1cNH9dFhmi/ug2znhlfsjQMbMgIqhlsjL7Tlq
         jaY4VMoogdLZpExC8kHIVIT6gM3SC+Mb4rfgGxlXT4n9kcgIavCEUsSaN6PNnLCj1ACU
         aaK/AOIIwGsBSbBKT6j/3Ih3DC8P9SFNQf6ZhbIPCYnycePLQjGhEsMykc+2zw5tC796
         QJQA==
X-Gm-Message-State: AOAM5329108w14TRqBscQcMWSSYkFNkebiyd8n1rlkWUDHl4BBcT+EzA
        rQJ1fio0d36mIb3Bz+7Gev8sWC64uh9HmQOd
X-Google-Smtp-Source: ABdhPJzUMUrbU7MtYI8f+6uaHA4IM5IWh8CZQ0FSDVIUjkvvJy/gngTa8r59M2Pc5XoUGKcRrl4aeA==
X-Received: by 2002:a17:906:1194:: with SMTP id n20mr2481756eja.269.1610443228075;
        Tue, 12 Jan 2021 01:20:28 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id rl7sm929187ejb.107.2021.01.12.01.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:20:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/7] libtracefs: tracefs_instance_file_read() get a const file name
Date:   Tue, 12 Jan 2021 11:20:18 +0200
Message-Id: <20210112092024.605705-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112092024.605705-1-tz.stoyanov@gmail.com>
References: <20210112092024.605705-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The file name input parameter of tracefs_instance_file_read() API should
be a pointer to a constat string, as this file name must not be changed
by the API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-instances-files.txt | 2 +-
 Documentation/libtracefs.txt                 | 2 +-
 include/tracefs.h                            | 2 +-
 src/tracefs-instance.c                       | 2 +-
 utest/tracefs-utest.c                        | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
index 9b18b73..a9af1f7 100644
--- a/Documentation/libtracefs-instances-files.txt
+++ b/Documentation/libtracefs-instances-files.txt
@@ -18,7 +18,7 @@ bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:
 char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
 char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
 int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
-char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_file_, int pass:[*]_psize_);
+char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
 
 --
 
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index ddbf783..bf3882f 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -26,7 +26,7 @@ Trace instances:
 	char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
 	char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
-	char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_file_, int pass:[*]_psize_);
+	char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
 	const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
 	bool *tracefs_instance_exists*(const char pass:[*]_name_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 3d70aca..06e2130 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -29,7 +29,7 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance);
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
-				 char *file, int *psize);
+				 const char *file, int *psize);
 int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
 
 bool tracefs_instance_exists(const char *name);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index bf3de7c..6dc85ee 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -282,7 +282,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
  * The return string must be freed by free()
  */
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
-				  char *file, int *psize)
+				 const char *file, int *psize)
 {
 	char *buf = NULL;
 	int size = 0;
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index b45a3c6..a8e8f67 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -181,7 +181,7 @@ static void test_trace_file(void)
 	tracefs_put_tracing_file(file);
 }
 
-static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
+static void test_instance_file_read(struct tracefs_instance *inst, const char *fname)
 {
 	const char *tdir  = tracefs_tracing_dir();
 	char buf[BUFSIZ];
-- 
2.29.2

