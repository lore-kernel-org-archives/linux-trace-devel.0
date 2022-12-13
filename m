Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE906C4167B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Dec 2022 17:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbiLMRC0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbiLMRBU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 12:01:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC3F24F10
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Dec 2022 08:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670950631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MEPpq5y0HbnJK7RSA2BlFjngIbfDjick2Z9K3NQ41KE=;
        b=Ly4OL1klTcSZ6nD3pbWSgFMWXmHtlYOdG1JTu0psS19zAUj34yImhEqmMhA/LjSkQEpx3n
        Pj4dtdbKX5QzKibMF5Cf2S4/G2gpc4z7QpeSD5XvK/ktuq033aIdx80ZQRVGE2jt6xN+VI
        pd3zx+1BBa92m7ZVD9Xe3UltI3aEhWQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-gPFwBuK9MUm6_qzCl42yKw-1; Tue, 13 Dec 2022 11:57:08 -0500
X-MC-Unique: gPFwBuK9MUm6_qzCl42yKw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F2C98038E7;
        Tue, 13 Dec 2022 16:57:08 +0000 (UTC)
Received: from vschneid.remote.csb (unknown [10.33.36.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 769B11121314;
        Tue, 13 Dec 2022 16:57:07 +0000 (UTC)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH v3 4/4] libtraceevent: Add unit tests for cpumask processing
Date:   Tue, 13 Dec 2022 16:56:20 +0000
Message-Id: <20221213165620.1034287-5-vschneid@redhat.com>
In-Reply-To: <20221213165620.1034287-1-vschneid@redhat.com>
References: <20221213165620.1034287-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add units tests that cover the TEP_PRINT_CPUMASK cases.

Sicne print_cpumask_to_seq() is based on a per-byte scan, add some tests
that cross byte boundaries when looking for the next non-zero byte.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 utest/traceevent-utest.c | 161 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 99900de..4fc09e5 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -100,6 +100,86 @@ static char dyn_str_old_data[] = {
 };
 static void *dyn_str_old_event_data = (void *)dyn_str_old_data;
 
+#define CPUMASK_EVENT_SYSTEM "ipi"
+#define CPUMASK_EVENT_FIELD  "cpumask"
+static const char cpumask_event_format[] =
+	"name: ipi_send_cpumask\n"
+	"ID: 3\n"
+	"format:\n"
+	"\tfield:unsigned short common_type;\toffset:0;\tsize:2;\n"
+	"\tfield:unsigned char common_flags;\toffset:2;\tsize:1;\n"
+	"\tfield:unsigned char common_preempt_count;\toffset:3;\tsize:1;\n"
+	"\tfield:int common_pid;\toffset:4;\tsize:4;\n"
+	"\n"
+	"\tfield:__data_loc cpumask_t *[] cpumask;\toffset:8;\tsize:4;\tsigned:0;\n"
+	"\n"
+	"print fmt: \"cpumask=%s\", __get_cpumask(cpumask)\n";
+
+/* Mind the endianness! */
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define DECL_CPUMASK_EVENT_DATA(name, args...)			\
+	static char cpumask_##name##_event_data[] = {		\
+	/* common type */		3, 0x00,                \
+	/* common flags */		0x00,                   \
+	/* common_preempt_count */	0x00,                   \
+	/* common_pid */		0x00, 0x00, 0x00, 0x00, \
+	/* [offset, size] */            16, 0x00, 8, 0x00,      \
+	/* padding */			0x00, 0x00, 0x00, 0x00, \
+	/* cpumask */                   args,                   \
+}
+#else
+#define DECL_CPUMASK_EVENT_DATA(name, args...)			\
+static char cpumask_##name##_event_data[] = {                       \
+	/* common type */		0x00, 3,                \
+	/* common flags */		0x00,                   \
+	/* common_preempt_count */	0x00,                   \
+	/* common_pid */		0x00, 0x00, 0x00, 0x00, \
+	/* [offset, size] */            0x00, 8, 0x00, 16,      \
+	/* padding */			0x00, 0x00, 0x00, 0x00, \
+	/* cpumask */                   args,                   \
+}
+#endif
+
+DECL_CPUMASK_EVENT_DATA(full, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff);
+#define CPUMASK_FULL     "ARRAY[ff, ff, ff, ff, ff, ff, ff, ff]"
+#define CPUMASK_FULL_FMT "cpumask=0-63"
+
+DECL_CPUMASK_EVENT_DATA(empty, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00);
+#define CPUMASK_EMPTY     "ARRAY[00, 00, 00, 00, 00, 00, 00, 00]"
+#define CPUMASK_EMPTY_FMT "cpumask="
+
+DECL_CPUMASK_EVENT_DATA(half, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55);
+#define CPUMASK_HALF     "ARRAY[55, 55, 55, 55, 55, 55, 55, 55]"
+#define CPUMASK_HALF_FMT "cpumask=0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62"
+
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+DECL_CPUMASK_EVENT_DATA(bytep1, 0x01, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00);
+#define CPUMASK_BYTEP1     "ARRAY[01, 80, 00, 00, 00, 00, 00, 00]"
+#define CPUMASK_BYTEP1_FMT "cpumask=0,15"
+
+DECL_CPUMASK_EVENT_DATA(bytep2, 0x01, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00);
+#define CPUMASK_BYTEP2     "ARRAY[01, 00, 80, 00, 00, 00, 00, 00]"
+#define CPUMASK_BYTEP2_FMT "cpumask=0,23"
+
+DECL_CPUMASK_EVENT_DATA(bytepn, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80);
+#define CPUMASK_BYTEPN     "ARRAY[01, 00, 00, 00, 00, 00, 00, 80]"
+#define CPUMASK_BYTEPN_FMT "cpumask=0,63"
+
+#else
+
+DECL_CPUMASK_EVENT_DATA(bytep1, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x01);
+#define CPUMASK_BYTEP1     "ARRAY[00, 00, 00, 00, 00, 00, 80, 01]"
+#define CPUMASK_BYTEP1_FMT "cpumask=0,15"
+
+DECL_CPUMASK_EVENT_DATA(bytep2, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x01);
+#define CPUMASK_BYTEP2     "ARRAY[00, 00, 00, 00, 00, 80, 00, 01]"
+#define CPUMASK_BYTEP2_FMT "cpumask=0,23"
+
+DECL_CPUMASK_EVENT_DATA(bytepn, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01);
+#define CPUMASK_BYTEPN     "ARRAY[80, 00, 00, 00, 00, 00, 80, 01]"
+#define CPUMASK_BYTEPN_FMT "cpumask=0,63"
+#endif
+
 static struct tep_handle *test_tep;
 static struct trace_seq *test_seq;
 static struct trace_seq seq_storage;
