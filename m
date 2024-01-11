Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACF258106
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD21DC433C7
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:11:03 +0000 (UTC)
Date: Thu, 11 Jan 2024 17:12:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Fix free_zpage() offset
Message-ID: <20240111171207.54d7cdbf@gandalf.local.home>
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

The offset exposed to the callers of libtracecmd is the uncompressed file
offset. The read_zpage() subtracts the fake uncompressed offset to get to
the compressed data offset.

The free_zpage() did not subtract the uncompressed offset so it was not
finding the cached compressed data it was looking for to free, and left the
page not freed.

Subtract the uncompressed file offset from the passed in offset to find the
cached node to free.

Fixes: add83e0c8b511 ("trace-cmd library: Fix tracecmd_read_at()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 88bef83f4fe0..e0194f89e5db 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1384,6 +1384,8 @@ static void free_zpage(struct cpu_data *cpu_data, off_t offset)
 	struct trace_rbtree_node *node;
 	struct zchunk_cache *cache;
 
+	offset -= cpu_data->file_offset;
+
 	node = trace_rbtree_find(&cpu_data->compress.cache, (void *)&offset);
 
 	if (!node)
-- 
2.43.0

