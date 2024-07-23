Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0950B1448D8
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2024 22:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721772518; cv=none; b=spROo9+tuFspNkXDX0CxWqdYxUqfOKHxnRMMgFkAMoLQG9MSQNNhdn/3JHkK/Rm8iY8UbI9iJux7yKYzsmF0Os5NXSXK8CQgFggGfbYzJ8bA4+Z8vPsBhAwpg+PiupFkJTELlPGslZFYyTNUbQ51DlMjU7NpWHA0Octaaof4RNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721772518; c=relaxed/simple;
	bh=ICudxA5cKjcIndP05XQI+uWbSyR2pzGGZzY57Q61E2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNah3vksgRzKAzq6RkxLBUsXPB7nHvPRZKa/cD4oWye93MugtxG6KUZ/r/pNF7i06RHzfj0Z3CMDvViZkkb57uaRPYqJvzXK61UBNFzVRaQZ3stM92Sq5le2V8AVnJ/PaipQldXjIOr5W4WAtAEqmYbGLuCiUxSo64ezcU66Hpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B12C4AF0A;
	Tue, 23 Jul 2024 22:08:37 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1sWNgk-000000023Fy-2x1t;
	Tue, 23 Jul 2024 18:08:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtracefs: Enable mmapped ring buffer
Date: Tue, 23 Jul 2024 18:07:23 -0400
Message-ID: <20240723220853.489058-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240723220853.489058-1-rostedt@goodmis.org>
References: <20240723220853.489058-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As of v6.10, ring buffer user space mapping is now supported by the Linux
kernel. This also means that it is an official API. Copy the latest API from
that kernel into the trace_mmap.h file and make it accessible to user space
programs.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-mmap.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index a0130bbc1cbe..44d1597f1ba5 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -22,8 +22,8 @@
  * @entries:		Number of entries in the ring-buffer.
  * @overrun:		Number of entries lost in the ring-buffer.
  * @read:		Number of entries that have been read.
- * @Reserved1:		Reserved for future use.
- * @Reserved2:		Reserved for future use.
+ * @Reserved1:		Internal use only.
+ * @Reserved2:		Internal use only.
  */
 struct trace_buffer_meta {
 	__u32		meta_page_size;
@@ -48,7 +48,7 @@ struct trace_buffer_meta {
 	__u64	Reserved2;
 };
 
-#define TRACE_MMAP_IOCTL_GET_READER		_IO('T', 0x1)
+#define TRACE_MMAP_IOCTL_GET_READER		_IO('R', 0x20)
 
 struct trace_mmap {
 	struct trace_buffer_meta	*map;
@@ -78,10 +78,6 @@ __hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
 	void *meta;
 	void *data;
 
-#ifndef FORCE_MMAP_ENABLE
-	return NULL;
-#endif
-
 	page_size = getpagesize();
 	meta = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
 	if (meta == MAP_FAILED)
-- 
2.43.0

