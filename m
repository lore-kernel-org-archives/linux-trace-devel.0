Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00EF6AA7
	for <linux-trace-devel@vger.kernel.org>; Wed,  2 Apr 2025 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743610921; cv=none; b=s+O74bF1RXXC1o7+7FoTYou0MU4ZtBb5WscRM1XrEHu+aJOy6VYwGnPaGI3LxNJzO9u+bG0GYkb4SJXs0Tu4gWCbaPQfYly8eF2bnm/qi+etm0EOx+oYwbK3rOs8gs+u+rqlPYZZiVxg0GQlW6J9ftgIYJ1vq82T+p3Br254WnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743610921; c=relaxed/simple;
	bh=9OPKcAcRDkB4W1C+gT1fvrqGReVIAjXutybN98vztXM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=kPZ3SQbz6U600DD7uwOwYGyYbVlSzLWGN5ZErw7W7XQhqnqSc549LqKjOAewWAVpqkgDRk+05gVWowgQd/lxkqj4FP0i2dbD0BM2dv3DKpexfciZ9n7Yy4/EW+dNAiWWZw17l8rqOcS0AiwYTxG+mr864FXbOiiQRhkVzEcjUUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E5CC4CEDD
	for <linux-trace-devel@vger.kernel.org>; Wed,  2 Apr 2025 16:22:00 +0000 (UTC)
Date: Wed, 2 Apr 2025 12:23:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add NEED_RESCHED_LAZY flag
Message-ID: <20250402122303.70ba14fa@gandalf.local.home>
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

Starting with v6.13 the IRQS_NOSUPPORT latency flag was replaced by the
NEED_RSCHED_LAZY flag. Update the library to do the same.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceevent/event-parse.h | 2 +-
 src/event-parse.c                | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 2b39b38..1a7984b 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -406,7 +406,7 @@ static inline int tep_is_bigendian(void)
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
-	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
+	TRACE_FLAG_NEED_RESCHED_LAZY	= 0x02,
 	TRACE_FLAG_NEED_RESCHED		= 0x04,
 	TRACE_FLAG_HARDIRQ		= 0x08,
 	TRACE_FLAG_SOFTIRQ		= 0x10,
diff --git a/src/event-parse.c b/src/event-parse.c
index f2e50b0..dcaf27b 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6809,11 +6809,9 @@ static void data_latency_format(struct tep_handle *tep, struct trace_seq *s,
 	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
 
 	trace_seq_printf(&sq, "%c%c%c",
-	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
-	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
-	       'X' : '.',
+	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
 	       (lat_flags & TRACE_FLAG_NEED_RESCHED) ?
-	       'N' : '.',
+	       'N' : (lat_flags &  TRACE_FLAG_NEED_RESCHED_LAZY) ? 'L' :'.',
 	       (hardirq && softirq) ? 'H' :
 	       hardirq ? 'h' : softirq ? 's' : '.');
 
-- 
2.47.2

