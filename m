Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673961DFF0
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2026 08:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780301897; cv=none; b=OVUxFV6SJGjpaTPnLxYw1UCUpLyyKjHYR8QH6rxNczfWXw6MDfdSKNjKOeuM9rXYFjCd7Z3Q6xAE7gkOT15MQ4Erxy82pKn1lYT+Zyp8/5AN4MiwJ/sJUG30hT1TC5+YXBgHw5ZPwDHNJFaOrVfW0yS3leO5ezsxvpuSPAaeKOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780301897; c=relaxed/simple;
	bh=ijbJYzL00rRDM/PdwnqaxGqQtaEI00rXyD8cp1f3rgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IZSAy/4K2ql+C+peBoD8/SlfP4pV7bnriW4yazZLZ+x2NeFEaAbnFBOF326DKahswdRyRiJk8IHwMh7uImG5t3huesBQl9UohICNXAxhbrMbV7Isks0aT8A2D5OyI/3yinYmYJO4qfXyeiqYTSfns57nFBorPNFf7BnS3I5LSlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Q8FQglEs; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Q8FQglEs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:Content-Type:
	MIME-Version; bh=s5/b24k2HDiT+Jq7MBE+zIt8kPEZcoJZt3pAG8zyLBA=;
	b=Q8FQglEsO02uU2VdCnZMhCI5BdJCnjOXb/Ot58GTY/T9InuIsyJWdHot6YeVY0
	bLbvolTwV6foQOVsSa8Mg1rR+pyhuuYsNig/U6OGXrxRkAuJFiBqwnAowepskZD1
	R1FquVTDYBtRBjGlguFbSsSSB9S6oKl88hj7Oa1tdcygw=
Received: from [127.0.0.1] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCntlc2QB1qbNvYAg--.53455S2;
	Mon, 01 Jun 2026 16:17:59 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: [PATCH v2] libtraceevent: Reject non-text symbol arithmetic
Date: Mon, 01 Jun 2026 16:14:30 +0800
Message-ID: <178030167078.481.3342175703420798099.libtraceevent-reject-non-text-symbol-arithmetic-v2@163.com>
In-Reply-To: <20260529151126.392e2a70@fedora>
References: <20260406123017.10928-1-create0818@163.com> <20260529151126.392e2a70@fedora>
X-Mailer: git-send-email compatible draft
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CM-TRANSID:_____wCntlc2QB1qbNvYAg--.53455S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3KrykWFWxJFy3Gw43tr15CFg_yoW8Gr4UAo
	WfZFs3X3y8Kw1xC3yDXF1fXFW5Xr1q934rK3Wa9wn8W3W3K39IgryI9ws8JrWUXF45GrW3
	X3Z0q34fJr4fCFn5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4REq2MDUUUU
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC5xgAOWodQDhxTwAA33

The print fmt parser currently treats any kallsyms entry as a function
symbol and will substitute its address into numeric expressions.

That works for _stext based offsets, but it also turns runtime globals
like jiffies into kernel virtual addresses. Events such as
writeback_single_inode_start then report a huge bogus age value instead
of something meaningful.

Only text symbols should be loaded into the function map from
/proc/kallsyms. When the affected numeric or pointer print paths later
see an unresolved bare identifier in symbol arithmetic, print INVALID
instead of fabricating a number.

This keeps _stext style symbol arithmetic working while making the
writeback age output fail in a local and explicit way.

Add unit tests for both the preserved _stext case and the rejected
jiffies arithmetic case.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=219839
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cao Ruichuang <create0818@163.com>
---
Changes since v1:
- Rename the patch subject to:

    libtraceevent: Reject non-text symbol arithmetic

- Move is_kernel_text_symbol() before tep_parse_kallsyms() and drop the
  forward declaration.
- Add the Assisted-by trailer following
  Documentation/process/coding-assistants.rst. GPT-5.5 was used as a
  coding assistant while preparing this revision. I reviewed the final
  diff myself and the Signed-off-by remains mine.
- Built on Rocky Linux 9.7 with:

    make -j$(nproc)
    make test

  In this tree make test builds the utest binary. I then ran the
  traceevent unit test binary directly. The two tests added by this
  patch passed:

    Test: parse symbol arithmetic ...caller=do_work+0x0passed
    Test: reject non-text symbol arithmetic ...age=INVALIDpassed

  The direct unit-test run still reports one failure in the pre-existing
  "read BTF" test on that machine. I checked the unmodified baseline on
  the same system and it fails in the same BTF test as well, so that is
  not a regression from this patch.

 src/event-parse.c        | 108 +++++++++++++++++++++++++++++++++++++------
 utest/traceevent-utest.c | 117 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 211 insertions(+), 14 deletions(-)
