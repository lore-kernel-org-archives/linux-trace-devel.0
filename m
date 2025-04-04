Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B36D145B25
	for <linux-trace-devel@vger.kernel.org>; Fri,  4 Apr 2025 19:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743794965; cv=none; b=JxxTK4Vvt2FynLl3jdbndXwkTrlS3kExhsDfWgS7rbkdTu/kYMy72mcgW0PxRs56VYxghrtX3FgRjVeQxVBPDZEJebIT4QHppi3YC9Jq6pdDbGWRE5g/L2GGjtWoz7PEF+GMAtBP0uqAeOzjwEcJcctRwfD5Q7KfTAF2K7KDr4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743794965; c=relaxed/simple;
	bh=ilM+Vuh7rfA1jKKVH6U6HgC5u/n01RzB2TjTpwEsUjg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=N9cNCaR/Z8WLXpOZnjrW8PpfSZSfm/ankI4++Yf39tftKuEBOnEKcuwghpTXLcliNCeCShPGOM3WqO20lazS6ZrtUIjXdIa90ZszO1AaKDo3Z3whDBVLsw38LpLEybaJayOzlAylarVjFhi4jtd/m0pp7q/W282dGvwHsqGOAYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EDEC4CEDD
	for <linux-trace-devel@vger.kernel.org>; Fri,  4 Apr 2025 19:29:24 +0000 (UTC)
Date: Fri, 4 Apr 2025 15:30:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: If function has arguments print them
Message-ID: <20250404153032.2ec27f47@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Starting with v6.15, function tracer can hold arguments. If the event has them,
then print them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 plugins/plugin_function.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 2d6509b..a337446 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -133,6 +133,39 @@ static void show_function(struct trace_seq *s, struct tep_handle *tep,
 	}
 }
 
+/* Returns true if it printed args, otherwise it returns false */
+static bool print_args(struct trace_seq *s, struct tep_event *event,
+		       struct tep_record *record)
+{
+	struct tep_format_field *field;
+	unsigned long arg;
+	void *args;
+	int len;
+
+	field = tep_find_field(event, "args");
+	if (!field)
+		return false;
+
+	len = record->size - field->offset;
+
+	/* todo make this tep long size */
+	if (len < 3 * sizeof(long))
+		return false;
+
+	args = record->data + field->offset;
+
+	trace_seq_putc(s, '(');
+
+	for (int i = 0; i < len; i += sizeof(long), args += sizeof(long)) {
+		memcpy(&arg, args, sizeof(long));
+		trace_seq_printf(s, "%lx", arg);
+		if (i + sizeof(long) < len)
+			trace_seq_puts(s, ", ");
+	}
+	trace_seq_putc(s, ')');
+	return true;
+}
+
 static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct tep_event *event, void *context)
 {
@@ -163,6 +196,8 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	else
 		trace_seq_printf(s, "0x%llx", function);
 
+	print_args(s, event, record);
+
 	if (ftrace_parent->set) {
 		trace_seq_printf(s, " <-- ");
 		if (parent)
-- 
2.47.2

