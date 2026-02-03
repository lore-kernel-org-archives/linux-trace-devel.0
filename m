Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013F031ED8A
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Feb 2026 23:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770161663; cv=none; b=FX0vFYcQXPwxuoMOyMxfgiz0KlvdsmsYjdE7s0+QzNlYkLBVo+ZUeQ45tPbeFcuNHABFXkXgx8c1Bto8mKnJ1a5HCvxwQkokmZ2AAPVyOYZHJlkFTYTl/TQEjpLSiuke53OY3C9i25PgOAbDLyxpHCF8p8uNzp5Va53xArHNiP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770161663; c=relaxed/simple;
	bh=14J7V0sqS2pcOQkyXtaxK+qqZokvfIYlQcMJWoO2h6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTqWxBb7/bjlpclQiMzmwLuOkSMKz9T9S5ReymSq5MuSbDi4ZORJeWzTrj8BjIpKCrGF8ruBe3HyUTVXj9fHtgA4fcU9CIVvNww9n34C1lRNV+Jz631fR18rRHcxW/3vs1kl+4efseu1Kw/ZvhqBmxWci2Cw05WoO7eCjivvvGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE934C2BCAF;
	Tue,  3 Feb 2026 23:34:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnPv2-00000008tFf-2xOa;
	Tue, 03 Feb 2026 18:34:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 5/6] libtracecmd: Add printing of arguments for function graph tracer
Date: Tue,  3 Feb 2026 18:32:28 -0500
Message-ID: <20260203233451.2118849-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203233451.2118849-1-rostedt@goodmis.org>
References: <20260203233451.2118849-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the function graph tracer was recorded with the funcgraph-args option
set, then the BTF file would also be recorded. Print the contents of the
arguments with the information provided by BTF.

