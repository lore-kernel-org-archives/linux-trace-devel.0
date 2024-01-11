Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C09458106
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76670C433F1
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:12:49 +0000 (UTC)
Date: Thu, 11 Jan 2024 17:13:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Return NULL if page is NULL in
 peek_last_event()
Message-ID: <20240111171352.5bd23613@gandalf.local.home>
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

If the handle->cpu_data[cpu].page has been freed and cleared, consider the
last event to be empty. This can happen if the buffer size is zero.

 (Should we add a warning if page is NULL and size is not zero?)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f458dcec68a8..a10d74cf6cf4 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2973,6 +2973,10 @@ static struct tep_record *peek_last_event(struct tracecmd_input *handle,
 	if (record)
 		return record;
 
+	/* page can be NULL if the size is zero */
+	if (!page)
+		return NULL;
+
 	page_offset = page->offset - handle->page_size;
 	if (page_offset < handle->cpu_data[cpu].file_offset)
 		return NULL;
-- 
2.43.0

