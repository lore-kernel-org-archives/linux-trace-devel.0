Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7C3C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 23:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbiBVXXt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 18:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiBVXXs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 18:23:48 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 540BE95A22
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 15:23:21 -0800 (PST)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0DA6720C31BF;
        Tue, 22 Feb 2022 15:23:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0DA6720C31BF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645572201;
        bh=Ep13W27GmfCBsKfhFFQ+OZw8O1dh5rA21NaJlEf/98Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Utx1KFa1la377D6gZAuykGioCLRm3fm2m88wYOtxfApOwYenJpnr5QR+BsSInCa7Z
         vmU/0FLk12dqyUpgI1IkpuxZ2GN/VanFtQkR7K8mG/FG8LqsNXEzXFxPMpG1sLqob7
         1xyu+HPAs3SoQp15w+WxyYB3Wc0Hexbqcb1GnVa8=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH v2 3/3] libtracefs: Add unit tests for user_events
Date:   Tue, 22 Feb 2022 15:23:16 -0800
Message-Id: <20220222232316.14640-4-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220222232316.14640-1-beaub@linux.microsoft.com>
References: <20220222232316.14640-1-beaub@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adds unit tests for user_events when available. Ensures APIs are working
correctly and appropriate errors are being returned.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 utest/tracefs-utest.c | 233 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 233 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e8d5c69..ed38d9c 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -11,6 +11,7 @@
 #include <time.h>
 #include <dirent.h>
 #include <ftw.h>
+#include <linux/types.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
@@ -871,6 +872,235 @@ static void test_eprobes(void)
 	test_eprobes_instance(test_instance);
 }
 
