Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6556106
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 04:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08F7C433F1
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 04:05:55 +0000 (UTC)
Date: Mon, 8 Jan 2024 23:06:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs Documentation: Fix tracefs_cpu_snapshot_open()
 man pages
Message-ID: <20240108230652.51bc3b6a@gandalf.local.home>
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

The tracefs_cpu_snapshot_open() prototype in the man page had a typo and
it was also missing from the main libtracefs man page.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-cpu-open.txt | 2 +-
 Documentation/libtracefs.txt          | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-cpu-open.txt b/Documentation/libtracefs-cpu-open.txt
index 46667e83f7ff..613a71db97ae 100644
--- a/Documentation/libtracefs-cpu-open.txt
+++ b/Documentation/libtracefs-cpu-open.txt
@@ -18,7 +18,7 @@ void *tracefs_cpu_close*(struct tracefs_cpu pass:[*]_tcpu_);
 struct tracefs_cpu pass:[*]*tracefs_cpu_alloc_fd*(int _fd_, int _subbuf_size_, bool _nonblock_);
 void *tracefs_cpu_free_fd*(struct tracefs_cpu pass:[*]_tcpu_);
 
-struct tracefs_cpu pass:[*]*tracefs_cpu_snapshot-open*(struct tracefs_instance pass:[*]_instance_,
+struct tracefs_cpu pass:[*]*tracefs_cpu_snapshot_open*(struct tracefs_instance pass:[*]_instance_,
 					     int _cpu_, bool _nonblock_);
 --
 
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 8dc3ba7386e3..38a93c912e9a 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -99,6 +99,8 @@ Snapshot buffer:
 				 cpu_set_t pass:[*]_cpus_, int _cpu_size_,
 				 int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]),
 				 void pass:[*]_callback_context_);
+	struct tracefs_cpu pass:[*]*tracefs_cpu_snapshot_open*(struct tracefs_instance pass:[*]_instance_,
+					     int _cpu_, bool _nonblock_);
 
 Event filters:
 	int *tracefs_filter_string_append*(struct tep_event pass:[*]_event_, char pass:[**]_filter_,
-- 
2.43.0