The output will look like this:

             cat-43792 [006] ..... 147894.472393: funcgraph_entry:                   |  mutex_unlock(lock=0xffffffff831dbbe0) {
             cat-43792 [006] ..... 147894.472394: funcgraph_entry:        1.005 us   |    __mutex_unlock_slowpath(lock=0xffffffff831dbbe0, ip=0xffffffff812f2e30); (ret=0x0)
             cat-43792 [006] ..... 147894.472396: funcgraph_exit:         3.581 us   |  } (ret=0x0)
             cat-43792 [006] ..... 147894.472397: funcgraph_entry:                   |  __f_unlock_pos(f=0xffff8881538df980) {
             cat-43792 [006] ..... 147894.472397: funcgraph_entry:                   |    mutex_unlock(lock=0xffff8881538dfa10) {
             cat-43792 [006] ..... 147894.472397: funcgraph_entry:        0.434 us   |      __mutex_unlock_slowpath(lock=0xffff8881538dfa10, ip=0xffffffff812f2e30); (ret=0x0)
             cat-43792 [006] ..... 147894.472398: funcgraph_exit:         1.216 us   |    } (ret=0x0)
             cat-43792 [006] ..... 147894.472399: funcgraph_exit:         2.152 us   |  } (ret=0x0)
             cat-43792 [006] d.... 147894.472399: funcgraph_entry:        0.360 us   |  fpregs_assert_state_consistent(); (ret=0x6)
             cat-43792 [006] ..... 147894.472403: funcgraph_entry:                   |  __x64_sys_execve(regs=0xffffc900029f3f58) {
             cat-43792 [006] ..... 147894.472404: funcgraph_entry:                   |    getname_flags(filename=0x7fff4a902080, flags=0) {
             cat-43792 [006] ..... 147894.472404: funcgraph_entry:                   |      getname_flags.part.0(7fff4a902080, 0, 0, 0, 0, 0) {
             cat-43792 [006] ..... 147894.472405: funcgraph_entry:                   |        kmem_cache_alloc_noprof(s=0xffff8881001d3800, gfpflags=0xcc0) {
             cat-43792 [006] ..... 147894.472405: funcgraph_entry:        0.618 us   |          fs_reclaim_acquire(gfp_mask=0xcc0); (ret=0x0)
             cat-43792 [006] ..... 147894.472406: funcgraph_entry:        0.380 us   |          fs_reclaim_release(gfp_mask=0xcc0); (ret=0x0)
             cat-43792 [006] ..... 147894.472407: funcgraph_entry:                   |          kmemleak_alloc(ptr=0xffff8881120b0000, size=0x1000, min_count=1, gfp=0xcc0) {
             cat-43792 [006] ..... 147894.472408: funcgraph_entry:                   |            __create_object(ptr=0xffff8881120b0000, size=0x1000, min_count=1, gfp=0xcc0, objflags=0x0) {
             cat-43792 [006] ..... 147894.472408: funcgraph_entry:                   |              __alloc_object(gfp=0xcc0) {
             cat-43792 [006] ..... 147894.472408: funcgraph_entry:                   |                kmem_cache_alloc_noprof(s=0xffff888100045700, gfpflags=0x92cc0) {
             cat-43792 [006] ..... 147894.472409: funcgraph_entry:        0.570 us   |                  fs_reclaim_acquire(gfp_mask=0x92cc0); (ret=0x0)
             cat-43792 [006] ..... 147894.472410: funcgraph_entry:        0.370 us   |                  fs_reclaim_release(gfp_mask=0x92cc0); (ret=0x0)
             cat-43792 [006] ..... 147894.472411: funcgraph_exit:         2.226 us   |                } (ret=0xffff88814bbcf6a8)

Even if libtraceevent 1.9 is not available, print the raw arg registers if
they exist in the function entry event.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-ftrace.c | 58 ++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index d0e6a8e7ac0d..c61dd543e250 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -198,6 +198,48 @@ static void print_graph_duration(struct trace_seq *s, unsigned long long duratio
 	trace_seq_puts(s, "|  ");
 }
 
+/* Returns true if it printed args, otherwise it returns false */
+static bool print_args(struct trace_seq *s, struct tep_event *event,
+		       struct tep_record *record, const char *func)
+{
+	struct tep_format_field *field;
+	int long_size = tep_get_long_size(event->tep);
+	void *args;
+	int len;
+
+	if (!long_size)
+		long_size = sizeof(long);
+
+	field = tep_find_field(event, "args");
+	if (!field)
+		return false;
+
+	len = record->size - field->offset;
+
+	len /= long_size;
+
+	args = record->data + field->offset;
+
+#ifdef HAVE_KERNEL_BTF
+	tep_btf_print_args(event->tep, s, args, len, long_size, func);
+#else
+	for (int i = 0; i < len; i++) {
+		void *arg;
+
+		if (i)
+			trace_seq_puts(s, ", ");
+
+		arg = args + i * long_size;
+		if (long_size == 4)
+			trace_seq_printf(s, "%x", *(unsigned int *)arg);
+		else
+			trace_seq_printf(s, "%llx", *(unsigned long long *)arg);
+	}
+#endif
+
+	return true;
+}
+
 static int
 print_graph_entry_leaf(struct trace_seq *s,
 		       struct tep_event *event,
@@ -247,9 +289,11 @@ print_graph_entry_leaf(struct trace_seq *s,
 		return trace_seq_putc(s, '!');
 	func = tep_find_function(pevent, val);
 
-	if (func)
-		ret = trace_seq_printf(s, "%s();", func);
-	else
+	if (func) {
+		ret = trace_seq_printf(s, "%s(", func);
+		print_args(s, event, record, func);
+		ret = trace_seq_puts(s, ");");
+	} else
 		ret = trace_seq_printf(s, "%llx();", val);
 
 	if (ret && fgraph_depth->set)
@@ -302,9 +346,11 @@ static int print_graph_nested(struct trace_seq *s,
 
 	func = tep_find_function(pevent, val);
 
-	if (func)
-		ret = trace_seq_printf(s, "%s() {", func);
-	else
+	if (func) {
+		ret = trace_seq_printf(s, "%s(", func);
+		print_args(s, event, record, func);
+		ret = trace_seq_puts(s, ") {");
+	} else
 		ret = trace_seq_printf(s, "%llx() {", val);
 
 	if (ret && fgraph_depth->set)
-- 
2.51.0