+#ifdef USEREVENTS
+struct user_test_context {
+	int seen;
+	int failed;
+};
+static int user_callback(struct tep_event *event, struct tep_record *record,
+			  int cpu, void *context)
+{
+	struct tep_format_field *field;
+	struct user_test_context *user_context;
+	__u32 *rel, size, offset;
+
+	user_context = (struct user_test_context *)context;
+	user_context->seen++;
+
+	field = tep_find_field(event, "u8");
+	if (!field || *(__u8 *)(record->data + field->offset) != 1)
+	{
+		user_context->failed = 1;
+		return -1;
+	}
+
+	field = tep_find_field(event, "s8");
+	if (!field || *(__s8 *)(record->data + field->offset) != 2)
+	{
+		user_context->failed = 2;
+		return -1;
+	}
+
+	field = tep_find_field(event, "u16");
+	if (!field || *(__u16 *)(record->data + field->offset) != 3)
+	{
+		user_context->failed = 3;
+		return -1;
+	}
+
+	field = tep_find_field(event, "s16");
+	if (!field || *(__s16 *)(record->data + field->offset) != 4)
+	{
+		user_context->failed = 4;
+		return -1;
+	}
+
+	field = tep_find_field(event, "u32");
+	if (!field || *(__u32 *)(record->data + field->offset) != 5)
+	{
+		user_context->failed = 5;
+		return -1;
+	}
+
+	field = tep_find_field(event, "s32");
+	if (!field || *(__s32 *)(record->data + field->offset) != 6)
+	{
+		user_context->failed = 6;
+		return -1;
+	}
+
+	field = tep_find_field(event, "u64");
+	if (!field || *(__u64 *)(record->data + field->offset) != 7)
+	{
+		user_context->failed = 7;
+		return -1;
+	}
+
+	field = tep_find_field(event, "s64");
+	if (!field || *(__s64 *)(record->data + field->offset) != 8)
+	{
+		user_context->failed = 8;
+		return -1;
+	}
+
+	field = tep_find_field(event, "string");
+	if (!field || memcmp(record->data + field->offset, "12345678", 8))
+	{
+		user_context->failed = 9;
+		return -1;
+	}
+
+	field = tep_find_field(event, "struct");
+	if (!field || *(__u64 *)(record->data + field->offset) != 9)
+	{
+		user_context->failed = 10;
+		return -1;
+	}
+
+	field = tep_find_field(event, "varray");
+	if (!field) {
+		user_context->failed = 11;
+		return -1;
+	}
+
+	rel = (__u32 *)(record->data + field->offset);
+	offset = *rel & 0xffff;
+	size = *rel >> 16;
+	rel++;
+
+	if (memcmp((void *)(rel) + offset, "Array", size)) {
+		user_context->failed = 12;
+		return -1;
+	}
+
+	field = tep_find_field(event, "vstring");
+	if (!field) {
+		user_context->failed = 13;
+		return -1;
+	}
+
+	rel = (__u32 *)(record->data + field->offset);
+	offset = *rel & 0xffff;
+	size = *rel >> 16;
+	rel++;
+
+	if (memcmp((void *)(rel) + offset, "Variable", size)) {
+		user_context->failed = 14;
+		return -1;
+	}
+
+	return 0;
+}
+
+static void test_userevents_instance(struct tracefs_instance *instance)
+{
+	struct tracefs_user_event_group *group;
+	struct tracefs_user_event *event;
+	struct tep_handle *user_tep;
+	enum tracefs_uevent_flags flags = TRACEFS_UEVENT_FLAG_NONE;
+	const char *systems[] = { "user_events", NULL };
+	const char *name = "libtracefs_utest";
+	const char *system = "user_events";
+	const char *test_string = "12345678";
+	const char *test_array = "Array";
+	const char *test_vstring = "Variable";
+	__u8 a = 1;
+	__s8 b = 2;
+	__u16 c = 3;
+	__s16 d = 4;
+	__u32 e = 5;
+	__s32 f = 6;
+	__u64 g = 7;
+	__s64 h = 8;
+	__u64 i = 9;
+	struct tracefs_uevent_item all_items[] = {
+		{ TRACEFS_UEVENT_u8, .name = "u8" },
+		{ TRACEFS_UEVENT_s8, .name = "s8" },
+		{ TRACEFS_UEVENT_u16, .name = "u16" },
+		{ TRACEFS_UEVENT_s16, .name = "s16" },
+		{ TRACEFS_UEVENT_u32, .name = "u32" },
+		{ TRACEFS_UEVENT_s32, .name = "s32" },
+		{ TRACEFS_UEVENT_u64, .name = "u64" },
+		{ TRACEFS_UEVENT_s64, .name = "s64" },
+		{ TRACEFS_UEVENT_string, .name = "string", .len = 8 },
+		{ TRACEFS_UEVENT_struct, .name = "test struct", .len = 8 },
+		{ TRACEFS_UEVENT_varray, .name = "varray" },
+		{ TRACEFS_UEVENT_vstring, .name = "vstring" },
+		{ TRACEFS_UEVENT_END },
+	};
+	struct tracefs_uevent_item write_items[] = {
+		{ TRACEFS_UEVENT_u8, .data = &a, .len = sizeof(a) },
+		{ TRACEFS_UEVENT_s8, .data = &b, .len = sizeof(b) },
+		{ TRACEFS_UEVENT_u16, .data = &c, .len = sizeof(c) },
+		{ TRACEFS_UEVENT_s16, .data = &d, .len = sizeof(d) },
+		{ TRACEFS_UEVENT_u32, .data = &e, .len = sizeof(e) },
+		{ TRACEFS_UEVENT_s32, .data = &f, .len = sizeof(f) },
+		{ TRACEFS_UEVENT_u64, .data = &g, .len = sizeof(g) },
+		{ TRACEFS_UEVENT_s64, .data = &h, .len = sizeof(h) },
+		{ TRACEFS_UEVENT_string, .data = test_string,
+					 .len = strlen(test_string) },
+		{ TRACEFS_UEVENT_struct, .data = &i, .len = sizeof(i) },
+		{ TRACEFS_UEVENT_varray, .data = test_array,
+					 .len = strlen(test_array) },
+		{ TRACEFS_UEVENT_vstring, .data = test_vstring,
+					  .len = strlen(test_vstring)+1 },
+		{ TRACEFS_UEVENT_END },
+	};
+	struct user_test_context context;
+	int ret;
+
+	/* Delete if it already exists */
+	tracefs_user_event_delete(name);
+
+	group = tracefs_user_event_group_open();
+	CU_TEST(group != NULL);
+
+	event = tracefs_user_event_register(group, name, flags, all_items);
+	CU_TEST(event != NULL);
+
+	/* Test enable and status */
+	CU_TEST(!tracefs_user_event_enabled(event));
+	CU_TEST(tracefs_event_enable(instance, system, name) == 0);
+	CU_TEST(tracefs_user_event_enabled(event));
+
+	/* Correct record should work */
+	CU_TEST(tracefs_user_event_record(event, write_items) > 0);
+
+	/* Ensure record output was correct */
+	user_tep = tracefs_local_events_system(NULL, systems);
+	CU_TEST(user_tep != NULL);
+
+	memset(&context, 0, sizeof(context));
+	ret = tracefs_iterate_raw_events(user_tep, instance, NULL, 0,
+					 user_callback, &context);
+	tep_free(user_tep);
+
+	CU_TEST(ret == 0);
+	CU_TEST(context.seen == 1);
+	CU_TEST(context.failed == 0);
+
+	/* Simulate bad length */
+	write_items[0].len = 0;
+	CU_TEST(tracefs_user_event_record(event, write_items) == -1);
+
+	/* Simulate bad pointer */
+	write_items[0].len = sizeof(a);
+	write_items[0].data = NULL;
+	CU_TEST(tracefs_user_event_record(event, write_items) == -1);
+
+	tracefs_user_event_group_close(group);
+
+	/* Disable and deletion must work */
+	CU_TEST(tracefs_event_disable(instance, system, name) == 0);
+	CU_TEST(tracefs_user_event_delete(name) == 0);
+}
+
+static void test_userevents(void)
+{
+	test_userevents_instance(test_instance);
+}
+#endif
+
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
@@ -1706,4 +1936,7 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "kprobes", test_kprobes);
 	CU_add_test(suite, "syntetic events", test_synthetic);
 	CU_add_test(suite, "eprobes", test_eprobes);
+#ifdef USEREVENTS
+	CU_add_test(suite, "user events", test_userevents);
+#endif
 }
-- 
2.17.1

