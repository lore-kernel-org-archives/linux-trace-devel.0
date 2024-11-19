Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13E41D0B8A
	for <linux-trace-devel@vger.kernel.org>; Tue, 19 Nov 2024 20:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732047456; cv=none; b=PfyDEhRq+rHOM0o5SaaYx1drUh/0DzC0nfTtmtnXn4OeEYg/Rwf6LY2Bz/P5Lh75CQQ1wYN4f3Q6edrTvDSxzOkOIiYFcJZrLV314JGexOrcwAXulO3ujhIaTYXFG8PfJs/EFZObW/jxGD1JADYK/O9zbLCRLl50lwyUnZgB3f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732047456; c=relaxed/simple;
	bh=bHeqDmCOeTsqzA201ik6WWwK2h4Exqp2u2ibz2D3EUY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=GQHT4AszFGcdUUm4Wpv8EnvBM9eYgGjZSPsUV3PLUGqBz/E1jQnlzLh84h1GD11hc8ah31IvfRZwkPxek6UfLxCIbS5LtuCfGd5bD+EotQSs6XjkmJVWSANAkfYA0dTU9B4STxghfrxWhV1mBMiaINX+iVur1dTWpnQDs4Aebkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E1BC4CED1;
	Tue, 19 Nov 2024 20:17:35 +0000 (UTC)
Date: Tue, 19 Nov 2024 15:18:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Subject: [PATCH] libtraceevent: Handle case of unknown operator
Message-ID: <20241119151809.4da5f874@gandalf.local.home>
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

The m68k architecture had a trace event with "m68k_memory[0].addr >> 13"
in it. The parsing after the ']' and before the '.' checked the priority
of the '.' but because it does not handle '.' as an operator it returned a
negative number. But process_op() did not check for an error and continued
processing. This caused a segfault.

Return immediately if the operator is not handled by get_op_prio().

Link: https://lore.kernel.org/all/20241119112850.219834f5@gandalf.local.home/

Reported-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Fixes: 6582b0aea1cc ("tools/events: Add files to create libtraceevent.a")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index 0427061603db..a6da8f04cbf3 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2498,6 +2498,10 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 		/* higher prios need to be closer to the root */
 		prio = get_op_prio(*tok);
+		if (prio < 0) {
+			token = *tok;
+			goto out_free;
+		}
 
 		if (prio > arg->op.prio)
 			return process_op(event, arg, tok);
-- 
2.45.2

