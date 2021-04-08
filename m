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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42276C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0147161158
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhDHIJh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhDHIJf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 04:09:35 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF5AC061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 01:09:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ba6so1312219edb.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 01:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQrDQN7kmV67xwEwt3vQLQeJolNFaTP7G45WonP7lG4=;
        b=OIY5c1oZvLsPCOvrThmGKzCCsauzwisTPKiqziTE5wVjKM1CrlzrVDnewpWxfTYIw+
         e3LrvH2JcvA/qzcKbVq8R5bwqAfPBh2gWOvXCotXS91t0zKaAfZVBNev7jIGVLfKw9e6
         S/hU2pzcIMDmk7YhL2bP+BCcZI3x24UobLf4PpKJfIvkpRflUDPgn0NJF4MoNr20iB+T
         N5lWyr91z2j4+FeHiMJzErzgCbvy4/VG1+VHFg898ekISvlTKlEy8TefJXKfx4zI46n9
         1Ubz6FAHZ03iSMS54FDpeYEpqN0gL4o3rV8NQMri3Ncqvtt0AZ8PEd6u0Wy43q1FhGKQ
         rvBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQrDQN7kmV67xwEwt3vQLQeJolNFaTP7G45WonP7lG4=;
        b=rRmyA8eWsSKOB/jagaGYC6egJFs3zOxERrT4lkqOGYwzpis7NQ9nwMA0pSNBBapB4W
         BHMfKlIDT2ISxeU1eNBgXwKqg5C4/ThBpXeRZ3epfIL1R8wi25o/MLb/jkbH5Ql/dug5
         xWG2PY1iCrxJ1zoAkKS/axhUFvekSNLvglsvUEvmAa3ZJBagp9Ut+pNnOC17RAdK9wcD
         95RM/iC5/4gntPDoJk3r2IrGn+ZjHNz+Zk7ul9j+wGq9yZBOiK+C3OvGl9B+NVPgbxeU
         BsniKZAIVNyQbkVmrUtHC53cEwHuHXX8mQjvLdxHWBYJnWBIO7m7zWzdo3uR++e9xH+v
         upVA==
X-Gm-Message-State: AOAM530mGb6TQd5PSUBtT4qfR8lJXiYkzjBUAhs6vXDqr/g3Cm/qafT4
        PsosGPqbHV+/j9ShAL+PDRQ=
X-Google-Smtp-Source: ABdhPJw+y4BI6mdohibuPN0IS4WKzK4mFhH9iRth+Myys62K6LLTgQSz5nQ/WWPSWTS5HQvJOKCtQQ==
X-Received: by 2002:aa7:d541:: with SMTP id u1mr9599702edr.95.1617869363164;
        Thu, 08 Apr 2021 01:09:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x1sm14009444eji.8.2021.04.08.01.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 01:09:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracefs: Unit test for trace marker APIs
Date:   Thu,  8 Apr 2021 11:09:20 +0300
Message-Id: <20210408080920.3130041-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210408080920.3130041-1-tz.stoyanov@gmail.com>
References: <20210408080920.3130041-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added unit tests for these APIs:
 tracefs_marker_init()
 tracefs_marker_print()
 tracefs_marker_vprint()
 tracefs_marker_write()
 tracefs_marker_close()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 91 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index ed2693b..bad4348 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -169,6 +169,95 @@ static const char *get_rand_str(void)
 	return str;
 }
 
+struct marker_find {
+	int len;
+	int count;
+	void *data;
+};
+
+static int test_marker_callback(struct tep_event *event, struct tep_record *record,
+				int cpu, void *context)
+{
+	struct marker_find *walk = context;
+	struct tep_format_field *field;
+
+	if (!walk)
+		return -1;
+	if (record->size < walk->len)
+		return 0;
+
+	field = tep_find_field(event, "buf");
+	if (field && memcmp(walk->data, record->data + field->offset, walk->len) == 0)
+		walk->count++;
+
+	return 0;
+}
+
+static bool find_test_marker(struct tracefs_instance *instance, void *data, int len, int expected)
+{
+	int ret;
+	struct marker_find walk;
+
+	walk.data = data;
+	walk.len = len;
+	walk.count = 0;
+	ret = tracefs_iterate_raw_events(test_tep, instance, NULL, 0,
+					 test_marker_callback, &walk);
+	CU_TEST(ret == 0);
+
+	return walk.count == expected;
+}
+
+static int marker_vprint(struct tracefs_instance *instance, char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = tracefs_marker_vprint(instance, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+
+#define MARKERS_WRITE_COUNT	100
+static void test_instance_ftrace_marker(struct tracefs_instance *instance)
+{
+	const char *string = get_rand_str();
+	unsigned int data = 0xdeadbeef;
+	char *str;
+	int i;
+
+	CU_TEST(tracefs_marker_init(instance) == 0);
+	tracefs_marker_close(instance);
+
+	for (i = 0; i < MARKERS_WRITE_COUNT; i++) {
+		CU_TEST(tracefs_marker_write(instance, &data, sizeof(data)) == 0);
+	}
+	CU_TEST(find_test_marker(instance, &data, sizeof(data), MARKERS_WRITE_COUNT));
+
+	for (i = 0; i < MARKERS_WRITE_COUNT; i++) {
+		CU_TEST(tracefs_marker_print(instance, "Test marker: %s 0x%X", string, data) == 0);
+	}
+	asprintf(&str, "Test marker: %s 0x%X", string, data);
+	CU_TEST(find_test_marker(instance, str, strlen(str) + 1, MARKERS_WRITE_COUNT));
+	free(str);
+
+	for (i = 0; i < MARKERS_WRITE_COUNT; i++) {
+		CU_TEST(marker_vprint(instance, "Test marker V: %s 0x%X", string, data) == 0);
+	}
+	asprintf(&str, "Test marker V: %s 0x%X", string, data);
+	CU_TEST(find_test_marker(instance, str, strlen(str) + 1, MARKERS_WRITE_COUNT));
+	free(str);
+
+	tracefs_marker_close(instance);
+}
+
+static void test_ftrace_marker(void)
+{
+	test_instance_ftrace_marker(test_instance);
+}
+
 static void test_trace_file(void)
 {
 	const char *tmp = get_rand_str();
@@ -1075,4 +1164,6 @@ void test_tracefs_lib(void)
 		    test_tracing_options);
 	CU_add_test(suite, "custom system directory",
 		    test_custom_trace_dir);
+	CU_add_test(suite, "ftrace marker",
+		    test_ftrace_marker);
 }
-- 
2.30.2

