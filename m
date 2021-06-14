Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E08C49361
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E17761289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhFNHwp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhFNHwo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:52:44 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A43C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:32 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id g8so15066538ejx.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+UPzknUK2mR1e7TDf4sgZmlqFGY4GrpppOqeYqILOPI=;
        b=f56nddkhgRdtIgRTYy/HL+dHkBpD300OhNx4kqtPuxypZL69STOTwz597nub+CQbSu
         KuJmX6gE45S6NlWajVF/aATVHZUC9HC9t7gdiLAsfIPfH1f5H+3/eO1lu97eIKGAE0MD
         v1cuyEu2Oxor6Vw/du50Ga1eW4eegjuJjh43ZKoeAPcJRRL00V2eCkigYACAc7StYepJ
         O7zlRkg25x2kBQ4ofqVkoWnFA0nwMMDfQnXYkgqWNzqtcwABqMqBxqf2pFR3CmbM4GhK
         PTEKkOXnAartGzqDen7WY+qJGI6HkfK55ZOkksJdBFQ0txmpQESaUQUO8ZSMfxLezvPk
         YNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+UPzknUK2mR1e7TDf4sgZmlqFGY4GrpppOqeYqILOPI=;
        b=GraVB6Yf9rEBfqi3M9NQWoz/BwqNeFkjXWjM8ijLsg17OB72UwEmYAjHSHoYYhjAik
         s/JldqqrHDdPvTRkVkzV5Jq4k/ACCUDw3sFLxyYsqGWY5abIch3Z43KvHwzm23hJgv3z
         1AjeFVYGyg49Tx4I6RIZgIVse3rZ7DPjlTpoQ9k6vBW70mxJCpwW59XJCeEOeRhmckxq
         TPtc8aWiB0KC8k+ocUlN7a1p5EWdmVw58DoqrDWTg0Y+Sy1fma/CCEwHbZIiI0kl36u3
         AkpXSQaNSLPzaYudsGoGD7gKm3vtIwPCvEn3ydYf4a8mtC4pQCQAvXnyT9mc1VQvo7jC
         PkfQ==
X-Gm-Message-State: AOAM531szspeZAlBBZ90A6omcWG0bnTuDrcRpwENFP3Ysd62xXB4akUA
        Sld+3qlOkpIjIsxz40h0RW8hvDCJUJ747w==
X-Google-Smtp-Source: ABdhPJyAKul5lmlHKh2gV4IVDoa0ngaJijEuvLzcnM0pHpDkNE27L+Uyklgp54Vt+pKcSm9fFl+Yiw==
X-Received: by 2002:a17:906:914f:: with SMTP id y15mr14633840ejw.354.1623657031506;
        Mon, 14 Jun 2021 00:50:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 00/45] Add trace file compression
Date:   Mon, 14 Jun 2021 10:49:44 +0300
Message-Id: <20210614075029.598048-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New implementation, adding a compression to trace file. A basic infrastructure
for compression support is added into the trace-cmd library. The zlib is used
for compression, but more libraries and algorithms can be added. Trace data is
commpressed and part of the trace file metadata: 
 - ftrace events format
 - format of recorded events
 - information about the mapping of function addresses to the function names
 - trace_printk() format strings
 - information of the mapping a PID to a process name
 - options
Note: not all trace-cmd commands are tested with these changes. These are
verified to work with compressed trace files:
 trace-cmd record
 trace-cmd report
 trace-cmd dump
 trace-cmd agent
 trace-cmd profile
 trace-cmd split
 trace-cmd convert

Todo list, in order to have complete trace file compression:
 - Add support for more compression libraries.
 - Test all trace-cmd commands with trace file v7.

v6 changes:
 - Documentation upadate.
 - Bug fixes.
 - Coding style fixes.
v5 changes:
 - Comress the latency trace data.
 - Add new "trace-cmd convert" subcommand.
 - Fixed bug with empty CPUs in the trace file.
 - A lot of minor bug fixes.
v4 changes:
 - Tested and fixed profile and split subcommands with compression files.
 - Bug fixes.
v3 changes:
 - Compress the trace data.
 - Added documentation to all compression APIs.
 - A few minor fixes.
v2 changes:
 - Refactored compression APIs.
 - Moved the trace buffers description out of the trace options section.
 - Added compression of "options" section of the trace file.
 - Updated "trace-cmd list" to show available compression algorithms.
 - Tested with host-guest tracing.
 - Merged with the patchset that bumps the trace file version.

