Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82C059168
	for <linux-trace-devel@vger.kernel.org>; Fri, 19 Jul 2024 20:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721421546; cv=none; b=AzcHOP0RWFkQAXGodG08qn7sUCuo3pA34RAaklFfaQ+XnA3UwXkvk1Mb2WordqjwHdeRNym5JZCBIp/fODA4Me35GPOPnJu3yXtvJ3wsYWo5O6igUl+m7ecia2hjAA+Iq4cz/QPLgUPQul5MJV0KBYu8pd6122M/FyjpMe5H6rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721421546; c=relaxed/simple;
	bh=TLNFD6+mPCcJ4e1AjNbIQyzX8pLmgmkxJTcY7Oad+WY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OGz2WUnqQlBFJL+yL01o161L/59ID2soVuww+rGJflkVtcq4J6k10tR1AUwc7XGxhlV0dTT/WlGUEpbeZPQvpDO/FZ1nFTnCP2h5TI+CrP2tr/knOw9sKwOGRYbfVbJW932qkAwbu0XY7+lN+7P+SrSJNFTyu6ZWpJ7ZcC0SH6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1105EC32782;
	Fri, 19 Jul 2024 20:39:05 +0000 (UTC)
Date: Fri, 19 Jul 2024 16:39:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, Ian Rogers <irogers@google.com>
Subject: Re: [PATCH] libtraceevent: Fix a double free in process_op()
Message-ID: <20240719163913.3684eaaa@gandalf.local.home>
In-Reply-To: <20240719163242.690f4c0e@gandalf.local.home>
References: <20240626033949.1017381-1-namhyung@google.com>
	<20240719163242.690f4c0e@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 Jul 2024 16:32:41 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Perhaps the real fix was:

Or better yet, something a bit cleaner, as I found another location that
needs an update.

diff --git a/src/event-parse.c b/src/event-parse.c
index 9f0522c8d9e4..d44da8baf087 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2197,21 +2197,24 @@ static int set_op_prio(struct tep_print_arg *arg)
 	return arg->op.prio;
 }
 
-static int consolidate_op_arg(struct tep_print_arg *arg)
+static int consolidate_op_arg(	enum tep_event_type type, struct tep_print_arg *arg)
 {
 	unsigned long long val, left, right;
 	int ret = 0;
 
+	if (type == TEP_EVENT_ERROR)
+		return -1;
+
 	if (arg->type != TEP_PRINT_OP)
 		return 0;
 
 	if (arg->op.left)
-		ret = consolidate_op_arg(arg->op.left);
+		ret = consolidate_op_arg(type, arg->op.left);
 	if (ret < 0)
 		return ret;
 
 	if (arg->op.right)
-		ret = consolidate_op_arg(arg->op.right);
+		ret = consolidate_op_arg(type, arg->op.right);
 	if (ret < 0)
 		return ret;
 
@@ -2375,8 +2378,6 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 		/* it will set arg->op.right */
 		type = process_cond(event, arg, tok);
-		if (type == TEP_EVENT_ERROR)
-			free(token);
 
 	} else if (strcmp(token, ">>") == 0 ||
 		   strcmp(token, "<<") == 0 ||
@@ -2587,7 +2588,7 @@ static int alloc_and_process_delim(struct tep_event *event, char *next_token,
 	if (type == TEP_EVENT_OP) {
 		type = process_op(event, field, &token);
 
-		if (consolidate_op_arg(field) < 0)
+		if (consolidate_op_arg(type, field) < 0)
 			type = TEP_EVENT_ERROR;
 
 		if (type == TEP_EVENT_ERROR)
@@ -3818,7 +3819,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 			type = process_op(event, arg, &token);
 			free_token(token);
 
-			if (consolidate_op_arg(arg) < 0)
+			if (consolidate_op_arg(type, arg) < 0)
 				type = TEP_EVENT_ERROR;
 
 			if (type == TEP_EVENT_ERROR) {


-- Steve
