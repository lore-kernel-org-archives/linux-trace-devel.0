Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B45355C04
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 20:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9113DC433C7;
	Mon,  8 Jan 2024 20:13:41 +0000 (UTC)
Date: Mon, 8 Jan 2024 15:14:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v3] kbuffer: Update kbuf->next in kbuffer_refresh
Message-ID: <20240108151437.3c23a4f9@gandalf.local.home>
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

If the kbuffer was read to completion, the kbuf->curr would equal both the
size and kbuf->next. The kbuffer_refresh() is to update the kbuf if more
data was added to the buffer. But if curr is at the end, the next pointer
was not updated, which is incorrect. The next pointer needs to be moved to
the end of the newly written event.

Update the pointers in kbuffer_refresh() just as if it was loaded new (but
still keeping curr at the correct location).

Fixes: 7a4d5b24 ("kbuffer: Add kbuffer_refresh() API")
Reported-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v2: https://lore.kernel.org/linux-trace-devel/20240108123859.32db3407@gandalf.local.home

- Remove leftover prototypes of old_update_pointers() and update_pointers()
  that was needed for v1 but not v2.

 src/kbuffer-parse.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 691d53678f5f..9b7278036ba8 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -180,6 +180,7 @@ static int calc_index(struct kbuffer *kbuf, void *ptr)
 	return (unsigned long)ptr - (unsigned long)kbuf->data;
 }
 
+static int next_event(struct kbuffer *kbuf);
 static int __next_event(struct kbuffer *kbuf);
 
 /*
@@ -309,13 +310,20 @@ void kbuffer_free(struct kbuffer *kbuf)
 int kbuffer_refresh(struct kbuffer *kbuf)
 {
 	unsigned long long flags;
+	unsigned int old_size;
 
 	if (!kbuf || !kbuf->subbuffer)
 		return -1;
 
+	old_size = kbuf->size;
+
 	flags = read_long(kbuf, kbuf->subbuffer + 8);
 	kbuf->size = (unsigned int)flags & COMMIT_MASK;
 
+	/* Update next to be the next element */
+	if (kbuf->size != old_size && kbuf->curr == kbuf->next)
+		next_event(kbuf);
+
 	return 0;
 }
 
-- 
2.43.0

