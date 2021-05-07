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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4938C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE43061059
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbhEGJyk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbhEGJyk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:54:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CE5C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:53:39 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id s20so7180516ejr.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MhaNQMLEk3FzjpKjnPZiq4qO19h0lLl+kHtcI51ICRM=;
        b=E27sU9jlYVLP9rsqG9h3yGyHjrux/hdaangjbBafY4vgaQ7eB/qR9e6VFjWO5eRpvb
         zb2auFYjkkHsw/otPWSsAFrWU/b8unZT9oydUG5w2oAMjJzhomx3fhzokw76h3RYKnDT
         hNy1aR3Dz76MOVWEXDFNpu+Vue5qcI4O+Ewl+SMNYl2LxPnnSF1CIEN6ZGHigP3hc4SZ
         FqrRmoh7fgdALYCc6B2T6AuQV4MptpcRVuy8XllcFZ1N26dpuw1Ywr76LeFRdUT4fF68
         DNSUXKeKUO1BemTwEKZDfQKyEvieCKUagherCLUdgGZOQ9Nkb55GhqHftGoicibaLgtT
         Fw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MhaNQMLEk3FzjpKjnPZiq4qO19h0lLl+kHtcI51ICRM=;
        b=iDgHDte/Zz30XybVtsHue6YVfR7vfnDcsTLE3pjRGYj7sFRhcnqR4uUVhh293/6v79
         Eb9N6Z0FgfpUnb52TcyFgnfoSDj6+qTOVKBBjJZ+k7cA2faqTlqOp56IlAeVM04zb58u
         s0+glPEicm+lxjHBhC2ptZnjS3dRPcMLainB3pVS+RWf3PjK112MKHmEK42Qy3gIewkb
         wLsKk2aVk7d4unaHUoMah82KVSXkaklM4UWhH3cRq6cSb/fK2DZ1sSqtj8O8YMhh5k1A
         mBN7xYE39ewRbGOSGBglYapQa6H/MK4nAVZX31GtvpevNgHBlsFrnc3QGc0nPYe/tosd
         LIhw==
X-Gm-Message-State: AOAM530P0q+GwjNAzAeP14KmmNokDYidrRl1SvsYCe46rOTTl7pZIP+a
        2rS0ZCg3yDm1oyanYEiMBZg=
X-Google-Smtp-Source: ABdhPJxqrsHBjfwzyiSVvrr8lzF4XfibQkEKMYK5afGEm2wktC+CvN2PUICGZUNRJRSvo7CZbJtTBQ==
X-Received: by 2002:a17:906:c14c:: with SMTP id dp12mr8887113ejc.312.1620381218390;
        Fri, 07 May 2021 02:53:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cr21sm3105812ejc.2.2021.05.07.02.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:53:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/8] trace-cmd library: Document the API for log levels
Date:   Fri,  7 May 2021 12:53:29 +0300
Message-Id: <20210507095333.1080910-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated trace-cmd library man pages with description of the API for
setting the library log levels:
 tracecmd_set_loglevel()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracecmd/libtracecmd-log.txt | 78 +++++++++++++++++++
 Documentation/libtracecmd/libtracecmd.txt     |  3 +
 2 files changed, 81 insertions(+)
 create mode 100644 Documentation/libtracecmd/libtracecmd-log.txt

diff --git a/Documentation/libtracecmd/libtracecmd-log.txt b/Documentation/libtracecmd/libtracecmd-log.txt
new file mode 100644
index 00000000..de5c2776
--- /dev/null
+++ b/Documentation/libtracecmd/libtracecmd-log.txt
@@ -0,0 +1,78 @@
+libtracecmd(3)
+=============
+
+NAME
+----
+tracecmd_set_loglevel - Set log level of the library
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <trace-cmd.h>*
+
+int *tracecmd_set_loglevel*(enum tep_loglevel _level_);
+--
+
+DESCRIPTION
+-----------
+The _tracecmd_set_loglevel()_ function sets the level of the library logs that will be printed on
+the console. See _libtraceevent(3)_ for detailed desciription of the log levels. Setting the log
+level to specific value means that logs from the previous levels will be printed too. For example
+_TEP_LOG_WARNING_ will print any logs with severity _TEP_LOG_WARNING_, _TEP_LOG_ERROR_ and
+_TEP_LOG_CRITICAL_. The default log level is _TEP_LOG_CRITICAL_.  When a new level is set, it is
+also propagated to the libtracefs and libtraceevent.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <trace-cmd.h>
+...
+tracecmd_set_loglevel(TEP_LOG_ALL);
+...
+/* call libtracecmd, libtracefs or libtraceevent APIs and observe any logs they produce */
+...
+tracecmd_set_loglevel(TEP_LOG_CRITICAL);
+--
+
+FILES
+-----
+[verse]
+--
+*trace-cmd.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracecmd*
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
+Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index adc9321c..dc528ce0 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -33,6 +33,9 @@ Read tracing instances from a trace file:
 Get traceing peer information from a trace file:
 	unsigned long long *tracecmd_get_traceid*(struct tracecmd_input pass:[*]_handle_);
 	int *tracecmd_get_guest_cpumap*(struct tracecmd_input pass:[*]_handle_, unsigned long long _trace_id_, const char pass:[*]pass:[*]_name_, int pass:[*]_vcpu_count_, const int pass:[*]pass:[*]_cpu_pid_);
+
+Control library logs:
+	int *tracecmd_set_loglevel*(enum tep_loglevel _level_);
 --
 
 DESCRIPTION
-- 
2.31.1

