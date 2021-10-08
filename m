Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01077C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5E8261073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbhJHEbK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhJHEbK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:31:10 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE71C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:29:15 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id a25so15526633edx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xpiuQPFYZ5796nAD04HY+o+y5cqyg7Axgxw2qra2cMo=;
        b=N00p7R0BnVqnzeopQ8FlQ4FlJKrACPxKqaCd8fqq5F9t9MNuO+XDPlRHEpFnVnm9C7
         KPHO1RaVh7Tf0B6Ms5zwQIiqxG6fnouvTW87XCNJN17GwDhHTKitaf9rN8lziMGcQEcq
         IbVrDLNTwgvO9lxIsRHyx32Ai0ixVfNK6F3xGDmrvJR3j6v+ncwJ6tV69dZgWWx3BB9u
         bNf1mGCfwMscPofQ5z+fTf2SEszvNbNs3mKLAGj/pP/Fv/3Pj5GrY1OtrUZ2RtqGifkA
         Xbphs3J1AGwqS57glwf7pqqwvGyKOWV4WgEg9BO2Qr9cu8xrBPAZvEGYWgCQ71u4hqv6
         VPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xpiuQPFYZ5796nAD04HY+o+y5cqyg7Axgxw2qra2cMo=;
        b=nMC7DmjwczE9XZXeanmjkWnc2ZklV2ZYuJdTWTaf24sJJKqhX5wqw1vn1aDjS98fV8
         u7c2DOP+ysJoGOKIh9GxbGjrtQsg2jD1g+g8n+Np4b8RzWBUvTag16MgY2/P0hn0mFrT
         iRgrfQM9YrTGO/10J/Sg79jkvcfj44OFXOfpcF2jrSE2mWCLixmYDE3HFG4H7cedkEHD
         T4kVPf0ySBweDRJxRRYbgBSUTJ+ZSC8bHsbMrcGuLumLMBTA08eFHBbkSTpqAVewcmr+
         YCbmBDv2tiAMsM52Gu7m0loTJyKKsT7BbAiI6XbT830ZCap3gkU6vJTO2HqQ/1KIYC+i
         HsnA==
X-Gm-Message-State: AOAM533ke2ZEg5tXKAU+uJwWaM/Q0Sgy5c/AUTtNsa81OSG5fyDH/L6a
        02YrKMxoitS1DSD8z0st9+XY2kZjWFWMOQ==
X-Google-Smtp-Source: ABdhPJw71f7DRbbke66DCgQWuR7D19SlDhlJZjmzdtLSEroZDNjms3IcD4Me2fPSgDiKm9/akBEKDQ==
X-Received: by 2002:a17:906:2f16:: with SMTP id v22mr1296715eji.126.1633667353759;
        Thu, 07 Oct 2021 21:29:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j11sm456662ejt.114.2021.10.07.21.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:29:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/4] tarce-cmd: Man page for "trace-cmd convert"
Date:   Fri,  8 Oct 2021 07:29:07 +0300
Message-Id: <20211008042909.979877-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042909.979877-1-tz.stoyanov@gmail.com>
References: <20211008042909.979877-1-tz.stoyanov@gmail.com>
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

