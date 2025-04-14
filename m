Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875D1247299
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Apr 2025 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744645187; cv=none; b=h6KUnyfHnPORPfI4HsMEi5OM6Grap5CTeCXtZHnYSd48MPRYJSl4hKF6wAp6Fx35MzhQvaWLYz36g4bLLoV+ukFdDE7dOkYNbR1qmj2K3Cm4cpHBxL0aRAVig/v+XyHGyXzDuyas/3SzobdWu5wzKronba8Rf8CwyRddnqEjYKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744645187; c=relaxed/simple;
	bh=kXpmoeXfy/4UaFSaLoPWvlmODv5FbfFbQdx+MnyNTXs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7xF+lYd+Q0dwbzN1Ji9Rith7ddeup4BYkTrO4E5LAcY392S6cL12FVpImzWgH+LSOiCol9vpfk74b07HivulIXdX2N7yE5XeHu8Vy5S3LG8dP1cc7hsbiKdmwIS3FkkV58vR3z0wj3rEhp0fBNsKfw/cYHXi6GjdnzX3MBARiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4759C4CEE2;
	Mon, 14 Apr 2025 15:39:46 +0000 (UTC)
Date: Mon, 14 Apr 2025 11:41:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Malat <oss@malat.biz>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent plugins: Add plugin_net to handle bswap
 during print
Message-ID: <20250414114117.6346acc3@gandalf.local.home>
In-Reply-To: <20250409225608.12df6ed8@gandalf.local.home>
References: <20250409110705.437321-1-oss@malat.biz>
	<20250409225608.12df6ed8@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 9 Apr 2025 22:56:08 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> As the else block will have args[0] already swapped wrt to host that's
> reading the information. libtraceevent does a byte swap on values read when
> the host and file do not match endianess.

Does this patch work for you?

I only compiled it, I haven't tested it against real functions.

-- Steve

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index d3ce0a4..99a7214 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -181,7 +181,9 @@ struct tep_print_arg_dynarray {
 	struct tep_print_arg	*index;
 };
 
-struct tep_print_arg;
+struct tep_print_arg_bswap {
+	struct tep_print_arg	*field;
+};
 
 struct tep_print_arg_op {
 	char			*op;
@@ -215,6 +217,9 @@ enum tep_print_arg_type {
 	TEP_PRINT_DYNAMIC_ARRAY_LEN,
 	TEP_PRINT_HEX_STR,
 	TEP_PRINT_CPUMASK,
+	TEP_PRINT_BSWAP16,
+	TEP_PRINT_BSWAP32,
+	TEP_PRINT_BSWAP64,
 };
 
 struct tep_print_arg {
@@ -233,6 +238,7 @@ struct tep_print_arg {
 		struct tep_print_arg_bitmask	bitmask;
 		struct tep_print_arg_op		op;
 		struct tep_print_arg_dynarray	dynarray;
+		struct tep_print_arg_bswap	bswap;
 	};
 };
 
diff --git a/src/event-parse.c b/src/event-parse.c
index 6317ff6..ae19dee 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1129,6 +1129,11 @@ static void free_arg(struct tep_print_arg *arg)
 		free_arg(arg->op.left);
 		free_arg(arg->op.right);
 		break;
+	case TEP_PRINT_BSWAP16:
+	case TEP_PRINT_BSWAP32:
+	case TEP_PRINT_BSWAP64:
+		free_arg(arg->bswap.field);
+		break;
 	case TEP_PRINT_FUNC:
 		while (arg->func.args) {
 			farg = arg->func.args;
@@ -2879,6 +2884,25 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 		}
 		break;
 
+	case TEP_PRINT_BSWAP16:
+		ret = arg_num_eval(arg->bswap.field, val);
+		if (!ret)
+			break;
+		*val = __builtin_bswap16((uint16_t)(*val));
+		return ret;
+	case TEP_PRINT_BSWAP32:
+		ret = arg_num_eval(arg->bswap.field, val);
+		if (!ret)
+			break;
+		*val = __builtin_bswap32((uint32_t)(*val));
+		return ret;
+	case TEP_PRINT_BSWAP64:
+		ret = arg_num_eval(arg->bswap.field, val);
+		if (!ret)
+			break;
+		*val = __builtin_bswap16(*val);
+		return ret;
+
 	case TEP_PRINT_NULL:
 	case TEP_PRINT_FIELD ... TEP_PRINT_SYMBOL:
 	case TEP_PRINT_STRING:
@@ -3525,6 +3549,55 @@ out_free:
 	return TEP_EVENT_ERROR;
 }
 
+static enum tep_event_type
+process_builtin_bswap(struct tep_event *event, char *num, struct tep_print_arg *arg, char **tok)
+{
+	struct tep_handle *tep = event->tep;
+	struct tep_print_arg *field;
+	enum tep_event_type type;
+	char *token = NULL;
+	int n;
+
+	field = alloc_arg();
+	if (!field) {
+		do_warning_event(event, "%s(%d): not enough memory!",
+				 __func__, __LINE__);
+		return TEP_EVENT_ERROR;
+	}
+
+	type = process_arg(event, field, &token);
+	if (test_type_token(type, token,  TEP_EVENT_DELIM, ")"))
+		goto out_free;
+
+	tep_free_token(token);
+	token = NULL;
+
+	/* Do not need to swap if host and file do not match */
+	if (tep->host_bigendian != tep->file_bigendian) {
+		*arg = *field;
+		free_arg(field);
+		return read_token_item(event->tep, tok);
+	}
+
+	n = atoi(num);
+
+	switch (n) {
+	case 16: arg->type = TEP_PRINT_BSWAP16; break;
+	case 32: arg->type = TEP_PRINT_BSWAP32; break;
+	case 64: arg->type = TEP_PRINT_BSWAP64; break;
+	default: goto out_free;
+	}
+
+	arg->bswap.field = field;
+	return read_token_item(event->tep, tok);
+
+out_free:
+	free_arg(field);
+	tep_free_token(token);
+	*tok = NULL;
+	return TEP_EVENT_ERROR;
+}
+
 static enum tep_event_type
 process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 {
@@ -3696,6 +3769,13 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		tep_free_token(token);
 		return process_sizeof(event, arg, tok);
 	}
+	if (strncmp(token, "__builtin_bswap", 15) == 0) {
+		enum tep_event_type type;
+
+		type = process_builtin_bswap(event, token + 15, arg, tok);
+		tep_free_token(token);
+		return type;
+	}
 
 	func = find_func_handler(event->tep, token);
 	if (func) {

