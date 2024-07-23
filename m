Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094C914430D
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2024 22:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721772518; cv=none; b=RMsYzu9mf5JE+VMIJ5xPVg/+2ra+vvzPUp7oNwk7AKDTBCb11BlR5z7otopWTqTQY97yumapghd+G3vNUzwWrSplv2jCKPTIha+Ush3zVpACZlDLVPBY8rT6ywFSiQndYJbvtxOFECBsocaN30GVpWRPG0+KlOQXs87jR4qm3YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721772518; c=relaxed/simple;
	bh=Fca6sW65qSo/PW/fmQkM8UOqrKriRvFkOT5nMXiIwB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmZAEKzsG2fYFDiLtG7L7hXNz9H05pBWhDo4rCd/NdIlCH4/O1xCTHc/opJCFzGSdbAXQ38vpUA8TRYZGHqYzFjH67TE3SHp6e7ejDYDBzIWQN+RCbpCPL0fdPbZ868fdlvyh0v3YWEaHsVPgA5Vvy+xUpJhBmFpYdhP9GUtK4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BCCC4AF10;
	Tue, 23 Jul 2024 22:08:37 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1sWNgk-000000023G1-34VA;
	Tue, 23 Jul 2024 18:08:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracefs: Add cpu-map sample to trace mapped buffer
Date: Tue, 23 Jul 2024 18:07:24 -0400
Message-ID: <20240723220853.489058-3-rostedt@goodmis.org>
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

Add a sample program that reads the trace buffer with the mapped open.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/Makefile  |  2 ++
 samples/cpu-map.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)
 create mode 100644 samples/cpu-map.c

diff --git a/samples/Makefile b/samples/Makefile
index 81c8006f823e..7b68ae7ad34c 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -67,6 +67,8 @@ $(EXAMPLES): $(patsubst %,$(sdir)/%,$(TARGETS))
 #
 # $(bdir)/XX.o: $(bdir)/XX.c
 #	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
+$(bdir)/cpu-map.o: $(bdir)/cpu-map.c
+	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 $(bdir)/kprobes.o: $(bdir)/kprobes.c
 	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
diff --git a/samples/cpu-map.c b/samples/cpu-map.c
new file mode 100644
index 000000000000..b42742d8d073
--- /dev/null
+++ b/samples/cpu-map.c
@@ -0,0 +1,90 @@
+#include <stdlib.h>
+#include <ctype.h>
+#include <tracefs.h>
+
+static void read_subbuf(struct tep_handle *tep, struct kbuffer *kbuf)
+{
+	static struct trace_seq seq;
+	struct tep_record record;
+	int missed_events;
+
+	if (seq.buffer)
+		trace_seq_reset(&seq);
+	else
+		trace_seq_init(&seq);
+
+	while ((record.data = kbuffer_read_event(kbuf, &record.ts))) {
+		record.size = kbuffer_event_size(kbuf);
+		missed_events = kbuffer_missed_events(kbuf);
+		if (missed_events) {
+			printf("[MISSED EVENTS");
+			if (missed_events > 0)
+				printf(": %d]\n", missed_events);
+			else
+				printf("]\n");
+		}
+		kbuffer_next_event(kbuf, NULL);
+		tep_print_event(tep, &seq, &record,
+				"%s-%d %6.1000d\t%s: %s\n",
+				TEP_PRINT_COMM,
+				TEP_PRINT_PID,
+				TEP_PRINT_TIME,
+				TEP_PRINT_NAME,
+				TEP_PRINT_INFO);
+		trace_seq_do_printf(&seq);
+		trace_seq_reset(&seq);
+	}
+}
+
+int main (int argc, char **argv)
+{
+	struct tracefs_cpu *tcpu;
+	struct tep_handle *tep;
+	struct kbuffer *kbuf;
+	bool mapped;
+	int cpu;
+
+	if (argc < 2 || !isdigit(argv[1][0])) {
+		printf("usage: %s cpu\n\n", argv[0]);
+		exit(-1);
+	}
+
+	cpu = atoi(argv[1]);
+
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		perror("Reading trace event formats");
+		exit(-1);
+	}
+
+	tcpu = tracefs_cpu_open_mapped(NULL, cpu, 0);
+	if (!tcpu) {
+		perror("Open CPU 0 file");
+		exit(-1);
+	}
+
+	/*
+	 * If this kernel supports mapping, use normal read,
+	 * otherwise use the piped buffer read, although if
+	 * the mapping succeeded, tracefs_cpu_buffered_read_buf()
+	 * acts the same as tracefs_cpu_read_buf(). But this is just
+	 * an example on how to use tracefs_cpu_is_mapped().
+	 */
+	mapped = tracefs_cpu_is_mapped(tcpu);
+	if (!mapped)
+		printf("Was not able to map, falling back to buffered read\n");
+	while ((kbuf = mapped ? tracefs_cpu_read_buf(tcpu, true) :
+			tracefs_cpu_buffered_read_buf(tcpu, true))) {
+		read_subbuf(tep, kbuf);
+	}
+
+	kbuf = tracefs_cpu_flush_buf(tcpu);
+	if (kbuf)
+		read_subbuf(tep, kbuf);
+
+	tracefs_cpu_close(tcpu);
+	tep_free(tep);
+
+	return 0;
+}
+
-- 
2.43.0

