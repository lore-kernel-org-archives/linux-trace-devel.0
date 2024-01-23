Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4D880037
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 17:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706031127; cv=none; b=MgelySpensSt5Q73/E2IRPPx06KduTiwwxdGA1oSazNgmfF1DSvqJRCFMPXxYGMaZW+qUTen1YicZATdvWYGg5JmGQxl3Po1nYTcMMbHQwgIXwkAwinWQo9kX0S9Pl7dHPNXukRkIpDFOUhECgPyFDHz+8k76VbxeV0oBbzjHZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706031127; c=relaxed/simple;
	bh=o5yzkFt6fI61uII+3i+G5bT1Mu1xxSqaKmtlfIrbE0g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=O8Okr0wNhOLlGjX2Rlf23BEA9DeDEyKirRnkWTEHfNsIoArBuLv1s6DfWkd4UippxspYiAzv+CHrftd9s/7GWlR312u3jGDV4ciqMCwN2E2A48IDevGy7eMNFBpFwdvKH16cYkP4mPDz8IO+vhcdoiH089NeBkeoTvbvkrezMdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6307C433C7;
	Tue, 23 Jan 2024 17:32:06 +0000 (UTC)
Date: Tue, 23 Jan 2024 12:33:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH] libtracefs: Update the kbuf for previous read in
 trace_mmap_load_subbuf()
Message-ID: <20240123123337.1f785f98@gandalf.local.home>
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

The trace_mmap() checks if the mmapped data has any previously read data
(the reader.read value of the meta page is non-zero), then it will pre-read
the kbuf to move its internal reader pointer to the same value.

But when tracefs_cpu_read_buf() calls trace_mmap_load_subbuf(), its
kbuf->subbuffer will not be the same as the mapped data and
kbuffer_load_subbuffer() is called on it and it is returned. But that means
its read pointer has not been updated, and the read data will restart again.

When the kbuf is updated in trace_mmap_load_subbuf() check the tmap->kbuf to
see if it already read any of the data, and move the kbuffer forward just
like the trace_mmap() does.

Link: https://lore.kernel.org/linux-trace-devel/Za-Md51snPcIoYFn@google.com/

Fixes: 2ed14b59 ("libtracefs: Add ring buffer memory mapping APIs")
Reported-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-mmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index d3af453..a288677 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -165,6 +165,12 @@ __hidden int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
 	 */
 	if (data != kbuffer_subbuffer(kbuf)) {
 		kbuffer_load_subbuffer(kbuf, data);
+		/* Move the read pointer forward if need be */
+		if (kbuffer_curr_index(tmap->kbuf)) {
+			int size = kbuffer_curr_offset(tmap->kbuf);
+			char tmpbuf[size];
+			kbuffer_read_buffer(kbuf, tmpbuf, size);
+		}
 		return 1;
 	}
 
-- 
2.43.0

