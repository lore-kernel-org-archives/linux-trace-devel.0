Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CFAFC04FE3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66FBA6103E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhG1NdA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbhG1Nc5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:32:57 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B120C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:54 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id o5so4671180ejy.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mYZ+SHoS3LFHCiFoDz0zFwfcmx1fs2niURARPmJkCiU=;
        b=ax95AQPTny6UHbr3xd1Z8kI/U7oCyBA85zd2DGV1G83CyKAEkPFWIzsjQ9/07f6oAL
         qbbB96Y/J2MJdjNzySV/NH92FgLwpwowespBsNRgVX+xGNEuIQQaBPuNryeS8v9EOz5N
         ZRI/hVUt8s/8BRQIls3/VbzGLcs+Ks6bNLL1yVTIhuRfLxl3/B6LjzxwDHpQpqr5Fvxl
         BgvxzjKG3FipzSlXUy3Hgo0MpGstcUjo84EfdALBWv6Vylw49PqSMWxtqWZueqKbV4KQ
         WuWv8TTArQBpij6D5qpHNGkqLCB5ku7fo5dmsjvBtJCxpXK3j2BkKrSGZDjOv18kayON
         lVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mYZ+SHoS3LFHCiFoDz0zFwfcmx1fs2niURARPmJkCiU=;
        b=TdQThTraAuK2b6dk4KvdVYBHDCybedWANiC1iMvf2FKYH2T6VHBfjd4wkTJ90xVobA
         G+IDqVKOv/NmbIDpYwD6nMhUOm1+X6DnpG5RUjyxLa1tZ1g8r7DPsfr9VmY3FZYZr025
         OA/eAh8y1krc4o7sRBfKMGjOf1j0FOdSx824xhNjrBn1UCQ7S0aAu2d4sLWp339DDHx5
         Uj9sT3wZvcbLWyQE8+w/xVmnBjP6440lFrTE4iAMLT3IknY61DEnwH2YVHexFuvNWKTi
         I5p2SzBzealxqNCPFd8QHdsTzh/3QlyyIsEOtcDO58ctBxKUG560DGvtH0JWd4oooMv/
         r43w==
X-Gm-Message-State: AOAM530xlwpMO4azbJ5HRJfZ/vbkX9zFod2jVO7q8+UAOzX4VQOMdjz7
        H4WldmXEWlTGcgAtGkaitUem3mC1uiVf1Q==
X-Google-Smtp-Source: ABdhPJyw8nt8SmSfriJa9KgblLlbRabWZr+PTyTrlm9pU0YNCNzXL8TfGWI1SqRKAO7zjfrIxki1ZQ==
X-Received: by 2002:a17:907:9604:: with SMTP id gb4mr27180729ejc.142.1627479172305;
        Wed, 28 Jul 2021 06:32:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:32:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/87] Trace file version 7
Date:   Wed, 28 Jul 2021 16:31:23 +0300
Message-Id: <20210728133250.234140-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce the next version of the trace-cmd trace file - 7. Major changes
since version 6:
 - New, flexible and extendable structure of the file.
 - Optional compression of file metadata and tracing data.
 
By default, trace-cmd still uses the old version 6 when recording trace
file. There are new options to force using the new version.
A new "trace-cmd convert" sub-command is introduced, to convert files
between different versions.

Known issues:
 - "trace-cmd split" does not work with trace file version 7, if there are
   CPUs with empty trace data.
 - "trace-cmd agent" has problems with compressed files

