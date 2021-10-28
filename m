Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48188C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EB5260F90
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhJ1MLm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhJ1MLl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:41 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A95AC061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:14 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 5so23268221edw.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s27DRwdzMZn1X7JsHj+RWkGbryG9TpWSXANqEscYviw=;
        b=SQeISJlnaerShnhZE/W/mkQoF+ATyhx0UsMwzPuDi9sJF3pKM9noF199nEQnQ4Qdpw
         kNKvYKPfds8QmV3teOSHt5/tMQDWbS9dMgvgII9AGHNtB07gQ1mpyDVcnorb6FpLJJN7
         H90IfWlDSrYK4AwRKy89mRPn8F1yVSqK9rwP1xBDVSbHQQDNBo/b2FKupyTSo7oXaDfp
         5GH8BiaPVpcwy/VAQ4V/YGze/HNZ5xO6ffxOu5jNgKNCtlQ1UzEG9OtJ63fhvRqe3jX7
         utMfkV7UtU9QX1WujOpjce8SBlOPRgfwBZJaRt3gVyt+ZKM2c7YbMZQAs2OM8yEonH8f
         9x1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s27DRwdzMZn1X7JsHj+RWkGbryG9TpWSXANqEscYviw=;
        b=q8iyCzelN1XOJt6icAyWyAkHQt8mAw+RyICCbAXD7snEZ9z7WJdJD7PsMXxfoYghXC
         j6y2CsxliFcljDF/nIXPtZ4OIPJQeMY6wqiDsWglFEwgXFebMBPDZTVEcxPNE8I22uE+
         wKLqXcNoJyUj6McXU1sILsSLLcV+SOcj/oItOADzQ0L8z0v+JOFMcUvC2pszJThpsCrO
         7Uyi8DLyS+Lav3ZkgppSrass7UWJ6JheMgnifRdGddu9MdIK8AbbOZCMsbJtAsaHC6V1
         RJf6ArlOs0BaItYzwFNz6bQc+H0zsavzgq37NJAN6iu2zbVVYoxFDOF0uEjcn+Ne1dfW
         Th4A==
X-Gm-Message-State: AOAM531/DJ/J41R4MIPXDfXJmqu01tudTqWFCyXLctIprYKm4WY6HJf9
        gIJU6FjQmk5eVkiq9vmPH+uw0uXxS0se8w==
X-Google-Smtp-Source: ABdhPJwcvNTLmhbx8v+ICXawLjb1MxXm3cvQh2WagnDF+WkOgZrlQ7Bf6/++wUhb0EIYWxZWdiJk/Q==
X-Received: by 2002:a50:e089:: with SMTP id f9mr5643408edl.290.1635422952543;
        Thu, 28 Oct 2021 05:09:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/12] libtracefs: Rename tracefs_get_kprobes API
Date:   Thu, 28 Oct 2021 15:08:57 +0300
Message-Id: <20211028120907.101847-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
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
index 4020551..0240aef 100644
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

