Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7929D3D989
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D33C43394;
	Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNJ45-00000000JKX-1XtB;
	Tue, 09 Jan 2024 15:51:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] libtracefs: Have tracefs_cpu_flush(_buf)() use mapping
Date: Tue,  9 Jan 2024 15:48:59 -0500
Message-ID: <20240109205112.74225-5-rostedt@goodmis.org>
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

If the tracefs_cpu is opened with tracefs_cpu_open_mapped() and uses
tracefs_cpu_read_buf() along with tracefs_cpu_flush_buf(), the flush will
load the tcpu->kbuf with a new buffer which may make the one in the mmapped
out of sync.

If the tcpu is mapped, make sure tracefs_cpu_flush() and
tracefs_cpu_flush_buf() also use the mapping.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-record.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 4a59c61c195f..fca3ddf9afbe 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -690,6 +690,9 @@ int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer)
 	if (tcpu->buffered < 0)
 		tcpu->buffered = 0;
 
+	if (tcpu->mapping)
+		return trace_mmap_read(tcpu->mapping, buffer);
+
 	if (tcpu->buffered) {
 		ret = read(tcpu->splice_pipe[0], buffer, tcpu->subbuf_size);
 		if (ret > 0)
@@ -729,6 +732,13 @@ struct kbuffer *tracefs_cpu_flush_buf(struct tracefs_cpu *tcpu)
 	if (!get_buffer(tcpu))
 		return NULL;
 
+	if (tcpu->mapping) {
+		/* Make sure that reading is now non blocking */
+		set_nonblock(tcpu);
+		ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf);
+		return ret > 0 ? tcpu->kbuf : NULL;
+	}
+
 	ret = tracefs_cpu_flush(tcpu, tcpu->buffer);
 	if (ret <= 0)
 		return NULL;
-- 
2.43.0

