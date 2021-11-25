Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEE0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Nov 2021 15:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349511AbhKYPDX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354002AbhKYPBW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Nov 2021 10:01:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 424F261106;
        Thu, 25 Nov 2021 14:58:11 +0000 (UTC)
Date:   Thu, 25 Nov 2021 09:58:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH] libtracefs: Rename tracefs_hist*alloc*() functions once
 again
Message-ID: <20211125095809.305fb243@oasis.local.home>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

After reviewing an early user of libtracefs hist APIs, it seems more
logical to have the most common case (1 dimensional histograms) be the
default name. Rename the functions:

  tracefs_hist1d_alloc()  -->   tracefs_hist_alloc()
  tracefs_hist2d_alloc()  -->   tracefs_hist_alloc_2d()
  tracefs_hist_alloc()    -->   tracefs_hist_alloc_nd()

Also, by having all start with "tracefs_hist_alloc" it makes them easier
to grep for.

Link: https://lore.kernel.org/all/1d9826696a1e8c3584158c0dd570b8b22db708db.1635535309.git.bristot@kernel.org/

Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-filter.txt    |  2 ++
 Documentation/libtracefs-hist-cont.txt |  8 +++---
 Documentation/libtracefs-hist.txt      | 30 +++++++++++------------
 Documentation/libtracefs-sql.txt       |  2 ++
 Documentation/libtracefs-synth.txt     |  2 ++
 Documentation/libtracefs-synth2.txt    |  2 ++
 include/tracefs.h                      | 20 +++++++--------
 src/tracefs-hist.c                     | 34 +++++++++++++-------------
 8 files changed, 55 insertions(+), 45 deletions(-)

diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index 7e167bc..14fb292 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -294,6 +294,8 @@ _libtracefs(3)_,
 _libtraceevent(3)_,
 _trace-cmd(1)_,
 _tracefs_hist_alloc(3)_,
+_tracefs_hist_alloc_2d(3)_,
+_tracefs_hist_alloc_nd(3)_,
 _tracefs_hist_free(3)_,
 _tracefs_hist_add_key(3)_,
 _tracefs_hist_add_value(3)_,
diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
index 5cdcc0a..b5cc726 100644
--- a/Documentation/libtracefs-hist-cont.txt
+++ b/Documentation/libtracefs-hist-cont.txt
@@ -107,9 +107,9 @@ int main (int argc, char **argv, char **env)
 		exit(-1);
 	}
 
-	hist = tracefs_hist2d_alloc(tep, "kmem", "kmalloc",
-				    "call_site",TRACEFS_HIST_KEY_SYM,
-				    "bytes_req", 0);
+	hist = tracefs_hist_alloc_2d(tep, "kmem", "kmalloc",
+				     "call_site",TRACEFS_HIST_KEY_SYM,
+				     "bytes_req", 0);
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
 		exit(-1);
@@ -184,6 +184,8 @@ _libtracefs(3)_,
 _libtraceevent(3)_,
 _trace-cmd(1)_,
 _tracefs_hist_alloc(3)_,
+_tracefs_hist_alloc_2d(3)_,
+_tracefs_hist_alloc_nd(3)_,
 _tracefs_hist_free(3)_,
 _tracefs_hist_add_key(3)_,
 _tracefs_hist_add_value(3)_,
diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index c501d5a..2eef718 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -29,14 +29,14 @@ struct tracefs_hist_axis {
 	enum tracefs_hist_key_type type;
 };
 
