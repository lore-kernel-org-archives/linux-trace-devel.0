Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49765D298
	for <linux-trace-devel@vger.kernel.org>; Sun, 24 Dec 2023 19:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E06C433CC;
	Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rHTzM-00000004VxW-08Ul;
	Sun, 24 Dec 2023 14:18:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5/6] kbuffer: Add kbuffer_subbuffer() API
Date: Sun, 24 Dec 2023 14:16:02 -0500
Message-ID: <20231224191813.1076074-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231224191813.1076074-1-rostedt@goodmis.org>
References: <20231224191813.1076074-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a way to retrieve the last loaded subbuffer to the kbuffer.

The kbuffer_subbuffer() will return a pointer to the last loaded subbuffer or
NULL if none was ever loaded.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-kbuffer-create.txt | 11 ++++++++++-
 Documentation/libtraceevent.txt                |  1 +
 include/traceevent/kbuffer.h                   |  1 +
 src/kbuffer-parse.c                            | 11 +++++++++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-kbuffer-create.txt b/Documentation/libtraceevent-kbuffer-create.txt
index 7279dbe56b01..0dca31432455 100644
--- a/Documentation/libtraceevent-kbuffer-create.txt
+++ b/Documentation/libtraceevent-kbuffer-create.txt
@@ -3,7 +3,8 @@ libtraceevent(3)
 
 NAME
 ----
-kbuffer_alloc, kbuffer_dup, kbuffer_free, kbuffer_load_subbuffer, kbuffer_subbuffer_size, kbuffer_start_of_data - Creating of kbuffer element to parse
+kbuffer_alloc, kbuffer_dup, kbuffer_free, kbuffer_load_subbuffer, kbuffer_subbuffer,
+kbuffer_subbuffer_size, kbuffer_start_of_data - Creating of kbuffer element to parse
 the Linux kernel tracing ring buffer
 
 SYNOPSIS
@@ -33,6 +34,7 @@ void *kbuffer_free*(struct kbuffer pass:[*]_kbuf_);
 int *kbuffer_load_subbuffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuffer_);
 int *kbuffer_subbuffer_size*(struct kbuffer pass:[*]_kbuf);
 int *kbuffer_start_of_data*(struct kbuffer pass:[*]_kbuf_);
+void pass:[*]*kbuffer_subbuffer*(struct kbuffer pass:[*]_kbuf);
 --
 
 DESCRIPTION
@@ -79,6 +81,10 @@ on the sub-buffer. It does not return the size of the sub-buffer itself.
 The *kbuffer_start_of_data()* function returns the offset of where the actual
 data load of the sub-buffer begins.
 
+The *kbuffer_subbuffer()* function returns the pointer to the currently loaded
+subbuffer. That is, the last subbuffer that was loaded by *kbuffer_load_subbuffer()*.
+If no subbuffer was loaded NULL is returned.
+
 RETURN VALUE
 ------------
 *kbuffer_alloc()* returns an allocated kbuffer descriptor or NULL on error.
@@ -92,6 +98,9 @@ of the last event is located.
 *kbuffer_start_of_data()* returns the offset of where the data begins on the
 sub-buffer loaded in _kbuf_.
 
+*kbuffer_subbuffer()* returns the last loaded subbuffer to _kbuf_ that was loaded
+by *kbuffer_load_subbuffer()* or NULL if none was loaded.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 8b63982e541e..253c9ea810aa 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -185,6 +185,7 @@ kbuffer parsing:
 	void *kbuffer_free*(struct kbuffer pass:[*]_kbuf_);
 	int *kbuffer_load_subbuffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuffer_);
 	int *kbuffer_subbuffer_size*(struct kbuffer pass:[*]_kbuf);
+	void pass:[*]*kbuffer_subbuffer*(struct kbuffer pass:[*]_kbuf);
 	int *kbuffer_start_of_data*(struct kbuffer pass:[*]_kbuf_);
 	unsigned long long *kbuffer_timestamp*(struct kbuffer pass:[*]_kbuf_);
 	unsigned long long *kbuffer_subbuf_timestamp*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuf_);
diff --git a/include/traceevent/kbuffer.h b/include/traceevent/kbuffer.h
index 7086e0303e5c..624517ed334b 100644
--- a/include/traceevent/kbuffer.h
+++ b/include/traceevent/kbuffer.h
@@ -52,6 +52,7 @@ int kbuffer_curr_size(struct kbuffer *kbuf);
 int kbuffer_event_size(struct kbuffer *kbuf);
 int kbuffer_missed_events(struct kbuffer *kbuf);
 int kbuffer_subbuffer_size(struct kbuffer *kbuf);
+void *kbuffer_subbuffer(struct kbuffer *kbuf);
 
 void kbuffer_set_old_format(struct kbuffer *kbuf);
 int kbuffer_start_of_data(struct kbuffer *kbuf);
diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index b117094856bc..b218d1fc9679 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -747,6 +747,17 @@ int kbuffer_subbuffer_size(struct kbuffer *kbuf)
 	return kbuf->size;
 }
 
+/**
+ * kbuffer_subbuffer - the currently loaded subbuffer
+ * @kbuf:	The kbuffer to read from
+ *
+ * Returns the currently loaded subbuffer.
+ */
+void *kbuffer_subbuffer(struct kbuffer *kbuf)
+{
+	return kbuf->subbuffer;
+}
+
 /**
  * kbuffer_curr_index - Return the index of the record
  * @kbuf:	The kbuffer to read from
-- 
2.42.0

