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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745C3C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B2C23A01
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbhAOFE5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAOFE4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 00:04:56 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17391C0613D3
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:16 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id t16so11488062ejf.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Lgv+YxSWw/Gv/GThtlJ0i/9eYQrkKOLA9pAKrnq3MI=;
        b=EVdvQ3VED611fl8iDxH8m/e2OBo7pntgY/e4MWat3mmcaGXcRTjQ/d5C6qKd2kxUoM
         PS0GsxRgeDZI0K47KOICXAROz9j76AIvteP5eDvtoRa8/hIVXhOpLPK7ozhVMz4aNJFu
         QACKlQtTopYgCXJI6DM/peaB3scbd/rmtNYbJf3h1j57Gld8QtwQNKLOo4bdARQfvhw4
         bZcrhUCtRj37YRY9194hWEzLBWCu1PuoKM7BNnRdXgIhq8XQlH1ufrEAp8ZMROXePxOs
         OL0vLRT8yLgatWogxvRzcGVMkMYrPcdWnmf5rq+J6KDfY3TLMcQdDSsUkP88WIYSkxmx
         +Omw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Lgv+YxSWw/Gv/GThtlJ0i/9eYQrkKOLA9pAKrnq3MI=;
        b=m+Ux2RTwvxMtoVMwUaR3ml5JsH6Q/iUR2GMfUnfVz5pGI8hhWAxCGXQkuVUiqxy0PI
         HKu7cq1iNV2a6W3Olmkf17pEa9HB48/wq9shkGUjxwrdIaZgnSeSYYlKuMWBXf0ZggXc
         sIVnrObtdE05HSW9sKmlOFMRZ2EIFuEYZ0rQHsDt3Lh5UX9gk99TM9VyxFRK/dNI2+9e
         Xbt1hNtmyQgi7DkjF51T1cLafQ5GaR0p90q40P3PSwz1e5lNzx74wURoW/7QZ7NKA07U
         1a90pYG/WwrYPglGOU6HGjYlHjn+UQwf7umECh3Vu66udS8zT5XnVP3uvgKTWOoL6XZr
         cJzg==
X-Gm-Message-State: AOAM531x9VOsWwtBTn3bZEeljiMjJ4vTzeJx7F4tbhMKaTV1lyPz9hBP
        nARF96/V9M1uvSuCjZztrzpK3ekd9Qsv+15T
X-Google-Smtp-Source: ABdhPJzco0ab5bcC0DzRxtzpSUTGavzDD0otFcVKUzjUiS5UyxBEtqQYu3vK0jCvhnom7RSVSUvheA==
X-Received: by 2002:a17:906:b244:: with SMTP id ce4mr2303064ejb.159.1610687054797;
        Thu, 14 Jan 2021 21:04:14 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d4sm3055670edq.36.2021.01.14.21.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 21:04:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/5] libtracefs: Unit tests for tracing options APIs
Date:   Fri, 15 Jan 2021 07:04:07 +0200
Message-Id: <20210115050410.1194011-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
References: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unit tests for these new APIs:

tracefs_options_get_supported();
tracefs_option_is_supported();
tracefs_options_get_enabled();
tracefs_option_is_enabled();
tracefs_options_set();
tracefs_options_clear();
tracefs_option_string();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 125 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 0520f49..1ade5dd 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -452,6 +452,129 @@ static void test_tracing_onoff(void)
 		close(fd);
 }
 