@@ -139,6 +219,75 @@ static void test_parse_dyn_str_old_event(void)
 	parse_dyn_str(dyn_str_old_event, dyn_str_old_event_data, sizeof(dyn_str_old_data));
 }
 
+static void parse_cpumask(const char *format, void *data, int size,
+			  const char* expected_raw, const char* expected)
+{
+	struct tep_format_field *field;
+	struct tep_event *event;
+	struct tep_record record;
+
+	record.data = data;
+	record.size = size;
+
+	CU_TEST(tep_parse_format(test_tep, &event,
+				 format, strlen(format),
+				 CPUMASK_EVENT_SYSTEM) == TEP_ERRNO__SUCCESS);
+
+	field = tep_find_any_field(event, CPUMASK_EVENT_FIELD);
+	CU_TEST(field != NULL);
+
+	trace_seq_reset(test_seq);
+	tep_print_field_content(test_seq, data, size, field);
+	CU_TEST(strcmp(test_seq->buffer, expected_raw) == 0);
+
+	trace_seq_reset(test_seq);
+	tep_print_event(test_tep, test_seq, &record, "%s", TEP_PRINT_INFO);
+	trace_seq_do_printf(test_seq);
+	CU_TEST(strcmp(test_seq->buffer, expected) == 0);
+}
+
+static void test_parse_cpumask_full(void)
+{
+	parse_cpumask(cpumask_event_format,
+		      cpumask_full_event_data, sizeof(cpumask_full_event_data),
+		      CPUMASK_FULL, CPUMASK_FULL_FMT);
+}
+
+static void test_parse_cpumask_empty(void)
+{
+	parse_cpumask(cpumask_event_format,
+		      cpumask_empty_event_data, sizeof(cpumask_empty_event_data),
+		      CPUMASK_EMPTY, CPUMASK_EMPTY_FMT);
+}
+
+static void test_parse_cpumask_half(void)
+{
+	parse_cpumask(cpumask_event_format,
+		      cpumask_half_event_data, sizeof(cpumask_half_event_data),
+		      CPUMASK_HALF, CPUMASK_HALF_FMT);
+}
+
+static void test_parse_cpumask_bytep1(void)
+{
+	parse_cpumask(cpumask_event_format,
+		      cpumask_bytep1_event_data, sizeof(cpumask_bytep1_event_data),
+		      CPUMASK_BYTEP1, CPUMASK_BYTEP1_FMT);
+}
+
+static void test_parse_cpumask_bytep2(void)
+{
+	parse_cpumask(cpumask_event_format,
+		      cpumask_bytep2_event_data, sizeof(cpumask_bytep2_event_data),
+		      CPUMASK_BYTEP2, CPUMASK_BYTEP2_FMT);
+}
+
+static void test_parse_cpumask_bytepn(void)
+{
+	parse_cpumask(cpumask_event_format,
+		      cpumask_bytepn_event_data, sizeof(cpumask_bytepn_event_data),
+		      CPUMASK_BYTEPN, CPUMASK_BYTEPN_FMT);
+}
+
 static int test_suite_destroy(void)
 {
 	tep_free(test_tep);
@@ -169,4 +318,16 @@ void test_traceevent_lib(void)
 		    test_parse_dyn_str_event);
 	CU_add_test(suite, "parse old dynamic string event",
 		    test_parse_dyn_str_old_event);
+	CU_add_test(suite, "parse full cpumask",
+		    test_parse_cpumask_full);
+	CU_add_test(suite, "parse empty cpumask",
+		    test_parse_cpumask_empty);
+	CU_add_test(suite, "parse half-filled cpumask",
+		    test_parse_cpumask_half);
+	CU_add_test(suite, "parse cpumask spanning 2 bytes",
+		    test_parse_cpumask_bytep1);
+	CU_add_test(suite, "parse cpumask spanning 3 bytes",
+		    test_parse_cpumask_bytep2);
+	CU_add_test(suite, "parse cpumask spanning all bytes",
+		    test_parse_cpumask_bytepn);
 }
-- 
2.31.1

