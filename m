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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B1BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60B99613FA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235862AbhD1Hmm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbhD1Hml (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:42:41 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281C1C06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:57 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c22so9343502edn.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CRwQl1RkWZDQSE4aQ6fUQgbS1AnPlATPnJ7XQuODs1Q=;
        b=QzJuFXAAcNpNrqVFugqIpGy7r2SDoUQ67IjSAhZIYS18R/ln4uDUjtm5pGvtyV3sFm
         +bmJylVPI3lim9oZ7x1FwRILuS6DN3w4+uj9woXTB3rlnOi3pZoZx2Jp0YpAty+Epvyj
         UuvmRwxxWJAfI64TDBtN0eVIS57VTF2LofRJUjqCSqnd5aHh0GZszAOrsNhXGPNR8WR+
         0BASaY7EBhNUt7hFUDQYSZRETdG5mkH0im0ArOrCQmzFUjgqtD7zt2YayDzckrRerZ7V
         bMfhD/dZLHkZwbDzFJ9kyDrGLKPi3VUh9EvguYqxdylWyIneY9c81hKQeBF4S/wszGn1
         6HAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CRwQl1RkWZDQSE4aQ6fUQgbS1AnPlATPnJ7XQuODs1Q=;
        b=h2aCLs9aE27eRDcnZMGvFEmod82iEEZRdKlLzH7ySBL3bMxBW15HgzEYRgDCi5I/2h
         cw4bcwGqrWBK/L54wsWNf1atLiqrb+rSjHm2k/wuSwaqOdAXFsAeY3UVLT21uq66VL+x
         eIqDpNJ0n0gsnjNirRJagL6whj6nUZ/snn9JsbN3ygGOi5ZUEBXdnUJW/v7NTp3Mo3QQ
         mgD/TAsCSXqtmdokaabmOP9bfsN6jGQS6aXmuOjP5SZrRVp7wedq/cTkYY3tqza+xSfK
         o+TGUD5FOdiZq0wDHudF7EZcpugeguU3J365HXXp+fXgmPh/EwCPsYJAVW16rXzaTjaj
         aF2w==
X-Gm-Message-State: AOAM532OFVpuQ2JeGuLyAahTkdcXb1jD5j1S0ri7OnibZpgd2kWsfy9H
        xMHSz2Ge+3A+6oJp3EK6GiQBZzbgmBHjtA==
X-Google-Smtp-Source: ABdhPJxW3zyOZb3DGTqOAHyV4HCvMrDzxYhWZjZLxPLW0Cgi5NjT+CdQ5+ft7yQuhxgtevPn241vPQ==
X-Received: by 2002:aa7:cdcc:: with SMTP id h12mr9352018edw.273.1619595715950;
        Wed, 28 Apr 2021 00:41:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k5sm4530504edk.46.2021.04.28.00.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:41:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/8] trace-cmd library: Document the API for log levels
Date:   Wed, 28 Apr 2021 10:41:45 +0300
Message-Id: <20210428074149.757163-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074149.757163-1-tz.stoyanov@gmail.com>
References: <20210428074149.757163-1-tz.stoyanov@gmail.com>
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
2.30.2

