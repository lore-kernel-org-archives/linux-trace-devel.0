Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76E1D2F1
	for <linux-trace-devel@vger.kernel.org>; Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBBAC433CA;
	Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rHTzL-00000004VxS-42LU;
	Sun, 24 Dec 2023 14:18:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/6] kbuffer: Add kbuffer_dup()
Date: Sun, 24 Dec 2023 14:16:01 -0500
Message-ID: <20231224191813.1076074-5-rostedt@goodmis.org>
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

Add the function kbuffer_dup() that will duplicate a current kbuffer structure
that can be used separately on the same subbuffer or load a new buffer on it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtraceevent-kbuffer-create.txt          |  8 +++++++-
 Documentation/libtraceevent.txt               |  1 +
 include/traceevent/kbuffer.h                  |  1 +
 src/kbuffer-parse.c                           | 20 +++++++++++++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-kbuffer-create.txt b/Documentation/libtraceevent-kbuffer-create.txt
index 12e5d6cd6b80..7279dbe56b01 100644
--- a/Documentation/libtraceevent-kbuffer-create.txt
+++ b/Documentation/libtraceevent-kbuffer-create.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-kbuffer_alloc, kbuffer_free, kbuffer_load_subbuffer, kbuffer_subbuffer_size, kbuffer_start_of_data - Creating of kbuffer element to parse
+kbuffer_alloc, kbuffer_dup, kbuffer_free, kbuffer_load_subbuffer, kbuffer_subbuffer_size, kbuffer_start_of_data - Creating of kbuffer element to parse
 the Linux kernel tracing ring buffer
 
 SYNOPSIS
@@ -28,6 +28,7 @@ struct kbuffer;
 struct tep_handle;
 
 struct kbuffer pass:[*]*kbuffer_alloc*(enum kbuffer_long_size _size_, enum kbuffer_endian _endian_);
+struct kbuffer pass:[*]*kbuffer_dup*(struct kbuffer pass:[*]_kbuf_);
 void *kbuffer_free*(struct kbuffer pass:[*]_kbuf_);
 int *kbuffer_load_subbuffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuffer_);
 int *kbuffer_subbuffer_size*(struct kbuffer pass:[*]_kbuf);
@@ -59,6 +60,11 @@ will then perform a *uname(2)* call, and if the _machine_ field has the string "
 in it, it will be set to 8 byte long size and not 4 byte. This is because the
 ring buffer long size is dependent on the kernel and not user space.
 
+The *kbuffer_dup()* function will duplicate an existing kbuffer structure with
+an allocated new one. It will have all the properties of the passed in _kbuf_,
+including pointing to the same subbuffer that was loaded in the _kbuf_.
+It must be freed with *kbuffer_free()*.
+
 The *kbuffer_free()* function will free the resources created by *kbuffer_alloc()*.
 
 The *kbuffer_load_subbuffer()* will take a _subbuffer_ which is a raw data blob
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 407c06809269..8b63982e541e 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -181,6 +181,7 @@ Trace sequences:
 kbuffer parsing:
 #include <kbuffer.h>
 	struct kbuffer pass:[*]*kbuffer_alloc*(enum kbuffer_long_size _size_, enum kbuffer_endian _endian_);
+	struct kbuffer pass:[*]*kbuffer_dup*(struct kbuffer pass:[*]_kbuf_);
 	void *kbuffer_free*(struct kbuffer pass:[*]_kbuf_);
 	int *kbuffer_load_subbuffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuffer_);
 	int *kbuffer_subbuffer_size*(struct kbuffer pass:[*]_kbuf);
diff --git a/include/traceevent/kbuffer.h b/include/traceevent/kbuffer.h
index e5d377bf0e60..7086e0303e5c 100644
--- a/include/traceevent/kbuffer.h
+++ b/include/traceevent/kbuffer.h
@@ -31,6 +31,7 @@ enum {
 struct kbuffer;
 
 struct kbuffer *kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian);
+struct kbuffer *kbuffer_dup(struct kbuffer *kbuf);
 void kbuffer_free(struct kbuffer *kbuf);
 int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer);
 void *kbuffer_read_event(struct kbuffer *kbuf, unsigned long long *ts);
diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index b86c8f0b9d4f..b117094856bc 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -269,6 +269,26 @@ kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian)
 	return kbuf;
 }
 
+/**
+ * kbuffer_dup - duplicate a given kbuffer
+ * @kbuf_orig; The kbuffer to duplicate
+ *
+ * Allocates a new kbuffer based off of anothe kbuffer.
+ * Returns the duplicate on success or NULL on error.
+ */
+struct kbuffer *kbuffer_dup(struct kbuffer *kbuf_orig)
+{
+	struct kbuffer *kbuf;
+
+	kbuf = malloc(sizeof(*kbuf));
+	if (!kbuf)
+		return NULL;
+
+	*kbuf = *kbuf_orig;
+
+	return kbuf;
+}
+
 /** kbuffer_free - free an allocated kbuffer
  * @kbuf:	The kbuffer to free
  *
-- 
2.42.0

