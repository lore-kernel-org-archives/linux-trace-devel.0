Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D847516D9B2
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 May 2024 15:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716910305; cv=none; b=ap5joXnc29St+yONjF0ZUS/Sx0pu6UW/kGTyrL+t95plr2xTMHUET+PY5TBuuOhceMxCUpaj9AxAkNIOtWmREDnRjmZTIa41r/P71aeHSqX20zws0eMsoZ8i3+gyp++iz7iILcGSf12dzNCg6zV240qswbJUFmx7BnLDLtJIE8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716910305; c=relaxed/simple;
	bh=toBmdSnvtVRrRVzokxVApofs598C5im3lpBARbhxA50=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=mhFtuRRSH+AAIb5k/rPvd7cxF6x1t+V8RmP6hBpYJmSnJqHX28J21OFa2edgWsuyFGzQN8+kxKJECbgtBAQRZhVwm7QbLoEm7F40s44f6hQZpjwI2FGHXVwvcnturn/hIkCLfhmFTUF7Hf2eT0OcVmoz8rjsr6ox/Yr6ZSEpdqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF22C3277B;
	Tue, 28 May 2024 15:31:44 +0000 (UTC)
Date: Tue, 28 May 2024 11:31:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] trace-cmd: Do not print stacks after stacks
Message-ID: <20240528113141.7a3e8a04@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When a filter is in place, the stack trace for the events that are
printed by the filter should also be printed. Stack traces for events
that are filtered out, should also be filtered out. But there was a bug
in the logic that checked if the last event was printed or not to know
to print the stack, and that is, the stack from the printed event was
considered a printed event itself. So a stack trace coming from another
event could be considered "printed" if two stacks came back to back
(which can happen because of interrupts.

Note, this does mean that logic should be added to test for interrupts.
But that's another story.

Reported-by: Vlastimil Babka <vbabka@suse.cz>
Fixes: 82ed4a937 ("trace-cmd library: Add filtering logic for iterating events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-filter.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-filter.c b/lib/trace-cmd/trace-filter.c
index 1c8c07fc..99423223 100644
--- a/lib/trace-cmd/trace-filter.c
+++ b/lib/trace-cmd/trace-filter.c
@@ -47,6 +47,7 @@ static bool test_stacktraces(struct tracecmd_filter *filter, struct tep_record *
 __hidden enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
 						     struct tep_record *record)
 {
+	bool is_stack = false;
 	bool found = false;
 	int ret;
 	int i;
@@ -94,6 +95,8 @@ __hidden enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *fil
 		/* If this is a stack trace and the last event was printed continue */
 		if (!test_stacktraces(filter, record))
 			return TRACECMD_FILTER_MISS;
+
+		is_stack = true;
 	}
 
 	found = false;
@@ -110,7 +113,7 @@ __hidden enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *fil
 	}
 
 	if (filter->last_printed)
-		filter->last_printed[record->cpu] = !found;
+		filter->last_printed[record->cpu] = !is_stack && !found;
 
 	return found ? TRACECMD_FILTER_MISS : TRACECMD_FILTER_MATCH;
 }
-- 
2.43.0

