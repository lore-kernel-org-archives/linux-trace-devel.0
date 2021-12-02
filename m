Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A64C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346947AbhLBMef (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240689AbhLBMee (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:34:34 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1300C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:31:11 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id e3so115438997edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rl7x5Hf7Sfp7pv6816hpBa6/ZNRh80ghX2VsBWK3Hz8=;
        b=YoMzCU8DKLbVJIihSuJKLbYyf/KPnFkrWM+oiqQtVW2WcwL9DbWyvICQs1OcXB1ng3
         M71rKyQvok78nv0zcyAZlk6rICXh2vkn4bLek5r1hXHjvVazApy9pElXq9SKuMSyOT2d
         bdjyLMKcKiV0qZcvgY6RvMr4rOzi34S/enSuXAfTbQzDDJo2VprFi9L5OXasnD4nrB+T
         iJoUMdZxWGaDeEfFsBELvLrv/zax/oucDERR28EmGpELDFWNbkohc5LDdk1aNzAjjuLe
         i9igVF/t/90WRyYcJ1XfPeySx6ex8ZH/93Jno5ZgphDR1bc29aVSL0h5mClHyNs/GOgT
         mmiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rl7x5Hf7Sfp7pv6816hpBa6/ZNRh80ghX2VsBWK3Hz8=;
        b=Qi90uxa3VNC8twdGcrM+H2Keq9YMQJmq8E5gaC5kG28Q/7j3MB1cx8f7NvEZ4YLNUE
         iz24uxRsJkwuwzR8vOk71SvN2eQEfBBsPOW9MqT8MbevFdbSOn8cAXOX03DpQKOLVIE5
         1fEvbPIbI3eaSbNn8IP7Z69gtNRSFuktpxfYhjn4J5CNVHYq2LeJZ1ngJI+iSDgF+ACd
         vRxuFya9RDxOQzHQgzi8omUbeHY194QuQGGhUhdgMWCgZI4EEdnqCRjTqFHP3KjXPSYU
         9qkj9XdrgHReqTSDzHXnCdtCkUAvxT4I01UgvoP5MjPrnEPkNNaQbUciVPfhcA0aIyA0
         Guhg==
X-Gm-Message-State: AOAM530csJ3hShJCxi4PicIWUOSaqcw4AxBBG9wdoMnZCmBZVB1Z4a3j
        akF3mm0DFkF3DENxn7nZZx9iJS5BMCyuYg==
X-Google-Smtp-Source: ABdhPJw5U6S/6WZYquWBfcMh/vSuGbGmGQZWraiYjx82VJfJLw230ksleW++XAVDF/tlUROy/6YKlQ==
X-Received: by 2002:a17:907:6e0d:: with SMTP id sd13mr15149054ejc.90.1638448270403;
        Thu, 02 Dec 2021 04:31:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b14sm2120394edw.6.2021.12.02.04.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:31:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 2/4] tarce-cmd: Man page for "trace-cmd convert"
Date:   Thu,  2 Dec 2021 14:31:04 +0200
Message-Id: <20211202123106.44245-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202123106.44245-1-tz.stoyanov@gmail.com>
References: <20211202123106.44245-1-tz.stoyanov@gmail.com>
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

