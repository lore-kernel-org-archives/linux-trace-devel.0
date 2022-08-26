Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52FCECAAD4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Aug 2022 14:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiHZOZB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 10:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiHZOZA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 10:25:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E43425D2
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Aug 2022 07:24:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8B67B1F8B5;
        Fri, 26 Aug 2022 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661523896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+nfjCLm3F0ArpI8hl+y6sxVtwbDldoZNcQQ+eNQFPrY=;
        b=dnjPwzgBjeXVpjHIOOSjT57tAzJuujWq9zl+vJR6Kv9I+GoEYMDvqUyz0v8afE3orZFkdP
        55s1DNxMlMUXIeLTwcWd8SQSVOSjpHXi2vOBm+tsC1WFplCbRI51mUeVYNYLAC/st5Vafq
        SL08qsLYXrtgVhNT3nfKXryrzumHAUA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7051C13421;
        Fri, 26 Aug 2022 14:24:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BmgbGrjXCGOnQwAAMHmgww
        (envelope-from <alexandre.vicenzi@suse.com>); Fri, 26 Aug 2022 14:24:56 +0000
From:   Alexandre Vicenzi <alexandre.vicenzi@suse.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Alexandre Vicenzi <alexandre.vicenzi@suse.com>
Subject: [PATCH 1/3] libtracefs: Add tracefs_tracer_available helper
Date:   Fri, 26 Aug 2022 16:24:18 +0200
Message-Id: <20220826142420.29911-1-alexandre.vicenzi@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add tracefs_tracer_available helper function to check if a giver tracer is available.

Signed-off-by: Alexandre Vicenzi <alexandre.vicenzi@suse.com>
---
 Documentation/libtracefs-utils.txt | 11 +++++++++--
 Documentation/libtracefs.txt       |  1 +
 include/tracefs.h                  |  2 ++
 src/tracefs-utils.c                | 28 ++++++++++++++++++++++++++++
 utest/tracefs-utest.c              |  3 +++
 5 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
index ddbd675..ab16cc6 100644
--- a/Documentation/libtracefs-utils.txt
+++ b/Documentation/libtracefs-utils.txt
@@ -3,8 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_tracers, tracefs_get_clock, tracefs_list_free, tracefs_list_add,
-tracefs_list_size - Helper functions for working with trace file system.
+tracefs_tracers, tracefs_tracer_available, tracefs_get_clock, tracefs_list_free,
+tracefs_list_add, tracefs_list_size - Helper functions for working with trace file system.
 
 SYNOPSIS
 --------
@@ -13,6 +13,7 @@ SYNOPSIS
 *#include <tracefs.h>*
 
 char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
+bool *tracefs_tracer_available*(const char pass:[*]_tracing_dir_, const char pass:[*]_tracer_);
 char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
 void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
 char pass:[**]*tracefs_list_add*(char **_list_, const char *_string_);
@@ -30,6 +31,9 @@ for the trace systems of the local machine, or it may be a path to a copy
 of the tracefs directory from another machine. The last entry in the array
 as a NULL pointer. The array must be freed with *tracefs_list_free()* API.
 
+The *tracefs_tracer_available()* returns true if the _tracer_ is available
+in the given _tracing_dir_director_, and false otherwise.
+
 The *tracefs_get_clock()* function returns name of the current trace clock,
 used in the given _instance_. If _instance_ is NULL, the clock of the main
 trace instance is returned. The returned string must be freed with free().
@@ -56,6 +60,9 @@ The *tracefs_tracers()* returns array of strings. The last element in that
 array is a NULL pointer. The array must be freed with *tracefs_list_free()* API.
 In case of an error, NULL is returned.
 
+The *tracefs_tracer_available()* returns true if the _tracer_ is available,
+and false otherwise.
+
 The *tracefs_get_clock()* returns string, that must be freed with free(), or NULL
 in case of an error.
 
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 82cb574..4f016f7 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -112,6 +112,7 @@ Trace options:
 
 Ftrace tracers:
 	char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
+	bool *tracefs_tracer_available*(const char pass:[*]_tracing_dir_, const char pass:[*]_tracer_);
 	int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_);
 	int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_, const char pass:[*]_name_);
 	int *tracefs_tracer_clear*(struct tracefs_instance pass:[*]_instance_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 693860d..ffa6842 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -77,6 +77,8 @@ void tracefs_list_free(char **list);
 char **tracefs_list_add(char **list, const char *string);
 int tracefs_list_size(char **list);
 
+bool tracefs_tracer_available(const char *tracing_dir, const char *tracer);
+
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
  * @instance: ftrace instance, can be NULL for the top instance
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 22f82af..766ed1b 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -514,3 +514,31 @@ int tracefs_list_size(char **list)
 	list--;
 	return (int)*(unsigned long *)list;
 }
+
+/**
+ * tracefs_tracer_available - test if a tracer is available
+ * @tracing_dir: The directory that contains the tracing directory
+ * @tracer: The name of the tracer
+ *
+ * Return true if the tracer is available
+ */
+bool tracefs_tracer_available(const char *tracing_dir, const char *tracer)
+{
+	bool ret = false;
+	char **tracers = NULL;
+	int i;
+
+	tracers = tracefs_tracers(tracing_dir);
+	if (!tracers)
+		return false;
+
+	for (i = 0; tracers[i]; i++) {
+		if (strcmp(tracer, tracers[i]) == 0) {
+			ret = true;
+			break;
+		}
+	}
+
+	tracefs_list_free(tracers);
+	return ret;
+}
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 3f63837..1ab43d2 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1404,6 +1404,9 @@ static void test_instance_tracers(struct tracefs_instance *instance)
 	tracers = tracefs_tracers(tdir);
 	CU_TEST(tracers != NULL);
 
+	for (i = 0; tracers[i]; i++)
+		CU_TEST(tracefs_tracer_available(tdir, tracers[i]));
+
 	tfile = tracefs_instance_file_read(NULL, ALL_TRACERS, NULL);
 
 	tracer = strtok(tfile, " ");
-- 
2.34.1

