Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35930C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F246610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhKKPQK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbhKKPQJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:16:09 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34460C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:20 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id o8so25346512edc.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rl7x5Hf7Sfp7pv6816hpBa6/ZNRh80ghX2VsBWK3Hz8=;
        b=mUiKSnpegIC5e1o0QzCLZ9E6ciGMA4ndNks7LF1ED8ll9EccKTx2ei9xc6V/6uP707
         uEj5QuRzSeLOwCtogJVz+9TrtWj9h4INQCoD9+ho6AkhYCvAHEhKUp55TVad+AoKfCd7
         5/OHC+KBvNQBR92mNjKFjmApI4zuv0ZW0xbhrUN72RI1pWNEH382EPuqwQ2ApeXULC+c
         ZO4JOt2tXAspdUN80xFLRrHUIttuVjIPE6mXhRUZw7C9HaQnzim181PDWd82q6viI6eY
         JnfBLPL5wbvtZoMYt1YyUELWDf3q/loJJCqSIL7ljooJpgVYaovn6yyYBn+Qy0uzW2pI
         dZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rl7x5Hf7Sfp7pv6816hpBa6/ZNRh80ghX2VsBWK3Hz8=;
        b=4sHSRgJ69OYXxAgxSd1fJFXCO8CLLTW9ua+YZB0A6hJJpgbXWp9rz0MGe7cfZPSa2f
         B+BH8Ru3dyl7VOXteF3P73jZQ0D+VUy04yAchBmAcj/J0Pt7aD+9ROm+J4415RxU+65H
         G2b96ZwguZnJUBcAm0NmrSnhUWnWwg7c5BwNZYPkoX3eCCqkNYu5On0T+Q/xBMVOGJrH
         Y6nnLOy8WIIGI0tgj98snCFSLL65XMxGcvcjocx4tmBDBcPsxlAXgMdQMMiQX+Z3EUS/
         NDPLK9dj38VVxEe6yjp9iyaY9BXcZOn1Si/XsNUKsoRJiiB2bMFak+gswfZjM+wAJsXh
         vFug==
X-Gm-Message-State: AOAM5314Y5AAgxXUMosyBKKkai++Has2JyrM0PIh/aATpMoPXJXa8O+v
        R7mVQI5YSM+YuKt6MabnorA=
X-Google-Smtp-Source: ABdhPJx2OmklpGJ+AvkfnzLIu31hrm60Ub8gpu42HvGEAUCv+yGpm5ZLRVLMmfQAchTK8T25d15AzA==
X-Received: by 2002:a17:907:9687:: with SMTP id hd7mr10555634ejc.498.1636643598467;
        Thu, 11 Nov 2021 07:13:18 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb3sm1545093ejc.81.2021.11.11.07.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:13:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/4] tarce-cmd: Man page for "trace-cmd convert"
Date:   Thu, 11 Nov 2021 17:13:12 +0200
Message-Id: <20211111151314.87148-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151314.87148-1-tz.stoyanov@gmail.com>
References: <20211111151314.87148-1-tz.stoyanov@gmail.com>
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

