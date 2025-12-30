Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FB92DCC13
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Dec 2025 01:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767056540; cv=none; b=AjZAAHDKFRc2KR3h8QK2iOSdrtyG82fAHLwrLKFHcr0P+Fm7vUqOCvCJSIVALGBYo78LaTa59BxP6d2YxPoG4vjnhrRDzuHw3YuyYG6an5Jch9b5/XPRH5zGytwgQnPaF5jiSG6pO44kx37HfF7TgXIVhgAsE07kZ3RVYlaqtvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767056540; c=relaxed/simple;
	bh=LUSNC0345d4OC+4BtxInGK8Fih1bXnyONmYw26E4z2I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=aNMpkt7slnhXzl4W0SIuaONEGJhY/YSavA/gz2aHNtUOUk7KkGhc4vgHPY3u1kyCzYlhDDcsoPFG8Dao95rUlQH5/6lRZgiOjJREsnCkooT6k98Q6s5Mf/NUO6DJs0dG86aiYGAg110KMveEUV0+ffmyXvCV5k6+WRFwzLNE844=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rostedt.org; spf=pass smtp.mailfrom=rostedt.org; dkim=pass (2048-bit key) header.d=rostedt.org header.i=@rostedt.org header.b=b3qt6QBV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Q0yF4sNK; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rostedt.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rostedt.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rostedt.org header.i=@rostedt.org header.b="b3qt6QBV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Q0yF4sNK"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 85037140007F;
	Mon, 29 Dec 2025 20:02:17 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 29 Dec 2025 20:02:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rostedt.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm3; t=1767056537; x=1767142937; bh=u0
	p/26waoVkjICeIi3ldy3CnYrLwMxad2S+wQUbwFlo=; b=b3qt6QBVsg9XQE2AWo
	fUD/4JAvdir0iHTnkyUMlxIYbdJDygD58YeQwswBwdUHmQkr7ffPf3QZ8uLQO582
	GGUUHhg0VlbSn/NnFjlF50o+fIEOOkYCR60NsD4AItN6A1lUObJ+b6owgK4um5WE
	wb8YfVTHlQ8vJmfEzP7DlxaBONRBxOcCEP0uhjPdDKAIKQoLBEJHf39E0lcIIgJd
	AM2TpaGFme4dKsWfjEpk2Ovr0DJX+8tJ5+dsqmxmVjnj+WVL6hH/SyfO0XEX6vj6
	a0CTHom1bKAdjuLTNQlPAmzhLsa6zxjySlvAx9RJS/nNT+f6At2AAFYBQBidxMS0
	XgEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1767056537; x=1767142937; bh=u0p/26waoVkjICeIi3ldy3CnYrLw
	Mxad2S+wQUbwFlo=; b=Q0yF4sNKIA41xIwrEN3X4tXGrZPg8gnQ7R9HG0vP6xYq
	DSj7tF7mKfIehhsnw0vbstjaY+KV66FOJOKRZi5TiWvQswNonVGlCaXWdFbrqqy4
	RBozbu5W6LzXa0d3RRfYqPXDr/neWKxeV1qVYFbLtP7Y2Tmr2nT4qGyg+hpUbN6P
	wOe2TmU5H04CaeI4B/YPctrC0gKqkua0wUhVGJHyAyrQOksqizZ3h8akHk6LGHTO
	MRVkB054Wm/KwAeGjzpMep2QPcwwp+0e9kssyminsSXOYrPYzfb51QwcaKsEb1xg
	adILODBlmdydQOFcS190atyFTOVbL7wYCm6nB8r9hQ==
X-ME-Sender: <xms:mSRTaYW4Tc1grXcYl61PefpfW3wUzG5CmpifcBfdGJq0DPVtJa_wDg>
    <xme:mSRTaSmuDofsBstuDvsJF0fK-du4BumGB9tJg6rxLYvSq6KwU491yMzX9nSMiTwms
    eu6DFx3md-MuiBVYjKcL7FMuhvIozGVbuj93zW0noKkPW84LXd5uXs>
