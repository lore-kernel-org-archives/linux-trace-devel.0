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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D2AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 04:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3EB223122
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 04:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgLVExv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 23:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVExv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 23:53:51 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFE0C061793
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 20:53:10 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t30so13252371wrb.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 20:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LsFXR+6Vvwo5sZiDrILhl3YUmQjRCvksfj/NQ2Wrj4U=;
        b=cD/f1tAr2vC67VIEpdivv4YIJ5PyHPyskI5c1dLJsCbCACt8GKf+YgK2iKjNp9rcva
         5D7SOx+zTDTjYPcTzUjIY2+yrUyAx6fn7T3k7QX1+heBageK6a3Lp/dHTrHtGUlMTT3i
         okyS0btLzn6rktxALmMSN/6LhF0Lw/lL3xpb+Vcxl2NV14XK9Aqz7EGHi+G1Cqxvcfxg
         AihA7C0Yf9j0m43VXdwQLV85PS8CoPsx60oQL57Olzre1KezV50wIsG8qLr44JVDBLT2
         4p4sB4K4bTp0ltiVeJQMsw/bbOkva1dvTyoyhSKw4rFLjVpIq3kLoOcvL6iX5TZ1BbAE
         muSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LsFXR+6Vvwo5sZiDrILhl3YUmQjRCvksfj/NQ2Wrj4U=;
        b=G8c8it4NosfT0thN8zECbXyRVmb/fg8rnr0Mu5y41YhTazOXfNYvGEl2Ng0lUfXDLj
         jMTbxFee36PtFQnmaBR6BCkIRnf9J4lX8HJ8yq/9d1AfdvFCoMVlIqM7oJ9bGNLjOC3m
         DDnwO7aQR3AJlKQDhEtzwFzkMu76ib95V3k4SV2O9i7VU+G+/Z/Q0u8aih14LxHfkYKf
         Pvzasp8Vjnw/WlohCVpG8p6aV79nqzkVuyrg/nt9itxNmR97a/ROhzVovCEbJz5LsjMg
         Gtyu+/EmTLiujNIRhfWMRut2zBBnive60LRA2VLeQFQ6gJwaYNY+VCfC/yVzoPZ3Vyhu
         nBOg==
X-Gm-Message-State: AOAM5336nRXv0jgBwGg9zaiCIEDgzYYAbApiHUEWi/91bRR3vBapgael
        FIoTbh1gk4U3iYR05HbB8r08xmJKqheNVolI
X-Google-Smtp-Source: ABdhPJz7mRZ/72MOGyEOt5G8K1G4kVKpeziv2LS8T+c9+Y1C064kAwjK2afA/C/NgbGFJmwn/54s+g==
X-Received: by 2002:a5d:4fcf:: with SMTP id h15mr21400328wrw.323.1608612789603;
        Mon, 21 Dec 2020 20:53:09 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c7sm32924159wro.16.2020.12.21.20.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 20:53:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/2] libtracefs man pages: helper APIs for working with trace file system.
Date:   Tue, 22 Dec 2020 06:53:04 +0200
Message-Id: <20201222045304.369175-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201222045304.369175-1-tz.stoyanov@gmail.com>
References: <20201222045304.369175-1-tz.stoyanov@gmail.com>
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
index 0000000..03bc39b
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
+names of supported tracer plugins, located in the given _tracing_dir_
+directory. This could be NULL or the location of the tracefs mount point
+for the trace systems of the local machine, or it may be a path to a copy
+of the tracefs directory from another machine. The last entry in the array
+as a NULL pointer. The array must be freed with _tracefs_list_free()_ API.
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