-struct tracefs_hist pass:[*]tracefs_hist1d_alloc(struct tracefs_tep pass:[*] tep,
+struct tracefs_hist pass:[*]tracefs_hist_alloc(struct tracefs_tep pass:[*] tep,
 			const char pass:[*]system, const char pass:[*]event,
 			const char pass:[*]key, enum tracefs_hist_key_type type);
-struct tracefs_hist pass:[*]tracefs_hist2d_alloc(struct tracefs_tep pass:[*] tep,
+struct tracefs_hist pass:[*]tracefs_hist_alloc_2d(struct tracefs_tep pass:[*] tep,
 			const char pass:[*]system, const char pass:[*]event,
 			const char pass:[*]key1, enum tracefs_hist_key_type type1,
 			const char pass:[*]key2, enum tracefs_hist_key_type type2));
-struct tracefs_hist pass:[*]tracefs_hist_alloc(struct tracefs_tep pass:[*] tep,
+struct tracefs_hist pass:[*]tracefs_hist_alloc_nd(struct tracefs_tep pass:[*] tep,
 			const char pass:[*]system, const char pass:[*]event,
 			struct tracefs_hist_axis pass:[*]axes);
 void tracefs_hist_free(struct tracefs_hist pass:[*]hist);
@@ -78,7 +78,7 @@ The syntax can be complex and difficult to get correct. This API handles the
 syntax, and facilitates the creation and interaction with the event histograms.
 See https://www.kernel.org/doc/html/latest/trace/histogram.html for more information.
 
-*tracefs_hist1d_alloc*() allocates a "struct tracefs_hist" descriptor of a one-dimensional
+*tracefs_hist_alloc*() allocates a "struct tracefs_hist" descriptor of a one-dimensional
 histogram and returns the address of it. This descriptor must be freed by *tracefs_hist_free*().
 The _tep_ is a trace event handle (see *tracefs_local_events*(3)), that holds the
 _system_ and _event_ that the histogram will be attached to. The _system_ is the
@@ -86,7 +86,7 @@ system or group of the event. The _event_ is the event to attach the histogram t
 The _key_ is a field of the event that will be used as the key(dimension) of the histogram.
 The _type_ is the type of the _key_. See KEY TYPES below.
 
-*tracefs_hist2d_alloc*() allocates a "struct tracefs_hist" descriptor of a two-dimensional
+*tracefs_hist_alloc_2d*() allocates a "struct tracefs_hist" descriptor of a two-dimensional
 histogram and returns the address of it. This descriptor must be freed by *tracefs_hist_free*().
 The _tep_ is a trace event handle (see *tracefs_local_events*(3)), that holds the
 _system_ and _event_ that the histogram will be attached to. The _system_ is the
@@ -96,7 +96,7 @@ of the histogram. The _type1_ is the type of the _key1_. See KEY TYPES below.
 The _key2_ is the second field of the event that will be used as the key(dimension)
 of the histogram. The _type2_ is the type of the _key2_. See KEY TYPES below.
 
-*tracefs_hist_alloc*() allocates a "struct tracefs_hist" descriptor of an N-dimensional
+*tracefs_hist_alloc_nd*() allocates a "struct tracefs_hist" descriptor of an N-dimensional
 histogram and returns the address of it. This descriptor must be freed by *tracefs_hist_free*().
 The _tep_ is a trace event handle (see *tracefs_local_events*(3)), that holds the
 _system_ and _event_ that the histogram will be attached to. The _system_ is the
@@ -108,7 +108,7 @@ or disable the running histogram if it was started. *tracefs_hist_destroy*() nee
 to be called to do so.
 
 *tracefs_hist_add_key*() Adds a secondary or tertiary key to the histogram.
-The key passed to *tracefs_hist_alloc*() is the primary key of the histogram.
+The key passed to *tracefs_hist_alloc_nd*() is the primary key of the histogram.
 The first time this function is called, it will add a secondary key (or two dimensional
 histogram). If this function is called again on the same histogram, it will add
 a _tertiary_ key (or three dimensional histogram). The _hist_ parameter is the
@@ -203,7 +203,7 @@ calling conventions a bit easier to understand what is happening.
 KEY TYPES
 ---------
 
-*tracefs_hist_alloc*() and *tracefs_hist_add_key*() both add a key and requires
+*tracefs_hist_alloc_nd*() and *tracefs_hist_add_key*() both add a key and requires
 that key to have a type. The types may be:
 
  *TRACEFS_HIST_KEY_NORMAL* or zero (0) which is to not modify the type.
@@ -232,7 +232,7 @@ in which case it will show the timestamp in microseconds instead of nanoseconds.
 
 RETURN VALUE
 ------------
-*tracefs_hist_alloc*() returns an allocated histogram descriptor which must
+*tracefs_hist_alloc_nd*() returns an allocated histogram descriptor which must
 be freed by *tracefs_hist_free*() or NULL on error.
 
 All the other functions return zero on success or -1 on error.
@@ -376,17 +376,17 @@ static void process_hist(enum commands cmd, const char *instance_name,
 	/* Show examples of hist1d and hist2d */
 	switch (cnt) {
 	case 1:
-		hist = tracefs_hist1d_alloc(tep, system, event,
-					    axes[0].key, axes[0].type);
+		hist = tracefs_hist_alloc(tep, system, event,
+					  axes[0].key, axes[0].type);
 		break;
 	case 2:
-		hist = tracefs_hist2d_alloc(tep, system, event,
-					    axes[0].key, axes[0].type,
-					    axes[1].key, axes[1].type);
+		hist = tracefs_hist_alloc_2d(tep, system, event,
+					     axes[0].key, axes[0].type,
+					     axes[1].key, axes[1].type);
 		break;
 	default:
 		/* Really, 1 and 2 could use this too */
-		hist = tracefs_hist_alloc(tep, system, event, axes);
+		hist = tracefs_hist_alloc_nd(tep, system, event, axes);
 	}
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 6297e9a..8c765eb 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -581,6 +581,8 @@ _tracefs_synth_destroy(3)_,
 _tracefs_synth_free(3)_,
 _tracefs_synth_echo_cmd(3)_,
 _tracefs_hist_alloc(3)_,
+_tracefs_hist_alloc_2d(3)_,
+_tracefs_hist_alloc_nd(3)_,
 _tracefs_hist_free(3)_,
 _tracefs_hist_add_key(3)_,
 _tracefs_hist_add_value(3)_,
diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index 87d2dfc..370a63b 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -317,6 +317,8 @@ _libtracefs(3)_,
 _libtraceevent(3)_,
 _trace-cmd(1)_,
 _tracefs_hist_alloc(3)_,
+_tracefs_hist_alloc_2d(3)_,
+_tracefs_hist_alloc_nd(3)_,
 _tracefs_hist_free(3)_,
 _tracefs_hist_add_key(3)_,
 _tracefs_hist_add_value(3)_,
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index c7be963..1cb07c8 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -241,6 +241,8 @@ _libtracefs(3)_,
 _libtraceevent(3)_,
 _trace-cmd(1)_,
 _tracefs_hist_alloc(3)_,
+_tracefs_hist_alloc_2d(3)_,
+_tracefs_hist_alloc_nd(3)_,
 _tracefs_hist_free(3)_,
 _tracefs_hist_add_key(3)_,
 _tracefs_hist_add_value(3)_,
diff --git a/include/tracefs.h b/include/tracefs.h
index 9662603..8b8b554 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -334,14 +334,14 @@ enum tracefs_compare {
 
 void tracefs_hist_free(struct tracefs_hist *hist);
 struct tracefs_hist *
-tracefs_hist1d_alloc(struct tep_handle *tep,
-		     const char *system, const char *event_name,
-		     const char *key, enum tracefs_hist_key_type type);
+tracefs_hist_alloc(struct tep_handle *tep,
+		   const char *system, const char *event_name,
+		   const char *key, enum tracefs_hist_key_type type);
 struct tracefs_hist *
-tracefs_hist2d_alloc(struct tep_handle *tep,
-		     const char *system, const char *event_name,
-		     const char *key1, enum tracefs_hist_key_type type1,
-		     const char *key2, enum tracefs_hist_key_type type2);
+tracefs_hist_alloc_2d(struct tep_handle *tep,
+		      const char *system, const char *event_name,
+		      const char *key1, enum tracefs_hist_key_type type1,
+		      const char *key2, enum tracefs_hist_key_type type2);
 
 struct tracefs_hist_axis {
 	const char *key;
@@ -349,9 +349,9 @@ struct tracefs_hist_axis {
 };
 
 struct tracefs_hist *
-tracefs_hist_alloc(struct tep_handle *tep,
-		   const char *system, const char *event_name,
-		   struct tracefs_hist_axis *axes);
+tracefs_hist_alloc_nd(struct tep_handle *tep,
+		      const char *system, const char *event_name,
+		      struct tracefs_hist_axis *axes);
 const char *tracefs_get_hist_name(struct tracefs_hist *hist);
 const char *tracefs_get_hist_event(struct tracefs_hist *hist);
 const char *tracefs_get_hist_system(struct tracefs_hist *hist);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 694b800..ea9e127 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -206,7 +206,7 @@ void tracefs_hist_free(struct tracefs_hist *hist)
 }
 
 /**
- * tracefs_hist1d_alloc - Initialize one-dimensional histogram
+ * tracefs_hist_alloc - Initialize one-dimensional histogram
  * @tep: The tep handle that has the @system and @event.
  * @system: The system the histogram event is in.
  * @event_name: The name of the event that the histogram will be attached to.
@@ -222,17 +222,17 @@ void tracefs_hist_free(struct tracefs_hist *hist)
  * NULL on failure.
  */
 struct tracefs_hist *
-tracefs_hist1d_alloc(struct tep_handle *tep,
-		     const char *system, const char *event_name,
-		     const char *key, enum tracefs_hist_key_type type)
+tracefs_hist_alloc(struct tep_handle *tep,
+		   const char *system, const char *event_name,
+		   const char *key, enum tracefs_hist_key_type type)
 {
 	struct tracefs_hist_axis axis[] = {{key, type}, {NULL, 0}};
 
-	return tracefs_hist_alloc(tep, system, event_name, axis);
+	return tracefs_hist_alloc_nd(tep, system, event_name, axis);
 }
 
 /**
- * tracefs_hist2d_alloc - Initialize two-dimensional histogram
+ * tracefs_hist_alloc_2d - Initialize two-dimensional histogram
  * @tep: The tep handle that has the @system and @event.
  * @system: The system the histogram event is in.
  * @event: The event that the histogram will be attached to.
@@ -250,20 +250,20 @@ tracefs_hist1d_alloc(struct tep_handle *tep,
  * NULL on failure.
  */
 struct tracefs_hist *
-tracefs_hist2d_alloc(struct tep_handle *tep,
-		     const char *system, const char *event_name,
-		     const char *key1, enum tracefs_hist_key_type type1,
-		     const char *key2, enum tracefs_hist_key_type type2)
+tracefs_hist_alloc_2d(struct tep_handle *tep,
+		      const char *system, const char *event_name,
+		      const char *key1, enum tracefs_hist_key_type type1,
+		      const char *key2, enum tracefs_hist_key_type type2)
 {
 	struct tracefs_hist_axis axis[] = {{key1, type1},
 					   {key2, type2},
 					   {NULL, 0}};
 
-	return tracefs_hist_alloc(tep, system, event_name, axis);
+	return tracefs_hist_alloc_nd(tep, system, event_name, axis);
 }
 
 /**
- * tracefs_hist_alloc - Initialize N-dimensional histogram
+ * tracefs_hist_alloc_nd - Initialize N-dimensional histogram
  * @tep: The tep handle that has the @system and @event.
  * @system: The system the histogram event is in
  * @event: The event that the histogram will be attached to
@@ -278,9 +278,9 @@ tracefs_hist2d_alloc(struct tep_handle *tep,
  * NULL on failure.
  */
 struct tracefs_hist *
-tracefs_hist_alloc(struct tep_handle *tep,
-		   const char *system, const char *event_name,
-		   struct tracefs_hist_axis *axes)
+tracefs_hist_alloc_nd(struct tep_handle *tep,
+		      const char *system, const char *event_name,
+		      struct tracefs_hist_axis *axes)
 {
 	struct tep_event *event;
 	struct tracefs_hist *hist;
@@ -1861,8 +1861,8 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 				return NULL;
 			}
 		} else {
-			hist = tracefs_hist1d_alloc(tep, system, event,
-						    key, type);
+			hist = tracefs_hist_alloc(tep, system, event,
+						  key, type);
 			if (!hist)
 				return NULL;
 		}
-- 
2.31.1

