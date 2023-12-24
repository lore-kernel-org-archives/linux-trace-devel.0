Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4972FD297
	for <linux-trace-devel@vger.kernel.org>; Sun, 24 Dec 2023 19:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AA2C433CD;
	Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rHTzM-00000004Vxa-0QmW;
	Sun, 24 Dec 2023 14:18:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6/6] kbuffer: Add kbuffer_refresh() API
Date: Sun, 24 Dec 2023 14:16:03 -0500
Message-ID: <20231224191813.1076074-7-rostedt@goodmis.org>
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

Add a way to refresh the current size of the loaded subbuffer of the
kbuffer. This is needed if the loaded subbuffer has a writer on it and it
needs to update for new events that have been written.

Note, no memory barriers are used here and that would be required by the
application.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtraceevent-kbuffer-create.txt          | 15 ++++++++++++--
 Documentation/libtraceevent.txt               |  1 +
 include/traceevent/kbuffer.h                  |  1 +
 src/kbuffer-parse.c                           | 20 +++++++++++++++++++
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtraceevent-kbuffer-create.txt b/Documentation/libtraceevent-kbuffer-create.txt
index 0dca31432455..6f89de914f39 100644
--- a/Documentation/libtraceevent-kbuffer-create.txt
+++ b/Documentation/libtraceevent-kbuffer-create.txt
@@ -4,7 +4,7 @@ libtraceevent(3)
 NAME
 ----
 kbuffer_alloc, kbuffer_dup, kbuffer_free, kbuffer_load_subbuffer, kbuffer_subbuffer,
-kbuffer_subbuffer_size, kbuffer_start_of_data - Creating of kbuffer element to parse
+kbuffer_refresh, kbuffer_subbuffer_size, kbuffer_start_of_data - Creating of kbuffer element to parse
 the Linux kernel tracing ring buffer
 
 SYNOPSIS
@@ -32,7 +32,8 @@ struct kbuffer pass:[*]*kbuffer_alloc*(enum kbuffer_long_size _size_, enum kbuff
 struct kbuffer pass:[*]*kbuffer_dup*(struct kbuffer pass:[*]_kbuf_);
 void *kbuffer_free*(struct kbuffer pass:[*]_kbuf_);
 int *kbuffer_load_subbuffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuffer_);
-int *kbuffer_subbuffer_size*(struct kbuffer pass:[*]_kbuf);
+int *kbuffer_subbuffer_size*(struct kbuffer pass:[*]_kbuf_);
+int *kbuffer_refresh*(struct kbuffer pass:[*]_kbuf_);
 int *kbuffer_start_of_data*(struct kbuffer pass:[*]_kbuf_);
 void pass:[*]*kbuffer_subbuffer*(struct kbuffer pass:[*]_kbuf);
 --
@@ -78,6 +79,13 @@ is what kbuffer uses to walk the events.
 The *kbuffer_subbuffer_size()* returns the location of the end of the last event
 on the sub-buffer. It does not return the size of the sub-buffer itself.
 
+The *kbuffer_refresh()* is to be used if more writes were done on the loaded kbuffer
+where the size of the kbuffer needs to be refreshed to be able to read the new
+events that were written since the last *kbuffer_load_subbuffer()* was called on it.
+
+Note, no memory barriers are implemented with this function and any synchronization
+with the writer is the responsibility of the application.
+
 The *kbuffer_start_of_data()* function returns the offset of where the actual
 data load of the sub-buffer begins.
 
@@ -101,6 +109,9 @@ sub-buffer loaded in _kbuf_.
 *kbuffer_subbuffer()* returns the last loaded subbuffer to _kbuf_ that was loaded
 by *kbuffer_load_subbuffer()* or NULL if none was loaded.
 
+*kbuffer_refresh()* returns 0 on success and -1 if _kbuf_ is NULL or it does not
+have a subbuffer loaded via *kbuffer_load_subbuffer()*.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 253c9ea810aa..d1aef40804e3 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -186,6 +186,7 @@ kbuffer parsing:
 	int *kbuffer_load_subbuffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuffer_);
 	int *kbuffer_subbuffer_size*(struct kbuffer pass:[*]_kbuf);
 	void pass:[*]*kbuffer_subbuffer*(struct kbuffer pass:[*]_kbuf);
+	int *kbuffer_refresh*(struct kbuffer pass:[*]_kbuf_);
 	int *kbuffer_start_of_data*(struct kbuffer pass:[*]_kbuf_);
 	unsigned long long *kbuffer_timestamp*(struct kbuffer pass:[*]_kbuf_);
 	unsigned long long *kbuffer_subbuf_timestamp*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuf_);
diff --git a/include/traceevent/kbuffer.h b/include/traceevent/kbuffer.h
index 624517ed334b..31a8c62d7a61 100644
--- a/include/traceevent/kbuffer.h
+++ b/include/traceevent/kbuffer.h
@@ -34,6 +34,7 @@ struct kbuffer *kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian e
 struct kbuffer *kbuffer_dup(struct kbuffer *kbuf);
 void kbuffer_free(struct kbuffer *kbuf);
 int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer);
+int kbuffer_refresh(struct kbuffer *kbuf);
 void *kbuffer_read_event(struct kbuffer *kbuf, unsigned long long *ts);
 void *kbuffer_next_event(struct kbuffer *kbuf, unsigned long long *ts);
 unsigned long long kbuffer_timestamp(struct kbuffer *kbuf);
diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index b218d1fc9679..d43fe5d972fd 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -299,6 +299,26 @@ void kbuffer_free(struct kbuffer *kbuf)
 	free(kbuf);
 }
 
+/**
+ * kbuffer_refresh - update the meta data from the subbuffer
+ * @kbuf; The kbuffer to update
+ *
+ * If the loaded subbuffer changed its meta data (the commit)
+ * then update the pointers for it.
+ */
+int kbuffer_refresh(struct kbuffer *kbuf)
+{
+	unsigned long long flags;
+
+	if (!kbuf || !kbuf->subbuffer)
+		return -1;
+
+	flags = read_long(kbuf, kbuf->subbuffer + 8);
+	kbuf->size = (unsigned int)flags & COMMIT_MASK;
+
+	return 0;
+}
+
 static unsigned int type4host(struct kbuffer *kbuf,
 			      unsigned int type_len_ts)
 {
-- 
2.42.0

