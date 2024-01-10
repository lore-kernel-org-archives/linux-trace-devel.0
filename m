Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A05428E8
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE7FC433B2;
	Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNOqD-00000000LLb-2KMx;
	Tue, 09 Jan 2024 22:01:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/7] libtracefs: Have mapping work with the other tracefs_cpu* functions
Date: Tue,  9 Jan 2024 21:51:45 -0500
Message-ID: <20240110030116.81837-2-rostedt@goodmis.org>
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

If the tracefs_cpu is opened with tracefs_cpu_open_mapped() and it
successfully maps, then still allow the other tracefs_cpu*() functions to
work with the mapping. That is:

 tracefs_cpu_buffered_read() will act like tracefs_cpu_read()
 tracefs_cpu_buffered_read_buf() will act like tracefs_cpu_read_buf()

and tracefs_cpu_write() and tracefs_cpu_pipe() will read from the mapping
instead of using splice.

Update tracefs_iterate_raw_events() to always use
tracefs_cpu_buffered_read_buf() as it will do the right thing when buffered.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-cpu-map.txt | 29 +++++++++++++++++++++------
 src/tracefs-events.c                 |  8 +-------
 src/tracefs-record.c                 | 30 ++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/Documentation/libtracefs-cpu-map.txt b/Documentation/libtracefs-cpu-map.txt
index 2c80d0894f87..ed62c96f83a1 100644
--- a/Documentation/libtracefs-cpu-map.txt
+++ b/Documentation/libtracefs-cpu-map.txt
@@ -29,11 +29,16 @@ memory mapping via either *tracefs_cpu_map()* or by *tracefs_cpu_open_mapped()*
 then the functions *tracefs_cpu_read*(3) and *tracefs_cpu_read_buf*(3) will use
 the mapping directly instead of calling the read system call.
 
-Note, mapping can also slow down *tracefs_cpu_buffered_read*(3) and
-*tracefs_cpu_buffered_read_buf*(3), as those use splice piping and when the
-kernel ring buffer is memory mapped, splice does a copy instead of using the
-ring buffer directly. Thus care must be used when determining to map the
-ring buffer or not, and why it does not get mapped by default.
+Note, mapping will cause *tracefs_cpu_buffered_read*(3) and *tracefs_cpu_buffered_read_buf*(3)
+to act just like *tracefs_cpu_read*(3) and *tracefs_cpu_read_buf*(3) respectively
+as it doesn't make sense to use a splice pipe when mapped. The kernel will do
+a copy for splice reads on mapping, and then another copy in the function when
+it can avoid the copying if the ring buffer is memory mapped.
+
+If the _tcpu_ is memory mapped it will also force *tracefs_cpu_write*(3) and
+*tracefs_cpu_pipe*(3) to copy from the mapping instead of using splice.
+Thus care must be used when determining to map the ring buffer or not,
+and why it does not get mapped by default.
 
 The *tracefs_cpu_is_mapped()* function will return true if _tcpu_ currently has
 its ring buffer memory mapped and false otherwise. This does not return whether or
