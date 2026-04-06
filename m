Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A504C23183C
	for <linux-trace-devel@vger.kernel.org>; Mon,  6 Apr 2026 12:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775478646; cv=none; b=deumNuOUrqbYypl9FWN39qtuyK9Olt3+3/V9yqVDPtnxixH04P+osvw8V3g6FdscWF7BeaevhA4hpvR+VLjvwY8h6c7rydrKiNyoSby1A84XWPINgRAlgV9ZCblV+lWlw5oovPm6/ZkHshNKTQLrFej2JRDla0KDrkJliZfmQ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775478646; c=relaxed/simple;
	bh=lJraCrW8cVhdbE54R11KLMF4Rz1hZjvvh0pKE6rukSc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q/u2NWPpm3piHmJaX7lpvyPi/VpoKEC0AaAoR3Dcev+JT7wS9MJk2rAF6YeOeowDPh/71+XU99G9HvSg8H9Segsw56usdTDkMijWKEmQ6AcgGerktFNyUAkQf+gyCQLKiobKzsBoScRVeGfuaFnl0qPEtxnjlrDQ2Y1CYVtYkfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Jea6LilE; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Jea6LilE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=j2
	/jHk45AUWRsWs9gBCSs5Xbmdfw/i5+B3TqkXOt7nk=; b=Jea6LilEL8vq0YlxQN
	eDZdPLpB6jmErojRBmoSBP1K19PVLtU/ohQmyFFPhCb24mXGCtiC3McEK76M1erc
	O/90K3Gzrf1cAwpQ3IJGG4MtgtO8m0C8OOukyk19TQhGGiMl9s8wI1ekhBsOYsql
	sJiB0AhAoOZByIU8fBlQ/osHM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H7pfp9NpWUfYDQ--.30930S2;
	Mon, 06 Apr 2026 20:30:26 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	tz.stoyanov@gmail.com
Subject: [PATCH] libtraceevent: reject non-text symbol arithmetic
Date: Mon,  6 Apr 2026 20:30:17 +0800
Message-Id: <20260406123017.10928-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H7pfp9NpWUfYDQ--.30930S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3KryxAr4xuw1fZrWrCFW8tFb_yoW8Jw13Zo
	W3Zan3XayrKw1xA3yDXF1fXFW5Xrn093s3K3Wa9wn8W3W3Kws0gr4xuws8G3yUXF45GFW3
	Z3Z0q34xJr47CFn5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4R_PESDUUUU
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbCvwNRimnTp2McuQAA38

The print fmt parser currently treats any kallsyms entry as a function
symbol and will substitute its address into numeric expressions.

That works for _stext based offsets, but it also turns runtime globals
like jiffies into kernel virtual addresses. Events such as
writeback_single_inode_start then report a huge bogus age value instead
of something meaningful.

Only text symbols should be loaded into the function map from
/proc/kallsyms. For any remaining bare identifier that cannot be
resolved as a numeric value, mark that argument as invalid and print
INVALID for that conversion instead of fabricating a number.

This keeps _stext style symbol arithmetic working while making the
writeback age output fail in a local and explicit way.

Add unit tests for both the preserved _stext case and the rejected
jiffies arithmetic case.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=219839
Signed-off-by: CaoRuichuang <create0818@163.com>
---
 src/event-parse.c        | 109 +++++++++++++++++++++++++----
 utest/traceevent-utest.c | 146 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 241 insertions(+), 14 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index fee0f91..60225ee 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -107,6 +107,7 @@ struct tep_mod_addr {
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
 		     struct tep_event *event, struct tep_print_arg *arg);
+static bool is_kernel_text_symbol(char ch);
 
 static void free_func_handle(struct tep_function_handler *func);
 
