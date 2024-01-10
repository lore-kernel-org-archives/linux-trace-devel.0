Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2334F88A
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 23:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26020C433F1;
	Wed, 10 Jan 2024 23:02:03 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNhbE-00000000Ut3-2nol;
	Wed, 10 Jan 2024 18:03:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd record: Reset buffer_size and subbuf_size when done
Date: Wed, 10 Jan 2024 18:00:29 -0500
Message-ID: <20240110230303.118668-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240110230303.118668-1-rostedt@goodmis.org>
References: <20240110230303.118668-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Save the current buffer_size_kb and subbuf_size_kb files before updating
them, and put them back to what they were when finished with recording.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  2 ++
 tracecmd/trace-record.c        | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 03738c518aa8..55934f98aa32 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -286,7 +286,9 @@ struct buffer_instance {
 	int			tracing_on_init_val;
 	int			tracing_on_fd;
 	int			buffer_size;
+	int			old_buffer_size;
 	int			subbuf_size;
+	int			old_subbuf_size;
 	int			cpu_count;
 
 	int			proxy_fd;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4646d8eb41f6..762afba4703a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2522,6 +2522,26 @@ static void update_reset_triggers(void)
 	}
 }
 
+static void reset_buffer_files_instance(struct buffer_instance *instance)
+{
+	if (instance->old_buffer_size != instance->buffer_size)
+		tracefs_instance_set_buffer_size(instance->tracefs,
+						 instance->old_buffer_size, -1);
+
+	if (instance->old_subbuf_size != instance->subbuf_size)
+		tracefs_instance_set_subbuf_size(instance->tracefs,
+						 instance->old_subbuf_size);
+}
+
+static void reset_buffer_files(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance) {
+		reset_buffer_files_instance(instance);
+	}
+}
+
 static void update_reset_files(void)
 {
 	struct reset_file *reset;
@@ -2536,6 +2556,8 @@ static void update_reset_files(void)
 		free(reset->reset);
 		free(reset);
 	}
+
+	reset_buffer_files();
 }
 
 static void
@@ -5110,6 +5132,7 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 	if (buffer_size < 0)
 		die("buffer size must be positive");
 
+	instance->old_buffer_size = tracefs_instance_get_buffer_size(instance->tracefs, 0);
 	ret = tracefs_instance_set_buffer_size(instance->tracefs, buffer_size, -1);
 	if (ret < 0)
 		warning("Can't set buffer size");
@@ -5129,6 +5152,7 @@ static void set_subbuf_size_instance(struct buffer_instance *instance)
 	if (subbuf_size < 0)
 		die("sub-buffer size must be positive");
 
+	instance->old_subbuf_size = tracefs_instance_get_subbuf_size(instance->tracefs);
 	ret = tracefs_instance_set_subbuf_size(instance->tracefs, subbuf_size);
 	if (ret < 0)
 		warning("Can't set sub-buffer size");
-- 
2.43.0

