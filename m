Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91175C2BB85
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7090020732
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:56:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pf1TROQy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgDNP4R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 11:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730955AbgDNP4N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 11:56:13 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FCBC061A0F
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:56:12 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id n17so312035lji.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lSjwSpAeM0KoDLl//f39L0dWWmD/hW+98icSfxLbfNM=;
        b=pf1TROQyT6sw0YP1pExE+/JyjPyfj+fz6ckTTgw6Puf31BzjlHBmWoqdIEkFXdd7Ry
         jq0Sn3WA+5VX+BeXJbtLoXjjAhD8CJbrxL9ca5tke5riJl4b7GBUp5sUiy7JRZf1uQPU
         99NlR7st1MmoVv+Ko2uZT1mXYx+7zdrqLnbm/DfihnTTNH2ifaBEHYk/xTmVCW6Aye2V
         gfjrMROCj90ka+ock1/TA07FFdvkUMgqAT21gTY+on9GhBrNLUzptscIjizZqORFCQe0
         23aB9uSABqRmHk3GG3wJbpfOZBtTAYbJEFI48YkftJ16PiKmVS94D3kZWpWYgHpTlxUS
         zsNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lSjwSpAeM0KoDLl//f39L0dWWmD/hW+98icSfxLbfNM=;
        b=dvKYjZhZJUaMzvgMWXuxtO39osdKyhYOXL1ol+O3cWPCL8ESgJYT4byp9N6vkwn3nb
         AeX1iK4Ge6RuNl7fhkvPYg53gyAXh4QPycJF9n4QDdx9xaGPYi/Am+DCQ8DGzehi0p8T
         OfPWcY4usO0VI7IGBHIoNSZoP2rRB+3h2X3n3/CLKSJHvzhxD1nq72cB/utcJ0r70mPy
         TC9+ZVI6RHuQPmULlX9WycOsy6OHvNrri40BQlt8RJcIkuJYlSvMZF9hX9NUzMiAdG+q
         2Xx2duqB8c2BOqZ+9DZrtF+4yJhQTPTeMN/SFgMK39m6JPyfzQFml7PFgoZ1oN0bQD3J
         nIFQ==
X-Gm-Message-State: AGi0PuYJyUc+6Y9JLF1EJSH/Ca/Dag84R+jdicLKNtngOMIZsoYDcAql
        MPG/YNs/B4iHBR+JlhVMk077vYj1CRM=
X-Google-Smtp-Source: APiQypLbIIq7rz/wzqK495DFkxUD/xx9y0frz4WxTz9lOE1ew5u1AYi43RTlhBGVkMKp9Hw0011Egw==
X-Received: by 2002:a2e:7602:: with SMTP id r2mr497376ljc.184.1586879770600;
        Tue, 14 Apr 2020 08:56:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b2sm11408534ljp.63.2020.04.14.08.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 08:56:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 2/3] trace-cmd: Unit tests for new libtracefs APIs
Date:   Tue, 14 Apr 2020 18:56:03 +0300
Message-Id: <20200414155604.31401-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414155604.31401-1-tz.stoyanov@gmail.com>
References: <20200414155604.31401-1-tz.stoyanov@gmail.com>
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
2.25.1