@@ -1070,6 +1071,10 @@ int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms)
 		 *  - x86-64 that reports per-cpu variable offsets as absolute
 		 */
 		if (func[0] != '$' && ch != 'A' && ch != 'a') {
+			if (!is_kernel_text_symbol(ch)) {
+				line = strtok_r(NULL, "\n", &next);
+				continue;
+			}
 			line[func_end] = 0;
 			if (mod_end) {
 				mod = line + mod_start;
@@ -4579,14 +4584,30 @@ tep_find_event_by_name(struct tep_handle *tep,
 	return event;
 }
 
+static bool is_kernel_text_symbol(char ch)
+{
+	switch (ch) {
+	case 'T':
+	case 't':
+	case 'W':
+	case 'w':
+		return true;
+	default:
+		return false;
+	}
+}
+
 static unsigned long long test_for_symbol(struct tep_handle *tep,
-					  struct tep_print_arg *arg)
+					  struct tep_print_arg *arg,
+					  bool *found)
 {
 	unsigned long long val = 0;
 	struct func_list *item = tep->funclist;
 	char *func;
 	int i;
 
+	*found = false;
+
 	if (isdigit(arg->atom.atom[0]))
 		return 0;
 
@@ -4607,10 +4628,14 @@ static unsigned long long test_for_symbol(struct tep_handle *tep,
 
 		if (strcmp(arg->atom.atom, name) == 0) {
 			val = addr;
+			*found = true;
 			break;
 		}
 	}
 
+	if (!*found)
+		return 0;
+
 	/*
 	 * This modifies the arg to hardcode the value
 	 * and will not loop again.
@@ -4686,13 +4711,17 @@ static bool check_data_offset_size(struct tep_event *event, const char *field_na
 }
 
 static unsigned long long
-eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg *arg)
+eval_num_arg_stat(void *data, int size, struct tep_event *event,
+		  struct tep_print_arg *arg, bool *valid)
 {
 	struct tep_handle *tep = event->tep;
 	unsigned long long val = 0;
 	unsigned long long left, right;
 	struct tep_print_arg *typearg = NULL;
 	struct tep_print_arg *larg;
+	bool found = false;
+	bool left_valid = true;
+	bool right_valid = true;
 	unsigned int offset;
 	unsigned int field_size;
 
@@ -4702,8 +4731,11 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		return 0;
 	case TEP_PRINT_ATOM:
 		val = strtoull(arg->atom.atom, NULL, 0);
-		if (!val)
-			val = test_for_symbol(tep, arg);
+		if (!val && !isdigit(arg->atom.atom[0])) {
+			val = test_for_symbol(tep, arg, &found);
+			if (!found)
+				*valid = false;
+		}
 		return val;
 	case TEP_PRINT_FIELD:
 		if (!arg->field.field) {
@@ -4728,7 +4760,10 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 	case TEP_PRINT_HEX_STR:
 		break;
 	case TEP_PRINT_TYPE:
-		val = eval_num_arg(data, size, event, arg->typecast.item);
+		val = eval_num_arg_stat(data, size, event, arg->typecast.item,
+					valid);
+		if (!*valid)
+			return 0;
 		return eval_type(val, arg, 0);
 	case TEP_PRINT_STRING:
 	case TEP_PRINT_BSTRING:
@@ -4749,7 +4784,12 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			 * Arrays are special, since we don't want
 			 * to read the arg as is.
 			 */
-			right = eval_num_arg(data, size, event, arg->op.right);
+			right = eval_num_arg_stat(data, size, event,
+						 arg->op.right, &right_valid);
+			if (!right_valid) {
+				*valid = false;
+				return 0;
+			}
 
 			/* handle typecasts */
 			larg = arg->op.left;
@@ -4797,17 +4837,34 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 				val = eval_type(val, typearg, 1);
 			break;
 		} else if (strcmp(arg->op.op, "?") == 0) {
-			left = eval_num_arg(data, size, event, arg->op.left);
+			left = eval_num_arg_stat(data, size, event, arg->op.left,
+						&left_valid);
+			if (!left_valid) {
+				*valid = false;
+				return 0;
+			}
 			arg = arg->op.right;
 			if (left)
-				val = eval_num_arg(data, size, event, arg->op.left);
+				val = eval_num_arg_stat(data, size, event,
+							arg->op.left, &left_valid);
 			else
-				val = eval_num_arg(data, size, event, arg->op.right);
+				val = eval_num_arg_stat(data, size, event,
+							arg->op.right, &right_valid);
+			if ((left && !left_valid) || (!left && !right_valid)) {
+				*valid = false;
+				return 0;
+			}
 			break;
 		}
  default_op:
-		left = eval_num_arg(data, size, event, arg->op.left);
-		right = eval_num_arg(data, size, event, arg->op.right);
+		left = eval_num_arg_stat(data, size, event, arg->op.left,
+					 &left_valid);
+		right = eval_num_arg_stat(data, size, event, arg->op.right,
+					  &right_valid);
+		if (!left_valid || !right_valid) {
+			*valid = false;
+			return 0;
+		}
 		switch (arg->op.op[0]) {
 		case '!':
 			switch (arg->op.op[1]) {
@@ -4922,6 +4979,15 @@ out_warning_field:
 	return 0;
 }
 
+static unsigned long long
+eval_num_arg(void *data, int size, struct tep_event *event,
+	     struct tep_print_arg *arg)
+{
+	bool valid = true;
+
+	return eval_num_arg_stat(data, size, event, arg, &valid);
+}
+
 struct flag {
 	const char *name;
 	unsigned long long value;
@@ -6607,9 +6673,14 @@ static int print_function(struct trace_seq *s, const char *format,
 			  struct tep_print_arg *arg, bool raw)
 {
 	struct func_map *func;
+	bool valid = true;
 	unsigned long long val;
 
-	val = eval_num_arg(data, size, event, arg);
+	val = eval_num_arg_stat(data, size, event, arg, &valid);
+	if (!valid) {
+		trace_seq_puts(s, "INVALID");
+		return 0;
+	}
 	func = find_func(event->tep, val);
 	if (func) {
 		trace_seq_puts(s, func->func);
@@ -6636,6 +6707,7 @@ static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 			     struct tep_event *event, struct tep_print_arg *arg,
 			     bool raw)
 {
+	bool valid = true;
 	unsigned long long val;
 	int ret = 1;
 
@@ -6674,7 +6746,11 @@ static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 		break;
 	default:
 		ret = 0;
-		val = eval_num_arg(data, size, event, arg);
+		val = eval_num_arg_stat(data, size, event, arg, &valid);
+		if (!valid) {
+			trace_seq_puts(s, "INVALID");
+			break;
+		}
 		trace_seq_printf(s, "%p", (void *)(intptr_t)val);
 		break;
 	}
@@ -6687,9 +6763,14 @@ static int print_arg_number(struct trace_seq *s, const char *format, int plen,
 			    void *data, int size, int ls,
 			    struct tep_event *event, struct tep_print_arg *arg)
 {
+	bool valid = true;
 	unsigned long long val;
 
-	val = eval_num_arg(data, size, event, arg);
+	val = eval_num_arg_stat(data, size, event, arg, &valid);
+	if (!valid) {
+		trace_seq_puts(s, "INVALID");
+		return 0;
+	}
 
 	switch (ls) {
 	case -2:
diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index b62411c..473b9c7 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -182,6 +182,74 @@ static char sizeof_data[] = {
 };
 static void *sizeof_event_data = (void *)sizeof_data;
 
+static const char symbol_kallsyms[] =
+	"0000000000001000 T _stext\n"
+	"0000000000001020 T do_work\n"
+	"0000000000001100 T end_text\n"
+	"0000000000002000 D jiffies\n";
+
+#define SYMBOL_ARITH_FMT "caller=do_work+0x0"
+static const char symbol_arith_event[] =
+	"name: symbol_arith\n"
+	"ID: 24\n"
+	"format:\n"
+	"\tfield:unsigned short common_type;\toffset:0;\tsize:2;\tsigned:0;\n"
+	"\tfield:unsigned char common_flags;\toffset:2;\tsize:1;\tsigned:0;\n"
+	"\tfield:unsigned char common_preempt_count;\toffset:3;\tsize:1;\tsigned:0;\n"
+	"\tfield:int common_pid;\toffset:4;\tsize:4;\tsigned:1;\n"
+	"\n"
+	"\tfield:unsigned int caller_off;\toffset:8;\tsize:4;\tsigned:0;\n"
+	"\n"
+	"print fmt: \"caller=%pS\", REC->caller_off + _stext\n";
+
+static char symbol_arith_data[] = {
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	/* common type */		24, 0x00,
+#else
+	/* common type */		0x00, 24,
+#endif
+	/* common flags */		0x00,
+	/* common_preempt_count */	0x00,
+	/* common_pid */		0x00, 0x00, 0x00, 0x00,
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	/* caller_off */		0x20, 0x00, 0x00, 0x00,
+#else
+	/* caller_off */		0x00, 0x00, 0x00, 0x20,
+#endif
+};
+
+#define JIFFIES_ARITH_FMT "age=INVALID"
+static const char jiffies_arith_event[] =
+	"name: jiffies_arith\n"
+	"ID: 25\n"
+	"format:\n"
+	"\tfield:unsigned short common_type;\toffset:0;\tsize:2;\tsigned:0;\n"
+	"\tfield:unsigned char common_flags;\toffset:2;\tsize:1;\tsigned:0;\n"
+	"\tfield:unsigned char common_preempt_count;\toffset:3;\tsize:1;\tsigned:0;\n"
+	"\tfield:int common_pid;\toffset:4;\tsize:4;\tsigned:1;\n"
+	"\n"
+	"\tfield:unsigned long dirtied_when;\toffset:8;\tsize:8;\tsigned:0;\n"
+	"\n"
+	"print fmt: \"age=%lu\", (jiffies - REC->dirtied_when) / 250\n";
+
+static char jiffies_arith_data[] = {
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	/* common type */		25, 0x00,
+#else
+	/* common type */		0x00, 25,
+#endif
+	/* common flags */		0x00,
+	/* common_preempt_count */	0x00,
+	/* common_pid */		0x00, 0x00, 0x00, 0x00,
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	/* dirtied_when */		0xf4, 0x01, 0x00, 0x00,
+					0x00, 0x00, 0x00, 0x00,
+#else
+	/* dirtied_when */		0x00, 0x00, 0x00, 0x00,
+					0x00, 0x00, 0x01, 0xf4,
+#endif
+};
+
 DECL_CPUMASK_EVENT_DATA(full, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff);
 #define CPUMASK_FULL     "ARRAY[ff, ff, ff, ff, ff, ff, ff, ff]"
 #define CPUMASK_FULL_FMT "cpumask=0-63"
@@ -380,6 +448,80 @@ static void test_parse_sizeof_undef(void)
 	test_parse_sizeof(0, 5, "sizeof_undef", SIZEOF_LONG0_FMT);
 }
 
+static struct tep_handle *alloc_local_tep(void)
+{
+	struct tep_handle *tep = tep_alloc();
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	if (tep)
+		tep_set_file_bigendian(tep, TEP_BIG_ENDIAN);
+#endif
+	return tep;
+}
+
+static void test_parse_symbol_offset(void)
+{
+	struct trace_seq seq;
+	struct tep_handle *tep;
+	struct tep_event *event;
+	struct tep_record record = {
+		.data = symbol_arith_data,
+		.size = sizeof(symbol_arith_data),
+	};
+
+	tep = alloc_local_tep();
+	CU_TEST(tep != NULL);
+	if (!tep)
+		return;
+
+	trace_seq_init(&seq);
+
+	CU_TEST(tep_parse_kallsyms(tep, symbol_kallsyms) == 0);
+	CU_TEST(tep_parse_format(tep, &event, symbol_arith_event,
+				 strlen(symbol_arith_event),
+				 "symbol") == TEP_ERRNO__SUCCESS);
+
+	trace_seq_reset(&seq);
+	tep_print_event(tep, &seq, &record, "%s", TEP_PRINT_INFO);
+	trace_seq_do_printf(&seq);
+	CU_TEST(strcmp(seq.buffer, SYMBOL_ARITH_FMT) == 0);
+
+	trace_seq_destroy(&seq);
+	tep_free(tep);
+}
+
+static void test_parse_jiffies_arith_invalid(void)
+{
+	struct trace_seq seq;
+	struct tep_handle *tep;
+	struct tep_event *event;
+	struct tep_record record = {
+		.data = jiffies_arith_data,
+		.size = sizeof(jiffies_arith_data),
+	};
+
+	tep = alloc_local_tep();
+	CU_TEST(tep != NULL);
+	if (!tep)
+		return;
+
+	trace_seq_init(&seq);
+
+	CU_TEST(tep_parse_kallsyms(tep, symbol_kallsyms) == 0);
+	CU_TEST(tep_find_function(tep, 0x2000) == NULL);
+	CU_TEST(tep_parse_format(tep, &event, jiffies_arith_event,
+				 strlen(jiffies_arith_event),
+				 "symbol") == TEP_ERRNO__SUCCESS);
+
+	trace_seq_reset(&seq);
+	tep_print_event(tep, &seq, &record, "%s", TEP_PRINT_INFO);
+	trace_seq_do_printf(&seq);
+	CU_TEST(strcmp(seq.buffer, JIFFIES_ARITH_FMT) == 0);
+
+	trace_seq_destroy(&seq);
+	tep_free(tep);
+}
+
 static void test_btf_read(void)
 {
 	unsigned long args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
@@ -466,6 +608,10 @@ void test_traceevent_lib(void)
 		    test_parse_sizeof4);
 	CU_add_test(suite, "parse sizeof() no long size defined",
 		    test_parse_sizeof_undef);
+	CU_add_test(suite, "parse _stext symbol arithmetic",
+		    test_parse_symbol_offset);
+	CU_add_test(suite, "reject data symbol arithmetic",
+		    test_parse_jiffies_arith_invalid);
 	CU_add_test(suite, "read BTF",
 		    test_btf_read);
 }
-- 
2.39.5 (Apple Git-154)

