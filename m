Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7198D3D988
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBD5C43399;
	Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNJ45-00000000JKO-1LE2;
	Tue, 09 Jan 2024 15:51:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] libtracefs: Use tracefs_cpu_*_buf() calls for iterator
Date: Tue,  9 Jan 2024 15:48:57 -0500
Message-ID: <20240109205112.74225-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240109205112.74225-1-rostedt@goodmis.org>
References: <20240109205112.74225-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The iterators were created before the tracefs_cpu_buffered_read_buf() and
tracefs_cpu_flush_buf() which returns a kbuffer to iterate. Instead of
having to manage its own kbuffer, use the one that is managed by the
tracefs_cpu.

This will also allow the iterator to use the memory mapping code.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 49 ++++++++------------------------------------
 1 file changed, 9 insertions(+), 40 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 3c844b0ab408..2571c4b43341 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -31,8 +31,6 @@ struct cpu_iterate {
 	struct tep_record record;
 	struct tep_event *event;
 	struct kbuffer *kbuf;
-	void *page;
-	int psize;
 	int cpu;
 };
 
@@ -63,46 +61,24 @@ static int read_kbuf_record(struct cpu_iterate *cpu)
 
 int read_next_page(struct tep_handle *tep, struct cpu_iterate *cpu)
 {
-	enum kbuffer_long_size long_size;
-	enum kbuffer_endian endian;
-	int r;
+	struct kbuffer *kbuf;
 
 	if (!cpu->tcpu)
 		return -1;
 
-	r = tracefs_cpu_buffered_read(cpu->tcpu, cpu->page, true);
+	kbuf = tracefs_cpu_buffered_read_buf(cpu->tcpu, true);
 	/*
-	 * tracefs_cpu_buffered_read() only reads in full subbuffer size,
+	 * tracefs_cpu_buffered_read_buf() only reads in full subbuffer size,
 	 * but this wants partial buffers as well. If the function returns
-	 * empty (-1 for EAGAIN), try tracefs_cpu_read() next, as that can
+	 * empty (-1 for EAGAIN), try tracefs_cpu_flush_buf() next, as that can
 	 * read partially filled buffers too, but isn't as efficient.
 	 */
-	if (r <= 0)
-		r = tracefs_cpu_read(cpu->tcpu, cpu->page, true);
-	if (r <= 0)
+	if (!kbuf)
+		kbuf = tracefs_cpu_flush_buf(cpu->tcpu);
+	if (!kbuf)
 		return -1;
 
-	if (!cpu->kbuf) {
-		if (tep_is_file_bigendian(tep))
-			endian = KBUFFER_ENDIAN_BIG;
-		else
-			endian = KBUFFER_ENDIAN_LITTLE;
-
-		if (tep_get_header_page_size(tep) == 8)
-			long_size = KBUFFER_LSIZE_8;
-		else
-			long_size = KBUFFER_LSIZE_4;
-
-		cpu->kbuf = kbuffer_alloc(long_size, endian);
-		if (!cpu->kbuf)
-			return -1;
-	}
-
-	kbuffer_load_subbuffer(cpu->kbuf, cpu->page);
-	if (kbuffer_subbuffer_size(cpu->kbuf) > r) {
-		tracefs_warning("%s: page_size > %d", __func__, r);
-		return -1;
-	}
+	cpu->kbuf = kbuf;
 
 	return 0;
 }
@@ -314,11 +290,7 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 
 		tmp[i].tcpu = tcpu;
 		tmp[i].cpu = cpu;
-		tmp[i].psize = tracefs_cpu_read_size(tcpu);
-		tmp[i].page =  malloc(tmp[i].psize);
-
-		if (!tmp[i++].page)
-			goto error;
+		i++;
 	}
 	*count = i;
 	return 0;
@@ -326,7 +298,6 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 	tmp = *all_cpus;
 	for (; i >= 0; i--) {
 		tracefs_cpu_close(tmp[i].tcpu);
-		free(tmp[i].page);
 	}
 	free(tmp);
 	*all_cpus = NULL;
@@ -539,9 +510,7 @@ static int iterate_events(struct tep_handle *tep,
 out:
 	if (all_cpus) {
 		for (i = 0; i < count; i++) {
-			kbuffer_free(all_cpus[i].kbuf);
 			tracefs_cpu_close(all_cpus[i].tcpu);
-			free(all_cpus[i].page);
 		}
 		free(all_cpus);
 	}
-- 
2.43.0