Tzvetomir Stoyanov (VMware) (87):
  trace-cmd library: Read option id with correct endian
  trace-cmd report: Fix typos in error messages
  tarce-cmd library: Fix version string memory leak
  trace-cmd library: Fixed a memory leak on input handler close
  trace-cmd library: Fix possible memory corruption on processing a
    trace buffer
  trace-cmd library: Add constructor and destructor
  trace-cmd library: Add cache functionality to network message handler
  trace-cmd library: Add support for compression algorithms
  trace-cmd list: Show supported compression algorithms
  trace-cmd library: Internal helpers for compressing data
  trace-cmd library: Internal helpers for uncompressing data
  trace-cmd library: Define trace file version 7
  trace-cmd library: Refactor APIs for creating output handler
  trace-cmd library: Reuse within the library the function that checks
    file state.
  trace-cmd library: New API to get the version of output handler
  trace-cmd library: Inherit compression algorithm from input file
  trace-cmd library: New API to configure compression on an output
    handler
  trace-cmd record: Add compression to the trace context
  trace-cmd library: Write compression header in the trace file
  trace-cmd library: Compress part of the trace file
  trace-cmd library: Add internal helper functon for writing headers
    before file sections
  trace-cmd library: Write header before file sections
  trace-cmd library: Refactor the logic for writing trace data in the
    file
  trace-cmd library: Add local helper function for data compression
  trace-cmd library: Compress the trace data
  tarce-cmd library: Add multiple options sections in trace file version
    7
  trace-cmd library: Do not write CPU count section in trace files
    version 7
  trace-cmd library: Move CPU flyrecord trace metadata into the buffer
    option, for trace file version 7
  trace-cmd record: Append trace options after the trace data are
    written
  trace-cmd library: Add section header before flyrecord trace data
  trace-cmd library: Fit CPU latency trace data in the new trace file
    version 7 format
  trace-cmd library: Do not write CPUs with empty trace data
  trace-cmd library: Add macro to check file state on reading
  trace-cmd library: Introduce sections in trace file reading logic
  trace-cmd library: Initialize internal sections database on file read
  trace-cmd library: Use sections database when reading parts of the
    trace file
  trace-cmd library: Set log size to the input tep handler when it is
    read from the file
  trace-cmd library: Fix possible memory leak in read_ftrace_files()
  trace-cmd library: Fix possible memory leak in read_event_files()
  trace-cmd library: Fix possible memory leak in read_proc_kallsyms()
  trace-cmd library: Fix possible memory leak in read_ftrace_printk()
  trace-cmd library: Fix possible memory leak in
    read_and_parse_cmdlines()
  trace-cmd library: Track maximum CPUs count in input handler
  trace-cmd library: Set input handler default values in allocation
    function
  trace-cmd library: Read headers from trace file version 7
  tarce-cmd library: Do not use local variables when reading CPU stat
    option
  trace-cmd library: Read handle header and compression of the option
    section
  trace-cmd library: Read extended BUFFER option
  trace-cmd library: Handle the extended DONE option
  trace-cmd library: Read compression header
  trace-cmd library: Extend the input handler with trace data
    decompression context
  trace-cmd library: Initialize CPU data decompression logic
  trace-cmd library: Initialize CPU data for reading from version 7
    trace files
  trace-cmd library: Add logic for in-memory decompression
  trace-cmd library: Handle latency trace in version 7 files
  trace-cmd library: Handle buffer trace data init for version 7 files
  trace-cmd report: Use the new latency API to read data
  trace-cmd report: Close input file handlers on exit
  trace-cmd report: Do not print empty buffer name
  trace-cmd report: Init the top trace instance earlier
  trace-cmd: Call additional APIs when creating trace file
  trace-cmd dump: Add helpers for processing trace file version 7
  trace-cmd dump: Print compression header
  trace-cmd dump: Add helpers for processing trace file sections
  trace-cmd dump: Read recursively all options sections
  trace-cmd dump: Read extended BUFFER option
  trace-cmd dump: Dump sections
  trace-cmd dump: Dump trace file version 7
  trace-cmd dump: Dump sections content
  trace-cmd dump: Add new argument --sections
  trace-cmd dump: Align better the output of flyrecord dump
  trace-cmd library: Add zlib compression algorithm
  trace-cmd library: Reuse local function that writes to output handler
  trace-cmd library: Use output handler when copying data from input
    file
  trace-cmd library: Handle version 7 files when copying headers between
    files
  tarce-cmd library: Copy CPU count between trace files
  tarce-cmd library: New API to copy buffer description between trace
    files
  tarce-cmd library: New API to copy options between trace files
  tarce-cmd library: New API to copy trace data between trace files
  trace-cmd library: Extend tracecmd_copy() API
  trace-cmd library: Set correct CPU to the record, retrieved with
    tracecmd_peek_data
  trace-cmd: Add new subcommand "convert"
  trace-cmd report: Add new parameters for version 7 trace files
  trace-cmd: Update bash completion
  tarce-cmd: Man page for "trace-cmd convert"
  tarce-cmd: Update record man page
  trace-cmd: Document trace file version 7

 .../trace-cmd/trace-cmd-convert.1.txt         |   65 +
 Documentation/trace-cmd/trace-cmd-list.1.txt  |    3 +
 .../trace-cmd/trace-cmd-record.1.txt          |   13 +
 Documentation/trace-cmd/trace-cmd.1.txt       |    4 +-
 ...e-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} |   15 +-
 .../trace-cmd/trace-cmd.dat.v7.5.txt          |  442 ++++
 Makefile                                      |    7 +
 include/trace-cmd/trace-cmd.h                 |    5 +
 lib/trace-cmd/Makefile                        |    8 +
 .../include/private/trace-cmd-private.h       |  115 +-
 lib/trace-cmd/include/trace-cmd-local.h       |   63 +-
 lib/trace-cmd/trace-compress-zlib.c           |  109 +
 lib/trace-cmd/trace-compress.c                |  910 +++++++
 lib/trace-cmd/trace-input.c                   | 2130 ++++++++++++++---
 lib/trace-cmd/trace-msg.c                     |  131 +-
 lib/trace-cmd/trace-output.c                  | 1681 ++++++++++---
 lib/trace-cmd/trace-util.c                    |   45 +-
 tracecmd/Makefile                             |    5 +
 tracecmd/include/trace-local.h                |    2 +
 tracecmd/trace-cmd.bash                       |   37 +
 tracecmd/trace-cmd.c                          |    1 +
 tracecmd/trace-convert.c                      |  106 +
 tracecmd/trace-dump.c                         |  459 +++-
 tracecmd/trace-list.c                         |   26 +
 tracecmd/trace-listen.c                       |    8 +-
 tracecmd/trace-read.c                         |   40 +-
 tracecmd/trace-record.c                       |  141 +-
 tracecmd/trace-restore.c                      |   37 +-
 tracecmd/trace-split.c                        |    5 +-
 tracecmd/trace-usage.c                        |   21 +-
 30 files changed, 5723 insertions(+), 911 deletions(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-convert.1.txt
 rename Documentation/trace-cmd/{trace-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} (96%)
 create mode 100644 Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c
 create mode 100644 tracecmd/trace-convert.c

-- 
2.31.1

