Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BD32F1FC9
	for <linux-trace-devel@vger.kernel.org>; Sun,  5 Apr 2026 22:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775427054; cv=none; b=DE6zTgo7yYiOkZfe+/Es0csxKxdpajoElHr9lRaDI/LJk60Ejgu2exE3rS4mWkTLn1EdYCXbmPqOYQyIIbA2FPtTmaclqnBi0LPUN+wiV2TiU5ZQ6BwYlWss60NNkXAYqj817LoHq23c7MP0OYaH7O4xlgWRCmj4RlaxALiPDyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775427054; c=relaxed/simple;
	bh=bm/L/2jGgYH3d6LbBkqb7N4D5vY29x7W2pBfQo8Vm68=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gvJSxBk+dXcQOjR3tydeg/zEAnWwTd0gIWnUhLeUCToy5YxQjsdiClwbtR+V7+1t2cFqEZcGp5hiIzv8Y/AgaliZIy03npIoPAazFFSx91wvayRxqxNGZO8okpLTDoZFEuOb3Wkidtr/vsw2NUjjgXiiT3l560RKo/6f6ezwpuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=l8x5c5Vl; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="l8x5c5Vl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=p9
	YVfN4YnmukZLnfi9qKxpkGVq6ZQsxyepKaqMAKGeU=; b=l8x5c5VlKPZo5cli8L
	oFmAO52loFLjh4cO3teSiSaQpGLGeRudwewAPMBpAp+Uep9hp9XsAN9FYDIZMqbx
	Z8DC29DdwdCgqRGhayhnF0kCl+wl/DihYBXpJGGKTlQJrdM/sEMIlGkChlneGMGM
	92/vVV66nTcLvjY+2O00yMwVE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3nxre3dJp0U3oDQ--.35031S2;
	Mon, 06 Apr 2026 06:10:40 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	tz.stoyanov@gmail.com,
	create0818@163.com
Subject: [PATCH] libtraceevent: parse %pB and %pa address specifiers
Date: Mon,  6 Apr 2026 06:10:33 +0800
Message-Id: <20260405221033.7036-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3nxre3dJp0U3oDQ--.35031S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GFWUuFWDZFWfAFWkZFykuFg_yoWfGFWxpF
	y3Ar15Kr4UtF42gw43AFZ5Zr15tr1kJ3yDtFZ7Ca4FyFyDJFykXayFkFy0qF1Ykw10qF9I
	yws0qFW5GFs7ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JU5wIfUUUUU=
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbCvwG+92nS3eG1ygAA3P

tep_parse_format() currently rejects events whose print fmt uses
%pB, %pap or %pad. The pointer format parser does not recognise
those suffixes, so libtraceevent fails before trace-cmd can report
the event at all.

Teach the pointer-format parser to accept %pB and %pa[p]/%pad,
print %pB with backtrace-style symbol lookup, and format %pa[p]/%pad
values from the referenced event fields.

Add unit tests that cover %pB, %pap and %pad.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217337
Signed-off-by: CaoRuichuang <create0818@163.com>
---
 src/event-parse.c        |  90 ++++++++++++++++++++++++++++++++
 utest/traceevent-utest.c | 108 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 198 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index fee0f91..4bd5c1b 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6631,6 +6631,78 @@ static int print_function(struct trace_seq *s, const char *format,
 	return 0;
 }
 