@@ -78,6 +83,7 @@ static void read_subbuf(struct tep_handle *tep, struct kbuffer *kbuf)
 {
 	static struct trace_seq seq;
 	struct tep_record record;
+	int missed_events;
 
 	if (seq.buffer)
 		trace_seq_reset(&seq);
@@ -86,6 +92,14 @@ static void read_subbuf(struct tep_handle *tep, struct kbuffer *kbuf)
 
 	while ((record.data = kbuffer_read_event(kbuf, &record.ts))) {
 		record.size = kbuffer_event_size(kbuf);
+		missed_events = kbuffer_missed_events(kbuf);
+		if (missed_events) {
+			printf("[MISSED EVENTS");
+			if (missed_events > 0)
+				printf(": %d]\n", missed_events);
+			else
+				printf("]\n");
+		}
 		kbuffer_next_event(kbuf, NULL);
 		tep_print_event(tep, &seq, &record,
 				"%s-%d %6.1000d\t%s: %s\n",
@@ -128,7 +142,10 @@ int main (int argc, char **argv)
 
 	/*
 	 * If this kernel supports mapping, use normal read,
-	 * otherwise use the piped buffer read.
+	 * otherwise use the piped buffer read, although if
+	 * the mapping succeeded, tracefs_cpu_buffered_read_buf()
+	 * acts the same as tracefs_cpu_read_buf(). But this is just
+	 * an example on how to use tracefs_cpu_is_mapped().
 	 */
 	mapped = tracefs_cpu_is_mapped(tcpu);
 	if (!mapped)
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 9f620abebdda..1b1693cf0923 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -32,7 +32,6 @@ struct cpu_iterate {
 	struct tep_event *event;
 	struct kbuffer *kbuf;
 	int cpu;
-	bool mapped;
 };
 
 static int read_kbuf_record(struct cpu_iterate *cpu)
@@ -67,11 +66,7 @@ int read_next_page(struct tep_handle *tep, struct cpu_iterate *cpu)
 	if (!cpu->tcpu)
 		return -1;
 
-	/* Do not do buffered reads if it is mapped */
-	if (cpu->mapped)
-		kbuf = tracefs_cpu_read_buf(cpu->tcpu, true);
-	else
-		kbuf = tracefs_cpu_buffered_read_buf(cpu->tcpu, true);
+	kbuf = tracefs_cpu_buffered_read_buf(cpu->tcpu, true);
 	/*
 	 * tracefs_cpu_buffered_read_buf() only reads in full subbuffer size,
 	 * but this wants partial buffers as well. If the function returns
@@ -295,7 +290,6 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 
 		tmp[i].tcpu = tcpu;
 		tmp[i].cpu = cpu;
-		tmp[i].mapped = tracefs_cpu_is_mapped(tcpu);
 		i++;
 	}
 	*count = i;
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index fca3ddf9afbe..881f49256dc2 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -571,6 +571,9 @@ int tracefs_cpu_buffered_read(struct tracefs_cpu *tcpu, void *buffer, bool nonbl
 	if (ret <= 0)
 		return ret;
 
+	if (tcpu->mapping)
+		return trace_mmap_read(tcpu->mapping, buffer);
+
 	if (tcpu->flags & TC_NONBLOCK)
 		mode |= SPLICE_F_NONBLOCK;
 
@@ -617,6 +620,16 @@ struct kbuffer *tracefs_cpu_buffered_read_buf(struct tracefs_cpu *tcpu, bool non
 {
 	int ret;
 
+	/* If mapping is enabled, just use it directly */
+	if (tcpu->mapping) {
+		ret = wait_on_input(tcpu, nonblock);
+		if (ret <= 0)
+			return NULL;
+
+		ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf);
+		return ret > 0 ? tcpu->kbuf : NULL;
+	}
+
 	if (!get_buffer(tcpu))
 		return NULL;
 
@@ -795,6 +808,20 @@ int tracefs_cpu_write(struct tracefs_cpu *tcpu, int wfd, bool nonblock)
 	int tot;
 	int ret;
 
+	if (tcpu->mapping) {
+		int r = tracefs_cpu_read(tcpu, buffer, nonblock);
+		if (r < 0)
+			return r;
+		do {
+			ret = write(wfd, buffer, r);
+			if (ret < 0)
+				return ret;
+			r -= ret;
+			tot_write += ret;
+		} while (r > 0);
+		return tot_write;
+	}
+
 	ret = wait_on_input(tcpu, nonblock);
 	if (ret <= 0)
 		return ret;
@@ -860,6 +887,9 @@ int tracefs_cpu_pipe(struct tracefs_cpu *tcpu, int wfd, bool nonblock)
 	int mode = SPLICE_F_MOVE;
 	int ret;
 
+	if (tcpu->mapping)
+		return tracefs_cpu_write(tcpu, wfd, nonblock);
+
 	ret = wait_on_input(tcpu, nonblock);
 	if (ret <= 0)
 		return ret;
-- 
2.43.0

