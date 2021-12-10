Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B5DC43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbhLJLKz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhLJLKz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:10:55 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491C4C0617A2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:07:20 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x10so11424806edd.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rl7x5Hf7Sfp7pv6816hpBa6/ZNRh80ghX2VsBWK3Hz8=;
        b=JnNZ5OSDyiDQOC3Hg2Q1O6MNHn/D9leIxlJiNLhF2rkiN0VNvAu0NXCcSz6xfYLJnD
         nSxYdZhQouQwX1jvqtNmEdNDNuNIa41P6RLZjMdOSNLdn04xat9ZIWiiJwWGq4Kh/t70
         xWevfzVhO7b2MgJjvRVTt4GqslteUnvwZpJairEqZ2cGkBOycZqg5Tetlpfxhp1Tkxsp
         v4tRD0BgikHOaHjGgKBx7c1jz+Q8UvzUCIZy5B7zytRjplkvB1959vZgxw/0DJzAkfoc
         PvffH19Nk+AgqGl2fcf21fFIJdke2+cfg/zmymJkEF2ODCYjzNdAGvWZNDvMMLmPHtL6
         5i3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rl7x5Hf7Sfp7pv6816hpBa6/ZNRh80ghX2VsBWK3Hz8=;
        b=BrSwlNg45l2q7AXJJPhXQ2qsFl/I4EnRk2wjs0qlZDgugLvmczHcW6dc1GdmJe5nEv
         z9EYKiWd3rl1UXz0qgkV0m8+KLqqeUnJNN3uTA3nhHO4vV6s2cXESutavv1gIBHJ+srZ
         +n0y/l4fWXmTnuECJS4mE5lKuipZSM2DC/ouq1EM+iqubbIVrxiurjy/KnMYEymwUdGw
         O/DEtceIiVc1lCD+Kg8V95CovYEx7JZDO7c/SIbY2xEV3UaHYsZ4mKfgJ2PSd0a4ra+u
         JgFQspjSInKuV7dIZ8Ik2AViBBHd9uonbGTRKVpCF3qOOIF9x37SDnZoviONIscofYqu
         lxNQ==
X-Gm-Message-State: AOAM530kG2Fujh1n3/KSewXCKfXJpE7EukQM+CJ31Zr343xi3wV0E5A3
        Oi4un7ehQYcjbjno2LK8EDxk77YRSBQ=
X-Google-Smtp-Source: ABdhPJytg4afkBrqeWDFySEoWLkkuuxx/czmFNkJb/TyimSBxAwWNH/4gQQfF9E5QRLH3Kr5WSn1mQ==
X-Received: by 2002:a17:907:ea5:: with SMTP id ho37mr24309596ejc.133.1639134437664;
        Fri, 10 Dec 2021 03:07:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w5sm1299236edc.58.2021.12.10.03.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:07:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 2/4] tarce-cmd: Man page for "trace-cmd convert"
Date:   Fri, 10 Dec 2021 13:07:12 +0200
Message-Id: <20211210110714.99067-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110714.99067-1-tz.stoyanov@gmail.com>
References: <20211210110714.99067-1-tz.stoyanov@gmail.com>
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
2.33.1

