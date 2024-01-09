Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F8879C4
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 03:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40C1C433C7
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 03:59:02 +0000 (UTC)
Date: Mon, 8 Jan 2024 22:59:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs Documentation: Add tracefs_follow_events_clear()
 to main man page
Message-ID: <20240108225959.6ea4b2fb@gandalf.local.home>
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

The tracefs_follow_events_clear() and tracefs_follow_missed_events_clear()
man pages were missing from the main libtracefs man page.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 634583d90715..9c3cc3ea3c06 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -76,6 +76,9 @@ Trace events:
 						  struct tep_record pass:[*],
 						  int, void pass:[*]),
 				  void pass:[*]_callback_data_);
+	int *tracefs_follow_event_clear*(struct tracefs_instance pass:[*]_instance_,
+			  const char pass:[*]_system_, const char pass:[*]_event_name_);
+	int *tracefs_follow_missed_events_clear*(struct tracefs_instance pass:[*]_instance_);
 	struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
 	struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
 	int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
-- 
2.43.0

