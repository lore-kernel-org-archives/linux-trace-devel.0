Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1033AC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDF5E20738
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbhAGIdk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIdk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:33:40 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A25C0612FB
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:32:59 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id y23so4782992wmi.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WcrN2QECMeUQHo6SiX87vG7Px54DeR0GyapfjL1vkLY=;
        b=n1Gz6rCUJYY+EkjPAd/Zxmmlvdde9yBnaoLb0q9kJE8HdM7PCBRrGle5TlBwzMKDdZ
         y5WKSwzWwlh0Os8uCOjJq8bDBw/wLS0QWazL9rJubGAYrz5FXdR1yxsHE2IrTZqFeijz
         lpVNLGxLDCgkqzEMABTMZjGBinO+eK4GdQE3DJ66bZip513Fw2y3G3RBLJT+Pjmafp6C
         0BMiSijcC+MBcRyI9Ebn15EbQheosf1lLU9mk8E1+aXFyjPSHe4Wq/esC0X360v4kT+U
         nDwUhzEVSOK2PG4ajKyWhQ14Z06fcylB3z44PSRydG3UIubPclMcMqxWZHLlWqN3+/Hj
         oxuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WcrN2QECMeUQHo6SiX87vG7Px54DeR0GyapfjL1vkLY=;
        b=MpbhgdxM4Ostb418km921WDOGTMWMr2QgEIWIdD3y2bQ46q6dU5Sq9pIhxOr47dm3x
         ScUX3Z+0mQ2waz0fhIu213jsgnDxnZCL00ceU5wWB0LqPmudUUi5OAa5OS5llWqzvcZV
         9wZfI4nhT2yJe0yXFkccnxAIwcMScMlv04p3GAXJpy6gTe/WgylWlW2K6eq2syTWYHsW
         enNamXDQK3qMk+wF+75o894Wml7mhEZAefzq1gAh95YJN23zfffsiG2HUm1xiQHl1sVc
         RVbWzybj4+Jco4PrMkV8VYsdUfT+nS1JoQTO0/YYV/smYXSoYWsoRWEJYhSdMNj/n5YG
         dbCg==
X-Gm-Message-State: AOAM533nhn3uUmkufUoGk6minW7oMdGBj0sFYXPtD4AcDfiMI6rMvtNt
        0Wh6rti6pos3uiQfzQVdbhU=
X-Google-Smtp-Source: ABdhPJzbimwnKHEaVwK8bcDJa/ow3XHjzxox2Gk4Y30XyZUfXJLdGT5KtNdgBHW/MKuVO4pZpMgwug==
X-Received: by 2002:a1c:2c83:: with SMTP id s125mr6943809wms.161.1610008378448;
        Thu, 07 Jan 2021 00:32:58 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v20sm7293867wra.19.2021.01.07.00.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:32:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/6] libtracefs: Unit tests for the new APIs for opening and reading ftrace files
Date:   Thu,  7 Jan 2021 10:32:49 +0200
Message-Id: <20210107083250.16295-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107083250.16295-1-tz.stoyanov@gmail.com>
References: <20210107083250.16295-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added unit tests for:
  tracefs_instance_file_open();
  tracefs_instance_file_read_int();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 92 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index b45a3c6..a51d6fc 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -218,6 +218,7 @@ static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
 #define ALL_TRACERS	"available_tracers"
 #define CUR_TRACER	"current_tracer"
 #define PER_CPU		"per_cpu"
+#define TRACE_ON	"tracing_on"
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
@@ -322,6 +323,95 @@ static void test_instance_file(void)
 	free(inst_dir);
 }
 
+static bool check_fd_name(int fd, char *name)
+{
+	char link[PATH_MAX + 1];
+	char path[PATH_MAX + 1];
+	struct stat st;
+	char *file;
+	int ret;
+
+	snprintf(link, PATH_MAX, "/proc/self/fd/%d", fd);
+	ret = lstat(link, &st);
+	CU_TEST(ret == 0);
+	if (ret < 0)
+		return false;
+	CU_TEST(S_ISLNK(st.st_mode));
+	if (!S_ISLNK(st.st_mode))
+		return false;
+	ret = readlink(link, path, PATH_MAX);
+	CU_TEST(ret > 0);
+	if (ret > PATH_MAX || ret < 0)
+		return false;
+	path[ret] = 0;
+	file = basename(path);
+	CU_TEST(file != NULL);
+	if (!file)
+		return false;
+	ret = strcmp(file, name);
+	CU_TEST(ret == 0);
+	if (ret)
+		return false;
+	return true;
+}
+
+#define FLAGS_STR	"flags:"
+static bool check_fd_mode(int fd, int mode)
+{
+	char path[PATH_MAX + 1];
+	long fmode = -1;
+	char *line = NULL;
+	struct stat st;
+	size_t len = 0;
+	ssize_t size;
+	FILE *file;
+	int ret;
+
+	snprintf(path, PATH_MAX, "/proc/self/fdinfo/%d", fd);
+	ret = stat(path, &st);
+	CU_TEST(ret == 0);
+	if (ret < 0)
+		return false;
+	file = fopen(path, "r");
+	if (!file)
+		return false;
+	while ((size = getline(&line, &len, file)) > 0) {
+		if (strncmp(line, FLAGS_STR, strlen(FLAGS_STR)))
+			continue;
+		fmode = strtol(line + strlen(FLAGS_STR), NULL, 8);
+		break;
+	}
+	free(line);
+	fclose(file);
+	if (fmode < 0 ||
+	    (O_ACCMODE & fmode) != (O_ACCMODE & mode))
+		return false;
+	return true;
+}
+
+static void test_instance_file_fd(void)
+{
+	const char *name = get_rand_str();
+	long long res = -1;
+	char rd[2];
+	int fd;
+
+	fd = tracefs_instance_file_open(test_instance, name, -1);
+	CU_TEST(fd == -1);
+	fd = tracefs_instance_file_open(test_instance, TRACE_ON, O_RDONLY);
+	CU_TEST(fd >= 0);
+	CU_TEST(check_fd_name(fd, TRACE_ON));
+	CU_TEST(check_fd_mode(fd, O_RDONLY));
+
+	CU_TEST(tracefs_instance_file_read_int(test_instance, TRACE_ON, &res) == 0);
+	CU_TEST((res == 0 || res == 1));
+	CU_TEST(read(fd, &rd, 1) == 1);
+	rd[1] = 0;
+	CU_TEST(res == atoi(rd));
+
+	close(fd);
+}
+
 static void exclude_string(char **strings, char *name)
 {
 	int i;
@@ -614,6 +704,8 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "tracing file / directory APIs",
 		    test_trace_file);
 	CU_add_test(suite, "instance file / directory APIs",
+		    test_instance_file_fd);
+	CU_add_test(suite, "instance file descriptor",
 		    test_instance_file);
 	CU_add_test(suite, "systems and events APIs",
 		    test_system_event);
-- 
2.29.2

