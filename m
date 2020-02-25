Return-Path: <SRS0=gJb8=4N=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837D4C35E01
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB44206E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYqvLwRg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbgBYSHn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:07:43 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39607 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731149AbgBYSHn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 13:07:43 -0500
Received: by mail-lj1-f195.google.com with SMTP id o15so15088929ljg.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Feb 2020 10:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Vc+kwOmUbzpTE/KOdHos8lFRoTNpj0rkr6VH01Ok+I=;
        b=kYqvLwRgAsvCPKoUPGQ3QLZRSG4tA7wftZZHaVvGpLr1khJdpezET2KYmWOcf0tdm0
         FFA5DTjb4DmFMUJPggjoX6NC4WDD1hGFD61A/nd34nA8Za0g5wfej+gq0OkoHEgh3aRw
         fIAKXXnPViANDshWBhnvWi+q1Y8bddws7EkX7HaJDtdP4Ok7JYwZUuV5tGcetzUsdNmF
         uxy+vk9MtOD8HW9E9wTDLOvFsBggOtfQ6I6lpKJzt0NOeDv/1DsusKUzmw7BP//4z7wU
         ZzDHWrY1ZhjWoCiTibe+bRqwSpfvrxyeBW7uc++SRjlwx6cJKauMe+eCM4/n+ONIfjKP
         SnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Vc+kwOmUbzpTE/KOdHos8lFRoTNpj0rkr6VH01Ok+I=;
        b=WNzx96L4+9bGf8PfPOT9fBdFrXcY6bQrd+okIZIfNiw3L08XgQXihhf3XEv9QmiZtj
         6FnzF01/gcYMWaxlgWxQRmphiP17riC1Ldd1gGgXrBq8u/GB4fv+zDf/DWZuKB0bpiLi
         Jpj4pgR52k8nD1U7BwrA7MKWehJ/+pcv9KR5IAu3mM5BnCpQSv2wG0HfpLPXWPhbOhG3
         Dak8IAOtO6L3cD2ytUQGfFfP+sjoA9U6ZUA1M6n1vAcV42+n+RFlsA4p5j9I34ePHBlR
         u7HdGjBo6R5dNqUB3Je2XCDhUGG1iMhd9VOi5EvbKPTU0WWZkcjn+yfkv4VO1ncEbwXo
         v7Ww==
X-Gm-Message-State: APjAAAVADi2d1qrJcDDENFMXfegO7t1i1KBJgLVAG0rJYZYTvxHOKfYN
        JoGi8VAg1kL7m7TO6/nODW9rkY/vWBA=
X-Google-Smtp-Source: APXvYqxQaMZ5y/7fwpK6f8+02tP+H8qAvQU64wY1IkUs1QUvMRV2ucU47Gzzvxnw8Y8z5MU3agCNlA==
X-Received: by 2002:a2e:9f52:: with SMTP id v18mr179917ljk.30.1582654061032;
        Tue, 25 Feb 2020 10:07:41 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v15sm4141438lfg.51.2020.02.25.10.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 10:07:40 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/4] trace-cmd: Unit tests for new libtracefs APIs
Date:   Tue, 25 Feb 2020 20:07:31 +0200
Message-Id: <20200225180733.89344-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225180733.89344-1-tz.stoyanov@gmail.com>
References: <20200225180733.89344-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unit tests for tracefs APIs, checking for ftrace file / directory existence:
  bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
  bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 2473e893..3f57ecad 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -175,6 +175,7 @@ static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
 
 #define ALL_TRACERS	"available_tracers"
 #define CUR_TRACER	"current_tracer"
+#define PER_CPU		"per_cpu"
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
@@ -251,6 +252,21 @@ static void test_instance_file(void)
 	tracefs_put_tracing_file(inst_file);
 	free(fname);
 
+	CU_TEST(tracefs_file_exist(NULL, (char *)name) == false);
+	CU_TEST(tracefs_dir_exist(NULL, (char *)name) == false);
+	CU_TEST(tracefs_file_exist(instance, (char *)name) == false);
+	CU_TEST(tracefs_dir_exist(instance, (char *)name) == false);
+
+	CU_TEST(tracefs_file_exist(NULL, CUR_TRACER) == true);
+	CU_TEST(tracefs_dir_exist(NULL, CUR_TRACER) == false);
+	CU_TEST(tracefs_file_exist(instance, CUR_TRACER) == true);
+	CU_TEST(tracefs_dir_exist(instance, CUR_TRACER) == false);
+
+	CU_TEST(tracefs_file_exist(NULL, PER_CPU) == false);
+	CU_TEST(tracefs_dir_exist(NULL, PER_CPU) == true);
+	CU_TEST(tracefs_file_exist(instance, PER_CPU) == false);
+	CU_TEST(tracefs_dir_exist(instance, PER_CPU) == true);
+
 	CU_TEST(tracefs_instance_destroy(NULL) != 0);
 	CU_TEST(tracefs_instance_destroy(instance) == 0);
 	CU_TEST(tracefs_instance_destroy(instance) != 0);
-- 
2.24.1

