Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C489C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E8C920738
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbhAGIdj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIdi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:33:38 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E4DC0612FA
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:32:58 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id y23so4782944wmi.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uS7DCua/vhhQcEfCge+9yCG9OTf1xjHKM2C8mH7dCeM=;
        b=hgobh96fvuCid+1BohoBoTmzo9YzhvGkB9TjlionEg2xG7lQ6G6lHvtPw4DojitmaG
         3JFAPaRUlDBtD4yYWyYlCJll8WoXXzoC8Ic02sqOo8jGrDaw7Py+ELRSl8bJlD6QfMvL
         TCb5h+hAs9lcQjF7djKXcrN6C1i1ZjEyuzZQ8uz9Pjw7T4gCk3w+z2GGN4f+GFEqRoIj
         4IcKWT4vqcJ5GBiSelvBRF9RdoV2W85uT0odoAUPsuLXBmtSAK1KZN0liKE06y/XmfDy
         v8NcFgaAXGqmqIuPMpHi5iQ2zajiYTeLdPpyUScraqQhkP7mDXE1a2qS7FQHvop3j0kl
         HMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uS7DCua/vhhQcEfCge+9yCG9OTf1xjHKM2C8mH7dCeM=;
        b=Ru+qYtEUlU8Od7/tEVfG8VgJWuq/50X8kygrzb0teX8/CGZsyTVMh9PHpAYVtpj+xB
         cnLE44HPGKu3V7NHix/CDgu2g7oVjm8b7v8o8hZ23mw+xJuV65OMOpFT+l763F+Bf19n
         P3v3oDr8DbycTj2ZIrElQrrHZ+o33mLCb0YPMLi//Y2+x9uN2vowTkBXRBQ6XkRV1pX4
         Z372dGBfhyUQW1l/RHQJfFEMEuPjvsHYZ/1Tge2YfbLrWeW8yb324GDLviVZwlMsmOIJ
         r/CfvUAJq9Y7Q8nULx2DI0EHHLxzyQFC+RS32KkPxXFU4P3L2Tu/7BjKraO0E7u1ja8l
         Oi3A==
X-Gm-Message-State: AOAM533T5RzSfQnwVwKVERFhWWlj1uzfvlJSqxPke9oBTzInwiwE+g/K
        Ix9b41JgBAgwHXDr3wqlQ2KM3k2i1Yfh+a8X
X-Google-Smtp-Source: ABdhPJxflF4kuJGWR0G6MrKlmKbZv+yqEalx0oaAobEQF0aD+f5r/DjcCtwAQ9tJNP0QGX9dQN5s4w==
X-Received: by 2002:a1c:9a4d:: with SMTP id c74mr7232830wme.5.1610008377209;
        Thu, 07 Jan 2021 00:32:57 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v20sm7293867wra.19.2021.01.07.00.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:32:56 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/6] libtracefs: Documentation for enable / disable tracing APIs
Date:   Thu,  7 Jan 2021 10:32:48 +0200
Message-Id: <20210107083250.16295-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107083250.16295-1-tz.stoyanov@gmail.com>
References: <20210107083250.16295-1-tz.stoyanov@gmail.com>
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
 Documentation/libtracefs-traceon.txt | 143 +++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)
 create mode 100644 Documentation/libtracefs-traceon.txt

diff --git a/Documentation/libtracefs-traceon.txt b/Documentation/libtracefs-traceon.txt
new file mode 100644
index 0000000..af4b7f7
--- /dev/null
+++ b/Documentation/libtracefs-traceon.txt
@@ -0,0 +1,143 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_trace_is_on, tracefs_trace_on, tracefs_trace_off, tracefs_trace_on_fd,
+tracefs_trace_off_fd - Functions to enable or disable tracing.
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
+The _tracefs_trace_on_fd()_ and _tracefs_trace_off_fd()_ functions set the tracing state to enable
+or disable using the given _fd_. This file descriptor must be opened for writing with
+*tracefs_instance_file_open*(3) for *tracing_on* file from desired trace instance. These functions
+are faster than *tracefs_trace_on* and *tracefs_trace_off*.
+
+RETURN VALUE
+------------
+The _tracefs_trace_is_on()_ function returns 0 if tracing is disable, 1 if it is enabled or
+-1 in case of an error.
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
+	int fd = tracefs_instance_file_open(NULL, "tracing_on", O_WRONLY);
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
-- 
2.29.2

