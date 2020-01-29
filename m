Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54ECC33CB2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 779DA20708
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rPv+EV52"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgA2Jyd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:33 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44337 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgA2Jyd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:33 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so11418851lfa.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MZSL4lSAr1LRR/QNV4EpJkgCnF+b0yunYxPJoPPBh9E=;
        b=rPv+EV52273euSyyGgFxq9jlmJ1z6jUXgVuTY10xlamp8DIQhnKsFVe1ilVOwb1isv
         kUnWpSNdkbzSVKah3gwkAJnsFBJExcNGC5JzMi2Ccv364h4eKRoOwHgc4b/87Yn2opzc
         gVwTMpjexkEKkUG0sNNb06vTkIrCoC8H0bGymmkqF646rwuoaKGkfjPT9UYTtSbpXOGI
         S+LjNOo6kJkqnLDom+Ozdh+agjTHbU9ojFIWpYc9ofC1Qh9kVHFV8KOER+W1RyUc+nHV
         gLKSNGyXdAO3BAfAy57nTcwC6qnxMitfWmuBKAJuvsvziR1LRgvUWLeAvLc4FgcNMy+a
         IKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MZSL4lSAr1LRR/QNV4EpJkgCnF+b0yunYxPJoPPBh9E=;
        b=EfYUeVZtq+jlruSum0op1hUSInN6sXF+4bYNnvpsiSfJd4Xe3d4408Y+OcOq+RHUrJ
         8W4mbvJ7bOwl0syV2Yx2W4QFPB0L28oa5xL4Q41ZAkOzOGeUNrEHGhJtLXZNNuQ3ypfw
         ua9w0ojjkf9kfWuD+R2wMz21uupc6YBYRtv/HFegVj7KcMYWKw2KpIEhELcduis+ec+U
         lj1KaxhJR306N+KcaUL6DCNbKtXdr6tMz0DRL5/l9qEJPvW0mUE5uevQLOpWpIw0efVp
         /rNFyV3kSjLQNs0bgESQJ4Te1KE/TmGaOtnLWIKhyvFcpU6nMVdPVeE8eUlQc8xu0Jei
         mi8g==
X-Gm-Message-State: APjAAAWkjif7I/xFqw2tQl41OD6JfrITklsNhlJS4nfCh4zeJPSOsAky
        Hn6/28w5DajdVrlYPSNs+3J+zqd+
X-Google-Smtp-Source: APXvYqyo7Tkli13DB9yqNKuehuC/+1CjEkjEkQo+pHq7kX1RpuVx97CxJtcGiiKz6+A43uRYb/9xqA==
X-Received: by 2002:a19:748:: with SMTP id 69mr5162834lfh.40.1580291670285;
        Wed, 29 Jan 2020 01:54:30 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/9] trace-cmd: Unit tests for libtracefs APIs related to ftrace instances
Date:   Wed, 29 Jan 2020 11:54:18 +0200
Message-Id: <20200129095421.881786-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129095421.881786-1-tz.stoyanov@gmail.com>
References: <20200129095421.881786-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added unit tests for these APIs:
  tracefs_instance_alloc()
  tracefs_instance_get_name()
  tracefs_instance_create()
  tracefs_instance_get_dir()
  tracefs_instance_get_file()
  tracefs_instance_file_read()
  tracefs_instance_file_write()
  tracefs_instance_free()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 122 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 2e6e96f..7930c64 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -138,6 +138,126 @@ static void test_trace_file(void)
 	tracefs_put_tracing_file(file);
 }
 
