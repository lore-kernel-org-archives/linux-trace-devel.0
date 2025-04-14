Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CD6E571
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Apr 2025 19:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744659235; cv=none; b=dpDJQ+IoPVMwNenRPe50uuTBKEJBczGUtOR8KrAH43IBdCjiMyYvCTRlQ/QHEi/zbiSKEpV07zZlX0TXBxDeeUo9cpWuQBpQcib1f5+35gIXJl8ysSTF1q9r2/yF9OeSwwKzgstFS/C0OktuL1TK1VFXqPOhAyFZm3Fzfvbfj2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744659235; c=relaxed/simple;
	bh=DRY/f6RlohY6irFQQjU9uDlK+rydrKVUAKbZf8TQkhs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=au6jSlhA45yih/vjKotrOapc6hY9HxYiHKm7oJtTIr7pVrjBXlbDrGI2ZBEgpQLqDjs/rQfMPLRUd0uIx4iYqmxXhsjhr3pmMjS8PIHsBodhMIz6iyNcjcx9watxF/deMLLlakPWttkM5qGGXi0AQCyFuTm7qfqUWTk1OU9PvfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86980C4CEE2;
	Mon, 14 Apr 2025 19:33:54 +0000 (UTC)
Date: Mon, 14 Apr 2025 15:35:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH] libtraceevent: Add support for nested ?: conditionals
Message-ID: <20250414153526.25bb71db@gandalf.local.home>
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

It was reported that nested ?: conditionals were broken in libtraceevent.
Specifically, the following did not parse correctly:

	REC->severity == AER_CORRECTABLE ? "Corrected" :
		REC->severity == AER_FATAL ?
		"Fatal" : "Uncorrected, non-fatal",

That was due to the second half of the ':' operator was not being evaluated.

Link: https://lore.kernel.org/all/20250414153835.947207-1-sargun@sargun.me/

Reported-by: Borislav Petkov <bp@alien8.de>
Reported-by: Sargun Dhillon <sargun@sargun.me>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index ba6e42b..aa16d83 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2083,6 +2083,16 @@ process_cond(struct tep_event *event, struct tep_print_arg *top, char **tok)
 
 	type = process_arg(event, right, &token);
 
+ againagain:
+	if (type == TEP_EVENT_ERROR)
+		goto out_free;
+
+	/* Handle other operations in the results */
+	if (type == TEP_EVENT_OP) {
+		type = process_op(event, right, &token);
+		goto againagain;
+	}
+
 	top->op.right = arg;
 
 	*tok = token;
-- 
2.47.2