diff --git a/src/event-parse.c b/src/event-parse.c
index 4bd5c1b..128a1cb 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1017,6 +1017,19 @@ int tep_load_modules(struct tep_handle *tep, char *modules, size_t size)
 	return ret;
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
 /**
  * tep_parse_kallsyms - load functions from a read of /proc/kallsyms
  * @tep: a handle to the trace event parser
@@ -1070,6 +1083,10 @@ int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms)
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
@@ -4580,13 +4597,16 @@ tep_find_event_by_name(struct tep_handle *tep,
 }
 
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
 
@@ -4607,10 +4627,14 @@ static unsigned long long test_for_symbol(struct tep_handle *tep,
 
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
@@ -4686,13 +4710,17 @@ static bool check_data_offset_size(struct tep_event *event, const char *field_na
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
 
@@ -4702,8 +4730,11 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
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
@@ -4728,7 +4759,10 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
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
@@ -4749,7 +4783,12 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
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
@@ -4797,17 +4836,34 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
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
@@ -4922,6 +4978,15 @@ out_warning_field:
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
@@ -6607,9 +6672,14 @@ static int print_function(struct trace_seq *s, const char *format,
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
@@ -6708,6 +6778,7 @@ static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 			     struct tep_event *event, struct tep_print_arg *arg,
 			     bool raw)
 {
+	bool valid = true;
 	unsigned long long val;
 	int ret = 1;
 
@@ -6752,7 +6823,11 @@ static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
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
@@ -6765,9 +6840,14 @@ static int print_arg_number(struct trace_seq *s, const char *format, int plen,
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
index 1c3a4c2..7d27211 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -184,6 +184,74 @@ static char sizeof_data[] = {
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
 static const char pointer_backtrace_event[] =
 	"name: pointer_backtrace_event\n"
 	"ID: 40\n"
@@ -434,6 +502,51 @@ static void test_parse_sizeof_undef(void)
 	test_parse_sizeof(0, 5, "sizeof_undef", SIZEOF_LONG0_FMT);
 }
 
+static void parse_symbol_event(const char *format, const char *system,
+			       void *data, int size, const char *expected)
+{
+	struct tep_handle *tep;
+	struct tep_event *event;
+	struct tep_record record;
+
+	tep = tep_alloc();
+	CU_TEST(tep != NULL);
+	if (!tep)
+		return;
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	tep_set_file_bigendian(tep, TEP_BIG_ENDIAN);
+#endif
+
+	record.data = data;
+	record.size = size;
+
+	CU_TEST(tep_parse_kallsyms(tep, symbol_kallsyms) == 0);
+	CU_TEST(tep_parse_format(tep, &event, format, strlen(format),
+				 system) == TEP_ERRNO__SUCCESS);
+
+	trace_seq_reset(test_seq);
+	tep_print_event(tep, test_seq, &record, "%s", TEP_PRINT_INFO);
+	trace_seq_do_printf(test_seq);
+	CU_TEST(strcmp(test_seq->buffer, expected) == 0);
+
+	tep_free(tep);
+}
+
+static void test_parse_symbol_arith(void)
+{
+	parse_symbol_event(symbol_arith_event, "symbol_arith",
+			   symbol_arith_data, sizeof(symbol_arith_data),
+			   SYMBOL_ARITH_FMT);
+}
+
+static void test_parse_jiffies_arith(void)
+{
+	parse_symbol_event(jiffies_arith_event, "jiffies_arith",
+			   jiffies_arith_data, sizeof(jiffies_arith_data),
+			   JIFFIES_ARITH_FMT);
+}
+
 static void parse_pointer_event(const char *format, const char *system,
 				void *data, int size, const char *expected)
 {
@@ -609,6 +722,10 @@ void test_traceevent_lib(void)
 		    test_parse_sizeof4);
 	CU_add_test(suite, "parse sizeof() no long size defined",
 		    test_parse_sizeof_undef);
+	CU_add_test(suite, "parse symbol arithmetic",
+		    test_parse_symbol_arith);
+	CU_add_test(suite, "reject non-text symbol arithmetic",
+		    test_parse_jiffies_arith);
 	CU_add_test(suite, "parse %pB pointer format",
 		    test_parse_pointer_backtrace);
 	CU_add_test(suite, "parse %pap pointer format",