X-ME-Received: <xmr:mSRTaaDzzQEIohXhHy9hIwvqjLhiuopUUMI1uBuvsZb8N_GlnPVTnw17coWx1Qs117xgX_5t>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdejkeeihecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukffogggtgfesthejredtredtvdenucfhrhhomhepufhtvghvvghnucft
    ohhsthgvughtuceoshhtvghvvghnsehrohhsthgvughtrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehteduiefftdefuddvjeelhedvhedtgeejheekfeeugfehgedvieeftdfhledu
    tdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepshhtvghvvghnsehrohhsthgvughtrdhorhhg
    pdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlih
    hnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:mSRTaSfE7EyFtb7qJzSN5K7B5jJIOZ8R4Dm5MKnIuATjITgEQJUauQ>
    <xmx:mSRTaVIMxQj7_s_iwdq--sRZenjPrcJD03QdG4GES0uoSfKhicZraQ>
    <xmx:mSRTaVfWJ9owGVBMkr9WylDCMr-oDDIPhtrH3iFwfZjcaiXdeX7IaA>
    <xmx:mSRTac0fUZPwdO2jyMy1dyhwxp2nKHGBm_3W0W7SxkUOMmS9YDJZ6Q>
    <xmx:mSRTaWp3I-dtK8teVSIBdmiaf7XQ2HKatBJ-llfMEHQur3p2cU0fCO7P>
Feedback-ID: id06e481b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Dec 2025 20:02:17 -0500 (EST)
Date: Mon, 29 Dec 2025 20:02:23 -0500
From: Steven Rostedt <steven@rostedt.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH] libtraceevent: Handle __get_stacktrace()
Message-ID: <20251229200223.04c8d2bc@gandalf.local.home>
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

A synthetic event can add a stacktrace as one of its fields. The print fmt
of getting to the stacktrace field is the __get_stacktrace() function
helper. Add support for parsing the __get_stacktrace() so that it properly
displays the stacktrace of synthetic events.

Link: https://lore.kernel.org/all/aVG2VoBpFoEEE1gG@krava/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceevent/event-parse.h |  7 +++
 src/event-parse.c                | 76 ++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index ebfc2c7abac2..9c1abfae28d9 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -138,6 +138,11 @@ struct tep_print_arg_bitmask {
 	struct tep_format_field	*field;
 };
 
