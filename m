Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B20C23B1
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2506C433C7;
	Wed, 10 Jan 2024 03:00:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNOqD-00000000LLh-2Y4p;
	Tue, 09 Jan 2024 22:01:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/7] libtracefs: Have nonblock tracefs_cpu reads set errno EAGAIN
Date: Tue,  9 Jan 2024 21:51:47 -0500
Message-ID: <20240110030116.81837-4-rostedt@goodmis.org>
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

If ring buffer memory mapping is used, and nothing is available to read on
the buffer, and nonblock is set, still update errno to EAGAIN.

Also always return subbuf_size when any data was read, and zero out the
rest of the buffer just like the kernel would do.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-record.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 881f49256dc2..59260da0e32c 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -402,6 +402,25 @@ static int wait_on_input(struct tracefs_cpu *tcpu, bool nonblock)
 	return FD_ISSET(tcpu->fd, &rfds);
 }
 
+/* If nonblock is set, set errno to EAGAIN on no data */
+static int mmap_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
+{
+	void *mapping = tcpu->mapping;
+	int ret;
+
+	ret = trace_mmap_read(mapping, buffer);
+	if (ret <= 0) {
+		if (!ret && nonblock)
+			errno = EAGAIN;
+		return ret;
+	}
+
+	/* Write full sub-buffer size, but zero out empty space */
+	if (ret < tcpu->subbuf_size)
+		memset(buffer + ret, 0, tcpu->subbuf_size - ret);
+	return tcpu->subbuf_size;
+}
+
 /**
  * tracefs_cpu_read - read from the raw trace file
  * @tcpu: The descriptor representing the raw trace file
@@ -433,7 +452,7 @@ int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
 		return ret;
 
 	if (tcpu->mapping)
-		return trace_mmap_read(tcpu->mapping, buffer);
+		return mmap_read(tcpu, buffer, nonblock);
 
 	ret = read(tcpu->fd, buffer, tcpu->subbuf_size);
 
@@ -572,7 +591,7 @@ int tracefs_cpu_buffered_read(struct tracefs_cpu *tcpu, void *buffer, bool nonbl
 		return ret;
 
 	if (tcpu->mapping)
-		return trace_mmap_read(tcpu->mapping, buffer);
+		return mmap_read(tcpu, buffer, nonblock);
 
 	if (tcpu->flags & TC_NONBLOCK)
 		mode |= SPLICE_F_NONBLOCK;
@@ -704,7 +723,7 @@ int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer)
 		tcpu->buffered = 0;
 
 	if (tcpu->mapping)
-		return trace_mmap_read(tcpu->mapping, buffer);
+		return mmap_read(tcpu, buffer, false);
 
 	if (tcpu->buffered) {
 		ret = read(tcpu->splice_pipe[0], buffer, tcpu->subbuf_size);
-- 
2.43.0

