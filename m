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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E831CC433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A266622E03
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732377AbhALJVX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390543AbhALJVW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 04:21:22 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F6BC0617A3
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:33 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id f4so1394950ejx.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v08s1omr+8XwvYUQgddTC+/0kdixtXlEPSBk19NV3/I=;
        b=oDnNbailWc+uovs0TrcWdzE6y7GVqu1v2ckU+DPKXIZqpv4ZVjBeO7yyARm3yDg7Tg
         12n38dWDPQXmJUpKlXx28ltxd0hHRcphJAmILXNGgNNo6hxf1l9dDMEZWB61ZaDGf2p5
         oapwER9XLO4HkFPEICugxuGy+dZBo0D2wtf0/OMtHZxJOQqoTsAb09wQYyl+Gf2jsmEY
         7hVYY3jm0iIFgcSV0gtqagDjLkfIacF595/u0u9kFfGsP1ydTSmmoiENDAn3Kq+1Hxe+
         X97gyO38mZs9bdwxa52MlSVfIhugd7PzooFf1YyFYQRESVfyxpMr0ftRv1s/NvobbAJm
         a9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v08s1omr+8XwvYUQgddTC+/0kdixtXlEPSBk19NV3/I=;
        b=MFTna6RpILlzECmx4+0RcChh2e0ouRaL/4o+m/i4YK0RbWu/8+Rs+yNFo9RpSV8UVN
         +tBKX/SA8tokCgJOE0lKH+D1zfo99IyoAmokV2+0GdWsGoOtNvEapZm64GWnTpIvbZyT
         g3445/f4ZuylZwodOxON81y8jpcC5XgLzsFw+GzI76tYtu5A18Xp+OvBZvzGKt32Qq5p
         yQGNpY81SwMCp9BZHtfwkjVpkUDheFDIvc8Ih8DQmKOwsGqv103HQOSUWvzG6ewKPkU8
         byKHUU10GhxrbKnazqTTBJn1HTnKajIbZIvpSmHN6S4GJbOHphL5LMgqkmp+WGyuIXeN
         hqEw==
X-Gm-Message-State: AOAM533Av6CIWmIbparthdVZWjcb/F8ojDHAReeyzvraZXRzK5Mw06UK
        COdsp+Aa0eVw7KunptXAuiQ=
X-Google-Smtp-Source: ABdhPJx9fnixv0M20VFZwnqmY3PmTp5xdm9h92LWF3+osi+bltw2X10VWiAX30vuEdp1W8Z+2jfHfg==
X-Received: by 2002:a17:906:8617:: with SMTP id o23mr2586969ejx.274.1610443232628;
        Tue, 12 Jan 2021 01:20:32 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id rl7sm929187ejb.107.2021.01.12.01.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:20:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/7] libtracefs: Documentation for enable / disable tracing APIs
Date:   Tue, 12 Jan 2021 11:20:22 +0200
Message-Id: <20210112092024.605705-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112092024.605705-1-tz.stoyanov@gmail.com>
References: <20210112092024.605705-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New man pages with documentation about:
 tracefs_trace_is_on();
 tracefs_trace_on();
 tracefs_trace_off();
 tracefs_trace_on_fd();
 tracefs_trace_off_fd();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-traceon.txt | 151 +++++++++++++++++++++++++++
 Documentation/libtracefs.txt         |   6 ++
 2 files changed, 157 insertions(+)
 create mode 100644 Documentation/libtracefs-traceon.txt

