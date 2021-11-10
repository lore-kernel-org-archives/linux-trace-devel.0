Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2379AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 23:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 087246112E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 23:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhKJX21 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 18:28:27 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:34883 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233964AbhKJX20 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 18:28:26 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2021 18:28:26 EST
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 10 Nov 2021 15:10:31 -0800
Received: from vypre.local.home (unknown [10.21.244.28])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id D13F92056F;
        Wed, 10 Nov 2021 15:10:35 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] tracefs: Rename tracefs_hist_reset_sort_key() tracefs_hist_set_sort_key()
Date:   Wed, 10 Nov 2021 18:10:25 -0500
Message-ID: <20211110231025.1131051-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110231025.1131051-1-rostedt@goodmis.org>
References: <20211110231025.1131051-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The commit log that added tracefs_hist_reset_sort_key() called it
tracefs_hist_set_sort_key(), and that seems to be a better name.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt | 8 ++++----
 include/tracefs.h                 | 4 ++--
 src/tracefs-hist.c                | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index cc82286..cc6b859 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value, tracefs_hist_add_name, tracefs_hist_start,
-tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_reset_sort_key,tracefs_hist_sort_key_direction - Create and update event histograms
+tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key,tracefs_hist_sort_key_direction - Create and update event histograms
 
 SYNOPSIS
 --------
@@ -28,8 +28,8 @@ int tracefs_hist_add_key(struct tracefs_hist pass:[*]hist, const char pass:[*]ke
 int tracefs_hist_add_value(struct tracefs_hist pass:[*]hist, const char pass:[*]value);
 int tracefs_hist_add_sort_key(struct tracefs_hist pass:[*]hist,
 			      const char pass:[*]sort_key);
-int tracefs_hist_reset_sort_key(struct tracefs_hist pass:[*]hist,
-			        const char pass:[*]sort_key, ...);
+int tracefs_hist_set_sort_key(struct tracefs_hist pass:[*]hist,
+			      const char pass:[*]sort_key, ...);
 int tracefs_hist_sort_key_direction(struct tracefs_hist pass:[*]hist,
 				    const char pass:[*]sort_key,
 				    enum tracefs_hist_sort_direction dir);
@@ -104,7 +104,7 @@ that must match either an already defined key of the histogram, or an already
 defined value. If _hist_  already has sorting keys (previously added) the new
 _sort_key_ will have lower priority(be secondary or so on) when sorting.
 
-*tracefs_hist_reset_sort_key*() will reset the list of key to sort on. The _hist_ is
+*tracefs_hist_set_sort_key*() will reset the list of key to sort on. The _hist_ is
 the histrogram descriptor to reset the sort key to. The _sort_key_ is a string
 that must match either an already defined key of the histogram, or an already
 defined value. Multiple sort keys may be added to denote a secondary, sort order
diff --git a/include/tracefs.h b/include/tracefs.h
index ebe83fe..32420eb 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -337,8 +337,8 @@ int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
 int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
 			      const char *sort_key);
-int tracefs_hist_reset_sort_key(struct tracefs_hist *hist,
-				const char *sort_key, ...);
+int tracefs_hist_set_sort_key(struct tracefs_hist *hist,
+			      const char *sort_key, ...);
 int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
 				    const char *sort_key,
 				    enum tracefs_hist_sort_direction dir);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 27bab00..7745bca 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -477,7 +477,7 @@ int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
 }
 
 /**
- * tracefs_hist_reset_sort_key - set a key for sorting the histogram
+ * tracefs_hist_set_sort_key - set a key for sorting the histogram
  * @hist: The histogram to set the sort key to
  * @sort_key: The key to sort (and the strings after it)
  *  Last one must be NULL.
@@ -487,8 +487,8 @@ int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
  *
  * Returns 0 on success, -1 on error.
  */
-int tracefs_hist_reset_sort_key(struct tracefs_hist *hist,
-				const char *sort_key, ...)
+int tracefs_hist_set_sort_key(struct tracefs_hist *hist,
+			      const char *sort_key, ...)
 {
 	char **list = NULL;
 	char **tmp;
-- 
2.31.1

