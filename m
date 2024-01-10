Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1771871
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0256CC433F1;
	Wed, 10 Jan 2024 03:00:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNOqD-00000000LLr-2loH;
	Tue, 09 Jan 2024 22:01:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5/7] libtracefs: Call mmap ioctl if a refresh happens
Date: Tue,  9 Jan 2024 21:51:49 -0500
Message-ID: <20240110030116.81837-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240110030116.81837-1-rostedt@goodmis.org>
References: <20240110030116.81837-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the reader sub-buffer gets more data on it due to a writer still on the
reader sub-buffer, just updating the kbuf is not enough. An ioctl() needs to
be called again to update the "read" pointer, otherwise after reading the
full reader sub-buffer and calling the next ioctl(), the kernel will not
swap out for a new reader sub-buffer as it still thinks there's more to be
read.

Fixes: 2ed14b594f669 ("libtracefs: Add ring buffer memory mapping APIs")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-mmap.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index e0e37681e019..499233ae396c 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -143,6 +143,11 @@ __hidden void trace_unmap(void *mapping)
 	free(tmap);
 }
 
+static int get_reader(struct trace_mmap *tmap)
+{
+	return ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER);
+}
+
 __hidden int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
 {
 	struct trace_mmap *tmap = mapping;
@@ -171,11 +176,18 @@ __hidden int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
 	kbuffer_refresh(kbuf);
 
 	/* Are there still events to read? */
-	if (kbuffer_curr_size(kbuf))
+	if (kbuffer_curr_size(kbuf)) {
+		/* If current is greater than what was read, refresh */
+		if (kbuffer_curr_offset(kbuf) + kbuffer_curr_size(kbuf) >
+		    tmap->map->reader.read) {
+			if (get_reader(tmap) < 0)
+				return -1;
+		}
 		return 1;
+	}
 
 	/* See if a new page is ready? */
-	if (ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER) < 0)
+	if (get_reader(tmap) < 0)
 		return -1;
 	id = tmap->map->reader.id;
 	data = tmap->data + tmap->map->subbuf_size * id;
-- 
2.43.0