diff --git a/Documentation/libtracefs-traceon.txt b/Documentation/libtracefs-traceon.txt
new file mode 100644
index 0000000..d7fc239
--- /dev/null
+++ b/Documentation/libtracefs-traceon.txt
@@ -0,0 +1,151 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_trace_is_on, tracefs_trace_on, tracefs_trace_off, tracefs_trace_on_get_fd,
+tracefs_trace_on_fd, tracefs_trace_off_fd - Functions to enable or disable tracing.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_trace_is_on*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_trace_on*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_trace_off*(struct tracefs_instance pass:[*]_instance_);
+int _tracefs_trace_on_get_fd_(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_trace_on_fd*(int _fd_);
+int *tracefs_trace_off_fd*(int _fd_);
+--
+
+DESCRIPTION
+-----------
+This set of functions can be used to check, enable or disable writing to the ring buffer in
+the given trace instance. The tracing is enabled when writing to the ring buffer is enabled.
+
+The _tracefs_trace_is_on()_ function checks if tracing is enabled for the given _instance_. If
+_instance_ is NULL, the top instance is used.
+
+The _tracefs_trace_on()_ and _tracefs_trace_off()_ functions set the tracing in the _instance_
+to enable or disable state. If _instance_ is NULL, the top instance is used.
+
+The _tracefs_trace_on_get_fd()_ function returns a file deascriptor to the "tracing_on" file from
+the given _instance_. If _instance_ is NULL, the top trace instance is used. The returned descriptor
+can be used for fast enabling or disabling the tracing of the instance.
+
+The _tracefs_trace_on_fd()_ and _tracefs_trace_off_fd()_ functions set the tracing state to enable
+or disable using the given _fd_. This file descriptor must be opened for writing with
+*tracefs_trace_on_get_fd*(3) of the desired trace instance. These functions are faster than
+*tracefs_trace_on* and *tracefs_trace_off*.
+
+RETURN VALUE
+------------
+The _tracefs_trace_is_on()_ function returns 0 if tracing is disable, 1 if it is enabled or
+-1 in case of an error.
+
+The _tracefs_trace_on_get_fd()_ function returns a file descriptor to "tracing_on"
+file for reading and writing, which must be closed wuth close(). In case of an error -1 is returned.
+
+The _tracefs_trace_on()_, _tracefs_trace_off()_, _tracefs_trace_on_fd()_ and
+_tracefs_trace_off_fd()_ functions return -1 in case of an error or 0 otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+	int ret;
+
+	ret = tracefs_trace_is_on(NULL);
+	if (ret == 0) {
+		/* Tracing is disabled in the top instance */
+	} else if (ret == 1) {"
+		/* Tracing is enabled in the top instance */
+	} else {
+		/* Error getting tracing state of the top instance */
+	}
+
+	...
+
+	if (!tracefs_trace_on(NULL)) {
+	    /* Enabled tracing in the top instance */
+
+	    ...
+
+	    if (!tracefs_trace_off(NULL)) {
+	    	/* Disabled tracing in the top instance */
+	    } else {
+	    	/* Error disabling tracing in the top instance */
+	    }
+	} else {
+		/* Error enabling tracing in the top instance */
+	}
+
+	...
+
+	int fd = tracefs_trace_on_get_fd(NULL);
+
+	if (fd < 0) {
+		/* Error opening tracing_on file */
+	}
+	...
+	if (!tracefs_trace_on_fd(fd)) {
+	    /* Enabled tracing in the top instance */
+
+	    ...
+
+	    if (!tracefs_trace_off_fd(fd)) {
+	    	/* Disabled tracing in the top instance */
+	    } else {
+	    	/* Error disabling tracing in the top instance */
+	    }
+	} else {
+		/* Error enabling tracing in the top instance */
+	}
+
+	...
+
+	close(fd);
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
+Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 0350416..cea21fe 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -45,6 +45,12 @@ Trace helper functions:
 	void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
 	char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
 	char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_trace_is_on*(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_trace_on*(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_trace_off*(struct tracefs_instance pass:[*]_instance_);
+	int _tracefs_trace_on_get_fd_(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_trace_on_fd*(int _fd_);
+	int *tracefs_trace_off_fd*(int _fd_);
 --
 
 DESCRIPTION
-- 
2.29.2

