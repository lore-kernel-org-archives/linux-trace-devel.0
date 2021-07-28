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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F84C4320E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12DA660EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbhG1Ne2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbhG1Ne1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:27 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EA1C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id x90so3227277ede.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jFqYVxkdWFkFLbm8eow9LgOG4BZkciuN5sl8VyVpIDY=;
        b=UkR6fAkD0VX+bUTdzjcXav/7kkTg9n2xb3Sf/LqqKS8rTt+f+3mmbYGaLbOu5zRxbq
         LwwmVuXWoyArBba+2zxC1UW1wpWkXp5ygcykEpPwQPKKeNC54IpY9QR8hH77YQlKuPyl
         W0iSsDYLF+NNYiik+mtV6rrzrlLo50imIw/h0fxshU1vFLakvAmPOoIK0iMTn8nSrYX0
         /ErkAMAPe9lqpWZhff7VlXloJc4T9dl6MRBX/NKo0q/OHI7i8UtU9F/JgSHL1EpeNmCe
         vPbitqs1iefm11qNhZxkrwJQpWY9bFwkGLrwnHm0QKsAW5DCXX6yXkbGmodsc6qT7Kfd
         9nvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jFqYVxkdWFkFLbm8eow9LgOG4BZkciuN5sl8VyVpIDY=;
        b=cQjbZd8haEM9Ac8a+WG/h0X/QPaG5owDIh1Y0hlj+jHNPviamIb6sW7zNU6Pni9JEc
         0Jtnc0yv6ExSMVx1DcIQ0D5q2CshvGt/1SMIz6ykWpEqpNMJGUcZsFjExCxCKAnpyHKJ
         pbC4DbuiHNr5haKZz9w2ImggbKBudF15NTaN0HoZ68e+0MBRvheFyYYRyD35lCnAn3Iy
         iOkP0AMU6HoxtdYYDvcZY5spe80p/6iuChi7gZmFeCcXtas6fSVDmP7QkG/3jZ2iNJW1
         vBwSiwmEoAGTgekkqIWo/do3cLUrCIDLQMgWUIr4xV0enYLavwRY78Dc45XEM1zcqwqL
         ihrw==
X-Gm-Message-State: AOAM531u4l0YIFU9u4ufJcEKGboPg4ngX+9S5/P3XDlD/ZTgZDkK+KO/
        bquPDloyj16El5Qouqwx5JM=
X-Google-Smtp-Source: ABdhPJy0FI+J6t+WcBTT1BjjVAc/RttER8SjOTyzHiSdcDfYHgubjXZ7yTmYe27s4En1GSWS81/8+A==
X-Received: by 2002:aa7:c2c4:: with SMTP id m4mr34470374edp.173.1627479264258;
        Wed, 28 Jul 2021 06:34:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 85/87] tarce-cmd: Man page for "trace-cmd convert"
Date:   Wed, 28 Jul 2021 16:32:48 +0300
Message-Id: <20210728133250.234140-86-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented new "trace-cmnd convert" subcommand.

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

