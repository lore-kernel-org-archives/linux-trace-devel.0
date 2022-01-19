Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E541C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351302AbiASIcZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352448AbiASIcZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:32:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D417BC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:32:24 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id a18so7629882edj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuzowlWIX2UC2O8JefGA4cnKiIjtzXvEFXeW0uStPxY=;
        b=X8h6v2RibrDMba/yNElILNflYr853OdUnx9z9sGs2CiZ09le0F9JXiz5inXlztNY/0
         tY+h74zylCp/a2d5dxhwlk6gApG8CqUhh1rOxE7eGecxsoRJsM4LJUrCdtE2fcBg9i15
         mLGWuiuK8GVhc5yIFmMjsPt0UyM/vCNg55Hiv+VdpErrFv/NM3/y/VWLumAV2RxQHpU0
         Qfq/Igiy1dBLE3sIQlLn2YRrC52f1q7NUXrqW8aNCtQCUc55HwgrAayAciFQISQAQg++
         +mS/1j4NLnpf2wh+d/aCnAlrAwvlj20XUa3RKc2RISPbXfdgxmiA7S22n8en/gU5WxxB
         OC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuzowlWIX2UC2O8JefGA4cnKiIjtzXvEFXeW0uStPxY=;
        b=tW3JzKbO7hNwJLquXo7oyzLCFmlNY4vO3HHWsGx6stfz8w6tsItYaBSEEFk+i644jx
         CLFnjMpwt+WOHQkj3eEZI0P9pYd9DewBq9wxKbdyxcteXNUbmTsRWzMmI1IXaIu406DR
         kqX9220GPGKTIoxoLE+RfA1GMZk2DtoaGb4bi5x+xX6Ou/tgmI2yL1TZYu+U16caC5p2
         z1ja+NaZGqiJXC7p/z40cqnArFUg24EesJrn/SgRd2cfKidxla9eDPfcOHGAEN7Vudud
         M3trFKNcuhcFiKpD121jLj3B5XpQ9ivTgzmzd1pBz1f0ztAyhmgkyPY5v7yg/iFN6tbN
         xg+w==
X-Gm-Message-State: AOAM533kNylaOa4WG71OqqpuVBMtYMLbYOkAVphReUj3+NNogL9kcI4R
        fQ3TGMnev/F3Xw0bDVGtAQPTUCQ9qVQ=
X-Google-Smtp-Source: ABdhPJyTYLbRkSxXY6agKVst1/xdAdvUHwcquaShX8wAuyUk7JhqnBO3QniQcbj8JTtzE6YOSPLdFg==
X-Received: by 2002:a05:6402:1cb1:: with SMTP id cz17mr1654962edb.88.1642581143455;
        Wed, 19 Jan 2022 00:32:23 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm875969edb.58.2022.01.19.00.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:32:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 2/4] tarce-cmd: Man page for "trace-cmd convert"
Date:   Wed, 19 Jan 2022 10:32:17 +0200
Message-Id: <20220119083219.246347-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083219.246347-1-tz.stoyanov@gmail.com>
References: <20220119083219.246347-1-tz.stoyanov@gmail.com>
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
2.34.1

