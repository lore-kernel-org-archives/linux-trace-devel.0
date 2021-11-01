Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA24C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F9D9610CF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhKAJLn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhKAJLn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 05:11:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342C5C061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 02:09:10 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h7so62697586ede.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 02:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vrIk2kTx3vhrRMqu+INFqOwEIZFvJqE1wHQ3opYgEP4=;
        b=CQJ1VPKfZjvQiDl9X9LnS9iLwLDcHWhdWOU4tpRmGUIGhEhGcBWZIC43gD5JpZ997r
         t5Z6wjlZlTK9xvssJhoqXOWoSrBU77ZRF7jIYd5sQcEM0TSbyNWlJZ5Po3vFg9VoiReP
         L7vQ3i2avLyalNbrUw8YZ9qrkTNUwLeWibpGJF29by0AB3BQ9hO50/DAgdwH6D8ZAKfG
         WwcvPnCLwHCR/OjkuXhtEZjfIcGUbxcsf6FjDzpSYi2PB6R+wuVxOyBqb4aVGv467PO3
         uBO2C3BIzs4w2JmCsSghKCmeAPhbhyUfYlo9c+omihkTBkrlvNO1ZT6suxCUiCpIHWsV
         IEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vrIk2kTx3vhrRMqu+INFqOwEIZFvJqE1wHQ3opYgEP4=;
        b=CvT/WCSRIz1qFw6oVpUbIWaI/IAwKb+8QJ22IQSnlrq5bYE0dbKIrKD/nkn95Cug5e
         TidnzhJJbdGTzZPhOawsyaYRwMeI568xThZEpHVvz/bbiFIL2tzlzV3QQOtapUm0BqVQ
         hN8M39UlHzSwRJGR6VidpaXLJ6qyM/RWOIKGrs3Vqv+hcwEfaRHNSzgkuAeTriq2e2YM
         4aMnDy6c+resbyMhHtY8WNNBP+HLi4MMvrDevv4jkdJwJ/UWjgoubs5OLBdH75k9KgRl
         ghaL/gF/WfAd6oXShDdk3P10Xpg+4CFoK/48owF2Km3oDvZMhG1H5hWZ+ZCiwAuQM9Hq
         +JfQ==
X-Gm-Message-State: AOAM531go4g7WrCZ7xLdOzP+Q/1pftOg5+dQMg68Fp1rNII02ULv4Xnv
        mhmd/YSSeqNuf6pc0Juk+uxYscq8GyO0zg==
X-Google-Smtp-Source: ABdhPJw+qyESa4YOCYIKRE5/LN/VLcJR2gC4QZ1OiV1cGSl8tfV2o6yRojsp7vFkeo7m5HqUNidhig==
X-Received: by 2002:a17:906:5d15:: with SMTP id g21mr35295528ejt.162.1635757748838;
        Mon, 01 Nov 2021 02:09:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm9873222edc.10.2021.11.01.02.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:09:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 02/12] libtracefs: Rename tracefs_get_kprobes API
Date:   Mon,  1 Nov 2021 11:08:54 +0200
Message-Id: <20211101090904.81454-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101090904.81454-1-tz.stoyanov@gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The names of tracefs API should follow the same pattern:
  tracefs_XXX_<action>
Rename tracefs_get_kprobes() to tracefs_kprobes_get() to be
consistent with that pattern.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-kprobes.txt |  8 ++++----
 include/tracefs.h                    |  2 +-
 src/tracefs-kprobes.c                |  6 +++---
 utest/tracefs-utest.c                | 10 +++++-----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index c10576e..ca48fa9 100644
--- a/Documentation/libtracefs-kprobes.txt
+++ b/Documentation/libtracefs-kprobes.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_kprobe_raw, tracefs_kretprobe_raw, tracefs_get_kprobes, tracefs_kprobe_info, tracefs_kprobe_clear_all, tracefs_kprobe_clear_probe - Create, list, and destroy kprobes
+tracefs_kprobe_raw, tracefs_kretprobe_raw, tracefs_kprobes_get, tracefs_kprobe_info, tracefs_kprobe_clear_all, tracefs_kprobe_clear_probe - Create, list, and destroy kprobes
 
 SYNOPSIS
 --------
@@ -13,7 +13,7 @@ SYNOPSIS
 
 int tracefs_kprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
 int tracefs_kretprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
-char pass:[*]pass:[*]tracefs_get_kprobes(enum tracefs_kprobe_type type);
+char pass:[*]pass:[*]tracefs_kprobes_get(enum tracefs_kprobe_type type);
 enum tracefs_kprobe_type tracefs_kprobe_info(const char pass:[*]group, const char pass:[*]event,
 					     char pass:[*]pass:[*]type, char pass:[*]pass:[*]addr, char pass:[*]pass:[*]format);
 enum tracefs_kprobe_type tracefs_kprobe_type(const char pass:[*]group, const char pass:[*]event)
