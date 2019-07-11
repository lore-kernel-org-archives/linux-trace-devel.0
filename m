Return-Path: <SRS0=ayt5=VI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B78C74A52
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A3B21019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HRvCadtD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfGKNDR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:03:17 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34925 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfGKNDR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 09:03:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so5638343wmg.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jul 2019 06:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WR2jIgSsS56EgfqYRN5eioND93JCvfRPCKcbSf6T2+Q=;
        b=HRvCadtD+bqPlxCV3N2XHjLTiuJnGuF4P/baqgphj0aepLpCfMeQF73uQh3FHGhLCd
         wkNsUunAOTXkz82NgIIzTmj/NVojoozdMK+pDu0s6+CTx9RyS/pwjPUVN22IIQeYmE2m
         M3m6JjP36CrexK+j87FsuuJF18VqKyUMif1ICx8CHo3ExfHmRMAwse3kRwQ6yx4ndjAc
         RRaeGoy63nCQstnKJCP7p9Ogq8PEZ9Rx6CzYwFfFbMy8tWiu/kN+zp1hgHoeWo31ixCO
         WjPdMHwoaP5WiTQkLDoBr62rQex4AzjumWC/1IGWJ1AGcuJ/WaCd0xJdY6hPPgxNg6C8
         gFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WR2jIgSsS56EgfqYRN5eioND93JCvfRPCKcbSf6T2+Q=;
        b=WxxG1tS7lsvHqSh05S33AcXezrVfxUJrURD88HShJCq/lAndBbYMBlKpt/9etaT+TM
         1v/21s2MSGZAoIdQfEZetrcNlEYoMbMF2qgq8Ep4RqZ2rfrQ5oeElURaqCiOfcecQGFH
         giR27P8X7hnvLRHZtNMmyImhnMxnCswZBeIg0oz/stu66+ikjLWtxs/p5GJSUyptdyDu
         agwNaTwYbL04Q1Gq9yVAcQupXsYJb9S5dTEwezsMAOMHkKLK5nYVcv8cvH0cKE0F/gYh
         IC2g9IYR24DpvZHCGAGVP1tNqf4byQrjSrmNDxQ0rQ4rdzl2IjVnpybp4BdTflRpPs1X
         he1w==
X-Gm-Message-State: APjAAAWZ0RTBcD+CtoTe+laBJ7MI0rgNF4sh+uf3zPYv5R6JngsT99O2
        tLZAWMCBCzBSW3OnXkviHK4=
X-Google-Smtp-Source: APXvYqzqRJpMuzqcMDELggRyIfyBAQ5+0N3HOAidYvrcEOL8lToI0CbDbdTecQxBjilOJIntGRoVew==
X-Received: by 2002:a1c:4041:: with SMTP id n62mr4369924wma.100.1562850194011;
        Thu, 11 Jul 2019 06:03:14 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h6sm4642590wre.82.2019.07.11.06.03.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:03:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/7] trace-cmd: Move trace-cmd global variable "quiet" to libtracecmd
Date:   Thu, 11 Jul 2019 16:03:03 +0300
Message-Id: <20190711130307.25041-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711130307.25041-1-tz.stoyanov@gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
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
 include/trace-cmd/trace-cmd.h      |  3 +++
 lib/trace-cmd/trace-output.c       |  4 ++--
 lib/trace-cmd/trace-util.c         | 21 +++++++++++++++++++++
 tracecmd/include/trace-cmd-local.h |  2 --
 tracecmd/include/trace-local.h     |  1 -
 tracecmd/trace-cmd.c               |  1 -
 tracecmd/trace-record.c            |  6 +++---
 7 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6f62ab9..8c8f87c 100644
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
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 33d6ce3..6ca7110 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1158,7 +1158,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
-		if (!quiet)
+		if (!tracecmd_get_quiet())
 			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
 				i, (unsigned long long) offsets[i]);
 		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
@@ -1173,7 +1173,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
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
diff --git a/tracecmd/include/trace-cmd-local.h b/tracecmd/include/trace-cmd-local.h
index fa96d4f..16db7a3 100644
--- a/tracecmd/include/trace-cmd-local.h
+++ b/tracecmd/include/trace-cmd-local.h
@@ -11,8 +11,6 @@
 #include "trace-cmd.h"
 #include "event-utils.h"
 
-extern int quiet;
-
 static ssize_t __do_write(int fd, const void *data, size_t size)
 {
 	ssize_t tot = 0;
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 1cad3cc..8fbafa6 100644
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
index 5dc6f17..e647117 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3163,7 +3163,7 @@ static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
 
-	if (quiet)
+	if (tracecmd_get_quiet())
 		return;
 
 	if (!is_top_instance(instance))
@@ -3979,7 +3979,7 @@ static void check_plugin(const char *plugin)
 	}
 	die ("Plugin '%s' does not exist", plugin);
  out:
-	if (!quiet)
+	if (!tracecmd_get_quiet())
 		fprintf(stderr, "  plugin '%s'\n", plugin);
 	free(buf);
 }
@@ -4913,7 +4913,7 @@ static void parse_record_options(int argc,
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

