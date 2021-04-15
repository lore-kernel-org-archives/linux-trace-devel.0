Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B13C43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 12:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 941F7613C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 12:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhDOMNv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbhDOMNu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 08:13:50 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73172C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 05:13:26 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id n2so36487836ejy.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 05:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hd4tyOOmUPYpQksWbSiqZqMIJjD/1lFPBVjhmFW/SmQ=;
        b=A0g35bUKF4fQJ39lFAAY4+dXkdjmmOcBrguHTi3krUQDBddo0qNdPAxHBV6L8fVXt5
         QFZoL5IMn/xBVwj6MZmlbmuUl/n19fU9rTdW5lUcssOZM30qQHC05fKnkkDfoOGDNGSu
         9f6GDq2PJianxryrUQvMahFjhgjSU7fhAlcEYcubbb1EjIPON6ARQdb5Ie1RPRicLhN8
         3IR7ZMEQ7c4beMyMwKZDtu0lI3O45t8gieQxJN21WB8f6BzfjQJGsjw2q6sMh1ULbCJc
         1HkIJpMncpOlKsP6PFsxOIH1s0vmFPhuoa9LiOqYjs4oU3kmaJmR7IHrAs84+UmFGwkz
         EKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hd4tyOOmUPYpQksWbSiqZqMIJjD/1lFPBVjhmFW/SmQ=;
        b=SDue1pQQ8matW+cdb8sJavDhhYxB21jTJxRvumGfzWNpRxNiW58AQ+WheFC8dK1Pgy
         l1jsHiBaxLovzdOvFWebJdTYxwhgZ0oZhZrmsFWtGnrtlL1Sk5qkVluosfyWGQ5hKLzh
         vhhAxdYNs0m6cqIdr7KqhiqAYblQbcoLsjbiGMmRBiVwdoSuVGMv1zVuHVd18g1SvgCZ
         SgbwX5oeVHRDCW/beYcAl+xU/90Z3FMNvywDgfvpAYAMjbjHWKG1PL7oNfvdqgwTc9Ea
         lbu67s8sssoDO0Xo351/nAa+g8aUuCO7k5PU/AgKZQa0E/UPd2ZDgPNfVfVvr7i2x/Wp
         W1sg==
X-Gm-Message-State: AOAM53230kXCTIIMuljFPZRSoV4peo2TEaFIpmHpL/iX3mnH2PZK5rZP
        Kl/N9qBBHDCAIBf4QnyCNZ5454TpyIw=
X-Google-Smtp-Source: ABdhPJwocpTY1PILt5WAS6As+tl0yo92ayrW8mMbNCelj6/Xf0hzFi8DPU3XjM9tZZqXX6S+EAGy0g==
X-Received: by 2002:a17:906:c9d8:: with SMTP id hk24mr3146124ejb.480.1618488805136;
        Thu, 15 Apr 2021 05:13:25 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.55])
        by smtp.gmail.com with ESMTPSA id o20sm2364863eds.65.2021.04.15.05.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 05:13:24 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     tz.stoyanov@gmail.com, linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] libtracefs: Document the new methods for writing to file.
Date:   Thu, 15 Apr 2021 15:13:11 +0300
Message-Id: <20210415121311.59787-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210415121311.59787-1-y.karadz@gmail.com>
References: <20210415121311.59787-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documentation for "int tracefs_instance_file_append()" and
"int tracefs_instance_file_clear()" is being added. The file
"Documentation/libtracefs-instances-files.txt" gets split,
because when adding two more APIs we exceed the  limit of APIs
per file.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .../libtracefs-instances-file-manip.txt       | 199 ++++++++++++++++++
 Documentation/libtracefs-instances-files.txt  |  35 +--
 2 files changed, 201 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/libtracefs-instances-file-manip.txt

