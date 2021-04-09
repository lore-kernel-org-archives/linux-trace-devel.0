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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D56C43461
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E9C261168
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhDIE2D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhDIE2C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 00:28:02 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B8AC061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 21:27:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hq27so6509326ejc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 21:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TwJngky2nhtIf4HO5lzK4L4z278ROJnnE6wZCsYNyls=;
        b=imJeSAagJzFQiJn9v5C3AkI7euMB+asYp45uW5xAdnTArO3DKvt/6PcIUhZDqsNDt4
         wD4ZWOppSe0AwcMbqOCRL3/Ubc3C3GFWJiS42RYGmE8tnHZDGfRUf6gahoNtO6mzZUWT
         VjJdMHnK/tALPfOsF8XbX+/ylN029LXYYdr4MzcMFOVqBESQGRVpNyIu5rGUE4s8y/NI
         xoMVWhp1ZpkNZwJv0w5t+Px0HTeTk6h9oiMevACfr8Qeos7OfR/xkyLYIt0T8FKoDYu+
         NPH+1ITp/WQzJW/uvv+NG3CxiAcdeBqHUrw4UmVF1LKpxDE6z51oXWlxd+zM+ewF3gQb
         fcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TwJngky2nhtIf4HO5lzK4L4z278ROJnnE6wZCsYNyls=;
        b=Va850CeaJ9qUAbtuVaI/Iy9Aq9GBlw//4P82Ffelf17cwj2m6hDDRxW4vPv9RVqAMJ
         uTXbZFYHf2q6Yxm3Xt38sLS+V+UqKxt6K3ot3ltpx+hDpFpwt+4cq92QvMCjGnwdTZBA
         saieLK02tDmucZdZJujs/Cvp61vDDHJ8H68GQTdA36vj/jxSyXp/j6pfenHP9An/UkfR
         Kr2BBhq6jDDAIWWSmI8kkm2n/WP8fwDKVt+Jwjs8ANekw/9m0ygoK0ig932eMOGkbYNx
         uOpTcW3NbVwFsjaE0qmR+Q7O7S3EC1grXTA1351wjaY/NTZ1oJJhpy2u/XN6Bzxyny5C
         GVQw==
X-Gm-Message-State: AOAM5319Ud3Rb4cBxANk0AnxGp0knh9Zv/aqjvGfL3756zOh/gTpO0As
        4fl6k0j5tScIJoxhiTr5bl0=
X-Google-Smtp-Source: ABdhPJyp6LF7NRZTB9MQTwbk/liYKKJKHI7aTs3CwNvweKCXQGkUsm9iEi7oUs/ONSVwTxOKvDIeew==
X-Received: by 2002:a17:906:cd0e:: with SMTP id oz14mr14596761ejb.60.1617942469416;
        Thu, 08 Apr 2021 21:27:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cf4sm701089edb.19.2021.04.08.21.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 21:27:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/2] libtracefs: Unit test for trace marker APIs
Date:   Fri,  9 Apr 2021 07:27:46 +0300
Message-Id: <20210409042746.3179319-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210409042746.3179319-1-tz.stoyanov@gmail.com>
References: <20210409042746.3179319-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added unit tests for thee APIs:
 tracefs_print_init();
 tracefs_printf();
 tracefs_vprintf();
 tracefs_print_close();
 tracefs_binary_init();
 tracefs_binary_write();
 tracefs_binary_close();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 116 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index f9441af..3f5c832 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -192,6 +192,120 @@ static const char *get_rand_str(void)
 	return str;
 }
 
+struct marker_find {
+	int data_offset;
+	int event_id;
+	int count;
+	int len;
+	void *data;
+};
+
+static int test_marker_callback(struct tep_event *event, struct tep_record *record,
+				int cpu, void *context)
+{
+	struct marker_find *walk = context;
+
+	if (!walk)
+		return -1;
+	if (event->id != walk->event_id)
+		return 0;
+	if (record->size < (walk->data_offset + walk->len))
+		return 0;
+
+	if (memcmp(walk->data, record->data + walk->data_offset, walk->len) == 0)
+		walk->count++;
+
+	return 0;
+}
+
+static bool find_test_marker(struct tracefs_instance *instance,
+			     void *data, int len, int expected, bool raw)
+{
+	struct tep_format_field *field;
+	struct tep_event *event;
+	struct marker_find walk;
+	int ret;
+
+	if (raw) {
+		event = tep_find_event_by_name(test_tep, "ftrace", "raw_data");
+		if (event)
+			field = tep_find_field(event, "id");
+
+	} else {
+		event = tep_find_event_by_name(test_tep, "ftrace", "print");
+		if (event)
+			field = tep_find_field(event, "buf");
+	}
+
+	if (!event || !field)
+		return false;
+
+	walk.data = data;
+	walk.len = len;
+	walk.count = 0;
+	walk.event_id = event->id;
+	walk.data_offset = field->offset;
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
+	ret = tracefs_vprintf(instance, fmt, ap);
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
+	CU_TEST(tracefs_print_init(instance) == 0);
+	tracefs_print_close(instance);
+
+	CU_TEST(tracefs_binary_init(instance) == 0);
+	tracefs_binary_close(instance);
+
+	for (i = 0; i < MARKERS_WRITE_COUNT; i++) {
+		CU_TEST(tracefs_binary_write(instance, &data, sizeof(data)) == 0);
+	}
+	CU_TEST(find_test_marker(instance, &data, sizeof(data), MARKERS_WRITE_COUNT, true));
+
+	for (i = 0; i < MARKERS_WRITE_COUNT; i++) {
+		CU_TEST(tracefs_printf(instance, "Test marker: %s 0x%X", string, data) == 0);
+	}
+	asprintf(&str, "Test marker: %s 0x%X", string, data);
+	CU_TEST(find_test_marker(instance, str, strlen(str) + 1, MARKERS_WRITE_COUNT, false));
+	free(str);
+
+	for (i = 0; i < MARKERS_WRITE_COUNT; i++) {
+		CU_TEST(marker_vprint(instance, "Test marker V: %s 0x%X", string, data) == 0);
+	}
+	asprintf(&str, "Test marker V: %s 0x%X", string, data);
+	CU_TEST(find_test_marker(instance, str, strlen(str) + 1, MARKERS_WRITE_COUNT, false));
+	free(str);
+
+	tracefs_print_close(instance);
+	tracefs_binary_close(instance);
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
@@ -1098,4 +1212,6 @@ void test_tracefs_lib(void)
 		    test_tracing_options);
 	CU_add_test(suite, "custom system directory",
 		    test_custom_trace_dir);
+	CU_add_test(suite, "ftrace marker",
+		    test_ftrace_marker);
 }
-- 
2.30.2

