Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB061D0DCB
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2024 19:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728676072; cv=none; b=feDYD64vqir7C5yC9+QqHHxF0vV51cynocEWeQaYf34LJY2bGfT90TjZ/x8HBkTqCDOzxrsiLES3IpkqgTSwzzbPkNtwfgb1pE9q2M8lfITB6sE6DuWnbV4OIZhslcz2w+VyVMw/MwKePTttdB1xbBDL5K7OvNz2yHAbpXpAWG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728676072; c=relaxed/simple;
	bh=H26EmBp/rdIU4xd04GDYNNVqR6G2sNlMn1wIW0MWDp4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=fKQ8BqS4gzAHcnEB6xy+vu+aXJCA9b4OniiApCrCMQnLTYUKCfZwnxQ5GhIw8bndrwvKst4Ad+2fQWhW8hYV6kT4O8318POFMYOdCC9zMUhv4T86ZXb4U9P24S5lEdu12/O4n0N+NIgeIYtsoWnOGNDPbCRg1WAS8wfJB6o9Yc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F47C4CEC3
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2024 19:47:51 +0000 (UTC)
Date: Fri, 11 Oct 2024 15:48:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Have sizeof() parsing handle u8/s8 through
 u64/s64
Message-ID: <20241011154801.6e237662@gandalf.local.home>
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

The sizeof() may be used for common types like:

 __u8, __s8, u8, s8,
 __u16, __s16, u16, s16,
 __u32, __s32, u32, s32,
 __u64, __s64, u64, s64

Handle them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index ddeb3b9909c0..73563c8e9dea 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3571,6 +3571,23 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 			/* The token is the next token */
 			token_has_paren = true;
 		}
+
+	} else if (strcmp(token, "__u64") == 0 || strcmp(token, "u64") == 0 ||
+		   strcmp(token, "__s64") == 0 || strcmp(token, "s64") == 0) {
+		arg->atom.atom = strdup("8");
+
+	} else if (strcmp(token, "__u32") == 0 || strcmp(token, "u32") == 0 ||
+		   strcmp(token, "__s32") == 0 || strcmp(token, "s32") == 0) {
+		arg->atom.atom = strdup("4");
+
+	} else if (strcmp(token, "__u16") == 0 || strcmp(token, "u16") == 0 ||
+		   strcmp(token, "__s16") == 0 || strcmp(token, "s16") == 0) {
+		arg->atom.atom = strdup("2");
+
+	} else if (strcmp(token, "__u8") == 0 || strcmp(token, "u8") == 0 ||
+		   strcmp(token, "__8") == 0 || strcmp(token, "s8") == 0) {
+		arg->atom.atom = strdup("1");
+
 	} else if (strcmp(token, "REC") == 0) {
 
 		free_token(token);
-- 
2.45.2

