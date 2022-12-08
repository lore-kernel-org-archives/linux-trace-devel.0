Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0381C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Dec 2022 20:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLHUxe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 15:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHUxd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 15:53:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380178B1A4
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 12:53:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D542AB82625
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 20:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF36C433EF
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 20:53:29 +0000 (UTC)
Date:   Thu, 8 Dec 2022 15:53:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Rename kbuffer_create() to tep_kbuffer()
Message-ID: <20221208155325.50bde2ea@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of adding a dependency of tep_handle to the kbuffer code, as
kbuffer should not reference the tep_handle, instead, it makes much more
sense to return a kbuffer descriptor from an existing tep_handle from the
tep interface.

Rename kbuffer_create() to tep_kbuffer().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-handle.txt | 9 ++++++++-
 Documentation/libtraceevent.txt        | 1 +
 include/traceevent/event-parse.h       | 2 ++
 include/traceevent/kbuffer.h           | 2 --
 src/parse-utils.c                      | 7 ++++---
 5 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/libtraceevent-handle.txt b/Documentation/libtraceevent-handle.txt
index 0d6afdae81df..64528ebc3433 100644
--- a/Documentation/libtraceevent-handle.txt
+++ b/Documentation/libtraceevent-handle.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_alloc, tep_free,tep_ref, tep_unref,tep_get_ref - Create, destroy, manage
+tep_alloc, tep_free,tep_ref, tep_unref,tep_get_ref, tep_kbuffer - Create, destroy, manage
 references of trace event parser context.
 
 SYNOPSIS
@@ -40,6 +40,10 @@ it had used are cleaned up.
 
 The *tep_ref_get()* functions gets the current references of the _tep_ handler.
 
+The *tep_kbuffer()* function allocates a kbuffer descriptor that can be used to
+parse raw data that is represented by the _tep_ handle descriptor. It must be freed
+with *kbuf_free(3)*.
+
 RETURN VALUE
 ------------
 *tep_alloc()* returns a pointer to a newly created tep_handle structure.
@@ -48,6 +52,9 @@ NULL is returned in case there is not enough free memory to allocate it.
 *tep_ref_get()* returns the current references of _tep_.
 If _tep_ is NULL, 0 is returned.
 
+*tep_kbuffer()* returns a kbuffer descriptor that can parse the raw data that
+represents the tep handle. Must be freed with *kbuf_free(3)*.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 67e964567736..488e689f6c85 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -31,6 +31,7 @@ Management of tep handler data structure and access of its members:
 	int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
 	bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
 	int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum_, char pass:[*]_buf_, size_t _buflen_);
+	struct kbuffer pass:[*]*tep_kbuffer*(struct tep_handle pass:[*]:_tep_);
 
 Register / unregister APIs:
 	int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index df307666abfa..3be98b01671d 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -601,6 +601,8 @@ void tep_ref(struct tep_handle *tep);
 void tep_unref(struct tep_handle *tep);
 int tep_get_ref(struct tep_handle *tep);
 
+struct kbuffer *tep_kbuffer(struct tep_handle *tep);
+
 /* for debugging */
 void tep_print_funcs(struct tep_handle *tep);
 void tep_print_printk(struct tep_handle *tep);
diff --git a/include/traceevent/kbuffer.h b/include/traceevent/kbuffer.h
index abfd83e6fe9f..ca638bc06dba 100644
--- a/include/traceevent/kbuffer.h
+++ b/include/traceevent/kbuffer.h
@@ -29,10 +29,8 @@ enum {
 };
 
 struct kbuffer;
-struct tep_handle;
 
 struct kbuffer *kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian);
-struct kbuffer *kbuffer_create(struct tep_handle *tep);
 void kbuffer_free(struct kbuffer *kbuf);
 int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer);
 void *kbuffer_read_event(struct kbuffer *kbuf, unsigned long long *ts);
diff --git a/src/parse-utils.c b/src/parse-utils.c
index ffa6c5871289..9c38e1e644d7 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -125,12 +125,13 @@ void __weak __vpr_stat(const char *fmt, va_list ap)
 void vpr_stat(const char *fmt, va_list ap) __attribute__((weak, alias("__vpr_stat")));
 
 /**
- * kbuffer_create - create and allocate a new kbuffer
- * @tep: the data to get the long size and endianess from
+ * tep_kbuffer - return an allocated kbuffer that can be used for the tep handle
+ * @tep: the handle that will work with the kbuffer descriptor
  *
  * Allocates and returns a new kbuffer.
+ * The return must be freed by kbuffer_free();
  */
-struct kbuffer *kbuffer_create(struct tep_handle *tep)
+struct kbuffer *tep_kbuffer(struct tep_handle *tep)
 {
 	enum kbuffer_endian endian;
 	int long_size;
-- 
2.35.1

