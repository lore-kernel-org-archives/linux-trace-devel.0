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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6E4C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC12C22DFB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390542AbhALJVu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390713AbhALJVt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 04:21:49 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E195C0617A5
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:36 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id q22so2507017eja.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kdqBTxwJ61ZHvf08XPUPelAlkHvuNFbl5SueVAFhgaA=;
        b=pAP4rH9JHZPCj5XDHLEF3a/6axFE8rFtMQLzuOCr15yngl6e+GflOCryWO4+p7otmn
         MBoDLUCtqIKKzPjaDWNBLU5oXjKkBXrOu5UCJjbr1xD1/G+1KwtNz64yuU7MD3HCCsUv
         wmiNjsokk0A/rZ0dP3lrU8g8/EjI2EjTMxIT5//rqcjLrDRaRXuRCBAxAzcnCuAkpVou
         FmZXQ/gDdhZd88X6tJX5N1xW0FgW5e/VWdFQnigdRGdrRi9bccqvzYGv7VexXg4INVVz
         AA76UEc7s/YO9eHKfSv2co75SJHKMH1l1mmFscwQUI6rGtPMYugVKOPORyiHX0ELS0yD
         vlgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kdqBTxwJ61ZHvf08XPUPelAlkHvuNFbl5SueVAFhgaA=;
        b=d/mkLCp/lw3dFc6WrY3BM0frusxkG0M4g+bjyM5sEI6wTxdhwpSbUEQC2ZQsb9LiJE
         dyW3Z7EJCxdIl+eVuCgRkQDZg5WYhWKtZ8xaiL6qk8x94i0JSHw5iQRpEbHtZg/J59OH
         gdUCjYaCPG5qZlthN1TmtwtYNu6fzSFX6bgZc56oT3iJpYXZaivN4HLZ50h2XSGjHK98
         g4F08vx0sYim0wgqiyaoQ3JF8r4se1uVEW8jy1Uz9WyKLPoKgdjKB+/E8fYBV5botSLH
         9XFtZdYlk0d6QspQFDSumPJxYig7T6pwT04dUCjgvJYEOL86DCE0YI/hvl2bJAwUbuIs
         Qsvg==
X-Gm-Message-State: AOAM533KX7eImFc7UHPj17RRUCB20DPdnuR/JgGDGI8IxI8GW4bwdXMm
        j1AdodxhkUbDCSii2hKpmro=
X-Google-Smtp-Source: ABdhPJxnBtK5YcG5QUoEc3159VEKlYpZyRqY8gMdC43MhHRLD5/JOTvV3wGta5HyNU7ecBGks4qoIA==
X-Received: by 2002:a17:906:7797:: with SMTP id s23mr481397ejm.84.1610443235046;
        Tue, 12 Jan 2021 01:20:35 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id rl7sm929187ejb.107.2021.01.12.01.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:20:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 7/7] libtracefs: Unit tests for enable / disable tracing APIs
Date:   Tue, 12 Jan 2021 11:20:24 +0200
Message-Id: <20210112092024.605705-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112092024.605705-1-tz.stoyanov@gmail.com>
References: <20210112092024.605705-1-tz.stoyanov@gmail.com>
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
 utest/tracefs-utest.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index bbe653c..0520f49 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -414,6 +414,44 @@ static void test_instance_file_fd(void)
 	close(fd);
 }
 
+static void test_tracing_onoff(void)
+{
+	long long res = -1;
+	int fd;
+
+	fd = tracefs_trace_on_get_fd(test_instance);
+	CU_TEST(fd >= 0);
+	CU_TEST(check_fd_name(fd, TRACE_ON));
+	CU_TEST(check_fd_mode(fd, O_RDWR));
+	CU_TEST(tracefs_instance_file_read_number(test_instance, TRACE_ON, &res) == 0);
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
@@ -721,4 +759,7 @@ void test_tracefs_lib(void)
 		    test_instances_walk);
 	CU_add_test(suite, "tracefs_get_clock API",
 		    test_get_clock);
+	CU_add_test(suite, "tracing on / off",
+		    test_tracing_onoff);
+
 }
-- 
2.29.2