+static bool check_option(long long id, bool exist, int enabled)
+{
+	const char *name = tracefs_option_string(id);
+	char file[PATH_MAX];
+	char *path = NULL;
+	bool ret = false;
+	bool supported;
+	struct stat st;
+	char buf[10];
+	int fd;
+	int r;
+	int rstat;
+
+	CU_TEST(name != NULL);
+	supported = tracefs_option_is_supported(test_instance, id);
+	CU_TEST(supported == exist);
+	if (supported != exist)
+		goto out;
+	snprintf(file, PATH_MAX, "options/%s", name);
+	path = tracefs_instance_get_file(test_instance, file);
+	CU_TEST(path != NULL);
+	rstat = stat(path, &st);
+	if (exist) {
+		CU_TEST(rstat == 0);
+		if (rstat != 0)
+			goto out;
+	} else {
+		CU_TEST(stat(path, &st) == -1);
+		if (rstat != -1)
+			goto out;
+	}
+
+	fd = open(path, O_RDONLY);
+	if (exist) {
+		CU_TEST(fd >= 0);
+		if (fd < 0)
+			goto out;
+	} else {
+		CU_TEST(fd < 0);
+		if (fd >= 0)
+			goto out;
+	}
+
+	if (exist && enabled >= 0) {
+		int val = enabled ? '1' : '0';
+
+		r = read(fd, buf, 10);
+		CU_TEST(r == 2);
+		CU_TEST(buf[0] == val);
+		if (buf[0] != val)
+			goto out;
+	}
+
+	ret = true;
+out:
+	tracefs_put_tracing_file(path);
+	if (fd >= 0)
+		close(fd);
+	return ret;
+}
+
+static void test_tracing_options(void)
+{
+	unsigned long long options_enabled = 0;
+	unsigned long long options_all = 0;
+	unsigned long long i = 1;
+	char file[PATH_MAX];
+	const char *name;
+
+	options_all = tracefs_options_get_supported(test_instance);
+	options_enabled = tracefs_options_get_enabled(test_instance);
+	CU_TEST(options_all > 0);
+
+	/* Invalid parameters test */
+	CU_TEST(!tracefs_option_is_supported(test_instance, TRACEFS_OPTION_INVALID << 1));
+	CU_TEST(!tracefs_option_is_enabled(test_instance, TRACEFS_OPTION_INVALID << 1));
+	CU_TEST(tracefs_options_set(test_instance, TRACEFS_OPTION_INVALID << 1) == -1);
+	CU_TEST(tracefs_options_clear(test_instance, TRACEFS_OPTION_INVALID << 1) == -1);
+	name = tracefs_option_string(TRACEFS_OPTION_INVALID << 1);
+	CU_TEST(!strcmp(name, "unknown"));
+
+	/* Test all valid options */
+	do {
+		name = tracefs_option_string(i);
+		CU_TEST(name != NULL);
+		CU_TEST(strcmp(name, "unknown"));
+		snprintf(file, PATH_MAX, "options/%s", name);
+
+		if (options_all & i) {
+			options_all &= ~i;
+			CU_TEST(check_option(i, true, -1));
+			CU_TEST(tracefs_option_is_supported(test_instance, i));
+		} else {
+			CU_TEST(check_option(i, false, -1));
+			CU_TEST(!tracefs_option_is_supported(test_instance, i));
+		}
+
+		if (options_enabled & i) {
+			options_enabled &= ~i;
+			CU_TEST(check_option(i, true, 1));
+			CU_TEST(tracefs_option_is_supported(test_instance, i));
+			CU_TEST(tracefs_option_is_enabled(test_instance, i));
+			CU_TEST(tracefs_options_clear(test_instance, i) == 0);
+			CU_TEST(check_option(i, true, 0));
+			CU_TEST(tracefs_options_set(test_instance, i) == 0);
+			CU_TEST(check_option(i, true, 1));
+		} else if (options_all & i) {
+			CU_TEST(check_option(i, true, 0));
+			CU_TEST(tracefs_option_is_supported(test_instance, i));
+			CU_TEST(!tracefs_option_is_enabled(test_instance, i));
+			CU_TEST(tracefs_options_set(test_instance, i) == 0);
+			CU_TEST(check_option(i, true, 1));
+			CU_TEST(tracefs_options_clear(test_instance, i) == 0);
+			CU_TEST(check_option(i, true, 0));
+		}
+		i <<= 1;
+	} while (i < TRACEFS_OPTION_INVALID);
+
+	CU_TEST(options_all == 0);
+	CU_TEST(options_enabled == 0);
+
+}
+
 static void exclude_string(char **strings, char *name)
 {
 	int i;
@@ -761,5 +884,7 @@ void test_tracefs_lib(void)
 		    test_get_clock);
 	CU_add_test(suite, "tracing on / off",
 		    test_tracing_onoff);
+	CU_add_test(suite, "tracing options",
+		    test_tracing_options);
 
 }
-- 
2.29.2

