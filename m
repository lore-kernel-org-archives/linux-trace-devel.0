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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BF7C43461
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6075E61451
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhEGJvd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbhEGJv3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:51:29 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08E7C06138A
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:50:29 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u3so12628745eja.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ZQ8lr8871xKPs3LDyWgoFfjwRgVLQ9CUpWrYg99OME=;
        b=FqXqMz1ZdWBlkvLUwkS018Ck2HWrGPxECF/rSWIar4Lru8E2OB6JHIl5SlaMOSt+Ns
         pNAWqgrQ2Bziea28rHBPZaYga0eGIbhDZXesziN5OKTJimo4XR9elEMzg6HE5sFo481s
         BTteWkFKmFA+cJ5/Fg3D5ejQB1g2ZMG8D2MqxfwHENChbZmn8pVq5bN4Er4MvEuJKXr6
         giEODR7XAFBaqlxSDuQmB3SNdmWdQVTzs+AuOJehHspC+f1R9dlCzA6QDXXbE8HwFVic
         RRiIF8rP6BZrgZD3MfOln4R09+aBJyAx/KR5CdclQRjpEsAfdaOU0K0xY0mx3fixQNhL
         X8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ZQ8lr8871xKPs3LDyWgoFfjwRgVLQ9CUpWrYg99OME=;
        b=ASraeZ4IScXm4TPRfoRReSmZegYkwFFwqJuYqTBx441lTVIOfhTRANX/QaUUGioa4s
         /cSsE3AiBCKtjIUJbGUHVMhes9V07pKHePGADBssIugK0BSfuVkYnLzNvMTjWO1ykJXK
         SmqkIWfJ/+ALAyhW14lfHXI+L5vPXsyNEWDbJR7jQSOIegE4W4b4HKSpF7yV/yjy1VgY
         TrVgzDL3729C+/qINuFBCmiPRsQdFd5XUR7H5lNSSfTe0tkQzkwBnfZgB5Yh70glkpae
         juVFLy+PheQkRsN+3Y78CgrY7OfIe4ZI8fig337WJ5dFuRR5ztunIn+qpW/nJpHeHriD
         FIZw==
X-Gm-Message-State: AOAM5312wWA28SGb2vjsraHMj76naO+TZhsoz4hhIQ8e3gZMcndIVnvz
        jJPdiDG4S9hlK6G+sQ2j/6DM6MBkiHH1xw==
X-Google-Smtp-Source: ABdhPJwHoAIf7P4Ut04f7G2ku0ML6EuEUGE8zlbl907iKuZ6cSm/2ahF3Grz4ko8e1q+rr9ng7lgww==
X-Received: by 2002:a17:906:c57:: with SMTP id t23mr3790997ejf.355.1620381028586;
        Fri, 07 May 2021 02:50:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a24sm3787193edr.74.2021.05.07.02.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:50:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/4] libtraceevent: Document new log functionality
Date:   Fri,  7 May 2021 12:50:22 +0300
Message-Id: <20210507095022.1079364-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
References: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated man pages with the new log API and log levels.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtraceevent-log.txt | 90 +++++++++++++++++++++++++++++
 Documentation/libtraceevent.txt     |  3 +
 2 files changed, 93 insertions(+)
 create mode 100644 Documentation/libtraceevent-log.txt

diff --git a/Documentation/libtraceevent-log.txt b/Documentation/libtraceevent-log.txt
new file mode 100644
index 0000000..0aee21d
--- /dev/null
+++ b/Documentation/libtraceevent-log.txt
@@ -0,0 +1,90 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_set_loglevel - Set log level of the library
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_loglevel* {
+	TEP_LOG_NONE = 0,
+	TEP_LOG_CRITICAL,
+	TEP_LOG_ERROR,
+	TEP_LOG_WARNING,
+	TEP_LOG_INFO,
+	TEP_LOG_DEBUG,
+	TEP_LOG_ALL
+};
+
+int *tep_set_loglevel*(enum tep_loglevel _level_);
+
+--
+DESCRIPTION
+-----------
+The _tep_set_loglevel()_ function sets the level of the library logs that will be printed
+on the console. Library log levels are:
+[verse]
+--
+	_TEP_LOG_NONE_ - Do not print any logs.
+	_TEP_LOG_CRITICAL_ - Print critical logs, problem that may case a crash.
+	_TEP_LOG_ERROR_ - Print error logs, problem that could break the main logic of an API.
+	_TEP_LOG_WARNING_ - Print warnings, problem that could limit the result of an API.
+	_TEP_LOG_INFO_ - Print information about normal execution of an API.
+	_TEP_LOG_DEBUG_ - Print debug information.
+	_TEP_LOG_ALL_ - Print logs from all levels.
+--
+Setting the log level to specific value means that logs from the previous levels will be printed
+too. For example _TEP_LOG_WARNING_ will print any logs with severity _TEP_LOG_WARNING_,
+_TEP_LOG_ERROR_ and _TEP_LOG_CRITICAL_. The default log level is _TEP_LOG_CRITICAL_.
+
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+
+tep_set_loglevel(TEP_LOG_ALL);
+...
+/* call libtraceevent APIs and observe any logs they produce */
+...
+tep_set_loglevel(TEP_LOG_CRITICAL);
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 3365455..d42b5c9 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -127,6 +127,9 @@ Endian related APIs:
 	bool *tep_is_local_bigendian*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_local_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
 
+Control library logs:
+	int *tep_set_loglevel*(enum tep_loglevel _level_);
+
 Trace sequences:
 *#include <trace-seq.h>*
 	void *trace_seq_init*(struct trace_seq pass:[*]_s_);
-- 
2.31.1

