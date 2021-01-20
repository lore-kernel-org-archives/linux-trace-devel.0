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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CFBC4332B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0E4B23382
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733040AbhATPX2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Jan 2021 10:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390605AbhATPNm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jan 2021 10:13:42 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F381C0613C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 07:13:02 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m2so3166194wmm.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 07:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A1gyWrenc4pNhGdwD3VJR4Hq/8LXJD6FgkNTiiS2dFs=;
        b=Jh3yFAsKhd7j8yZFWOxLrUsTSK4XM6SvYK3hP39FFfgxHR1gbC66GyxGEbR/kI0lMX
         9dEDHYnG2GuOUWy1Bhe0AoEui4mDJd6/L3/003sVtfGd2MvEaYpr+f+13m7s1IDeNw7n
         Fy9GwHVZE2koadSIuYxD8Cqz7ng8Npz40ozEyL+pw83mSfOZJeS7MnfkeJlEnqrPZkkU
         7Ymo3J2oXfUlAlY9ZX6yNqrZiYkwfwiPTTVUjK977Jb7BVrVIbzhlqhMwAtnrvXt7XPL
         FjfDKaYsWD0e3pGtINvJJ5/gLeW1GcNr0Q5k81qsGcR1HUFRshTD71j83hvG9GavZgaK
         juow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A1gyWrenc4pNhGdwD3VJR4Hq/8LXJD6FgkNTiiS2dFs=;
        b=mhYswPy60Jq0NPsNLeiauMzGkS3yr+S/e2sxWY1JjCoWhXrtJqumkDfJP04DD2cpog
         TOyUkoaoN3vZQilunxoQWGyMoe/XnAMw2+MelM8VW9GgslB2tTJ9mgYix6Zw22FSIL08
         vtu+U/P6rH82YaLKkBFBnyEndKXcqBIkmD7PcMWZvgoGtF/XzPMnOXmP//WK3WUgWSYN
         g1zmiLib3Mw34JtxySi0/TemaTQoitrCUwW9sBvT/i24la3WupU4TIA0IKTUuwqzilIQ
         Ikw0v8rPwlPmqF7uToCrkPElCAL9rMWOyVoN17k1z5qtwHTPaVmTLzZdswv1RBmz1kGY
         9UsA==
X-Gm-Message-State: AOAM530SvLhPcKxroeLsw83GDa4EHiIRBLZdf/MhTVqR+/MVOo8GQnLn
        Jogfb4WcisGwmXY2wVwEljGyb+gRqujl9u3u
X-Google-Smtp-Source: ABdhPJxwSTCMEmBffWBCbPuReTXBNXZu3ub9Nlkk7HPOdIjgmtiRhN74sr5/0ZvwNCreJZq1w7E51A==
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr4751403wmc.40.1611155580857;
        Wed, 20 Jan 2021 07:13:00 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c11sm4571106wmd.36.2021.01.20.07.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 07:13:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/5] libtracefs: Unit tests for tracing options APIs
Date:   Wed, 20 Jan 2021 17:12:53 +0200
Message-Id: <20210120151256.43075-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120151256.43075-1-tz.stoyanov@gmail.com>
References: <20210120151256.43075-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unit tests for these new APIs:

tracefs_option_set();
tracefs_option_clear();
tracefs_option_is_set();
tracefs_options_get_supported();
tracefs_option_is_supported();
tracefs_options_get_enabled();
tracefs_option_is_enabled();
tracefs_option_enable();
tracefs_option_diasble();
tracefs_option_name();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 144 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 0520f49..1f3c042 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -452,6 +452,148 @@ static void test_tracing_onoff(void)
 		close(fd);
 }
 
