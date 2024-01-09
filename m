Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F1E3D988
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45531C433C7;
	Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNJ45-00000000JKT-1RgR;
	Tue, 09 Jan 2024 15:51:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] libtracefs: Use mmapping for iterating raw events
Date: Tue,  9 Jan 2024 15:48:58 -0500
Message-ID: <20240109205112.74225-4-rostedt@goodmis.org>
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

If mmapping the ring buffer is available, use that for iterating raw events
as it's less copying than using splice buffering.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 2571c4b43341..9f620abebdda 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -32,6 +32,7 @@ struct cpu_iterate {
 	struct tep_event *event;
 	struct kbuffer *kbuf;
 	int cpu;
+	bool mapped;
 };
 
 static int read_kbuf_record(struct cpu_iterate *cpu)
@@ -66,7 +67,11 @@ int read_next_page(struct tep_handle *tep, struct cpu_iterate *cpu)
 	if (!cpu->tcpu)
 		return -1;
 
-	kbuf = tracefs_cpu_buffered_read_buf(cpu->tcpu, true);
+	/* Do not do buffered reads if it is mapped */
+	if (cpu->mapped)
+		kbuf = tracefs_cpu_read_buf(cpu->tcpu, true);
+	else
+		kbuf = tracefs_cpu_buffered_read_buf(cpu->tcpu, true);
 	/*
 	 * tracefs_cpu_buffered_read_buf() only reads in full subbuffer size,
 	 * but this wants partial buffers as well. If the function returns
@@ -274,7 +279,7 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 		if (snapshot)
 			tcpu = tracefs_cpu_snapshot_open(instance, cpu, true);
 		else
-			tcpu = tracefs_cpu_open(instance, cpu, true);
+			tcpu = tracefs_cpu_open_mapped(instance, cpu, true);
 		tmp = realloc(*all_cpus, (i + 1) * sizeof(*tmp));
 		if (!tmp) {
 			i--;
@@ -290,6 +295,7 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 
 		tmp[i].tcpu = tcpu;
 		tmp[i].cpu = cpu;
+		tmp[i].mapped = tracefs_cpu_is_mapped(tcpu);
 		i++;
 	}
 	*count = i;
-- 
2.43.0

