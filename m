Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345CBC5517A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8942620796
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPuq45Vh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgJ2LSZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgJ2LSY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BE6C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h22so2054655wmb.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cgkXtTTjQDFCWlL20hKA9bd4TLgxzqbmC9tF3XKRt+4=;
        b=QPuq45VhmcElznbWwC7VGNmPsw2oyFzhwl56k7dNiAhaYCHD6kHQ+enZb4bhDWAXvh
         EIclJPGMhPKSfKVc+HYdhZG48wzUSsUYFeh2MK3SyNJPv4fxnLAzyYb7Hdo7oOEk+GPv
         eUdujyC5YmdSM6D6pIkUoT2C2LMIShpgBxtshJ54psMT3JXUTkhqmnGA1u+9TmP0YW26
         ivcUPO5ub+3EYSJ4/Mc413vR51KMf89p07XNr75wGG1FK/6qfkga/6XdNUwij+IvhRh0
         QX9IbpbQoOeF4HIoDUtRIWmvLOibK6MEOUWtKbuRlsdp8ylOy1C9sF+PGH1Y62dq927f
         iXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cgkXtTTjQDFCWlL20hKA9bd4TLgxzqbmC9tF3XKRt+4=;
        b=lGbl5l29JDQPtjblrVpBgcfVJGdzPlCuUYjPl/UnCJ4BQO9NouYrti2Rw/Su24Oq0t
         bRzMhg9q1Y8fGLaLtCz6cGri75I7+Kt6f8fX39kFf1DTVtK7uqddDVvCTb7ICDoYFkWK
         jQNHifLYuHzWC1YG9Bk9b+c0dMVpX9rkTz0HY36RykYNdpDNDGELzySCvc/17YD2Ttv0
         +2vegbh+BfTRwURXG9lNQHWvqTbL63tH8g8DMsjHohrmXmUDRQQ0vEGkDs7k8Pkb4Wzi
         5kQA4M3O6BlfMguI2QWQzfP5VwtmaBzCSLm7AaczlVg+GX17rUpYe43oksjajsCYK5Hz
         EBJA==
X-Gm-Message-State: AOAM531kKBtNX69HvW0bkqgZ90tVZtg6bfYQZ6LEGxe1gPlr4nL+vhgB
        mZcRGUDm4UGFJVeaoqJxts4+3VVwh/k528ni
X-Google-Smtp-Source: ABdhPJxlxMG/zotHZs7h4sKzvtB/sDoLfUdrIU19DxRA0VB3yueJPOei6sa3aJDxPrdjk5q8UwdQ6Q==
X-Received: by 2002:a7b:c00b:: with SMTP id c11mr3793614wmb.96.1603970303162;
        Thu, 29 Oct 2020 04:18:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 04/16] trace-cmd: Add new libtrasefs API to get the current trace clock
Date:   Thu, 29 Oct 2020 13:18:04 +0200
Message-Id: <20201029111816.247241-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API is added to tracefs library:
	tracefs_get_clock()
It reads the trace_clock file from the ftrace file system, parses it
and returns a string with the current trace clock. The returned string
must be freed by free().

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      |  2 ++
 lib/tracefs/tracefs-instance.c | 35 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-stat.c          | 29 +++++++---------------------
 3 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 8ee7ba6e..fb33e6e8 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -55,4 +55,6 @@ struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
 int tracefs_fill_local_events(const char *tracing_dir,
 			       struct tep_handle *tep, int *parsing_failures);
 
+char *tracefs_get_clock(struct tracefs_instance *instance);
+
 #endif /* _TRACE_FS_H */
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 50e88534..89d0b484 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -291,3 +291,38 @@ bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
 {
 	return check_file_exists(instance, name, true);
 }
+
+/**
+ * tracefs_get_clock - Get the current trace clock
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns the current trace clock of the given instance, or NULL in
+ * case of an error.
+ * The return string must be freed by free()
+ */
+char *tracefs_get_clock(struct tracefs_instance *instance)
+{
+	char *all_clocks = NULL;
+	char *ret = NULL;
+	int bytes = 0;
+	char *clock;
+	char *cont;
+
+	all_clocks  = tracefs_instance_file_read(instance, "trace_clock", &bytes);
+	if (!all_clocks || !bytes)
+		goto out;
+
+	clock = strstr(all_clocks, "[");
+	if (!clock)
+		goto out;
+	clock++;
+	cont = strstr(clock, "]");
+	if (!cont)
+		goto out;
+	*cont = '\0';
+
+	ret = strdup(clock);
+out:
+	free(all_clocks);
+	return ret;
+}
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 260d0c37..a29e0c34 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -736,33 +736,18 @@ static void report_buffers(struct buffer_instance *instance)
 
 static void report_clock(struct buffer_instance *instance)
 {
-	char *str;
-	char *cont;
 	char *clock;
 
-	str = get_instance_file_content(instance, "trace_clock");
-	if (!str)
-		return;
-
-	clock = strstr(str, "[");
-	if (!clock)
-		goto out;
-	clock++;
-
-	cont = strstr(clock, "]");
-	if (!cont) /* should never happen */
-		goto out;
-
-	*cont = '\0';
+	if (instance)
+		clock = tracefs_get_clock(instance->tracefs);
+	else
+		clock = tracefs_get_clock(NULL);
 
 	/* Default clock is "local", only show others */
-	if (strcmp(clock, "local") == 0)
-		goto out;
+	if (clock && !strcmp(clock, "local") == 0)
+		printf("\nClock: %s\n", clock);
 
-	printf("\nClock: %s\n", clock);
-
- out:
-	free(str);
+	free(clock);
 }
 
 static void report_cpumask(struct buffer_instance *instance)
-- 
2.26.2