+static bool check_option(struct tracefs_instance *instance,
+			 enum tracefs_option_id id, bool exist, int enabled)
+{
+	const char *name = tracefs_option_name(id);
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
+	supported = tracefs_option_is_supported(instance, id);
+	CU_TEST(supported == exist);
+	if (supported != exist)
+		goto out;
+	snprintf(file, PATH_MAX, "options/%s", name);
+	path = tracefs_instance_get_file(instance, file);
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
+		CU_TEST(r >= 1);
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
+static bool check_options_mask_empty(struct tracefs_options_mask *mask)
+{
+	int i;
+
+	for (i = 1; i < TRACEFS_OPTION_MAX; i++) {
+		if (tracefs_option_is_set(*mask, i))
+			return false;
+	}
+	return true;
+}
+
+static void test_instance_tracing_options(struct tracefs_instance *instance)
+{
+	struct tracefs_options_mask *enabled;
+	struct tracefs_options_mask *all, *all_copy;
+	enum tracefs_option_id i = 1;
+	char file[PATH_MAX];
+	const char *name;
+
+	all = tracefs_options_get_supported(instance);
+	all_copy = tracefs_options_get_supported(instance);
+	enabled = tracefs_options_get_enabled(instance);
+	CU_TEST(all != NULL);
+
+	/* Invalid parameters test */
+	CU_TEST(!tracefs_option_is_supported(instance, TRACEFS_OPTION_INVALID));
+	CU_TEST(!tracefs_option_is_enabled(instance, TRACEFS_OPTION_INVALID));
+	CU_TEST(tracefs_option_enable(instance, TRACEFS_OPTION_INVALID) == -1);
+	CU_TEST(tracefs_option_diasble(instance, TRACEFS_OPTION_INVALID) == -1);
+	name = tracefs_option_name(TRACEFS_OPTION_INVALID);
+	CU_TEST(!strcmp(name, "unknown"));
+	/* Test all valid options */
+	for (i = 1; i < TRACEFS_OPTION_MAX; i++) {
+		name = tracefs_option_name(i);
+		CU_TEST(name != NULL);
+		CU_TEST(strcmp(name, "unknown"));
+		snprintf(file, PATH_MAX, "options/%s", name);
+
+		if (tracefs_option_is_set(*all, i)) {
+			tracefs_option_clear(all, i);
+			CU_TEST(!tracefs_option_is_set(*all, i));
+			CU_TEST(check_option(instance, i, true, -1));
+			CU_TEST(tracefs_option_is_supported(instance, i));
+		} else {
+			CU_TEST(check_option(instance, i, false, -1));
+			CU_TEST(!tracefs_option_is_supported(instance, i));
+		}
+
+		if (tracefs_option_is_set(*enabled, i)) {
+			tracefs_option_clear(enabled, i);
+			CU_TEST(!tracefs_option_is_set(*enabled, i));
+			CU_TEST(check_option(instance, i, true, 1));
+			CU_TEST(tracefs_option_is_supported(instance, i));
+			CU_TEST(tracefs_option_is_enabled(instance, i));
+			CU_TEST(tracefs_option_diasble(instance, i) == 0);
+			CU_TEST(check_option(instance, i, true, 0));
+			CU_TEST(tracefs_option_enable(instance, i) == 0);
+			CU_TEST(check_option(instance, i, true, 1));
+		} else if (tracefs_option_is_set(*all_copy, i)) {
+			CU_TEST(check_option(instance, i, true, 0));
+			CU_TEST(tracefs_option_is_supported(instance, i));
+			CU_TEST(!tracefs_option_is_enabled(instance, i));
+			CU_TEST(tracefs_option_enable(instance, i) == 0);
+			CU_TEST(check_option(instance, i, true, 1));
+			CU_TEST(tracefs_option_diasble(instance, i) == 0);
+			CU_TEST(check_option(instance, i, true, 0));
+		}
+	}
+	CU_TEST(check_options_mask_empty(all));
+	CU_TEST(check_options_mask_empty(enabled));
+
+	free(all);
+	free(enabled);
+}
+
+static void test_tracing_options(void)
+{
+	test_instance_tracing_options(test_instance);
+}
+
 static void exclude_string(char **strings, char *name)
 {
 	int i;
@@ -761,5 +903,7 @@ void test_tracefs_lib(void)
 		    test_get_clock);
 	CU_add_test(suite, "tracing on / off",
 		    test_tracing_onoff);
+	CU_add_test(suite, "tracing options",
+		    test_tracing_options);
 
 }
-- 
2.29.2

