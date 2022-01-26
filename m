Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7173C63684
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiAZJzi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbiAZJzh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:55:37 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF522C061744
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:55:36 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a18so67977222edj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuzowlWIX2UC2O8JefGA4cnKiIjtzXvEFXeW0uStPxY=;
        b=akbjtsvMrHdA14aZpQdr/lK5v3CQtbQqTR7CR6MWyEDyokffD3Ggzs+bazFQ1SI+kO
         S4XHqUzywjUPLAJG5r4Xyf+pR3LJAhYm4+tYrK1yzimucLGMMl5xpefTQWfemhp349wA
         /nLW4h6QoYKunANZ7dRrQd1Mer8NoCUhP+ng4i297JilODKRnS8a63XOpbSC9Xx2HHTC
         OJfSQb8UU5+ZstdlohvrcZIp5+26tog8CNOGNA55Eu9FuvON2mg1TYbk9BwxFU6+2613
         flNfJEB1lPanmF8QwYxs7Uv+nMLE387B0+SPDV2Nmrq9mbDgfKuTaFWcs8iAOc4ECx3j
         KyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuzowlWIX2UC2O8JefGA4cnKiIjtzXvEFXeW0uStPxY=;
        b=VrAX1jvvsqjwRTNs9zbNfpRlcA66+KJDSQeKhvRXZkXQOqrQXofll4/rKW03fcaR+m
         99My5lnPs5dt2UL3NHVcBxCNZADsLhWIRxF8QjO0KwAd7bugdpJCKzT8Ebqi4N/rl10Q
         dnKqKUFbtKGbtc64zxNKoQA3ThIJdvnn4P1AxPhaVxL8hA+5/7cyk3wGUqnxTqofQCdw
         InXDE3zUaP1AXJBth9msLzIMMCAgGuOBCPX3dE5bz1LZcveNWstF6j3QZKsunye8rLDS
         UtxDyYzLGDpc6YcLIb7rAw3aKDNZmdwQfKBt1DikLFs9+DImyITVHFWhzOtB5ZNYBMJR
         s0DQ==
X-Gm-Message-State: AOAM5331gPB5qkciv7NHWQ3L2Esa74nd3mccdg5JeUeiU6Ws7/+CiJKV
        KMlX8W/KUYc6KsSb3MLoQykvJxI7Pow=
X-Google-Smtp-Source: ABdhPJxTNd+wBqZDCmOJKchmVpVKJGuU1hH7ob2Qxbzywq6dlo/VUwYljbUq09WlxwYW2Z4zUfqYig==
X-Received: by 2002:a05:6402:5106:: with SMTP id m6mr15358554edd.292.1643190935571;
        Wed, 26 Jan 2022 01:55:35 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id z25sm9563070edm.60.2022.01.26.01.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:55:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 2/4] tarce-cmd: Man page for "trace-cmd convert"
Date:   Wed, 26 Jan 2022 11:55:28 +0200
Message-Id: <20220126095530.571035-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095530.571035-1-tz.stoyanov@gmail.com>
References: <20220126095530.571035-1-tz.stoyanov@gmail.com>
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

