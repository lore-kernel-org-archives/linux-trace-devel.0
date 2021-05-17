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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86652C43461
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C367610E9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbhEQNl1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 09:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhEQNl0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 09:41:26 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DDFC061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:10 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id et19so2206756ejc.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MhaNQMLEk3FzjpKjnPZiq4qO19h0lLl+kHtcI51ICRM=;
        b=TuP2oPLz9LQHMlHd9O+eaxt+h4D3ytdYDUIttCAqJtfngv7nMoHXuyLzNZz7m+uQxD
         mzEqIB+1aUGmVYFdO4EJeg+eknwH2rERF6g8OwsBx4roxuFkXODxXXs+eLir06Y77vW1
         WhS1pxyw46bHgjuTdh5Ae+kMp2s6yBm04oKdGiByhCYr8KQ6siCJSnJd7e4RCRJSzi9P
         zt+pEAGYJvue+ftDaE7SufyoMligXBOutpx52mep4IPoS9br7T+D/QzitLY0ZrPIJXcZ
         xSFfM7JltmHYD5rh4TxO7wfV244fGLO+ujnTHsh/SvNC3zhuRP3AaivXkITyHzll904M
         4XLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MhaNQMLEk3FzjpKjnPZiq4qO19h0lLl+kHtcI51ICRM=;
        b=r0NsrOEV/FH9VwllOOddSa9DHwsh7hmyzuA8rrn6FIvCkJIviBD7a+fZC00ZGsRzGH
         BgxqrPDD1lYSzTbdegNF6Q5lQLppCQqY+78jG/nLSe88s1CnaXxR9IqySKAkkF9JJbUM
         ctWa/cObahdERTfFuj9mSi+atMtkyigJIL12HSEHOCuqvvZpomdiZj/jpiiIVriBjhQ/
         Rd7ideIkMaY/dQkd4g5bpQQINF7xaAthsErwGDikEI28tcgKjuVnaiXr1akwrptSHjmV
         Zo+SbFvoJ1+encncZwpVytA5xqLqAUCEsH7AVgOsjZmWXkx1zf52ELKFTzwBUvrYXQHo
         NdQg==
X-Gm-Message-State: AOAM532MQfU1PBYDJIToYFFj+sGERmM+mceGDTslSQyVAKZycH+ekN1I
        0KQb5jEuAPK6XXLCPIbw+Bk=
X-Google-Smtp-Source: ABdhPJwrSwysw1sT0WC8lt7TnpVncaDrKpHX98yhzUc8TuEiagPU3RGoopT2MNOEZyFFC2zH8a0xQA==
X-Received: by 2002:a17:906:bb0e:: with SMTP id jz14mr61585986ejb.285.1621258809318;
        Mon, 17 May 2021 06:40:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r25sm10961799edv.78.2021.05.17.06.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:40:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/6] trace-cmd library: Document the API for log levels
Date:   Mon, 17 May 2021 16:40:01 +0300
Message-Id: <20210517134005.611251-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517134005.611251-1-tz.stoyanov@gmail.com>
References: <20210517134005.611251-1-tz.stoyanov@gmail.com>
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