Tzvetomir Stoyanov (VMware) (45):
  trace-cmd library: Remove unused private APIs for creating trace files
  trace-cmd library: Remove unused API tracecmd_update_option
  trace-cmd: Check if file version is supported
  trace-cmd library: Add new API to get file version of input handler
  trace-cmd library: Select the file version when writing trace file
  trace-cmd: Add APIs for library initialization and free
  trace-cmd library: Add support for compression algorithms
  trace-cmd list: Show supported compression algorithms
  trace-cmd library: Bump the trace file version to 7
  trace-cmd library: Compress part of the trace file
  trace-cmd library: Read compressed trace file
  trace-cmd library: Add new API to get compression of input handler
  trace-cmd library: Inherit compression algorithm from input file
  trace-cmd library: Extend the create file APIs to support different
    compression
  trace-cmd record: Add new parameter --compression
  trace-cmd dump: Add support for trace files version 7
  trace-cmd library: Add support for zlib compression library
  trace-cmd library: Hide the logic for updating buffer offset
  trace-cmd: Move buffers description outside of options
  trace-cmd library: Track the offset in the option section in the trace
    file
  trace-cmd library: Add compression of the option section of the trace
    file
  trace-cmd library: Refactor the logic for writing trace data in the
    file
  trace-cmd library: Add APIs for read and write compressed data in
    chunks
  trace-cmd: Compress trace data
  trace-cmd: Read compressed trace data
  trace-cmd library: Compress latency trace data
  trace-cmd: Read compressed latency trace data
  trace-cmd library: Reuse within the library the function that checks
    file state.
  trace-cmd library: Make tracecmd_copy_headers() to work with output
    handler
  trace-cmd: Do not use trace file compression with streams
  trace-cmd library: Add new API to get file version of output handler
  trace-cmd: Add file state parameter to tracecmd_copy
  trace-cmd: Copy CPU count in tracecmd_copy
  trace-cmd: Copy buffers description in tracecmd_copy
  trace-cmd: Copy options in tracecmd_copy
  trace-cmd library: Refactor the logic for writing CPU trace data
  trace-cmd library: Refactor the logic for writing CPU instance trace
    data
  trace-cmd: Copy trace data in tracecmd_copy
  trace-cmd: Add compression parameter to tracecmd_copy
  trace-cmd: Add new command "trace-cmd convert"
  trace-cmd record: Update man page
  trace-cmd: Add convert man page
  trace-cmd: Update bash completion
  trace-cmd list: Update the man page
  trace-cmd: Update trace.dat man page

 .../trace-cmd/trace-cmd-convert.1.txt         |  60 ++
 Documentation/trace-cmd/trace-cmd-list.1.txt  |   3 +
 .../trace-cmd/trace-cmd-record.1.txt          |  10 +
 Documentation/trace-cmd/trace-cmd.1.txt       |   4 +-
 Documentation/trace-cmd/trace-cmd.dat.5.txt   |  56 +-
 lib/trace-cmd/Makefile                        |  11 +
 .../include/private/trace-cmd-private.h       |  92 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  44 +-
 lib/trace-cmd/trace-compress-zlib.c           | 172 +++
 lib/trace-cmd/trace-compress.c                | 797 ++++++++++++++
 lib/trace-cmd/trace-input.c                   | 999 ++++++++++++++----
 lib/trace-cmd/trace-output.c                  | 877 ++++++++++-----
 lib/trace-cmd/trace-util.c                    |  60 ++
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.bash                       |  37 +
 tracecmd/trace-cmd.c                          |  12 +-
 tracecmd/trace-convert.c                      |  94 ++
 tracecmd/trace-dump.c                         | 162 ++-
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-listen.c                       |   3 +
 tracecmd/trace-read.c                         |  14 +-
 tracecmd/trace-record.c                       |  48 +-
 tracecmd/trace-restore.c                      |   6 +-
 tracecmd/trace-split.c                        |   2 +-
 tracecmd/trace-stream.c                       |   2 +-
 tracecmd/trace-usage.c                        |  18 +
 27 files changed, 3076 insertions(+), 536 deletions(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-convert.1.txt
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c
 create mode 100644 tracecmd/trace-convert.c

-- 
2.31.1

