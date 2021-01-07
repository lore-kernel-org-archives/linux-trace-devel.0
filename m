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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAE2C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5683F20738
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbhAGIdi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIdh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:33:37 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A6BC0612F9
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:32:57 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id y17so4735439wrr.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=haKTlhRBvQnAoCt7ye6uAWGXu2XyjhNIGokztycdGfI=;
        b=DUPLG9dVeHK/15o/vAmHV6fmDYF7oYh6cxxGpTbh3BNLLzUFIqAjEv8TER+vaZUeaO
         k2x4jRQ60LKShJK2RsMjHQJ+EMMDMPMRxCDORMGakkWNd+XZ9Uyz14Ee0rqTqeE4WvYK
         /7awd09IRqIi7ugzZBJNcdj1qtlg/TbcdbftcIiXRcTjDBx2xX3bjqZL0nM4P6dKBoJB
         O0sy8X14HU9eJPReR3drxCRBaFQ0kPanuiJRS2jTMCYkp2AojULpRcuwiBWhiHbVLt+z
         SAPX/UsWtZsux3UafR+nIxLYzzTe63rKmfSkzzYf5cy+8J6TLxe5A2b0UhSQELqRSuH7
         88nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=haKTlhRBvQnAoCt7ye6uAWGXu2XyjhNIGokztycdGfI=;
        b=ebNY5UMw2UKTfme8lHk21UK4vH5fGOe7Ya2k6AHaj2zfs2uVfjWCsjn5bW6TgPUVxr
         AW1FZhCQFWvwX/QyuyTfQ+Egz8nW8v+YAjbeCVz3MG98dzNst6R6D500x3XhINkhL3r3
         KCd1e8aea61HPD5ZDH1TDkJQ/BoENfvJu8BxQs2bP6Zb/If/sfB3q9jw7v2VJdEsKvhF
         W3W4hJwJa2mnNzTXbMm9Brai7gC1XI/t0kLKploaJ9C66bOIOAzpO6DpnosIj+ozQ8ss
         FYzW3Hf9/oK99PFypa9Inn+ZfOvVdlhI+mgb7gMbdxZgpmXeSqnAMDdNjZ54Hn/mcgVw
         3B1A==
X-Gm-Message-State: AOAM531z3qbAfxRkHGYy9sk346+DS4mtqHvqv2ow4h3zcK/OFae2Ky2+
        do5hmNtOWM2oOuk4yKk988p11tbvg8ppHbi6
X-Google-Smtp-Source: ABdhPJzltPSPyJPu2RrFhJvEJOh7PdQhu6+/fPbkFhMVJwUYuu83OhWVp2SriSuHMORrRO6lUf0ETQ==
X-Received: by 2002:adf:eec6:: with SMTP id a6mr7750334wrp.239.1610008376150;
        Thu, 07 Jan 2021 00:32:56 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v20sm7293867wra.19.2021.01.07.00.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:32:55 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/6] libtracefs: Documentation for the new APIs for opening and reading ftrace files
Date:   Thu,  7 Jan 2021 10:32:47 +0200
Message-Id: <20210107083250.16295-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107083250.16295-1-tz.stoyanov@gmail.com>
References: <20210107083250.16295-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Man pages updated with documentation about:
  tracefs_instance_file_open();
  tracefs_instance_file_read_int();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-instances-files.txt | 47 ++++++++++++++++++--
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
index 9b18b73..d3aaef2 100644
--- a/Documentation/libtracefs-instances-files.txt
+++ b/Documentation/libtracefs-instances-files.txt
@@ -4,8 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_file_exists, tracefs_dir_exists, tracefs_instance_get_file,
-tracefs_instance_get_dir, tracefs_instance_file_write,
-tracefs_instance_file_read - Work with files in tracing instances.
+tracefs_instance_get_dir, tracefs_instance_file_open, tracefs_instance_file_write,
+tracefs_instance_file_read, tracefs_instance_file_read_int - Work with files in tracing instances.
 
 SYNOPSIS
 --------
@@ -17,8 +17,10 @@ bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass
 bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
 char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
 char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_instance_file_open*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int _mode_);
 int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
-char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_file_, int pass:[*]_psize_);
+char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
+int *tracefs_instance_file_read_int*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, long long int pass:[*]_res_);
 
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
 
+The _tracefs_instance_file_read_int()_ function reads the content of a _file_ from
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
 
+The _tracefs_instance_file_read_int()_ function returns 0 if a valid integer is read from the file
+and stored in _res_ or -1 in case of an error.
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
+	if (tracefs_instance_file_read_int(NULL, "tracing_on", &res) == 0) {
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
-- 
2.29.2

