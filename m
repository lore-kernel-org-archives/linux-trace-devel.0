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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6C3C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A65020E65
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725300AbgLWEfx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgLWEfx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:35:53 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700B2C061282
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:39 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id i9so17340534wrc.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hQKKW+dU4a3WmtsXmhKRYuX+tH83jmdgb3mS+hBgz/I=;
        b=If1c4rkWotzblYTzWmKK7nj5p69LHGlEatUEGBKtdAUJdUvjpjCk54brK7DA6JZ2qC
         x/Y7o4CMrbSBJPp8YLEp7srEyqvhqko5usCGLwIrjnYPHsPt0lgKf+aRNRxUnvDa0HTA
         ZhkscuA499CbqoUdr+QC6gzWnYFC1eJ7krtOT+3QiR9KLJUY5qnNGfX8L8BBasMvkIGA
         AbYUXsNLLq3NGq0f3sRxJ/1IWCXRpaBsvn+ct8HguWsunjRTQOkCG+NpfnOjCZlxiAJl
         pxXCR6dofetDw9ko813i2Z33G3ka7z41k93umLhRY8mhQmWHPzS/X33oXZs9ykX/q7tD
         /8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hQKKW+dU4a3WmtsXmhKRYuX+tH83jmdgb3mS+hBgz/I=;
        b=av7PD6N1/uMOh9Dn0vBCxMvc92LlSTXPgVLT3dOvsUUXGpMB/hY1/UYKf2BDZe9l5L
         Sp6y1sYyL0T9/kYQUPW5YuvAJuvCkm80QN98eWhkzhNbL0AP4ZVP4gYtm8n1lQmT+sJb
         5tBNsKM0Wgi6ACIQvMUcJ1uv7KOZa7m05YQ/XY6WUQJ4efCnhtzo7IwjVCXEV1gSX9Hg
         Sb/x84pHEsZg6CcvsE3IXGgj32qMA6R/G1LCnxBR9Quc919Ja9o/SfCS66hfqcjuft2T
         F90QO8yq4ySk2B5o7s9x6KHeXvH5D21H1gL7ID6sTial3PrPfdAq265yHY9/K9Ze1GIJ
         rctA==
X-Gm-Message-State: AOAM533oo313/6YmK2DX2RxgiT0yj7qupwUslXKC1XhHUHCFXLytiA3E
        fBn/Ms+FUivA8p1dM1nDzeM=
X-Google-Smtp-Source: ABdhPJyKF9r0cYK5mhxZ7gmBEaKU8Hir2YBRAvu6asZdE8KNGfWdVDx1dhdLum7yS9NJllD7eykGYw==
X-Received: by 2002:a5d:504b:: with SMTP id h11mr27124343wrt.337.1608698078230;
        Tue, 22 Dec 2020 20:34:38 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s13sm28909095wmj.28.2020.12.22.20.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:34:37 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/6] trace-cmd library man pages: Read tracing instances from a trace file.
Date:   Wed, 23 Dec 2020 06:34:29 +0200
Message-Id: <20201223043429.586162-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201223043429.586162-1-tz.stoyanov@gmail.com>
References: <20201223043429.586162-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
 tracecmd_buffer_instances()
 tracecmd_buffer_instance_name()
 tracecmd_buffer_instance_handle()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../libtracecmd/libtracecmd-instances.3.txt   | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)
 create mode 100644 Documentation/libtracecmd/libtracecmd-instances.3.txt

diff --git a/Documentation/libtracecmd/libtracecmd-instances.3.txt b/Documentation/libtracecmd/libtracecmd-instances.3.txt
new file mode 100644
index 00000000..eff7e3ec
--- /dev/null
+++ b/Documentation/libtracecmd/libtracecmd-instances.3.txt
@@ -0,0 +1,129 @@
+libtracecmd(3)
+=============
+
+NAME
+----
+tracecmd_buffer_instances, tracecmd_buffer_instance_name, tracecmd_buffer_instance_handle
+- Read tracing instances from a trace file.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <trace-cmd.h>*
+
+int *tracecmd_buffer_instances*(struct tracecmd_input pass:[*]_handle_);
+const char pass:[*]*tracecmd_buffer_instance_name*(struct tracecmd_input pass:[*]_handle_, int _indx_);
+struct tracecmd_input pass:[*]*tracecmd_buffer_instance_handle*(struct tracecmd_input pass:[*]_handle_, int _indx_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to get information and read tracing data
+from tracing instances stored in a trace file.
+
+The _tracecmd_buffer_instances()_ function gets the number of tracing
+instances recorded in a trace file. The top instance is not counted.
+The _handle_ is a tracecmd_input handler returned by
+_tracecmd_open_head()_.
+
+The _tracecmd_buffer_instance_name()_ function gets the name of the
+tracing instance with given index _indx_, recorded in a trace file.
+The _indx_ is a number in the interval [0 .. count -1], where count
+is the number returned by _tracecmd_buffer_instances()_. The _handle_
+is a tracecmd_input handler returned by _tracecmd_open_head()_.
+
+The _tracecmd_buffer_instance_handle()_ allocates and initializes a
+tracecmd_input hanlder, associated with trace instance with index
+_indx_ from a trace file.  The _handle_ is a tracecmd_input handler
+returned by _tracecmd_open_head()_. The _indx_ is a number in the
+interval [0 .. count -1], where count is the number returned by
+_tracecmd_buffer_instances()_.
+
+RETURN VALUE
+------------
+The _tracecmd_buffer_instances()_ function returns the number of tracing
+instances recorded in a trace file.
+
+The _tracecmd_buffer_instance_name()_ function returns a string, the name
+of a tracing instance, or NULL in case of an error The string must *not*
+be freed.
+
+The _tracecmd_buffer_instance_handle()_ function returns a pointer to
+newly allocated tracecmd_input handler or NULL in case if an error. The
+returned handler must be closed by _tracecmd_close()(3)_
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <trace-cmd.h>
+...
+struct tracecmd_input *handle = tracecmd_open_head("trace.dat");
+	if (!handle) {
+		/* Failed to open trace.dat file */
+	}
+...
+int num = tracecmd_buffer_instances(handle);
+
+	while(num) {
+		struct tracecmd_input *h;
+		char *name;
+
+		name = tracecmd_buffer_instance_name(handle, num);
+		if (!name) {
+			/* Failed to get name of instance num */
+		}
+		h = tracecmd_buffer_instance_handle(handle, num);
+		if (!h) {
+			/* Failed to initialize handler for instance num */
+		}
+
+		...
+		tracecmd_close(h);
+		num--;
+	}
+...
+	tracecmd_close(hadle);
+
+--
+FILES
+-----
+[verse]
+--
+*trace-cmd.h*
+	Header file to include in order to have access to the library APIs.
+*-libtracecmd*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+_trace-cmd.dat(5)_
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
+libtracecmd is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.28.0