@@ -36,7 +36,7 @@ document.
 creates a kretprobe instead of a kprobe. The difference is also described
 in the Linux kernel source in the Documentation/trace/kprobetrace.rst file.
 
-*tracefs_get_kprobes*() returns an array of strings (char pass:[*]) that contain
+*tracefs_kprobes_get*() returns an array of strings (char pass:[*]) that contain
 the registered kprobes and kretprobes depending on the given _type_. If _type_ is
 TRACEFS_ALL_KPROBES, then all kprobes found are returned. If _type_ is
 TRACEFS_KPROBE, then only normal kprobes are returned. If _type_ is
@@ -76,7 +76,7 @@ If a parsing error occurs on *tracefs_kprobe_raw*() or *tracefs_kretprobe_raw*()
 then *tracefs_error_last*(3) may be used to retrieve the error message explaining
 the parsing issue.
 
-*tracefs_get_kprobes*() returns an allocate string list of allocated strings
+*tracefs_kprobes_get*() returns an allocate string list of allocated strings
 on success that must be freed with *tracefs_list_free*(3) and returns
 NULL on error.
 
diff --git a/include/tracefs.h b/include/tracefs.h
index ee167be..4e721eb 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -251,7 +251,7 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
-char **tracefs_get_kprobes(enum tracefs_kprobe_type type);
+char **tracefs_kprobes_get(enum tracefs_kprobe_type type);
 enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
 					     char **type, char **addr, char **format);
 int tracefs_kprobe_clear_all(bool force);
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 6fdd8f9..d4c5f9e 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -158,7 +158,7 @@ static int parse_kprobe(char *content, char **saveptr,
 }
 
 /**
- * tracefs_get_kprobes - return a list kprobes (by group/event name)
+ * tracefs_kprobes_get - return a list kprobes (by group/event name)
  * @type: The type of kprobes to return.
  *
  * If @type is TRACEFS_ALL_KPROBES all kprobes in the kprobe_events
@@ -174,7 +174,7 @@ static int parse_kprobe(char *content, char **saveptr,
  * only a NULL pointer.
  * On error, NULL is returned.
  */
-char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
+char **tracefs_kprobes_get(enum tracefs_kprobe_type type)
 {
 	char **list = NULL;
 	char *content;
@@ -357,7 +357,7 @@ static int kprobe_clear_probes(const char *group, bool force)
 	int ret;
 	int i;
 
-	kprobe_list = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
+	kprobe_list = tracefs_kprobes_get(TRACEFS_ALL_KPROBES);
 	if (!kprobe_list)
 		return -1;
 
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 09bb8f2..7c1a84e 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -583,7 +583,7 @@ static void test_instance_file(void)
 	free(kaddr);
 	free(kformat);
 
-	kprobes = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
+	kprobes = tracefs_kprobes_get(TRACEFS_ALL_KPROBES);
 	CU_TEST(kprobes != NULL);
 
 	for (i = 0; kprobes[i]; i++) {
@@ -612,7 +612,7 @@ static void test_instance_file(void)
 	tracefs_list_free(kprobes);
 	CU_TEST(i == 3);
 
-	kprobes = tracefs_get_kprobes(TRACEFS_KPROBE);
+	kprobes = tracefs_kprobes_get(TRACEFS_KPROBE);
 	CU_TEST(kprobes != NULL);
 
 	for (i = 0; kprobes[i]; i++) {
@@ -631,7 +631,7 @@ static void test_instance_file(void)
 	tracefs_list_free(kprobes);
 	CU_TEST(i == 2);
 
-	kprobes = tracefs_get_kprobes(TRACEFS_KRETPROBE);
+	kprobes = tracefs_kprobes_get(TRACEFS_KRETPROBE);
 	CU_TEST(kprobes != NULL);
 
 	for (i = 0; kprobes[i]; i++) {
@@ -663,7 +663,7 @@ static void test_instance_file(void)
 	ret = tracefs_kprobe_clear_probe(KPROBE_2_GROUP, NULL, true);
 	CU_TEST(ret == 0);
 
-	kprobes = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
+	kprobes = tracefs_kprobes_get(TRACEFS_ALL_KPROBES);
 	CU_TEST(kprobes != NULL);
 
 	for (i = 0; kprobes[i]; i++) {
@@ -682,7 +682,7 @@ static void test_instance_file(void)
 	ret = tracefs_kprobe_clear_all(true);
 	CU_TEST(ret == 0);
 
-	kprobes = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
+	kprobes = tracefs_kprobes_get(TRACEFS_ALL_KPROBES);
 	CU_TEST(kprobes != NULL);
 
 	CU_TEST(kprobes[0] == NULL);
-- 
2.31.1

