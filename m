Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E8DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAA4260E54
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245468AbhIXJ65 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245451AbhIXJ6v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 05:58:51 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69235C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ee50so33993795edb.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wBCqjXHWBmBSRhU1TRAUjG9WWuUPmGhegCeaVXbL/p0=;
        b=Fa0GfDBQhnp3doKLDhua1L4d5pKrQ+Mt7cI5N7gnXQf23UMfO5OfWonMby2O0yjy9E
         12bIqYtrA4VdaZ8W4aLAGMU/PI9fqb6DdmEZUZTuvmtfFmzrhOhV6GbEI2BbHZ8CKCvf
         ugcjVB4InEqTXwBkU1Gmr9hGo7mvClziF3S1DbtRZ939X5bKyQTaN2lyd5UaupU/mQHx
         /cYWHAqQ3KCXGkowy71M5zriHaDIU/yQdX82IGTJysKkz8cOg8lBukENqm/TTqZzz4D1
         3PESmM7WimGjKs1k2zpxph4vCofSMzwN5Z6qiST3IRCR5726DdPC9Qw3KODIijzuCj3b
         KZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wBCqjXHWBmBSRhU1TRAUjG9WWuUPmGhegCeaVXbL/p0=;
        b=o4cS23Y6OCxhx/YGVRwToZ2cIQcm9+s6TKwY0jQc8DdRQlSVqhgmbWaZAR7WRpN43l
         8DxxvlWHK0NaAse7Vr9dgCTrhmiCQor+fl6YoGLP51DwgedsJ9wiHKi2ZR7KEa4BOhi7
         BMxb8d8fYJ/z/M5tL4i54cdTB4qOAo6JbpBm9jbA+C9p6sF1foINEmEzkuFO12vgaJSY
         s/HSW+RKmx1QDcHx53SSCb8sI1F/Lfc1F6SCMIFtst+1MwryZYH/kPdrRR9m2nXGmImn
         ed44nmjTkOCgvtn3TFYW3arQ+tG+o3URuPYblV2GzV6/RnHlExNrWEnL2v7yAbCD1ne8
         6bSg==
X-Gm-Message-State: AOAM533Ox8aASYoP+55vfUj2cv0V+QqtHIun4FkCKsX4JiZ8jidareUe
        shS3lg4xPntL5Up0gD/ophU=
X-Google-Smtp-Source: ABdhPJyAEo/luze2dWY8yYfZZmvvNAbkFoi2dGmzx8489G23/ifgonOlDqtkCw7r0GkS5yLI/q6YTA==
X-Received: by 2002:a50:e009:: with SMTP id e9mr3878222edl.254.1632477437014;
        Fri, 24 Sep 2021 02:57:17 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id n13sm4635907ejk.97.2021.09.24.02.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 02:57:16 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 4/4] libtracefs: Update 'hist' documentation
Date:   Fri, 24 Sep 2021 12:57:02 +0300
Message-Id: <20210924095702.151826-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924095702.151826-1-y.karadz@gmail.com>
References: <20210924095702.151826-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New 'hist' APIs have been added and some existing APIs have been
modified. Here we update the documentation accordingly.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-hist-cont.txt | 30 ++++++++--
 Documentation/libtracefs-hist.txt      | 80 +++++++++++++++-----------
 2 files changed, 69 insertions(+), 41 deletions(-)

diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
index 1b0153c..2ee830d 100644
--- a/Documentation/libtracefs-hist-cont.txt
+++ b/Documentation/libtracefs-hist-cont.txt
@@ -11,18 +11,36 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_hist_pause(struct tracefs_hist pass:[*]hist);
-int tracefs_hist_continue(struct tracefs_hist pass:[*]hist);
-int tracefs_hist_reset(struct tracefs_hist pass:[*]hist);
+int tracefs_hist_start(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
+int tracefs_hist_destory(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
+int tracefs_hist_pause(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
+int tracefs_hist_continue(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
+int tracefs_hist_reset(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
+
 --
 
 DESCRIPTION
 -----------
+
+*tracefs_hist_start* is called to actually start the histogram _hist_.
+The _instance_ is the instance to start the histogram in, NULL if it
+should start at the top level.
+
 *tracefs_hist_pause* is called to pause the histogram _hist_.
+The _instance_ is the instance to pause the histogram in, NULL if it
+is in the top level.
 
 *tracefs_hist_continue* is called to continue a paused histogram _hist_.
+The _instance_ is the instance to continue the histogram, NULL if it
+is in the top level.
 
 *tracefs_hist_reset* is called to clear / reset the histogram _hist_.
+The _instance_ is the instance to clear the histogram, NULL if it
+is in the top level.
+
+*tracefs_hist_destory* is called to delete the histogram where it will no longer
+exist.  The _instance_ is the instance to delete the histogram from, NULL if it
+is in the top level.
 
 RETURN VALUE
 ------------
@@ -83,14 +101,14 @@ int main (int argc, char **argv, char **env)
 	}
 
 	hist = tracefs_hist_alloc(instance, "kmem", "kmalloc",
-				  "call_site", TRACEFS_HIST_KEY_SYM);
+				  "call_site", TRACEFS_HIST_KEY_SYM,
+				  "bytes_req", 0);
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
 		exit(-1);
 	}
 
-	ret = tracefs_hist_add_key(hist, "bytes_req", 0);
-	ret |= tracefs_hist_add_value(hist, "bytes_alloc");
+	ret = tracefs_hist_add_value(hist, "bytes_alloc");
 	ret |= tracefs_hist_add_sort_key(hist, "bytes_req", "bytes_alloc", NULL);
 
 	ret |= tracefs_hist_sort_key_direction(hist, "bytes_alloc",
diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 03ac077..0139ba8 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value, tracefs_hist_add_name, tracefs_hist_start,
-tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_sort_key_direction - Create and update event histograms
+tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_reset_sort_key,tracefs_hist_sort_key_direction - Create and update event histograms
 
 SYNOPSIS
 --------
@@ -12,15 +12,24 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-struct tracefs_hist pass:[*]tracefs_hist_alloc(struct tracefs_tep pass:[*] tep,
+struct tracefs_hist pass:[*]tracefs_hist1d_alloc(struct tracefs_tep pass:[*] tep,
 			const char pass:[*]system, const char pass:[*]event,
 			const char pass:[*]key, enum tracefs_hist_key_type type);
+struct tracefs_hist pass:[*]tracefs_hist2d_alloc(struct tracefs_tep pass:[*] tep,
+			const char pass:[*]system, const char pass:[*]event,
+			const char pass:[*]key1, enum tracefs_hist_key_type type1,
+			const char pass:[*]key2, enum tracefs_hist_key_type type2));
+struct tracefs_hist pass:[*]tracefs_hist_alloc(struct tracefs_tep pass:[*] tep,
+			const char pass:[*]system, const char pass:[*]event,
+			struct tracefs_hist_axis [*]axes);
 void tracefs_hist_free(struct tracefs_hist pass:[*]hist);
 int tracefs_hist_add_key(struct tracefs_hist pass:[*]hist, const char pass:[*]key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist pass:[*]hist, const char pass:[*]value);
 int tracefs_hist_add_sort_key(struct tracefs_hist pass:[*]hist,
-			      const char pass:[*]sort_key, ...);
+			      const char pass:[*]sort_key);
+int tracefs_hist_reset_sort_key(struct tracefs_hist pass:[*]hist,
+			        const char pass:[*]sort_key, ...);
 int tracefs_hist_sort_key_direction(struct tracefs_hist pass:[*]hist,
 				    const char pass:[*]sort_key,
 				    enum tracefs_hist_sort_direction dir);
@@ -36,8 +45,7 @@ int tracefs_hist_show(struct trace_seq pass:[*]s, struct tracefs_instance pass:[
 int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
 			 struct tracefs_hist pass:[*]hist,
 			 enum tracefs_hist_command command);
-int tracefs_hist_start(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
-int tracefs_hist_destory(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
+
 --
 
 DESCRIPTION
@@ -47,14 +55,31 @@ The syntax can be complex and difficult to get correct. This API handles the
 syntax, and facilitates the creation and interaction with the event histograms.
 See https://www.kernel.org/doc/html/latest/trace/histogram.html for more information.
 
-*tracefs_hist_alloc*() allocates a "struct tracefs_hist" descriptor and returns
-the address of it. This descriptor must be freed by *tracefs_hist_free*().
+*tracefs_hist1d_alloc*() allocates a "struct tracefs_hist" descriptor of a one-dimensional
+histogram and returns the address of it. This descriptor must be freed by *tracefs_hist_free*().
 The _tep_ is a trace event handle (see *tracefs_local_events*(3)), that holds the
 _system_ and _event_ that the histogram will be attached to. The _system_ is the
 system or group of the event. The _event_ is the event to attach the histogram to.
-The _key_ is a field of the event that will be used as the key of the histogram.
+The _key_ is a field of the event that will be used as the key(dimension) of the histogram.
 The _type_ is the type of the _key_. See KEY TYPES below.
 
+*tracefs_hist2d_alloc*() allocates a "struct tracefs_hist" descriptor of a two-dimensional
+histogram and returns the address of it. This descriptor must be freed by *tracefs_hist_free*().
+The _tep_ is a trace event handle (see *tracefs_local_events*(3)), that holds the
+_system_ and _event_ that the histogram will be attached to. The _system_ is the
+system or group of the event. The _event_ is the event to attach the histogram to.
+The _key1_ is the first field of the event that will be used as the key(dimension)
+of the histogram. The _type1_ is the type of the _key1_. See KEY TYPES below.
+The _key2_ is the second field of the event that will be used as the key(dimension)
+of the histogram. The _type2_ is the type of the _key2_. See KEY TYPES below.
+
+*tracefs_hist_alloc*() allocates a "struct tracefs_hist" descriptor of an N-dimensional
+histogram and returns the address of it. This descriptor must be freed by *tracefs_hist_free*().
+The _tep_ is a trace event handle (see *tracefs_local_events*(3)), that holds the
+_system_ and _event_ that the histogram will be attached to. The _system_ is the
+system or group of the event. The _event_ is the event to attach the histogram to.
+The _axes_ is an array of _key_ / _type_ pairs, defining the dimentions of the histogram.
+
 *tracefs_hist_free*() frees the _tracefs_hist_ descriptor. Note, it does not stop
 or disable the running histogram if it was started. *tracefs_hist_destroy*() needs
 to be called to do so.
@@ -73,8 +98,14 @@ key was hit. The _hist_ is the histogram descriptor to add the value to.
 The _value_ is a field in the histogram to add to when an instane of the
 key is hit.
 
-*tracefs_hist_add_sort_key*() will add a key to sort on. Th _hist_ is the
-the histrogram descriptor to add the sort key to. The _sort_key_ is a string
+*tracefs_hist_add_sort_key*() will add a key to sort on. The _hist_ is the
+histrogram descriptor to add the sort key to. The _sort_key_ is a string
+that must match either an already defined key of the histogram, or an already
+defined value. If _hist_  already has sorting keys (previously added) the new
+_sort_key_ will have lower priority(be secondary or so on) when sorting.
+
+*tracefs_hist_reset_sort_key*() will reset the list of key to sort on. The _hist_ is
+the histrogram descriptor to reset the sort key to. The _sort_key_ is a string
 that must match either an already defined key of the histogram, or an already
 defined value. Multiple sort keys may be added to denote a secondary, sort order
 and so on, but all sort keys must match an existing key or value, or be
@@ -146,27 +177,6 @@ The _cmd_ can be one of:
 The below functions are wrappers to tracefs_hist_command() to make the
 calling conventions a bit easier to understand what is happening.
 
-*tracefs_hist_start* is called to actually start the histogram _hist_.
-The _instance_ is the instance to start the histogram in, NULL if it
-should start at the top level.
-
-*tracefs_hist_pause* is called to pause the histogram _hist_.
-The _instance_ is the instance to pause the histogram in, NULL if it
-is in the top level.
-
-*tracefs_hist_continue* is called to continue a paused histogram _hist_.
-The _instance_ is the instance to continue the histogram, NULL if it
-is in the top level.
-
-*tracefs_hist_reset* is called to clear / reset the histogram _hist_.
-The _instance_ is the instance to clear the histogram, NULL if it
-is in the top level.
-
-*tracefs_hist_destory* is called to delete the histogram where it will no longer
-exist.  The _instance_ is the instance to delete the histogram from, NULL if it
-is in the top level.
-
-
 KEY TYPES
 ---------
 
@@ -263,15 +273,15 @@ int main (int argc, char **argv, char **env)
 	}
 
 	tep = tracefs_local_events(NULL);
-	hist = tracefs_hist_alloc(tep, "kmem", "kmalloc",
-				  "call_site", TRACEFS_HIST_KEY_SYM);
+	hist = tracefs_hist2d_alloc(tep, "kmem", "kmalloc",
+				    "call_site", TRACEFS_HIST_KEY_SYM,
+				    "bytes_req", 0);
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
 		exit(-1);
 	}
 
-	ret = tracefs_hist_add_key(hist, "bytes_req", 0);
-	ret |= tracefs_hist_add_value(hist, "bytes_alloc");
+	ret = tracefs_hist_add_value(hist, "bytes_alloc");
 	ret |= tracefs_hist_add_sort_key(hist, "bytes_req", "bytes_alloc", NULL);
 
 	ret |= tracefs_hist_sort_key_direction(hist, "bytes_alloc",
-- 
2.30.2

