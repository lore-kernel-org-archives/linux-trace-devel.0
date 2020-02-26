Return-Path: <SRS0=1BtL=4O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8699C4BA13
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F2AA24670
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBQt+9oF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgBZQcH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:32:07 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40596 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbgBZQcH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 11:32:07 -0500
Received: by mail-lj1-f194.google.com with SMTP id n18so3804853ljo.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Feb 2020 08:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hoA9+WGSbu8C2p4LQyj6mqpIZwKtFWUsPpsIzHeMVwk=;
        b=tBQt+9oFdg5KpbnOebh7AZjciabIvUZnxGY9dIneJYZgAfVvUF3aLbPbm2iakccho1
         mruAxBEuD5juhtMqeZ+ve5UfJu2ZTBo3ChIN7WZlAYNfaJygON2JGvTblf2puwrMKjzn
         1Op7J5Jg2kWUJ4YP2BwXYCTHz25vypxVJoNettJdHMS8sBlx9Dq7ZZ/O1irrkv/vh9Su
         gbQBnnu2byUbYWm6+mm2KTvPr83+syH4e2mkJr5fwBbuh9OvdFFbNmktIaqRlNDejzS0
         uKtVKcecm1xcQ1QIEGVXk9oPEeIBKzYaF3SeU9QAYtwgXS3BcMDnstFY4u94F8rK+9Ra
         P1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hoA9+WGSbu8C2p4LQyj6mqpIZwKtFWUsPpsIzHeMVwk=;
        b=sgiEVdM3p1FwtDICB1orznFVWP2tTm8eR7p93tD8qvfy5bEXhucz0Z/Frf6VUuEYWV
         mfZkQX3S/cQ0axvqPAxY8nnKjUjQHQBAzZFeU4Dfrxq4UDo1EZUHaUGjFRzclWwhBJOd
         K6tJPw88KBZas0QYzt4xhxA/RvraVMH/JapYke/K0BEKVo7X861tvu/jNvj6re8zzMH2
         xZFTmiV72qJtyoj3Czmr1+BwSB2eKO/5FHw42ryXwXoBWYElySuWDh7JxAclklwf7mDV
         qxAfZl/mcozcSW4lB5wsWz7D3eWDC3uC7kci3NCBbW93eOaS55Lke3knePGfNpiJzu7q
         RnRw==
X-Gm-Message-State: APjAAAWJZavRv12riQKvDo4xfpeHNe2JtJ4G6l5kX0GXaAhoWgoACcEo
        MICiyK+HHSYyczTOOmvdey0=
X-Google-Smtp-Source: ADFU+vvSDb6V5DWmZ2pskwy7PlqHuhtb/DiUvresgvpBeSf2jhHBYA4M/BP04YccKNykE1xeantkCw==
X-Received: by 2002:a2e:3504:: with SMTP id z4mr3508332ljz.273.1582734724563;
        Wed, 26 Feb 2020 08:32:04 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s2sm1264133lfd.67.2020.02.26.08.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 08:32:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/5] trace-cmd: Unit test for tracefs_instance_file_append() API
Date:   Wed, 26 Feb 2020 18:31:56 +0200
Message-Id: <20200226163159.20232-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226163159.20232-1-tz.stoyanov@gmail.com>
References: <20200226163159.20232-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A unit test for tracefs_instance_file_append() API is added.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 106 +++++++++++++++++++++++++++++++++---------
 1 file changed, 84 insertions(+), 22 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 3f57ecad..1dc15e1b 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -176,6 +176,86 @@ static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
 #define ALL_TRACERS	"available_tracers"
 #define CUR_TRACER	"current_tracer"
 #define PER_CPU		"per_cpu"
