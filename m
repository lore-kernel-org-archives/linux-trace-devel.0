Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654E354FBB
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 17:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FBDC433C9;
	Mon,  8 Jan 2024 17:33:24 +0000 (UTC)
Date: Mon, 8 Jan 2024 12:34:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2] kbuffer: Always walk the events to calculate timestamp
 in kbuffer_read_buffer()
Message-ID: <20240108123420.5e227075@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the buffer to read the kbuffer subbuffer is big enough to hold the
entire buffer, it was simply copied. But this is not good enough, as the
next read should include the events after what was copied. That means the
timestamps need to be calculated.

Just copying the data is not enough as the timestamp of any event is an
offset of the previous event. To know the event timestamp after what was
copied, the timestamps of the events before it need to be read, to know
what the offset is against of the following event.

Link: https://lore.kernel.org/linux-trace-devel/ZZwFvyGvm0C38eBh@google.com/

Fixes: 05821189 ("kbuffer: Add kbuffer_read_buffer()")
Reported-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes from v1: https://lore.kernel.org/linux-trace-devel/20240105194015.253165-3-rostedt@goodmis.org
 (which was originally: kbuffer: Add event if the buffer just fits in kbuffer_read_buffer()

 - Do not just fix the copying by the off-by-one error, but instead always
   read all events to copy to calculate the timestamp (Vincent Donnefort)

 src/kbuffer-parse.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index d43fe5d972fd..691d53678f5f 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -947,19 +947,12 @@ kbuffer_raw_get(struct kbuffer *kbuf, void *subbuf, struct kbuffer_raw_info *inf
  */
 int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 {
-	int subbuf_size = kbuf->start + kbuf->size;
 	unsigned long long ts;
 	unsigned int type_len_ts;
 	bool do_swap = false;
 	int last_next;
 	int save_curr;
 
-	if (!kbuf->curr && len >= subbuf_size) {
-		memcpy(buffer, kbuf->subbuffer, subbuf_size);
-		set_curr_to_end(kbuf);
-		return kbuf->size;
-	}
-
 	/* Are we at the end of the buffer */
 	if (kbuf->curr >= kbuf->size)
 		return 0;
@@ -982,24 +975,13 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 
 	save_curr = kbuf->curr;
 
-	/* Copy the rest of the buffer if it fits */
-	if (len >= kbuf->size - kbuf->curr) {
-		set_curr_to_end(kbuf);
-		last_next = kbuf->size;
-	} else {
-		/*
-		 * The length doesn't hold the rest,
-		 * need to find the last that fits
-		 */
+	/* Due to timestamps, we must save the current next to use */
+	last_next = kbuf->next;
 
-		/* Due to timestamps, we must save the current next to use */
+	while (len >= kbuf->next - save_curr) {
 		last_next = kbuf->next;
-
-		while (len > kbuf->next - save_curr) {
-			last_next = kbuf->next;
-			if (!kbuffer_next_event(kbuf, &ts))
-				break;
-		}
+		if (!kbuffer_next_event(kbuf, &ts))
+			break;
 	}
 
 	len = last_next - save_curr;
-- 
2.43.0

