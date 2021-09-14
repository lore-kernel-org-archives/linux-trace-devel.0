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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67218C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AD4A60F11
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhINNZA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhINNY7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:24:59 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F45CC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:23:42 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id n10so19849123eda.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xpiuQPFYZ5796nAD04HY+o+y5cqyg7Axgxw2qra2cMo=;
        b=OJbhI/25qAyeaTcjjs7p0mlkoHVJ2pYt6ggIvTAK5qLvWY85k39DAgVHdYeglkiH1W
         ZAq+R1XF1zFBFemRTG++qEr7dwQ8Z/QNnynMZS3avjJImMO7ujPDoJIaYAIh3ywHCZE7
         937q7wlL6RFbn3EOBFJB3S9JUITfcgdYqA5c8iUlPIMX7y+NmlgHiji/qKlMew4lsk9Q
         XC+qSnjorHjxhdvql+x7XUKCwgpiSSiDNX90kv5tr204R2oKWN1wIiTGm2Fw6eYWiy3C
         dw/tWHvb7eldm7DXytrWXbuSevVrNVujsUCDLg4ctukvRrwXzE0jwgXdpgsPbpEB1CVI
         qiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xpiuQPFYZ5796nAD04HY+o+y5cqyg7Axgxw2qra2cMo=;
        b=iqKsw8lveHZPMHbxN6XGGZ1fgkIUGn2Fv0eZxpQdlvaj6Y0u+mhdPSc5hC0SJpPijP
         Yl4d2E15+MCI3v6DGW7kHbcUeCRt6mYv2Vb0jSJwBAp3XHUF34JZIJIgo8a22zvjNLJ7
         sqbEE7jSiaiMRkaIaTc0oM6gQD/C77/+aq/vJmU8C17mjN8ybt7xMZWnoosXFTQbnVvt
         1SLp02YYOsT7XU4EPkjtdJRy7WqD1KsvohalWjjg9oCbIxg5AGubct0R6tBwyoOzqke6
         5DZBWiOkoRrBIpbsKe7swq702I81b7Eu3NFOpHWyezLaD4+8i2RM38OphPBjdT6PIja3
         TmJQ==
X-Gm-Message-State: AOAM5309XtoPp56aPzdxnIZYSFp0ehUJHPOGfIMbqwntuzFjUYeGu44Y
        wkv59d0i8b3IDw/yadC1ipKE2WGkO2Q=
X-Google-Smtp-Source: ABdhPJwtlRTlHPKf6Q5Sz1bAfmtMATZvtjOi8igVaYs7C9ucmXjyNszOd92wE8xKVPD49AzKPoth8g==
X-Received: by 2002:a05:6402:358a:: with SMTP id y10mr813507edc.238.1631625820831;
        Tue, 14 Sep 2021 06:23:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h10sm5689970edf.85.2021.09.14.06.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:23:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/4] tarce-cmd: Man page for "trace-cmd convert"
Date:   Tue, 14 Sep 2021 16:23:35 +0300
Message-Id: <20210914132337.3969125-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914132337.3969125-1-tz.stoyanov@gmail.com>
References: <20210914132337.3969125-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented new "trace-cmd convert" subcommand.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../trace-cmd/trace-cmd-convert.1.txt         | 65 +++++++++++++++++++
 Documentation/trace-cmd/trace-cmd.1.txt       |  4 +-
 2 files changed, 68 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-convert.1.txt

diff --git a/Documentation/trace-cmd/trace-cmd-convert.1.txt b/Documentation/trace-cmd/trace-cmd-convert.1.txt
new file mode 100644
index 00000000..7c13cf3d
--- /dev/null
+++ b/Documentation/trace-cmd/trace-cmd-convert.1.txt
@@ -0,0 +1,65 @@
+TRACE-CMD-CONVERT(1)
+===================
+
+NAME
+----
+trace-cmd-convert - convert trace files
+
+SYNOPSIS
+--------
+*trace-cmd convert* ['OPTIONS'] ['output-file']
+
+DESCRIPTION
+-----------
+The trace-cmd(1) convert command converts trace file. It reads the input file and copies the data
+into an output file. The output file may be in different format, depending on the command line
+arguments.
+
+OPTIONS
+-------
+*-i* 'input-file'::
+    By default, trace-cmd convert will read the file 'trace.dat'. But the *-i*
+    option open up the given 'input-file' instead.
+
+*-o* 'out-file'::
+    The name of the output file, this parameter is mandatory. Note, the output file may also be
+    specified as the last item on the command line.
+
+*--file-version*::
+    Desired version of the output file. Supported versions are 6 or 7.
+
+*--compression*::
+    Compression of the trace output file, one of these strings can be passed:
+
+    'any'  - auto select the best available compression algorithm
+
+    'none' - do not compress the trace file
+
+    'name' - the name of the desired compression algorithms. Available algorithms can be listed with
+    trace-cmd list -c
+
+*--help*::
+    Print usage information.
+
+EXAMPLES
+--------
+
+# trace-cmd convert --compression any trace_compress.dat
+
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd.dat(1)
+
+AUTHOR
+------
+*Steven Rostedt* <rostedt@goodmis.org>, author of *trace-cmd*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2021 VMware. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/trace-cmd/trace-cmd.1.txt b/Documentation/trace-cmd/trace-cmd.1.txt
index b330b4fe..27c6e973 100644
--- a/Documentation/trace-cmd/trace-cmd.1.txt
+++ b/Documentation/trace-cmd/trace-cmd.1.txt
@@ -58,6 +58,8 @@ COMMANDS
   check-events - parse format strings for all trace events and return
                  whether all formats are parseable
 
+  convert   - convert trace files
+
 OPTIONS
 -------
 
@@ -70,7 +72,7 @@ SEE ALSO
 --------
 trace-cmd-record(1), trace-cmd-report(1), trace-cmd-hist(1), trace-cmd-start(1),
 trace-cmd-stop(1), trace-cmd-extract(1), trace-cmd-reset(1),
-trace-cmd-restore(1), trace-cmd-stack(1),
+trace-cmd-restore(1), trace-cmd-stack(1), trace-cmd-convert(1),
 trace-cmd-split(1), trace-cmd-list(1), trace-cmd-listen(1),
 trace-cmd.dat(5), trace-cmd-check-events(1) trace-cmd-stat(1)
 
-- 
2.31.1