+static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
+{
+	const char *tdir  = tracefs_get_tracing_dir();
+	char buf[BUFSIZ];
+	char *fpath;
+	char *file;
+	size_t fsize = 0;
+	int size = 0;
+	int fd;
+
+	if (inst) {
+		CU_TEST(asprintf(&fpath, "%s/instances/%s/%s",
+			tdir, tracefs_instance_get_name(inst), fname) > 0);
+	} else {
+		CU_TEST(asprintf(&fpath, "%s/%s", tdir, fname) > 0);
+	}
+
+	memset(buf, 0, BUFSIZ);
+	fd = open(fpath, O_RDONLY);
+	CU_TEST(fd >= 0);
+	fsize = read(fd, buf, BUFSIZ);
+	CU_TEST(fsize >= 0);
+	close(fd);
+	buf[BUFSIZ - 1] = 0;
+
+	file = tracefs_instance_file_read(inst, fname, &size);
+	CU_TEST(file != NULL);
+	CU_TEST(size == fsize);
+	CU_TEST(strcmp(file, buf) == 0);
+
+	free(fpath);
+	free(file);
+}
+
+#define ALL_TRACERS	"available_tracers"
+#define CUR_TRACER	"current_tracer"
+static void test_instance_file(void)
+{
+	struct tracefs_instance *instance = NULL;
+	const char *name = get_rand_str();
+	char *inst_name = NULL;
+	const char *tdir;
+	char *inst_file;
+	char *inst_dir;
+	struct stat st;
+	char *fname;
+	char *file1;
+	char *file2;
+	char *tracer;
+	int size;
+	int ret;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+	CU_TEST(asprintf(&inst_dir, "%s/instances/%s", tdir, name) > 0);
+	CU_TEST(stat(inst_dir, &st) != 0);
+
+	instance = tracefs_instance_alloc(name);
+	CU_TEST(instance != NULL);
+	CU_TEST(stat(inst_dir, &st) != 0);
+	inst_name = tracefs_instance_get_name(instance);
+	CU_TEST(inst_name != NULL);
+	CU_TEST(strcmp(inst_name, name) == 0);
+
+	CU_TEST(tracefs_instance_create(instance) == 0);
+	CU_TEST(stat(inst_dir, &st) == 0);
+	CU_TEST(S_ISDIR(st.st_mode));
+
+	fname = tracefs_instance_get_dir(NULL);
+	CU_TEST(fname != NULL);
+	CU_TEST(strcmp(fname, tdir) == 0);
+	free(fname);
+
+	fname = tracefs_instance_get_dir(instance);
+	CU_TEST(fname != NULL);
+	CU_TEST(strcmp(fname, inst_dir) == 0);
+	free(fname);
+
+	CU_TEST(asprintf(&fname, "%s/"ALL_TRACERS, tdir) > 0);
+	CU_TEST(fname != NULL);
+	inst_file = tracefs_instance_get_file(NULL, ALL_TRACERS);
+	CU_TEST(inst_file != NULL);
+	CU_TEST(strcmp(fname, inst_file) == 0);
+	tracefs_put_tracing_file(inst_file);
+	free(fname);
+
+	CU_TEST(asprintf(&fname, "%s/instances/%s/"ALL_TRACERS, tdir, name) > 0);
+	CU_TEST(fname != NULL);
+	CU_TEST(stat(fname, &st) == 0);
+	inst_file = tracefs_instance_get_file(instance, ALL_TRACERS);
+	CU_TEST(inst_file != NULL);
+	CU_TEST(strcmp(fname, inst_file) == 0);
+
+	test_instance_file_read(NULL, ALL_TRACERS);
+	test_instance_file_read(instance, ALL_TRACERS);
+
+	file1 = tracefs_instance_file_read(instance, ALL_TRACERS, NULL);
+	CU_TEST(file1 != NULL);
+	tracer = strtok(file1, " ");
+	CU_TEST(tracer != NULL);
+	ret = tracefs_instance_file_write(instance, CUR_TRACER, tracer);
+	CU_TEST(ret == strlen(tracer));
+	file2 = tracefs_instance_file_read(instance, CUR_TRACER, &size);
+	CU_TEST(file2 != NULL);
+	CU_TEST(size >= strlen(tracer));
+	CU_TEST(strncmp(file2, tracer, strlen(tracer)) == 0);
+	free(file1);
+	free(file2);
+
+	tracefs_put_tracing_file(inst_file);
+	free(fname);
+
+	CU_TEST(tracefs_instance_destroy(NULL) != 0);
+	CU_TEST(tracefs_instance_destroy(instance) == 0);
+	CU_TEST(tracefs_instance_destroy(instance) != 0);
+	tracefs_instance_free(instance);
+	CU_TEST(stat(inst_dir, &st) != 0);
+	free(inst_dir);
+}
+
 static int test_suite_destroy(void)
 {
 	tracefs_instance_destroy(test_instance);
@@ -175,6 +295,8 @@ void test_tracefs_lib(void)
 	}
 	CU_add_test(suite, "tracing file / directory APIs",
 		    test_trace_file);
+	CU_add_test(suite, "instance file / directory APIs",
+		    test_instance_file);
 	CU_add_test(suite, "tracefs_iterate_raw_events API",
 		    test_iter_raw_events);
 }
-- 
2.24.1

