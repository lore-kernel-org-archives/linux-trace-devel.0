Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04832382
	for <linux-trace-devel@vger.kernel.org>; Fri, 30 May 2025 21:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748640093; cv=none; b=jx9n9OhXgIkcKS2JG5AthaHBHRE4XH/MZBX3lx0kSQmiUZtoebdZD4j1AMhDSvf0t2n69SNf6pA5+DLZZlwe859XQI0HZvBUiPnKmKBrWvt0boNMcRI23Ig3iRVxNIJOpkBbjNG7S1HSDwzPXjTrl61S78ot11w1L5PQ9SLFUo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748640093; c=relaxed/simple;
	bh=ku6PbsVuIh3oO/ruRbHiFg25SachU3tUBJCjPCCpWEU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=aBy+q2wWhcRBXVIrGYwJ/RmEajIsnx5rvMu0+xSXDul2IFS5sXfGdFDlmTUTg3alfreD1Kh56Eutebf9zDxc5wpPLsUBhaZCEo0JPPr3i90YO6jMxUDvIUyOU1dcLS4vy4Juccp5WpCLq89L40iLAmuQQjtnqxV+XIitZ23Rpz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3B8C4CEE9
	for <linux-trace-devel@vger.kernel.org>; Fri, 30 May 2025 21:21:32 +0000 (UTC)
Date: Fri, 30 May 2025 17:22:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Save missed events in kbuffer_read_buffer()
Message-ID: <20250530172237.022d21d0@gandalf.local.home>
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

When reading events from a kbuffer, if the kbuf has missed events make sure
to pass that information to the buffer passed to it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/kbuffer-parse.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 9b72780..71291ad 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -958,6 +958,7 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 	unsigned long long ts;
 	unsigned int type_len_ts;
 	bool do_swap = false;
+	int buf_len = len;
 	int last_next;
 	int save_curr;
 
@@ -1009,6 +1010,33 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 
 	write_4(do_swap, buffer + kbuf->start, type_len_ts);
 
+	/*
+	 * If reading the first event and there are lost events, add it
+	 * to the buffer.
+	 */
+	if (!save_curr && kbuf->lost_events) {
+		unsigned long long cnt_8;
+		unsigned int cnt_4;
+		int word_size;
+
+		if (kbuf->flags & KBUFFER_FL_LONG_8)
+			word_size = sizeof(cnt_8);
+		else
+			word_size = sizeof(cnt_4);
+
+		if (len + kbuf->start <= word_size + buf_len) {
+			if (word_size == sizeof(cnt_8)) {
+				cnt_8 = kbuf->lost_events;
+				write_8(do_swap, buffer + len + kbuf->start, cnt_8);
+			} else {
+				cnt_4 = kbuf->lost_events;
+				write_4(do_swap, buffer + len + kbuf->start, cnt_4);
+			}
+			len |= MISSING_STORED;
+		}
+		len |= MISSING_EVENTS;
+	}
+
 	/* Update the size */
 	if (kbuf->read_long == __read_long_8)
 		write_8(do_swap, buffer + 8, len);
-- 
2.47.2

