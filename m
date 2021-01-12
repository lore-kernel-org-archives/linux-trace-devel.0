Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AA5C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E74022E01
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390755AbhALJVt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390542AbhALJVt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 04:21:49 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AE3C0617A4
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:34 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id t16so2429187ejf.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YUbWQbjxxAko+8hvUqXQyq9S/8eClQ9L2CYVZy6Pcig=;
        b=NvGDB0C+Y1lndZMwjH6Wr3IYs1M2DYnOF4hd9wkht9YaqXKBMkceEe7BMwR/XXJI+a
         jLjWjZ1SPldV/NwfynvlZzwMpcQlSZdN3+NE4jWlTm+s/0Y/AMTMBIAgDL3WDzexp9tD
         uvwIvWBqmlEfzr549MOMEie2KPjq5kE/N4oW/Msa4RKf3U+KrAHL4vBy5RSAem7kIHGU
         SlIqM0eqe+gm6DvvJYRa2SwmVV6iV3lPO5QnCNjXbShe+kOA9aETyVlgzgui9iA+wm1U
         ET3kmdJKy4VpxYAYYwcjb7tQ0gdl9dFl0IW4CyFwhNETYKP339F4qxeSJnq9H7hpt7wa
         kRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUbWQbjxxAko+8hvUqXQyq9S/8eClQ9L2CYVZy6Pcig=;
        b=Wf8Hc6JG3DQOrMawkisDdoSmX8dKhhErZ6IgRAB5FzwryIrpTmFuLVDfhJkO1jzDF8
         KzUr2HNSE3jouGZlmVlpD68r2TZa3aH0HWkhX3jXtuiXiCTi7exYPJSkMOwfH7Ldz2eC
         99QrxsJaLJ0QfPQs+5vbXqtPrnZqyXQIemPRiMDVp2fa8Gers1TXczu4K1z0UkfPampn
         MvhFwh75vdJEgUTWKdYLF92Na++Qv9D3Lc5D83Tj7amnepVdTlCbCMPtYboBurGUtNSJ
         FoXUbaN6u76YlJpkJmAO5mZOpQs5IGxadaMig+noLiu7H/0WcJnl3QMlr0Id1QR3uDH8
         Oj6A==
X-Gm-Message-State: AOAM532h+Xzf6tLRlLyqNUjTtOKY5uFx0fpmVUmWyD/EisOinZwPy74n
        4X+3/0Kv4XUayoAR/ypJX/jY6zPn/Qb1znOK
X-Google-Smtp-Source: ABdhPJz4tpsxWu/9T8Q0yjvcU6sRia4d9sO5QPWRRTUaTBYGRGezQ282Uf3M4162pHTa1GGep4XH/g==
X-Received: by 2002:a17:906:3111:: with SMTP id 17mr2415626ejx.152.1610443233714;
        Tue, 12 Jan 2021 01:20:33 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id rl7sm929187ejb.107.2021.01.12.01.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:20:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 6/7] libtracefs: Unit tests for the new APIs for opening and reading ftrace files
Date:   Tue, 12 Jan 2021 11:20:23 +0200
Message-Id: <20210112092024.605705-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112092024.605705-1-tz.stoyanov@gmail.com>
References: <20210112092024.605705-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added unit tests for:
  tracefs_instance_file_open();
  tracefs_instance_file_read_number();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 94 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index a8e8f67..bbe653c 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -218,6 +218,7 @@ static void test_instance_file_read(struct tracefs_instance *inst, const char *f
 #define ALL_TRACERS	"available_tracers"
 #define CUR_TRACER	"current_tracer"
 #define PER_CPU		"per_cpu"
+#define TRACE_ON	"tracing_on"
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
@@ -322,6 +323,97 @@ static void test_instance_file(void)
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
+	CU_TEST(tracefs_instance_file_read_number(test_instance, "available_tracer", &res) != 0);
+	CU_TEST(tracefs_instance_file_read_number(test_instance, name, &res) != 0);
+	CU_TEST(tracefs_instance_file_read_number(test_instance, TRACE_ON, &res) == 0);
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
@@ -614,6 +706,8 @@ void test_tracefs_lib(void)
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

