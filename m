Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C5210967
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B97C433B6;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKp-00000000EJR-0K9g;
	Thu, 28 Dec 2023 16:54:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 13/22] libtracefs: Add tracefs_instance_clear() API
Date: Thu, 28 Dec 2023 16:52:08 -0500
Message-ID: <20231228215433.54854-14-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228215433.54854-1-rostedt@goodmis.org>
References: <20231228215433.54854-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracefs_instance_clear() that will clear the ring buffer of a given
instance or the top level ring buffer if NULL is passed to it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-manage.txt |  9 ++++++++-
 Documentation/libtracefs.txt                  |  1 +
 include/tracefs.h                             |  1 +
 src/tracefs-instance.c                        | 11 +++++++++++
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index 1e0735ee153c..4e5c64588772 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_instance_create, tracefs_instance_destroy, tracefs_instance_alloc, tracefs_instance_free,
-tracefs_instance_is_new, tracefs_instances, tracefs_instance_reset - Manage trace instances.
+tracefs_instance_is_new, tracefs_instances, tracefs_instance_clear, tracefs_instance_reset - Manage trace instances.
 
 SYNOPSIS
 --------
@@ -18,6 +18,7 @@ struct tracefs_instance pass:[*]*tracefs_instance_alloc*(const char pass:[*]_tra
 void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
 bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
 char pass:[**]*tracefs_instances*(const char pass:[*]_regex_);
+void *tracefs_instance_clear*(struct tracefs_instance pass:[*]_instance_);
 void *tracefs_instance_reset*(struct tracefs_instance pass:[*]_instance_);
 
 --
@@ -61,6 +62,9 @@ it will match all instances that exist. The returned list must be freed with
 *tracefs_list_free*(3). Note, if no instances are found an empty list is returned
 and that too needs to be free with *tracefs_list_free*(3).
 
+The *tracefs_instance_clear()* function clears the ring buffer of the given _instance_
+or the top level ring buffer if _instance_ is NULL.
+
 The *tracefs_instance_reset*() function resets the given _instance_ to its default state.
 
 RETURN VALUE
@@ -83,6 +87,9 @@ The list must be freed with *tracefs_list_free*(3). An empty list is returned if
 no instance exists that matches _regex_, and this needs to be freed with
 *tracefs_list_free*(3) as well. NULL is returned on error.
 
+The *tracefs_instance_clear()* returns 0 if it successfully cleared the ring buffer,
+or -1 on error.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 529922580f8d..273423cecf4a 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -25,6 +25,7 @@ Trace instances:
 	struct tracefs_instance pass:[*]*tracefs_instance_alloc*(const char pass:[*]_tracing_dir_, const char pass:[*]_name_);
 	void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
 	char pass:[**]*tracefs_instances*(const char pass:[*]_regex_);
+	void *tracefs_instance_clear*(struct tracefs_instance pass:[*]_instance_);
 	void *tracefs_instance_reset*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 4be66b488536..31aba92d9a16 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -25,6 +25,7 @@ struct tracefs_instance;
 
 void tracefs_instance_free(struct tracefs_instance *instance);
 void tracefs_instance_reset(struct tracefs_instance *instance);
+int tracefs_instance_clear(struct tracefs_instance *instance);
 struct tracefs_instance *tracefs_instance_create(const char *name);
 struct tracefs_instance *tracefs_instance_alloc(const char *tracing_dir,
 						const char *name);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index b019836333a3..4e7434157109 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -1409,6 +1409,17 @@ static void clear_func_filters(struct tracefs_instance *instance)
 		clear_func_filter(instance, files[i]);
 }
 
+/**
+ * tracefs_instance_clear - clear the trace buffer
+ * @instance: The instance to clear the trace for.
+ *
+ * Returns 0 on succes, -1 on error
+ */
+int tracefs_instance_clear(struct tracefs_instance *instance)
+{
+	return tracefs_instance_file_clear(instance, "trace");
+}
+
 /**
  * tracefs_instance_reset - Reset a ftrace instance to its default state
  * @instance - a ftrace instance to be reseted
-- 
2.42.0