+#define SYNTH_EVENTS	"synthetic_events"
+static void test_trace_file_read(struct tracefs_instance *instance)
+{
+	test_instance_file_read(NULL, ALL_TRACERS);
+	test_instance_file_read(instance, ALL_TRACERS);
+}
+
+static void test_trace_file_write(struct tracefs_instance *instance)
+{
+	char *tracer;
+	char *file1;
+	char *file2;
+	int size;
+	int ret;
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
+}
+
+static bool check_file_line(struct tracefs_instance *instance,
+			    char *fname, char *line, bool last)
+{
+	bool found = false;
+	char *buf = NULL;
+	char *l;
+	int n;
+
+	buf = tracefs_instance_file_read(instance, fname, &n);
+	if (!buf)
+		return 0;
+	l = strtok(buf, "\n");
+	while (l) {
+		if (strncmp(l, line, strlen(line)) == 0) {
+			if (last) {
+				if (strtok(NULL, "\n") == NULL)
+					found = true;
+			} else
+				found = true;
+			break;
+		}
+		l = strtok(NULL, "\n");
+	}
+	free(buf);
+	return found;
+}
+
+static void test_trace_file_append(struct tracefs_instance *instance)
+{
+	char *sevent1 = "first	u64 start; u64 end; pid_t pid; u64 delta";
+	char *sevent2 = "second	u64 start; u64 end; pid_t pid; u64 delta";
+	char buf[256];
+	int ret;
+
+	if (!tracefs_file_exist(NULL, SYNTH_EVENTS))
+		return;
+
+	CU_TEST(!check_file_line(NULL, SYNTH_EVENTS, sevent1, false));
+	ret = tracefs_instance_file_append(NULL, SYNTH_EVENTS, sevent1);
+	CU_TEST(ret == strlen(sevent1));
+	CU_TEST(check_file_line(NULL, SYNTH_EVENTS, sevent1, true));
+	ret = tracefs_instance_file_append(NULL, SYNTH_EVENTS, sevent2);
+	CU_TEST(ret == strlen(sevent2));
+	CU_TEST(check_file_line(NULL, SYNTH_EVENTS, sevent1, false));
+	CU_TEST(check_file_line(NULL, SYNTH_EVENTS, sevent2, true));
+	snprintf(buf, 256, "!%s", sevent1);
+	tracefs_instance_file_write(NULL, SYNTH_EVENTS, buf);
+	snprintf(buf, 256, "!%s", sevent2);
+	tracefs_instance_file_write(NULL, SYNTH_EVENTS, buf);
+}
+
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
@@ -186,11 +266,6 @@ static void test_instance_file(void)
 	char *inst_dir;
 	struct stat st;
 	char *fname;
-	char *file1;
-	char *file2;
-	char *tracer;
-	int size;
-	int ret;
 
 	tdir  = tracefs_get_tracing_dir();
 	CU_TEST(tdir != NULL);
@@ -232,26 +307,13 @@ static void test_instance_file(void)
 	inst_file = tracefs_instance_get_file(instance, ALL_TRACERS);
 	CU_TEST(inst_file != NULL);
 	CU_TEST(strcmp(fname, inst_file) == 0);
-
-	test_instance_file_read(NULL, ALL_TRACERS);
-	test_instance_file_read(instance, ALL_TRACERS);
-
-	file1 = tracefs_instance_file_read(instance, ALL_TRACERS, NULL);
-	CU_TEST(file1 != NULL);
-	tracer = strtok(file1, " ");
-	CU_TEST(tracer != NULL);
-	ret = tracefs_instance_file_write(instance, CUR_TRACER, tracer);
-	CU_TEST(ret == strlen(tracer));
-	file2 = tracefs_instance_file_read(instance, CUR_TRACER, &size);
-	CU_TEST(file2 != NULL);
-	CU_TEST(size >= strlen(tracer));
-	CU_TEST(strncmp(file2, tracer, strlen(tracer)) == 0);
-	free(file1);
-	free(file2);
-
 	tracefs_put_tracing_file(inst_file);
 	free(fname);
 
+	test_trace_file_read(instance);
+	test_trace_file_write(instance);
+	test_trace_file_append(instance);
+
 	CU_TEST(tracefs_file_exist(NULL, (char *)name) == false);
 	CU_TEST(tracefs_dir_exist(NULL, (char *)name) == false);
 	CU_TEST(tracefs_file_exist(instance, (char *)name) == false);
-- 
2.24.1