+static int print_function_backtrace(struct trace_seq *s,
+				    void *data, int size,
+				    struct tep_event *event,
+				    struct tep_print_arg *arg, bool raw)
+{
+	struct func_map *func = NULL;
+	unsigned long long lookup;
+	unsigned long long val;
+
+	val = eval_num_arg(data, size, event, arg);
+	lookup = val ? val - 1 : 0;
+	func = val ? find_func(event->tep, lookup) : NULL;
+
+	if (func) {
+		trace_seq_puts(s, func->func);
+		trace_seq_printf(s, "+0x%llx", lookup - func->addr);
+	}
+
+	if (!func || raw) {
+		if (raw)
+			trace_seq_puts(s, " (");
+		if (event->tep->long_size == 4)
+			trace_seq_printf(s, "0x%lx", (long)val);
+		else
+			trace_seq_printf(s, "0x%llx", (long long)val);
+		if (raw)
+			trace_seq_puts(s, ")");
+	}
+
+	return 0;
+}
+
+static int print_addr_ref_arg(struct trace_seq *s, const char *format,
+			      void *data, int size,
+			      struct tep_event *event,
+			      struct tep_print_arg *arg)
+{
+	struct tep_format_field *field;
+	struct tep_handle *tep = event->tep;
+	unsigned long long val;
+	int width;
+	int ret = 0;
+
+	while (arg->type == TEP_PRINT_TYPE)
+		arg = arg->typecast.item;
+
+	if (arg->type != TEP_PRINT_FIELD) {
+		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
+		return ret;
+	}
+
+	field = arg->field.field;
+	if (!field) {
+		field = tep_find_any_field(event, arg->field.name);
+		if (!field) {
+			do_warning_event(event, "%s: field %s not found",
+					 __func__, arg->field.name);
+			return ret;
+		}
+		arg->field.field = field;
+	}
+
+	val = tep_read_number(tep, data + field->offset, field->size);
+	width = field->size * 2;
+	trace_seq_printf(s, "0x%0*llx", width, val);
+
+	if (format[1] == 'p' || format[1] == 'd')
+		ret++;
+
+	return ret;
+}
+
 static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 			     void *data, int size,
 			     struct tep_event *event, struct tep_print_arg *arg,
