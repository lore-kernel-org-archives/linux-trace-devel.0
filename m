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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BDFC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3397960234
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhD1HdC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhD1HdC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:33:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CDEC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:32:18 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z5so36470787edr.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7zebYPqJyGAu3jhE10rNauXE9g/PfLMGKBQv/XfpW80=;
        b=r31I1++Fw1UcC6qg2+yRQKMZa2pt7b25L8IvIZJpHo62ZnHUJiVb5WdqGa3i09OoVP
         DFpni6A9NZgHLZ3sUcsTWKcJzqpcpvzSSY7mvMstq1C2DeHReovGJu9ViKlZHsHLjiYP
         dotLOPETGopBqdVSYMXWf1opCR+HwRykTKpc8PXVjPQ1PGeRUd0ovIwMTHiCYeSvyRoR
         L27V5lWywfMspjIK2YvaCjOVTtOxYsIe3MHXhRyYYRpC3RwI7vtkbFLXLbrecmcgojPT
         GK6W6owhRVw7z/9kCtkRfDDUt867ALOkRGeIVOHL18tYmzJwIeP+Y0TFp1lYrcYVnF1V
         LQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7zebYPqJyGAu3jhE10rNauXE9g/PfLMGKBQv/XfpW80=;
        b=TAC/lTmoRmgvSbfgrllk5mG2ipdaACbli9l0XZbfxpdene1J4+Oen8i40tRfCiz+aE
         rA5Lt3BMmoS4r8mGvmPxGDdQscdpEk8hCW5sR5HJ2D/sJR2L3m4FwVHWY8frhhmvZY+f
         RVXlIrtPS4kSXcrFWB6NUtBLCz7H2sz6ZASDAPs6GfwcFC/elOhk8yrRsD6koFrPMuWr
         Zla48QHyPUoViFq73gLExU26BHAHChier4xv79wDHZ8DEcUYvf17KYwhLTi3lin1u4dC
         IhhZS6xALW2cA9CAWTjI0xat6mTSoZZKkePTSbJyPlcJcd80Ylm4p8zxd4g5YC/j48SA
         VB9g==
X-Gm-Message-State: AOAM533gbGiXl/V7n9p1tdl6Nl4ApDjXIpJRGIf7J7YVka5UHXICjpdg
        Q4Kf4ZvFcPbHkYUywCS2Tx4=
X-Google-Smtp-Source: ABdhPJxuQvYkpZ9gDocJA0bBqrPBtRRkghfdPGfF6dxlKMRFFVJE1lUe1YuiiLxG1y1kR08VaSPFXQ==
X-Received: by 2002:aa7:c7da:: with SMTP id o26mr9285605eds.244.1619595136893;
        Wed, 28 Apr 2021 00:32:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z26sm1363646ejd.52.2021.04.28.00.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:32:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracefs: Document new log functionality
Date:   Wed, 28 Apr 2021 10:32:12 +0300
Message-Id: <20210428073212.756329-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428073212.756329-1-tz.stoyanov@gmail.com>
References: <20210428073212.756329-1-tz.stoyanov@gmail.com>
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
2.30.2

