Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BD4C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0EB613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhELGjg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhELGjf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2F2C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:27 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a25so1570822edr.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2talXa222It5GbLZq192eR50wpf+1vvPxTIhgxaJ2Y=;
        b=ofjfQGuD3Uvl7D8an3L8Jp5JjBRxxs5A5F/yZHCzOIsHo3LKhGvp4s1i+jRyPLCQwu
         eMom/DM754aHepDmjWjHHL0UQSX24AQhJYllfjvlx8AxVDfI5OuuDVfDYpd5+ZyY1rRm
         ed2q1vG2XR7jt1QrzWb05qOgmnKwfk/B1BCepmP+zclF1BR6E4n+MOOwP+RXt9nKxPBb
         XyHALjRes2lcHGOY4nRtUFYKKdf/qDMOxQEyZzlRInnMzmxFGy71CQjischqTbvs4Mro
         vOqlpUrggju9OjHbeYb90vMTjue0rHsNfhLU5HCgosYPOkAy4oYdTTj8Rv/3LLC6eVCJ
         epeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2talXa222It5GbLZq192eR50wpf+1vvPxTIhgxaJ2Y=;
        b=KjMKOENsRByAOTdgs/t71m7WPi4ZF4TCa3i3jZv7WZH6vR81K22X7MPuOOQKsJe3UP
         prMrIiL24MfK9F4eduywlIvnoDifduBoJJTPkFPQLz6Uvcxi/O0Cj3HUN6CXbxZykj3u
         ctXWRak/MVk0/STWQf0wqDZiBHvdcgHmTXUgFdhRoYV7Wjzc9ROjFfppUlxVKnPVYhbY
         sHBna9LkcTEQuYRYLN2iT+AaDvaM/fcUtOdjbZnfjSC63aptsAn/D9BpTc9luP8g9QEr
         WljZyWgTqAHXb7sw7J6lh2p7ZISmBjuAqyCb6biolZ3YP9Z2tBr+JjrWfHW3b9wyvrwe
         W7gg==
X-Gm-Message-State: AOAM532Ym1t7Ri9okG5Qt2XaLfsAWYZpn4o6EdtLHm+Okh6CXQW7ydFl
        NFpWg9EAW7HovwiR3IylKPSLqGfF79odQQ==
X-Google-Smtp-Source: ABdhPJyIOtwIt5wYpp4+2AZZ2F1TVYFvofOew3hz6+b1yTLLK0QVOOkYJ7a8DQNj1FhKx5IEbC4uGw==
X-Received: by 2002:aa7:c98b:: with SMTP id c11mr41381494edt.50.1620801505905;
        Tue, 11 May 2021 23:38:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PoC PATCH v3 00/25] Add trace file compression
Date:   Wed, 12 May 2021 09:37:58 +0300
Message-Id: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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

Todo list, in order to have complete trace file compression:
 - Add support for more compression libraries.
 - Add new trace-cmd command to convert trace files from version 6 to
   version 7 and vise versa.
 - Test all trace-cmd commands with trace file v7.
 - Update trace-cmd documentation.

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

Tzvetomir Stoyanov (VMware) (25):
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

 lib/trace-cmd/Makefile                        |  11 +
 .../include/private/trace-cmd-private.h       |  74 +-
 lib/trace-cmd/include/trace-cmd-local.h       |   9 +-
 lib/trace-cmd/trace-compress-zlib.c           | 172 ++++
 lib/trace-cmd/trace-compress.c                | 787 ++++++++++++++++++
 lib/trace-cmd/trace-input.c                   | 451 +++++++---
 lib/trace-cmd/trace-output.c                  | 676 ++++++++++-----
 lib/trace-cmd/trace-util.c                    |  19 +
 tracecmd/trace-cmd.c                          |  11 +-
 tracecmd/trace-dump.c                         | 162 +++-
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-listen.c                       |   3 +
 tracecmd/trace-read.c                         |   8 +
 tracecmd/trace-record.c                       |  42 +-
 tracecmd/trace-restore.c                      |   4 +-
 tracecmd/trace-usage.c                        |   6 +
 16 files changed, 2101 insertions(+), 360 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.31.1

