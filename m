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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08535C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7A9A22513
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgLUGEH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgLUGEF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:04:05 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2CBC0611D0
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:06 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id u19so8489192edx.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HUU1Jh6FSWY9JTBNdVV/FN25lvc1+FDVD1OMUo4JEl8=;
        b=L9ZkYIN3fJgNhRb+CxmLZYPFlducuSDv7RSKDE2SiHRACfUBC58RNGhOBxCG3605BI
         uj7Gvq9NCh4hEHkGpiRTLZgY1CZleuiVe6GZ4qFUJiYv3nxl6SrvOlb7RZg4BQNE+F5r
         /vRxMO5GytPUt0jj6vtP7pKGV6tgI4cMWT54QRN0m4/g/DLkIjnPuI3YZ+zCr0mX4CLO
         hauNLDTaY9IcfCfJb30qVdVTomxpG0dNwQUepFsMkiV0HwIqb35dacu/4Lq8ohfEmGVR
         iBdUN9z3sUIS7JSVZVcMW4cxmRuPiE3BsYlC0ZPvrYr6dBFEc1LttlweljslZj6ngDWb
         gQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HUU1Jh6FSWY9JTBNdVV/FN25lvc1+FDVD1OMUo4JEl8=;
        b=Eq5/cPpbn04wxA8NVg1vPllZPbKnmF5EGVQ3U+tifQjdoE0Rq9B9yXBzq+uQMeF9H1
         HG08j9FcB6pvg1kCgQ033wrCfcYHk4k6EYwSCQAqHhQV8pfi1vUYwSFWKnDP1EFYm2Qy
         HGqISks8diMcqi/fdLnGXnJu/U23jO1vXbIf9ZD1sGg1riWRh2Gk5+J5EN/mdTHMuQjW
         WTZ2rTnhdL3LU1MGbiRZbXNZpJNH4yEnlGZXXCrwQA8zRmsss67FZIfe4WlQpXT8bLgU
         4IZ1voATdQwWfs8NDYRYMa0r4OiY7uhZLkDBOg/ruzZ2NCHTgQQ2aP/31VQb+eVYwELn
         cdnw==
X-Gm-Message-State: AOAM531P7yWbbDCAPeBIBz2cVL52xEl0TX7phoAsI8mMOkE+d/42TKYe
        oIkcYeQQcoXi/C7EdvJV8rQ=
X-Google-Smtp-Source: ABdhPJzhNSmsGBVJgzzhIbTqSVf0cgx4yZkI4+vzBF6SjCV8Ek4A6wrIoEIT3yfqzlglV5qAq45C7A==
X-Received: by 2002:a05:6402:ca2:: with SMTP id cn2mr14581021edb.137.1608530585399;
        Sun, 20 Dec 2020 22:03:05 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z10sm8560885ejl.30.2020.12.20.22.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:03:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 8/8] libtracefs man pages: helper APIs for working with trace file system.
Date:   Mon, 21 Dec 2020 08:02:52 +0200
Message-Id: <20201221060252.177890-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201221060252.177890-1-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_tracers()
tracefs_get_clock()
tracefs_list_free()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-utils.txt | 103 +++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 Documentation/libtracefs-utils.txt

diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
new file mode 100644
index 0000000..86dd754
--- /dev/null
+++ b/Documentation/libtracefs-utils.txt
@@ -0,0 +1,103 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_tracers, tracefs_get_clock, tracefs_list_free -
+Helper functions for working with trace file system.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
+char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
+void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
+--
+
+DESCRIPTION
+-----------
+Various useful functions for working with trace file system.
+
+The _tracefs_tracers()_ function returns array of strings with the
+names of supported tracer plugins, located in the given _tracing_dir_ directory.
+This could be NULL or tracefs mount point, for trace systems in top instance,
+or full path to a trace instance, for trace systems in that instance.
+The last entry in the array as a NULL pointer. The array must
+be freed with _tracefs_list_free()_ API.
+
+The _tracefs_get_clock()_ function returns name of the current trace clock,
+used in the given _instance_. If _instance_ is NULL, the clock of the main
+trace instance is returned. The returned string must be freed with free().
+
+The _tracefs_list_free()_ function frees an array of strings, returned by
+_tracefs_event_systems()_, _tracefs_system_events()_ and _tracefs_tracers()_
+APIs.
+
+RETURN VALUE
+------------
+The _tracefs_tracers()_ returns array of strings. The last element in that
+array is a NULL pointer. The array must be freed with _tracefs_list_free()_ API.
+In case of an error, NULL is returned.
+
+The _tracefs_get_clock()_ returns string, that must be freed with free(), or NULL
+in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+char **tracers = tracefs_tracers(NULL);
+
+	if (tracers) {
+		/* Got tracer plugins from the top trace instance */
+		...
+		tracefs_list_free(tracers);
+	}
+....
+char *clock = tracefs_get_clock(NULL);
+
+	if (clock) {
+		/* Got current trace clock of the top trace instance */
+		...
+		free(clock);
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
\ No newline at end of file
-- 
2.28.0

