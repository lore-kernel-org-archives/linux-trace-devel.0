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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6CCC43460
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B8F6145A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhEGJxA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbhEGJxA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:53:00 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5C2C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:52:00 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id zg3so12685840ejb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dqx6CL0xi+M79HkvMsOGyWbYR/BaxV9XL5sermNfC6A=;
        b=NQCS3Qxu9WKYcL+J/8kI4y/E6/T5QIP3NFPDwHSkmTGLAfEFoCxRiJ/FXWC4nE6830
         KVT7oLEECHsawKAQ5TnlJKgqTpTFwTIF6zigRT5e7uiRqV9YPKFrv5OmK/IuKcHNWmcB
         Km3wgexnkE3CUnhIirttBNpKKKlN4hATUgRpRuq1kPtoVtjAw03G3aLDBYkNLcPmoHPS
         KpXTCsXknw2Xhe+oE7KEWFefKIutfnaaGfHOb7ysQiOlE37t35eF0F6ARb84wLC3ZLZe
         raAPN1DxqS7Ud4svH5ukK2vZC1IPzE4aYcEdnKAnntga5/ZrOgWIw+JNOit4s2oWZRjV
         70wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dqx6CL0xi+M79HkvMsOGyWbYR/BaxV9XL5sermNfC6A=;
        b=XfEevKZS0T4kNndyFgvxql3MjCiWE5ppORgb/bAIUcpcVxPOkVkhLRlJSnl4EAvQOt
         APo0qh/VkbAjx0zOksfB1amtPqvL1GvAd8yr6vWjDjS8DGUeyPLQm45KXxqgWOtXJp0H
         adcd4uwgxSvKpEXeJ9kX6X1r7qzHqhJh1ApaE0fWMJHy5VBjL849pORNmR4+9gMuEw25
         BASfqSULwG+/MbG2IWOhGeRuh/zoxx2+f1C9tjNJ1uR6a2Ex+tqF3Fbasq6OdKRoY8Rz
         OiY8iEWyeNOr1Lmdmh05n8gE+viSNc/4S1NR1hLo6rTc0F3ZCn15mKoZ0TucrkL3KVAe
         3PoQ==
X-Gm-Message-State: AOAM531BovT2JAm3ssUfWR+2kNpPoNStJzo5GkJj+v8r6JGm0X+NF7WT
        sX0ramm7ohkAC7HpshnVis4=
X-Google-Smtp-Source: ABdhPJwB682QJPivFNMKTcjEKEMYppcYcgn/nWUPYP6fogCEvsGxgrVgmkbaTrzeLvPJDNjXvM1Nww==
X-Received: by 2002:a17:906:a0c6:: with SMTP id bh6mr9019691ejb.359.1620381119384;
        Fri, 07 May 2021 02:51:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eb9sm3130893ejc.96.2021.05.07.02.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:51:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/3] libtracefs: Document new log functionality
Date:   Fri,  7 May 2021 12:51:53 +0300
Message-Id: <20210507095154.1080202-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095154.1080202-1-tz.stoyanov@gmail.com>
References: <20210507095154.1080202-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated man pages with the new log API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-log.txt | 76 ++++++++++++++++++++++++++++++++
 Documentation/libtracefs.txt     |  2 +
 2 files changed, 78 insertions(+)
 create mode 100644 Documentation/libtracefs-log.txt

diff --git a/Documentation/libtracefs-log.txt b/Documentation/libtracefs-log.txt
new file mode 100644
index 0000000..a4107e8
--- /dev/null
+++ b/Documentation/libtracefs-log.txt
@@ -0,0 +1,76 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_set_loglevel - Set log level of the library
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_set_loglevel*(enum tep_loglevel _level_);
+--
+
+DESCRIPTION
+-----------
+The _tracefs_set_loglevel()_ function sets the level of the library logs that will be printed on
+the console. See _libtraceevent(3)_ for detailed desciription of the log levels. Setting the log
+level to specific value means that logs from the previous levels will be printed too. For example
+_TEP_LOG_WARNING_ will print any logs with severity _TEP_LOG_WARNING_, _TEP_LOG_ERROR_ and
+_TEP_LOG_CRITICAL_. The default log level is _TEP_LOG_CRITICAL_.  When a new level is set, it is
+also propagated to the libtraceevent.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+tracefs_set_loglevel(TEP_LOG_ALL);
+...
+/* call libtracefs or libtraceevent APIs and observe any logs they produce */
+...
+tracefs_set_loglevel(TEP_LOG_CRITICAL);
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
index 77d053d..2c9eabd 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -61,6 +61,8 @@ Writing data in the trace buffer:
 	int *tracefs_binary_write*(struct tracefs_instance pass:[*]_instance_, void pass:[*]_data_, int _len_);
 	void *tracefs_binary_close*(struct tracefs_instance pass:[*]_instance_);
 
+Control library logs:
+	int *tracefs_set_loglevel*(enum tep_loglevel _level_);
 --
 
 DESCRIPTION
-- 
2.31.1

