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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8F0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0373F6103B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbhIMMyo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbhIMMyn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:54:43 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6083C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:53:27 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id m9so14553656wrb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xpiuQPFYZ5796nAD04HY+o+y5cqyg7Axgxw2qra2cMo=;
        b=onuwBQaYCE5cSK7PZ2iBb8r+jN044+nu0icNEOK2khWrkEhOqjGKvBaFGqePr/rrtE
         uaqe5bJ2cUZqo4FkBTgPMv9TScefz+qGrwus3EO53aKjjILM/q/urGd81LbubjH69Z3s
         fXJTbfEv6jIwU14OFSC5rjne4sLoDUC+iQnOsWZbwsAFUzd9ioTH6xcV3PB9TbtxLgPf
         TB26vmLC2rtG+AFzOmhUdWkm/K5jnQvtnntLQmiLF/iM0i0DuaqHTOy7TUgLQFU+pNIH
         aN5gPGNjoPLI7YbuQARZnN3Nu3uOOePmp08OrrU1+hQYD968Dft/G/Q5RxdaPL7sIbuA
         aCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xpiuQPFYZ5796nAD04HY+o+y5cqyg7Axgxw2qra2cMo=;
        b=LnyDQlHderLXBtcNdPPEPurSnRUkBkC1H/VQsLfqBwHUH8dwoCBxc9SonwsfSeV7Xl
         /BILts+YCW0Aqj+8tC1LG0+pN3W20gpDJbjUv/HO+UOB8iy3YZBbZWmWq7GQPz3KmnDE
         rLIll+1/m8v91xWSvLPvOC0XC8vTPjkMiZ7pYtIW//t5Z0ndzeeU3EtAHio2yqwQuUKp
         jygp9QgXWiGmWcrhDADScaA6YT5ArfY8gPcYrGzLnWLNBZ787mSD+paE53KunCjNQ3CC
         jm2WGddk5fBf7Y4jFwJWMzIwaYFk8eITUgVlEINlvnDVSyt7mFOP1v9qeoV3kxsLkmDG
         fNxw==
X-Gm-Message-State: AOAM530ctZlMjAeElH3raIbvR3ykf/jRWYd6vzXccGaphPrKikVmdCcZ
        QKRz0x8KFbhsw2TeMkNg5h0YyI7jJBQ=
X-Google-Smtp-Source: ABdhPJxsJGWkWZoJNdJSoHc2innfA5wImjOIbOEQOwH7RU7FhJ04BAKLV098OgjyjW1w+q5vp9CvAA==
X-Received: by 2002:adf:b789:: with SMTP id s9mr12359687wre.315.1631537606501;
        Mon, 13 Sep 2021 05:53:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u8sm7280552wmq.45.2021.09.13.05.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:53:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] tarce-cmd: Man page for "trace-cmd convert"
Date:   Mon, 13 Sep 2021 15:53:20 +0300
Message-Id: <20210913125322.3682097-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125322.3682097-1-tz.stoyanov@gmail.com>
References: <20210913125322.3682097-1-tz.stoyanov@gmail.com>
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

