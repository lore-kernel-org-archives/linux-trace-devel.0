Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59365C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33C8D61155
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhEJGRq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhEJGRq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:46 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2FC061573
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:40 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id di13so17324647edb.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WYIVZqe/cvkiDoJ3NjHVJodsJtx7qAeBnf/jB9XlzQk=;
        b=MWOClVKWh2wSeAYeLLMA34tCC0stAArsRgXrQ5qjxB23PnF6yA60GyO0YppMPhAxHv
         oUVSvufSKbxGGADhMXiP0rLlz1MGQns37R7TnDh7UKVlg/GdT0rxI4GKw/xQJ+/6eIPP
         XOQg/3UHT0T6O/grk0BweDgYEjvBVVegNqqoRIHfd4dOqkn5yym18S/xEUBjERvvrMuq
         ASAGWF5e2rTNMR3BHQhYXWXmnoMVgzXAVPv48aPxnd5Ux9MKdc3t7zZ2cU9oCNcQ+okZ
         rU4P/KA350qv1R0JNLNPA9GcbuftG4fUomZjQITR4r5AEIpLdboEJVQsGFwoyyXMEjxn
         1GQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WYIVZqe/cvkiDoJ3NjHVJodsJtx7qAeBnf/jB9XlzQk=;
        b=qIu6vBiUdD/9bOlg6UmWDpX2Ot6q/p4eC6+My2rQFaIVMAdFdug1vqiifmL51eDK3c
         l9tZuQThuZf+Koj8JGuEDJJLNeb24QkqnZ2OSQ31GuPVSbjvMyrDHxMSLLAdsXA/B2Kd
         oYaIYaHNd8ToDf9ZrEfupCFNzWWLeNBZywD9sLnv4GWnmC/n+IWOGe5MFf6SsjvFYwh7
         tVgePHr6PBNe8Yhu1bTF09lOt2UjzUmA9u1f+07JY/vfeQi1vkdmWUhxdLQoJiX7B3pb
         BzCzF2kGQrSFS848KWBHo0w50i/iLsiybotlUS8Bt/NGuuQylRQN5ef+dVqZSoUNI0Z0
         IMoA==
X-Gm-Message-State: AOAM532VWy8fUy/mpwDRGYfjJXAC/Jp6fc+c/3XNwGMX4L3QNfGhTnxa
        AmMg1Gzm/lbNq4KI7Tw/FH7PestOtjww8w==
X-Google-Smtp-Source: ABdhPJzL+P2NT1WeYnuAQGCxdbRStZe4ARGGVLM4kbWqwrmM1kKxCcRso3Qr6FPa4QNBsaTM+9qEKg==
X-Received: by 2002:aa7:d699:: with SMTP id d25mr27016883edr.107.1620627398211;
        Sun, 09 May 2021 23:16:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PoC PATCH v2 00/21] Add trace file compression
Date:   Mon, 10 May 2021 09:16:15 +0300
Message-Id: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new PoC implementation, adding a compression to trace file.
A basic infrastructure for compression support is added into the trace-cmd
library. The zlib is used for compression, but more libraries and algorithms
can be added. Only part of the trace file metadata is compressed: 
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
 - Compress trace data.
 - Add support for more compression libraries.
 - Add new trace-cmd command to convert trace files from version 6 to
   version 7 and vise versa.
 - Test all trace-cmd commands with trace file v7.
 - Update trace-cmd documentation.

v2 changes:
 - Refactored compression APIs.
 - Moved the trace buffers description out of the trace options section.
 - Added compression of "options" section of the trace file.
 - Updated "trace-cmd list" to show available compression algorithms.
 - Tested with host-guest tracing.
 - Merged with the patchset that bumps the trace file version.

Tzvetomir Stoyanov (VMware) (21):
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

 lib/trace-cmd/Makefile                        |  11 +
 .../include/private/trace-cmd-private.h       |  71 ++-
 lib/trace-cmd/include/trace-cmd-local.h       |   9 +-
 lib/trace-cmd/trace-compress-zlib.c           | 172 ++++++
 lib/trace-cmd/trace-compress.c                | 543 ++++++++++++++++++
 lib/trace-cmd/trace-input.c                   | 375 +++++++++---
 lib/trace-cmd/trace-output.c                  | 541 ++++++++++++-----
 lib/trace-cmd/trace-util.c                    |  19 +
 tracecmd/trace-cmd.c                          |  11 +-
 tracecmd/trace-dump.c                         | 162 +++++-
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-listen.c                       |   3 +
 tracecmd/trace-record.c                       |  42 +-
 tracecmd/trace-restore.c                      |   4 +-
 tracecmd/trace-usage.c                        |   6 +
 15 files changed, 1703 insertions(+), 292 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.31.1

