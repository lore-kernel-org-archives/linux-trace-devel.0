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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D62C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7871122E01
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390589AbhALJVX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732377AbhALJVW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 04:21:22 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7338C0617A2
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:32 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id g12so308334ejf.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YC8+W9IviYLVe4KAzoDQWXwIO0NEa4o48S06NExlU0g=;
        b=Rc6RGmYCweqw6kOSejajW3mYTGLj7EFbxafvhWaGQLtABV7V5nTIw+oJzVM7shd/Nv
         E70GQ1zP97N56dkCgKUIqGlWGbf8vpM5UE6WcFkFX4orIFN7pJbblM9juFPcUWXtYHHO
         ruKQe7twfvYxKjW13EwOoPMCjmxP3PDRtngvmpCWQyYXBof5aIlU024nFc7EFiFwiHy1
         bnbVBHBm8/w8iqZEbGKuRg1czE4xgK4sdbpxIoqQrzxjOdP5PHPtMxM4ozARc4ZPE1Ux
         VArrCW0djNBJMa9ETKzNguQ733Y41gQZ9tmi5FgeLLv9T65zQ7VvXj0hlLVDqLeWHAW7
         S6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YC8+W9IviYLVe4KAzoDQWXwIO0NEa4o48S06NExlU0g=;
        b=E3Fy+Wt4Kh47vNLZo4sWf+P3lDO3E8wVJgIwmMvYBzElX3W1rhB+d/rGsJ4IxDHwmP
         NO5/KGuKCstmz9dqP77uEydGfH+1N45LJ5OGpCw3seL9X8GE2UTuXDyusV2TTU19Zmor
         yrZwFNuDwzEOQNfkajfDFw+qsNjWn/zljhtxmLWI/yRy6IAPpv7LNwPbTdwlYHj7mV+g
         D3wVFCrwu5MI/g/p6WLlNtVmftTPB/wlnOcIQVRhfVagS41T9xNxYfX3YL2coD4my6Bf
         ftnwQFEBRnKv8c4w9xEub33lQo5kKck05Iec78BwPupFcmNcX/OAIeFOrNRfzSksMhEe
         wY2A==
X-Gm-Message-State: AOAM531fvnHSb58hEpp1aFnyFJoxTVoKJOIixJPVS/RckYX95eUsxHF8
        jxij6iQPZYsSlnFhhCnlR0BYEQl5z0zr636S
X-Google-Smtp-Source: ABdhPJwuo6qTRkVL1L+lHy88SmuBYbclvw0epX/MGRArF/24toq5+qY0wT8MsU6tT88oTXvfeTtrzg==
X-Received: by 2002:a17:906:87c3:: with SMTP id zb3mr1352942ejb.244.1610443231539;
        Tue, 12 Jan 2021 01:20:31 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id rl7sm929187ejb.107.2021.01.12.01.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:20:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/7] libtracefs: Documentation for the new APIs for opening and reading ftrace files
Date:   Tue, 12 Jan 2021 11:20:21 +0200
Message-Id: <20210112092024.605705-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112092024.605705-1-tz.stoyanov@gmail.com>
References: <20210112092024.605705-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Man pages updated with documentation about:
  tracefs_instance_file_open();
  tracefs_instance_file_read_number();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-instances-files.txt | 45 ++++++++++++++++++--
 Documentation/libtracefs.txt                 |  2 +
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
index a9af1f7..124ef52 100644
--- a/Documentation/libtracefs-instances-files.txt
+++ b/Documentation/libtracefs-instances-files.txt
@@ -4,8 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_file_exists, tracefs_dir_exists, tracefs_instance_get_file,
-tracefs_instance_get_dir, tracefs_instance_file_write,
-tracefs_instance_file_read - Work with files in tracing instances.
+tracefs_instance_get_dir, tracefs_instance_file_open, tracefs_instance_file_write,
+tracefs_instance_file_read, tracefs_instance_file_read_number - Work with files in tracing instances.
 
 SYNOPSIS
 --------
@@ -17,8 +17,10 @@ bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass
 bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
 char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
 char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_instance_file_open*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int _mode_);
 int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
 char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
+int *tracefs_instance_file_read_number*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, long long int pass:[*]_res_);
 
 --
 
@@ -41,12 +43,19 @@ The _tracefs_instance_get_dir()_ function  returns the full path of the director
 with given _name_ in _instance_. Note, it does not check if the directory exists
 in the instance.
 
+The _tracefs_instance_file_open()_ function opens trace _file_ from given _instance_ and returns
+a file descriptor to it. The file access _mode_ can be specified, see *open*(3) for more details.
+If -1 is passed as _mode_, default O_RDWR is used.
+
 The _tracefs_instance_file_write()_ function writes a string _str_ in a _file_ from
 the given _instance_, without the terminating NULL character.
 
-The _tracefs_instance_file_read()_ function reads the content of a _file_  from
+The _tracefs_instance_file_read()_ function reads the content of a _file_ from
 the given _instance_.
 
+The _tracefs_instance_file_read_number()_ function reads the content of a _file_ from
+the given _instance_ and converts it to a long long integer, which is stored in _res_.
+
 RETURN VALUE
 ------------
 The _tracefs_file_exists()_ and  _tracefs_dir_exists()_ functions return true if the
@@ -56,6 +65,9 @@ The _tracefs_instance_get_file()_ and _tracefs_instance_get_dir()_ functions ret
 a string or NULL in case of an error. The returned string must be freed with
 _tracefs_put_tracing_file()_.
 
+The _tracefs_instance_file_open()_ function returns a file descriptor to the opened file. It must be
+closed with *close*(3). In case of an error, -1 is returned.
+
 The _tracefs_instance_file_write()_ function returns the number of written bytes,
 or -1 in case of an error.
 
@@ -63,6 +75,9 @@ The _tracefs_instance_file_read()_ function returns a pointer to a NULL terminat
 string, read from the file, or NULL in case of an error. The returned string must
 be freed with free().
 
+The _tracefs_instance_file_read_number()_ function returns 0 if a valid integer is read from
+the file and stored in _res_ or -1 in case of an error.
+
 EXAMPLE
 -------
 [source,c]
@@ -123,6 +138,30 @@ struct tracefs_instance *inst = tracefs_instance_create("foo");
 		tracefs_instance_destroy(inst);
 	else
 		tracefs_instance_free(inst);
+	...
+
+	long long int res;
+	if (tracefs_instance_file_read_number(NULL, "tracing_on", &res) == 0) {
+		if (res == 0) {
+			/* tracing is disabled in the top instance */
+		} else if (res == 1) {
+			/* tracing is enabled in the top instance */
+		} else {
+			/* Unknown tracing state of the top instance */
+		}
+	} else {
+		/* Failed to read integer from tracing_on file */
+	}
+
+	...
+
+	int fd;
+	fd = tracefs_instance_file_open(NULL, "tracing_on", O_WRONLY);
+	if (fd >= 0) {
+		/* Got file descriptor to the tracing_on file from the top instance for writing */
+		...
+		close(fd);
+	}
 --
 FILES
 -----
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index bf3882f..0350416 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -25,8 +25,10 @@ Trace instances:
 	bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
 	char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
 	char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_instance_file_open*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int _mode_);
 	int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
 	char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
+	int *tracefs_instance_file_read_number*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, long long int pass:[*]_res_);
 	const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
 	bool *tracefs_instance_exists*(const char pass:[*]_name_);
-- 
2.29.2

