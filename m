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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55160C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A7E20738
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbhAGIdq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIdq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:33:46 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08D2C0612FC
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:33:00 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d13so4705257wrc.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s2I3KtOFcWjYCRGWlxpzPO3r0lLeLwX7VasqrIJSlw0=;
        b=tkquyvNtlRGKpP5lnJc73TK7XjIT3FQVyXiQmxYS05dwsUtxtfjPoBaIG61t04caGY
         abEpq7EvPm636hPB4q8HVEVKI5BVCmqcrb6Eny80OJ5xyEA7ZVz8Ilq0d53o1RTJdSvL
         WcjjJtfWZrb6u/9+LmXvtZNBdJ9vva7NsFOMou+Dz+A53Ld/rGPFlTz1IlvAQuNzYz41
         vI5ihEbeZAqdE6t/9pTAkqsMSOslQO2Bm2bSQlw6Kum59nQXJVhRo/0FsbSXyS0N/PEp
         kpz1OQmNkEiQMcTNAfLnRBTaYPrvB/Rp1f4WH6aYi/ZzRIxaS+Wzt4zbsxnto0hqhvLt
         IBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s2I3KtOFcWjYCRGWlxpzPO3r0lLeLwX7VasqrIJSlw0=;
        b=FH9o91V++yBg8pglccXIkM5d/9UJmhGoyccrzkvfNdPAbXj8yfDUVlqD+FIWe65o0j
         owDWxgLQ0EzDfIEYH4C9PyAWxg94A/waUiz+8DbYtqzF73zNfpbmZGiC992Q90VnUZp6
         doP0Nkbj+0v6yjkD5Zb+yxkMI1YEKSZ0slQfviL/b2YQDgwItRFxgKPNn6ISbKYuiu71
         d39JjII/DqLRJ06JdGuZHJ1H/9pkEt0IlqaZhLAPXoCI8+IAvfyruAnIH2pQ5nnS65gd
         v8RcRbxphjgmvhDJkR3cA7ohOX6HoCph7DtiKzgB79mb10wDxnazyaTjNeIUq9VJQsfa
         fYjQ==
X-Gm-Message-State: AOAM530sMPJEIrpeYPgEl7HNsXHCaKP7qdS1EH7dYGCa3KTq171/FJDa
        jgTdZ6dPxQc8kdk/aTazn0w=
X-Google-Smtp-Source: ABdhPJwVyuziMB8R1Qr7yLEDDXxB6QSxu4T9ToZAlHFN7mR5CA3nN5vrtj55YRXG/9E+onLQYCpuqA==
X-Received: by 2002:a5d:5005:: with SMTP id e5mr7588952wrt.279.1610008379632;
        Thu, 07 Jan 2021 00:32:59 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v20sm7293867wra.19.2021.01.07.00.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:32:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/6] libtracefs: Unit tests for enable / disable tracing APIs
Date:   Thu,  7 Jan 2021 10:32:50 +0200
Message-Id: <20210107083250.16295-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107083250.16295-1-tz.stoyanov@gmail.com>
References: <20210107083250.16295-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New unit tests for these APIs:
 tracefs_trace_is_on();
 tracefs_trace_on();
 tracefs_trace_off();
 tracefs_trace_on_fd();
 tracefs_trace_off_fd();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index a51d6fc..2a80cf7 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -412,6 +412,42 @@ static void test_instance_file_fd(void)
 	close(fd);
 }
 
+static void test_tracing_onoff(void)
+{
+	long long res = -1;
+	int fd;
+
+	fd = tracefs_instance_file_open(test_instance, TRACE_ON, O_WRONLY);
+	CU_TEST(fd >= 0);
+	CU_TEST(tracefs_instance_file_read_int(test_instance, TRACE_ON, &res) == 0);
+	if (res == 1) {
+		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
+		CU_TEST(tracefs_trace_off(test_instance) == 0);
+		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
+		CU_TEST(tracefs_trace_on(test_instance) == 0);
+		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
+
+		CU_TEST(tracefs_trace_off_fd(fd) == 0);
+		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
+		CU_TEST(tracefs_trace_on_fd(fd) == 0);
+		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
+	} else {
+		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
+		CU_TEST(tracefs_trace_on(test_instance) == 0);
+		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
+		CU_TEST(tracefs_trace_off(test_instance) == 0);
+		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
+
+		CU_TEST(tracefs_trace_on_fd(fd) == 0);
+		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
+		CU_TEST(tracefs_trace_off_fd(fd) == 0);
+		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
+	}
+
+	if (fd >= 0)
+		close(fd);
+}
+
 static void exclude_string(char **strings, char *name)
 {
 	int i;
@@ -719,4 +755,7 @@ void test_tracefs_lib(void)
 		    test_instances_walk);
 	CU_add_test(suite, "tracefs_get_clock API",
 		    test_get_clock);
+	CU_add_test(suite, "tracing on / off",
+		    test_tracing_onoff);
+
 }
-- 
2.29.2

