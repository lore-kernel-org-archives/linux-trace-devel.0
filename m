Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA9AC48BDF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B641E6140F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFJLh3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:29 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:45919 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhFJLhZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:25 -0400
Received: by mail-wr1-f53.google.com with SMTP id z8so1891374wrp.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OAtcN3yW//6TPwrrgQW5xCMTxQFXX36QFktTPkEsJIg=;
        b=PyNl3nmJHE/0uixv0aC3lp2UxC2DLf9mU0c/H00aZYL2nYXOn7nD5uVdoFSCeXV8Gg
         YRV896vuXvdXeISgyO0YP9OClEA34iYTjGptHNKbVfnlqUhyeFh7hwRXZlvCSbKqir/A
         6TgmM6xAJ4bs3S84CyyPzADogD8Ifvrw4qRP4cG2LgqT6ni8SMIPFEXwAjxoW6GXatbu
         LmPVDIP3pq9o+J+kMnkgGphCE1gE8JT9cjn/YCd13Dn10CsCqH5ix4Ep27hW6HrrkNNk
         /+Efr0sGAbJL4SaJvWUzVIws0DewUHJAhawxMjrANOkNL+C0TLfz9TPQtCTxqAmUwNWA
         /e+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OAtcN3yW//6TPwrrgQW5xCMTxQFXX36QFktTPkEsJIg=;
        b=sgIaFPHkAyDGKsf80pqI74arhn3O7nMGsaVrrYYhxsNybpcc6D8KG/AJIbI5kKhyee
         NrJjNI/MXy/+iiZ08hyE+EHtsYNwJ797DD11OO0Sm1EebVKkccDNIuIXjcL8aLNfH31+
         QJlzCapt/RKJsJ7tLvZr9ZEaStSqjnvhotIiyq/QSnn20hImMocl89ON63PEynO8R38Q
         15OurzTD/bkX8YsDpasU8vx7W9khdiQgTWttfXAQrrewf0o0F3Dg2qROXOKjcS2YNzrw
         lZxY/Vh7ptIUa7ex6UKqhymhQ3rNyLoyKmEuffTyDIihXiwzCMg0SpH901gDGD+4EPuf
         tAHg==
X-Gm-Message-State: AOAM533cE7kMa55Az8cYSY/ryMk2ivCyHHEbapDVz5GwR2rSnNs3r2k0
        baSlUcE4I1mSYvBrZq0EXQMMq3zRfHPUJw==
X-Google-Smtp-Source: ABdhPJwjG6ignhQ8s7O51Q4TTzVxa/DtuScKyXlccLmRJPojeslhzncRNTtEUeW1lfR9eVD6DLkPmg==
X-Received: by 2002:a05:6000:cb:: with SMTP id q11mr4950912wrx.13.1623324868655;
        Thu, 10 Jun 2021 04:34:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 00/40] Add trace file compression
Date:   Thu, 10 Jun 2021 14:33:46 +0300
Message-Id: <20210610113426.257931-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new PoC implementation, adding a compression to trace file.
A basic infrastructure for compression support is added into the trace-cmd
library. The zlib is used for compression, but more libraries and algorithms
can be added. Trace data is commpressed and part of the trace file metadata: 
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
 - Update trace-cmd documentation.

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

Tzvetomir Stoyanov (VMware) (40):
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

 lib/trace-cmd/Makefile                        |  11 +
 .../include/private/trace-cmd-private.h       |  92 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  44 +-
 lib/trace-cmd/trace-compress-zlib.c           | 172 +++
 lib/trace-cmd/trace-compress.c                | 796 ++++++++++++++
 lib/trace-cmd/trace-input.c                   | 999 ++++++++++++++----
 lib/trace-cmd/trace-output.c                  | 877 ++++++++++-----
 lib/trace-cmd/trace-util.c                    |  60 ++
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.c                          |  12 +-
 tracecmd/trace-convert.c                      |  93 ++
 tracecmd/trace-dump.c                         | 162 ++-
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-listen.c                       |   3 +
 tracecmd/trace-read.c                         |  14 +-
 tracecmd/trace-record.c                       |  42 +-
 tracecmd/trace-restore.c                      |   6 +-
 tracecmd/trace-split.c                        |   2 +-
 tracecmd/trace-stream.c                       |   2 +-
 tracecmd/trace-usage.c                        |  18 +
 21 files changed, 2905 insertions(+), 529 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c
 create mode 100644 tracecmd/trace-convert.c

-- 
2.31.1

