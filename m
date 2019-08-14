Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C7FC433FF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1F322083B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDALI7cX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfHNIrX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34111 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfHNIrX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so110334873wrm.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BOlQQC/LhTmortr7wCI14Q4XMaaRk4LvFnhRPQhaeVk=;
        b=EDALI7cXlM1JvJoswI1dx2cG2cyiwYIkSo2T75/WROgk1yxA9fXliYPOSVbHYSJTdI
         CxiyBlt4tIwqnqSffrVW10ZcuYUxaVdtKs/a5gvK5F1BZTcXX+A0VIa5rumHnYlOMP7P
         DhXbMr8dS/mQwGIUqv3rtLudZsaPw6/1FwOP61tGj3PpdKwduXGLcd8wuguH+zlyuNfO
         VmE9FVh+9glzEL66ZvPXJDgmlyNRe8ODdjB2EjLMxAdFlj0gPawuFj1579j4VRyM+6Vh
         Z++5G7TQgtc+7Da7W0wlEg5aS9jMVHEkXhe013v7MC3pmsEprrY/hRBBP5+ed1Do6Qjc
         jDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BOlQQC/LhTmortr7wCI14Q4XMaaRk4LvFnhRPQhaeVk=;
        b=tP4V/twrHze+5z2gckk6qhgHWCU18uZNedzMQIg0rENK/0fKo2y3vMibG1dKBlJYf4
         u9IhiB1RG483qnQOHKXWnmcCOhVxsliyQC/mMdx5qsseaO6t6sWANLrHzdZvPZvhmOpS
         R4EpIaImyomhGNmnhfloO+NUG+8GWuy4AnXtMgnNBQwJrdtL/dWkVx4jGAZ5w513MurC
         RgLsZuu8RO7rwXDESCpqG4lgq0u1nDWnf5FXhC8Ywpg8YETNUk/Th8NIGwqe8T4LBMSR
         E5Ku2VjepNcrzhrJzTYQJIm7Syb1dRfHzIh5L+EADHAMCg+6X3OKsnW62WTBadC+YSe5
         2djA==
X-Gm-Message-State: APjAAAVpi9pWoH4C+JdjC0jAfynUKvUzrSQ6u98kT83aXp15bB0BU95B
        LQbZ5jkWBMZkySioGOrFHxgA+1k/wrU=
X-Google-Smtp-Source: APXvYqzU+2oCsMER6tFnSAEHfTXRuSMVyMNo62fX229Dw0BdcPatjjvxi1ZKqhdjt4FuWPvL2k9q/A==
X-Received: by 2002:a5d:4490:: with SMTP id j16mr24142596wrq.335.1565772440223;
        Wed, 14 Aug 2019 01:47:20 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/8] trace-cmd: Move trace-cmd global variable "quiet" to libtracecmd
Date:   Wed, 14 Aug 2019 11:47:04 +0300
Message-Id: <20190814084712.28188-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A trace-cmd global variable "quiet" is used from libtracecmd and
should be defined there. A new library APIs are implemented to
access it:
 void tracecmd_set_quiet(int quiet);
 int tracecmd_get_quiet(void);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h           |  3 +++
 lib/trace-cmd/include/trace-cmd-local.h |  2 --
 lib/trace-cmd/trace-output.c            |  4 ++--
 lib/trace-cmd/trace-util.c              | 21 +++++++++++++++++++++
 tracecmd/include/trace-local.h          |  1 -
 tracecmd/trace-cmd.c                    |  1 -
 tracecmd/trace-record.c                 |  6 +++---
 7 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index c4a437a..5ce8fb3 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -49,6 +49,9 @@ enum {
 void tracecmd_record_ref(struct tep_record *record);
 void free_record(struct tep_record *record);
 
+void tracecmd_set_quiet(int quiet);
+int tracecmd_get_quiet(void);
+
 struct tracecmd_input;
 struct tracecmd_output;
 struct tracecmd_recorder;
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index bad325f..09574db 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -18,8 +18,6 @@
 #define STR(x)	_STR(x)
 #define FILE_VERSION_STRING STR(FILE_VERSION)
 
-extern int quiet;
-
 static ssize_t __do_write(int fd, const void *data, size_t size)
 {
 	ssize_t tot = 0;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 1f94346..35252ef 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1157,7 +1157,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
-		if (!quiet)
+		if (!tracecmd_get_quiet())
 			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
 				i, (unsigned long long) offsets[i]);
 		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
@@ -1172,7 +1172,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			    check_size, sizes[i]);
 			goto out_free;
 		}
-		if (!quiet)
+		if (!tracecmd_get_quiet())
 			fprintf(stderr, "    %llu bytes in size\n",
 				(unsigned long long)check_size);
 	}
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 7c74bae..26b9a18 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -28,6 +28,7 @@
 
 int tracecmd_disable_sys_plugins;
 int tracecmd_disable_plugins;
+static int tracecmd_quiet;
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
@@ -96,6 +97,26 @@ char **trace_util_list_plugin_options(void)
 	return list;
 }
 
+/**
+ * tracecmd_set_quiet - Set if to print output to the screen
+ * @quiet: If non zero, print no output to the screen
+ *
+ */
+void tracecmd_set_quiet(int quiet)
+{
+	tracecmd_quiet = quiet;
+}
+
+/**
+ * tracecmd_get_quiet - Get if to print output to the screen
+ * Returns non zero, if no output to the screen should be printed
+ *
+ */
+int tracecmd_get_quiet(void)
+{
+	return tracecmd_quiet;
+}
+
 void trace_util_free_plugin_options_list(char **list)
 {
 	tracecmd_free_list(list);
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 78c52dc..23a3a29 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -13,7 +13,6 @@
 #include "event-utils.h"
 
 extern int debug;
-extern int quiet;
 
 /* fix stupid glib guint64 typecasts and printf formats */
 typedef unsigned long long u64;
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 797b303..5283ba7 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -17,7 +17,6 @@ int silence_warnings;
 int show_status;
 
 int debug;
-int quiet;
 
 void warning(const char *fmt, ...)
 {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b2ed6bf..b25b659 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3387,7 +3387,7 @@ static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
 
-	if (quiet)
+	if (tracecmd_get_quiet())
 		return;
 
 	if (!is_top_instance(instance))
@@ -4207,7 +4207,7 @@ static void check_plugin(const char *plugin)
 	}
 	die ("Plugin '%s' does not exist", plugin);
  out:
-	if (!quiet)
+	if (!tracecmd_get_quiet())
 		fprintf(stderr, "  plugin '%s'\n", plugin);
 	free(buf);
 }
@@ -5154,7 +5154,7 @@ static void parse_record_options(int argc,
 			break;
 		case OPT_quiet:
 		case 'q':
-			quiet = 1;
+			tracecmd_set_quiet(1);
 			break;
 		default:
 			usage(argv);
-- 
2.21.0