diff --git a/Documentation/libtracefs-instances-file-manip.txt b/Documentation/libtracefs-instances-file-manip.txt
new file mode 100644
index 0000000..942e7ad
--- /dev/null
+++ b/Documentation/libtracefs-instances-file-manip.txt
@@ -0,0 +1,199 @@
+libtracefs(3)
+=============
+
+NAME
+----
+
+tracefs_instance_file_open,
+tracefs_instance_file_write, tracefs_instance_file_append, tracefs_instance_file_clear,
+tracefs_instance_file_read, tracefs_instance_file_read_number - Work with files in tracing instances.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_instance_file_open*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int _mode_);
+int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
+int *tracefs_instance_file_append*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
+int *tracefs_instance_file_clear*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
+char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
+int *tracefs_instance_file_read_number*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, long long int pass:[*]_res_);
+
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to work with trace files in all trace instances.
+Each of these APIs take an _instance_ argument, that can be NULL to act
+on the top level instance. Otherwise, it acts on an instance created with
+*tracefs_insance_create*(3)
+
+The _tracefs_instance_file_open()_ function opens trace _file_ from given _instance_ and returns
+a file descriptor to it. The file access _mode_ can be specified, see *open*(3) for more details.
+If -1 is passed as _mode_, default O_RDWR is used.
+
+The _tracefs_instance_file_write()_ function writes a string _str_ in a _file_ from
+the given _instance_, without the terminating NULL character. When opening the file, this function
+tries to truncates the size of the file to zero, which clears all previously existing settings.
+
+The _tracefs_instance_file_append()_ function writes a string _str_ in a _file_ from
+the given _instance_, without the terminating NULL character.  This function is similar to
+_tracefs_instance_file_write()_, but the existing content of the is not cleared. Thus the
+new settings are appended to the existing ones (if any).
+
+The _tracefs_instance_file_clear()_ function tries to truncates the size of the file to zero,
+which clears all previously existing settings. If the file has content that does not get
+cleared in this way, this will not have any effect.
+
+The _tracefs_instance_file_read()_ function reads the content of a _file_ from
+the given _instance_.
+
+The _tracefs_instance_file_read_number()_ function reads the content of a _file_ from
+the given _instance_ and converts it to a long long integer, which is stored in _res_.
+
+RETURN VALUE
+------------
+The _tracefs_instance_file_open()_ function returns a file descriptor to the opened file. It must be
+closed with *close*(3). In case of an error, -1 is returned.
+
+The _tracefs_instance_file_write()_ function returns the number of written bytes,
+or -1 in case of an error.
+
+The _tracefs_instance_file_append()_ function returns the number of written bytes,
+or -1 in case of an error.
+
+The _tracefs_instance_file_clear()_ function returns 0 on success, or -1 in case of an error.
+
+The _tracefs_instance_file_read()_ function returns a pointer to a NULL terminated
+string, read from the file, or NULL in case of an error. The returned string must
+be freed with free().
+
+The _tracefs_instance_file_read_number()_ function returns 0 if a valid integer is read from
+the file and stored in _res_ or -1 in case of an error.
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
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
index 124ef52..4ac87d1 100644
--- a/Documentation/libtracefs-instances-files.txt
+++ b/Documentation/libtracefs-instances-files.txt
@@ -3,9 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_file_exists, tracefs_dir_exists, tracefs_instance_get_file,
-tracefs_instance_get_dir, tracefs_instance_file_open, tracefs_instance_file_write,
-tracefs_instance_file_read, tracefs_instance_file_read_number - Work with files in tracing instances.
+tracefs_file_exists, tracefs_dir_exists,
+tracefs_instance_get_file, tracefs_instance_get_dir - Work with files directories in tracing instances.
 
 SYNOPSIS
 --------
@@ -17,10 +16,6 @@ bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass
 bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
 char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
 char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
-int *tracefs_instance_file_open*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int _mode_);
-int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
-char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
-int *tracefs_instance_file_read_number*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, long long int pass:[*]_res_);
 
 --
 
@@ -43,19 +38,6 @@ The _tracefs_instance_get_dir()_ function  returns the full path of the director
 with given _name_ in _instance_. Note, it does not check if the directory exists
 in the instance.
 
-The _tracefs_instance_file_open()_ function opens trace _file_ from given _instance_ and returns
-a file descriptor to it. The file access _mode_ can be specified, see *open*(3) for more details.
-If -1 is passed as _mode_, default O_RDWR is used.
-
-The _tracefs_instance_file_write()_ function writes a string _str_ in a _file_ from
-the given _instance_, without the terminating NULL character.
-
-The _tracefs_instance_file_read()_ function reads the content of a _file_ from
-the given _instance_.
-
-The _tracefs_instance_file_read_number()_ function reads the content of a _file_ from
-the given _instance_ and converts it to a long long integer, which is stored in _res_.
-
 RETURN VALUE
 ------------
 The _tracefs_file_exists()_ and  _tracefs_dir_exists()_ functions return true if the
@@ -65,19 +47,6 @@ The _tracefs_instance_get_file()_ and _tracefs_instance_get_dir()_ functions ret
 a string or NULL in case of an error. The returned string must be freed with
 _tracefs_put_tracing_file()_.
 
-The _tracefs_instance_file_open()_ function returns a file descriptor to the opened file. It must be
-closed with *close*(3). In case of an error, -1 is returned.
-
-The _tracefs_instance_file_write()_ function returns the number of written bytes,
-or -1 in case of an error.
-
-The _tracefs_instance_file_read()_ function returns a pointer to a NULL terminated
-string, read from the file, or NULL in case of an error. The returned string must
-be freed with free().
-
-The _tracefs_instance_file_read_number()_ function returns 0 if a valid integer is read from
-the file and stored in _res_ or -1 in case of an error.
-
 EXAMPLE
 -------
 [source,c]
-- 
2.25.1

