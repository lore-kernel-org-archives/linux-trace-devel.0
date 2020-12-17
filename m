Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745E5C2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F961238E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgLQJrR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgLQJrR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:47:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576F0C0611CB
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:36 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q18so18390258wrn.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r+YUtLl/Hf8N/iAQo2QQM3eGnDGMajLkjE2wfra0Wbo=;
        b=YaGAJtKmNigO5Aof9I+o0gpD+GeJ5ObdWiaV80qU2gOh6YR/LBJWmDL3LP9C0P6vO3
         b8eXBtngHMu6SAObXhFq1CPUh87G6CfLWy4c4gBZp0ZQmY06oTj9KusoU5esBpK87WN+
         imtjgOJNXjWRHBe2NopWp3R6tcVptlLxvP4smCzPBY/o2LdYfRkYYl4JFtqZGuo61q6W
         pa6v7AaOs3X0FBxOGD6XaxvK7Afmv1ONCxVEXd/YhdX8PcknoISv+N9P+hd0cJqw+E5A
         Rg1HE+XkYyF1QCnxKYCbhb4F1ssHFR3K11OfQoAv5bWA/XBY/NAiDm0CvHAEgap96taC
         ixSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r+YUtLl/Hf8N/iAQo2QQM3eGnDGMajLkjE2wfra0Wbo=;
        b=N6AH213AIcjyZvvUheep0LdaS4RJVkOQwsJLIw7eTXJdS+Om0Zzu8hdnbBch1W63PZ
         3V/Qj3evxfl63MJTORhNhTbpTwEYPtk2levyeCiqLk6Oa825foLA6Zt8Q87PEfO7Zu4L
         q7Sqkvjbk13I1O1AN+9t+fXYXg2NaEUi02ty/c+qOlM4dBIdieJXHDFFZ3yFaKX4pAP2
         EIcmXWAc0alrzLhIFtvn2pNhamEJ/vd3rjovDiOrt9pom1t5BpFHWzncwxOvW6al0nsN
         xgcGQHnxKFRCWYVw/mRxjVThK+DvgveNxKF/EfbvgB++Um/z3eOaE9qH37rdXUGJaPz8
         6EUg==
X-Gm-Message-State: AOAM532dKEYZOMRlwcesgYwLBV8Rmh+uCzVaO5ULnj3ZBJTHQajAGrrS
        dwcu2j1txCjckwGKCKOy/M0=
X-Google-Smtp-Source: ABdhPJyiOHlalWQEKoaL8HmMRsf7bP3mzr0mCnJqaGVDbFPQBYFY9kovLl9T93+XGy/fyjsLKtsPfQ==
X-Received: by 2002:adf:9cc6:: with SMTP id h6mr42512065wre.341.1608198395097;
        Thu, 17 Dec 2020 01:46:35 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/9] libtracefs man pages: APIs for working with files in trace instances.
Date:   Thu, 17 Dec 2020 11:46:23 +0200
Message-Id: <20201217094626.1402191-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_file_exists()
tracefs_dir_exists()
tracefs_instance_get_file()
tracefs_instance_get_dir()
tracefs_instance_file_write()
tracefs_instance_file_read()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-instances-files.txt | 157 +++++++++++++++++++
 1 file changed, 157 insertions(+)
 create mode 100644 Documentation/libtracefs-instances-files.txt

diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
new file mode 100644
index 0000000..f1e9707
--- /dev/null
+++ b/Documentation/libtracefs-instances-files.txt
@@ -0,0 +1,157 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_file_exists, tracefs_dir_exists, tracefs_instance_get_file,
+tracefs_instance_get_dir, tracefs_instance_file_write,
+tracefs_instance_file_read - Work with files in tracing instances.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
+bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
+char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
+char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
+char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_file_, int pass:[*]_psize_);
+
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to work with trace files in all trace instances.
+All they have _instance_ argument, to limit the scope on the given trace _instance_ only.
+If _instance_ is NULL, the scope is limited to the main trace instance.
+
+The _tracefs_file_exists()_ function checks if a file with _name_ exists in _instance_.
+
+The _tracefs_dir_exists()_ function checks if a directory with _name_ exists in _instance_.
+
+The _tracefs_instance_get_file()_ function returns the full path of the file with
+given _name_ in _instance_.
+
+The _tracefs_instance_get_dir()_ function  returns the full path of the directory with
+given _name_ in _instance_.
+
+The _tracefs_instance_file_write()_ function writes a string _str_ in a _file_ from
+the given _instance_, without the terminating NULL character.
+
+The _tracefs_instance_file_read()_ function reads the content of a _file_  from
+the given _instance_.
+
+RETURN VALUE
+------------
+The _tracefs_file_exists()_ and  _tracefs_dir_exists()_ functions return true if the
+file / directory exist in the given instance or false if they do not exist.
+
+The _tracefs_instance_get_file()_ and _tracefs_instance_get_dir()_ functions return
+a string or NULL in case of an error. The returned string must be freed with
+_tracefs_put_tracing_file()_.
+
+The _tracefs_instance_file_write()_ function returns the number of written bytes,
+or -1 in case of an error.
+
+The _tracefs_instance_file_read()_ function returns a pointer to a NULL terminated
+string, read from the file, or NULL in case of an error. The returned string must
+be freed with free().
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+struct tracefs_instance *inst = tracefs_instance_create("foo");
+	if (!inst) {
+		/* Error creating a new trace instance */
+		...
+	}
+
+	if (tracefs_file_exists(inst,"trace_clock")) {
+		/* The instance foo supports trace clock */
+		char *path, *clock;
+		int size;
+
+		path =  = tracefs_instance_get_file(inst, "trace_clock")
+		if (!path) {
+			/* Error getting the path to trace_clock file in instance foo */
+			...
+		}
+		...
+		tracefs_put_tracing_file(path);
+
+		clock = tracefs_instance_file_read(inst, "trace_clock", &size);
+		if (!clock) {
+			/* Failed to read trace_clock file in instance foo */
+			...
+		}
+		...
+		free(clock);
+
+		if (tracefs_instance_file_write(inst, "trace_clock", "global") != strlen("global")) {
+			/* Failed to set gloabl trace clock in instance foo */
+			...
+		}
+	} else {
+		/* The instance foo does not support trace clock */
+	}
+
+	if (tracefs_dir_exists(inst,"options")) {
+		/* The instance foo supports trace options */
+		char *path = tracefs_instance_get_file(inst, "options");
+		if (!path) {
+			/* Error getting the path to options directory in instance foo */
+			...
+		}
+
+		tracefs_put_tracing_file(path);
+	} else {
+		/* The instance foo does not support trace options */
+	}
+
+	...
+
+	if (tracefs_instance_is_new(inst))
+		tracefs_instance_destroy(inst);
+	else
+		tracefs_instance_free(inst);
+--
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
-- 
2.28.0

