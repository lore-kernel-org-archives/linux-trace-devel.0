Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDE6C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA4961184
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhETDVZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhETDVZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:25 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BC1C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:03 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l1so22954311ejb.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IO6bdzXRIseBH/sb0GDiGn7Vo9nvWcrPwq7BmG9xH2U=;
        b=op7QheF/eQP96N6ut1X0J6CEAbhwX2Aap/RXCRrutcSbryUwxgiuIv2NjuzgfAqlhQ
         S9b5TpVijf0RghikbIMw7gZDsp5KQLaIlBrnTUOqpInCJ0yv9VwEy91bIOHIvijzxg12
         yWrz/19hSf6XuTaeJwr6Fh3XFHecLcMlRezUHQsbUpheQGxMEK3l97b3dPFAvGs3O1jj
         MICVUGceZ3kmVDhJanPIQIlfisUClL3rdDbQvW/dKDuUZd0ePGAYHK1ejT5ZYbRpOBhn
         Wgl1m/AyO5wPErBo6o1qdyboAK2SZMGfwsb3pRLhuEg+8xP5/nUwUv7cYVvgRwmz0xer
         92XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IO6bdzXRIseBH/sb0GDiGn7Vo9nvWcrPwq7BmG9xH2U=;
        b=rFXXsXZsWS3utqRhyIcSQ6mkDJz77ngSkJCmCboAGGEzK8LxZ2ieqSNv32tKWmYTgA
         UhqiqL0Ai1ZR4a8vtGoQEYLG2NMu8vGJ+4DOShKgbZcpVnanRqmprIhFZ7yDEO1TsDjN
         dg0HazFLZzyvosuBHeCEXP4TOqTs2PvoFQMsre+YlL+M916SiJVqFGWqPlWWZ8t2U0Ce
         3AofoUYZ3WmoP/68pJKIBs9tbPJSriyYtac4UNSgCMFRl0tCsltPnqlwz7/U5xc7D43K
         9I2RnFtBh9AZNVLoZoYBQZ+ca7tnRCdhMwxQ5OG7eulv8nCATdgd6VVKxAVkqjeCHnY1
         3Khw==
X-Gm-Message-State: AOAM5319yY2hZUNUan4owQNsnNVSLLNu0aLb0UPnLnvI9N9Ju8NvGONQ
        xntbqhe3t0ILN54oZecZEcnLQwVJpi9B+A==
X-Google-Smtp-Source: ABdhPJwzutDJMOyulokg7Anec+AzeCPTWUF4p33pbtoEJ9Ufr+MI5lHPbZlZCE2UiR3SnMJBB1WMWA==
X-Received: by 2002:a17:906:fc0d:: with SMTP id ov13mr2406528ejb.504.1621480801935;
        Wed, 19 May 2021 20:20:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 00/29] Add trace file compression
Date:   Thu, 20 May 2021 06:19:30 +0300
Message-Id: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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

Todo list, in order to have complete trace file compression:
 - Add support for more compression libraries.
 - Add new trace-cmd command to convert trace files from version 6 to
   version 7 and vise versa.
 - Test all trace-cmd commands with trace file v7.
 - Update trace-cmd documentation.

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

Tzvetomir Stoyanov (VMware) (29):
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
  trace-cmd library: Reuse within the library the function that checks
    file state.
  trace-cmd library: New internal API to set file state of output
    handler
  trace-cmd library: Make tracecmd_copy_headers() to work with output
    handler
  trace-cmd: Do not use trace file compression with streams

 lib/trace-cmd/Makefile                        |  11 +
 .../include/private/trace-cmd-private.h       |  79 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  25 +-
 lib/trace-cmd/trace-compress-zlib.c           | 172 ++++
 lib/trace-cmd/trace-compress.c                | 787 ++++++++++++++++++
 lib/trace-cmd/trace-input.c                   | 711 +++++++++++-----
 lib/trace-cmd/trace-output.c                  | 738 ++++++++++------
 lib/trace-cmd/trace-util.c                    |  60 ++
 tracecmd/trace-cmd.c                          |  11 +-
 tracecmd/trace-dump.c                         | 162 +++-
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-listen.c                       |   3 +
 tracecmd/trace-read.c                         |   8 +
 tracecmd/trace-record.c                       |  42 +-
 tracecmd/trace-restore.c                      |   4 +-
 tracecmd/trace-stream.c                       |   2 +-
 tracecmd/trace-usage.c                        |   6 +
 17 files changed, 2342 insertions(+), 505 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.31.1