@@ -6652,12 +6724,18 @@ static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 	}
 
 	switch (*format) {
+	case 'B':
+		ret += print_function_backtrace(s, data, size, event, arg, raw);
+		break;
 	case 'F':
 	case 'f':
 	case 'S':
 	case 's':
 		ret += print_function(s, format, data, size, event, arg, raw);
 		break;
+	case 'a':
+		ret += print_addr_ref_arg(s, format, data, size, event, arg);
+		break;
 	case 'M':
 	case 'm':
 		ret += print_mac_arg(s, format, data, size, event, arg);
@@ -6752,12 +6830,24 @@ static int parse_arg_format_pointer(const char *format)
 	int loop;
 
 	switch (*format) {
+	case 'B':
+		ret++;
+		break;
 	case 'F':
 	case 'S':
 	case 'f':
 	case 's':
 		ret++;
 		break;
+	case 'a':
+		switch (format[1]) {
+		case 'p':
+		case 'd':
+			ret++;
+			break;
+		}
+		ret++;
+		break;
 	case 'M':
 	case 'm':
 		/* [mM]R , [mM]F */
diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index b62411c..e64c923 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -16,6 +16,7 @@
 #include <ftw.h>
 
 #include <sys/mman.h>
+#include <stdint.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
@@ -182,6 +183,45 @@ static char sizeof_data[] = {
 };
 static void *sizeof_event_data = (void *)sizeof_data;
 
+static const char pointer_backtrace_event[] =
+	"name: pointer_backtrace_event\n"
+	"ID: 40\n"
+	"format:\n"
+	"\tfield:unsigned short common_type;\toffset:0;\tsize:2;\tsigned:0;\n"
+	"\tfield:unsigned char common_flags;\toffset:2;\tsize:1;\tsigned:0;\n"
+	"\tfield:unsigned char common_preempt_count;\toffset:3;\tsize:1;\tsigned:0;\n"
+	"\tfield:int common_pid;\toffset:4;\tsize:4;\tsigned:1;\n"
+	"\n"
+	"\tfield:unsigned long long ptr;\toffset:8;\tsize:8;\tsigned:0;\n"
+	"\n"
+	"print fmt: \"ptr=%pB\", REC->ptr\n";
+
+static const char phys_addr_event[] =
+	"name: phys_addr_event\n"
+	"ID: 41\n"
+	"format:\n"
+	"\tfield:unsigned short common_type;\toffset:0;\tsize:2;\tsigned:0;\n"
+	"\tfield:unsigned char common_flags;\toffset:2;\tsize:1;\tsigned:0;\n"
+	"\tfield:unsigned char common_preempt_count;\toffset:3;\tsize:1;\tsigned:0;\n"
+	"\tfield:int common_pid;\toffset:4;\tsize:4;\tsigned:1;\n"
+	"\n"
+	"\tfield:unsigned long long phys;\toffset:8;\tsize:8;\tsigned:0;\n"
+	"\n"
+	"print fmt: \"phys=%pap\", REC->phys\n";
+
+static const char dma_addr_event[] =
+	"name: dma_addr_event\n"
+	"ID: 42\n"
+	"format:\n"
+	"\tfield:unsigned short common_type;\toffset:0;\tsize:2;\tsigned:0;\n"
+	"\tfield:unsigned char common_flags;\toffset:2;\tsize:1;\tsigned:0;\n"
+	"\tfield:unsigned char common_preempt_count;\toffset:3;\tsize:1;\tsigned:0;\n"
+	"\tfield:int common_pid;\toffset:4;\tsize:4;\tsigned:1;\n"
+	"\n"
+	"\tfield:unsigned int dma;\toffset:8;\tsize:4;\tsigned:0;\n"
+	"\n"
+	"print fmt: \"dma=%pad\", REC->dma\n";
+
 DECL_CPUMASK_EVENT_DATA(full, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff);
 #define CPUMASK_FULL     "ARRAY[ff, ff, ff, ff, ff, ff, ff, ff]"
 #define CPUMASK_FULL_FMT "cpumask=0-63"
@@ -380,6 +420,64 @@ static void test_parse_sizeof_undef(void)
 	test_parse_sizeof(0, 5, "sizeof_undef", SIZEOF_LONG0_FMT);
 }
 
+static void parse_pointer_event(const char *format, const char *system,
+				void *data, int size, const char *expected)
+{
+	struct tep_event *event;
+	struct tep_record record;
+
+	record.data = data;
+	record.size = size;
+
+	CU_TEST(tep_parse_format(test_tep, &event, format, strlen(format),
+				 system) == TEP_ERRNO__SUCCESS);
+
+	trace_seq_reset(test_seq);
+	tep_print_event(test_tep, test_seq, &record, "%s", TEP_PRINT_INFO);
+	trace_seq_do_printf(test_seq);
+	CU_TEST(strcmp(test_seq->buffer, expected) == 0);
+}
+
+static void test_parse_pointer_backtrace(void)
+{
+	unsigned char data[16] = { 0 };
+	unsigned short type = 40;
+	uint64_t ptr = 0x1001ULL;
+
+	memcpy(data, &type, sizeof(type));
+	memcpy(data + 8, &ptr, sizeof(ptr));
+
+	parse_pointer_event(pointer_backtrace_event, "ptr_backtrace",
+			    data, sizeof(data), "ptr=test_func+0x0");
+}
+
+static void test_parse_phys_addr(void)
+{
+	unsigned char data[16] = { 0 };
+	unsigned short type = 41;
+	uint64_t phys = 0x123456789abcdef0ULL;
+
+	memcpy(data, &type, sizeof(type));
+	memcpy(data + 8, &phys, sizeof(phys));
+
+	parse_pointer_event(phys_addr_event, "ptr_phys",
+			    data, sizeof(data),
+			    "phys=0x123456789abcdef0");
+}
+
+static void test_parse_dma_addr(void)
+{
+	unsigned char data[12] = { 0 };
+	unsigned short type = 42;
+	uint32_t dma = 0x1234abcdU;
+
+	memcpy(data, &type, sizeof(type));
+	memcpy(data + 8, &dma, sizeof(dma));
+
+	parse_pointer_event(dma_addr_event, "ptr_dma",
+			    data, sizeof(data), "dma=0x1234abcd");
+}
+
 static void test_btf_read(void)
 {
 	unsigned long args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
@@ -429,6 +527,10 @@ static int test_suite_init(void)
 	test_tep = tep_alloc();
 	if (!test_tep)
 		return 1;
+	if (tep_register_function(test_tep, "test_func", 0x1000, NULL))
+		return 1;
+	if (tep_register_function(test_tep, "test_func_end", 0x2000, NULL))
+		return 1;
 #if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
 	tep_set_file_bigendian(test_tep, TEP_BIG_ENDIAN);
 #endif
@@ -466,6 +568,12 @@ void test_traceevent_lib(void)
 		    test_parse_sizeof4);
 	CU_add_test(suite, "parse sizeof() no long size defined",
 		    test_parse_sizeof_undef);
+	CU_add_test(suite, "parse %pB pointer format",
+		    test_parse_pointer_backtrace);
+	CU_add_test(suite, "parse %pap pointer format",
+		    test_parse_phys_addr);
+	CU_add_test(suite, "parse %pad pointer format",
+		    test_parse_dma_addr);
 	CU_add_test(suite, "read BTF",
 		    test_btf_read);
 }
-- 
2.39.5 (Apple Git-154)