+struct tep_print_arg_stacktrace {
+	char			*stacktrace;
+	struct tep_format_field	*field;
+};
+
 struct tep_print_arg_field {
 	char			*name;
 	struct tep_format_field	*field;
@@ -215,6 +220,7 @@ enum tep_print_arg_type {
 	TEP_PRINT_DYNAMIC_ARRAY_LEN,
 	TEP_PRINT_HEX_STR,
 	TEP_PRINT_CPUMASK,
+	TEP_PRINT_STACKTRACE,
 };
 
 struct tep_print_arg {
@@ -231,6 +237,7 @@ struct tep_print_arg {
 		struct tep_print_arg_func	func;
 		struct tep_print_arg_string	string;
 		struct tep_print_arg_bitmask	bitmask;
+		struct tep_print_arg_stacktrace	stacktrace;
 		struct tep_print_arg_op		op;
 		struct tep_print_arg_dynarray	dynarray;
 	};
diff --git a/src/event-parse.c b/src/event-parse.c
index 939b0a8fbdf2..09d9092d9d20 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1129,6 +1129,9 @@ static void free_arg(struct tep_print_arg *arg)
 		free_arg(arg->op.left);
 		free_arg(arg->op.right);
 		break;
+	case TEP_PRINT_STACKTRACE:
+		free(arg->stacktrace.stacktrace);
+		break;
 	case TEP_PRINT_FUNC:
 		while (arg->func.args) {
 			farg = arg->func.args;
@@ -2895,6 +2898,7 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 	case TEP_PRINT_BSTRING:
 	case TEP_PRINT_BITMASK:
 	case TEP_PRINT_CPUMASK:
+	case TEP_PRINT_STACKTRACE:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		ret = 0;
@@ -2925,6 +2929,7 @@ static char *arg_eval (struct tep_print_arg *arg)
 	case TEP_PRINT_BSTRING:
 	case TEP_PRINT_BITMASK:
 	case TEP_PRINT_CPUMASK:
+	case TEP_PRINT_STACKTRACE:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		break;
@@ -3462,6 +3467,34 @@ process_cpumask(struct tep_event *event __maybe_unused, struct tep_print_arg *ar
 	return type;
 }
 
+static enum tep_event_type
+process_stacktrace(struct tep_event *event, struct tep_print_arg *arg, char **tok)
+{
+	enum tep_event_type type;
+	char *token;
+
+	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
+		goto out_free;
+
+	arg->type = TEP_PRINT_STACKTRACE;
+	arg->stacktrace.stacktrace = token;
+	arg->stacktrace.field = NULL;
+
+	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
+		goto out_err;
+
+	type = read_token(event->tep, &token);
+	*tok = token;
+
+	return type;
+
+ out_free:
+	free_token(token);
+ out_err:
+	*tok = NULL;
+	return TEP_EVENT_ERROR;
+}
+
 static struct tep_function_handler *
 find_func_handler(struct tep_handle *tep, char *func_name)
 {
@@ -3750,6 +3783,10 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		free_token(token);
 		return process_dynamic_array_len(event, arg, tok);
 	}
+	if (strcmp(token, "__get_stacktrace") == 0) {
+		free_token(token);
+		return process_stacktrace(event, arg, tok);
+	}
 	if (strcmp(token, "__builtin_expect") == 0) {
 		free_token(token);
 		return process_builtin_expect(event, arg, tok);
@@ -4414,6 +4451,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 	case TEP_PRINT_BSTRING:
 	case TEP_PRINT_BITMASK:
 	case TEP_PRINT_CPUMASK:
+	case TEP_PRINT_STACKTRACE:
 		return 0;
 	case TEP_PRINT_FUNC: {
 		struct trace_seq s;
@@ -4859,6 +4897,33 @@ more:
 	free(str);
 }
 
+static void print_stacktrace_to_seq(struct tep_handle *tep,
+				    struct trace_seq *s, const char *format,
+				    int len_arg, const void *data, int size)
+{
+	int nr_funcs = size / tep->long_size;
+	struct func_map *func;
+	unsigned long long val;
+
+	trace_seq_putc(s, '\n');
+
+	/* The first entry is a counter, skip it */
+	data += tep->long_size;
+
+	for (int i = 1; i < nr_funcs; i++) {
+		trace_seq_puts(s, "=> ");
+		val = tep_read_number(tep, data, tep->long_size);
+		func = find_func(tep, val);
+		if (func) {
+			trace_seq_puts(s, func->func);
+			trace_seq_printf(s, "+0x%llx\n", val - func->addr);
+		} else {
+			trace_seq_printf(s, "%llx\n", val);
+		}
+		data += tep->long_size;
+	}
+}
+
 static void print_str_arg(struct trace_seq *s, void *data, int size,
 			  struct tep_event *event, const char *format,
 			  int len_arg, struct tep_print_arg *arg)
@@ -5097,6 +5162,17 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 				     data + offset, len);
 		break;
 	}
+	case TEP_PRINT_STACKTRACE: {
+		if (!arg->stacktrace.field) {
+			arg->stacktrace.field = tep_find_any_field(event, arg->stacktrace.stacktrace);
+			if (!arg->stacktrace.field)
+				break;
+		}
+		dynamic_offset_field(tep, arg->stacktrace.field, data, size, &offset, &len);
+		print_stacktrace_to_seq(tep, s, format, len_arg,
+					data + offset, len);
+		break;
+	}
 	case TEP_PRINT_OP:
 		/*
 		 * The only op for string should be ? :
-- 
2.51.0

