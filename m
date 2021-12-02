Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE69C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhLBM2d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhLBM2c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:32 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDE5C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:10 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id e3so115370516edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ubj0S/00994a4tM8RQrO6W4xFAou7+gN59bm2xZZHIk=;
        b=GAPzi2lJGJkYYvJw9MCFbPKOCf8wNccGRA9eg6M+TaXtQ6/HGSYxX3u6LfTXuP4pde
         uBuHk/fnFdG+n9Jt+01QhgTD6NM/wRCLpd8UTmBHrhoKKm0ct3zrq4OTLVM5PUCX2A2R
         6h3UQgw0okaOT1EWMB6fxhtwdiR7hLQ75ZgcDr3dnRHVfQu6sOVYY7CFh2I/ujrAVqwC
         RgCtXngMhBhOP3dyQf0ClAX65CLJSZMqNW8oqUfBYwdUf7srl3P/kVzN3TkQYsjkIY9M
         m9EtymoAylS3bvOLewpZTIezFh2Y0w+uCsZIdMEvRS5H4p485D1oDEFhkxEo2ZVkXxla
         P9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ubj0S/00994a4tM8RQrO6W4xFAou7+gN59bm2xZZHIk=;
        b=tndJ2xmogkq/Xg4rX3WkMC3NSB4VlUcVBmGlDaVh1TQ95gKwzBW51O5sUNoUCznqkK
         sURZV2iWWtH3oqCxp03CbJ97bhzBU+vpxRd++Ij20azRhuCG2rW/u3y0QlCYwqBs4T81
         rzBgv3Z+aPogTgs/jMN5/3Ww9d7Rw4Kp+skgZRwo7Ha5uE0QXS2fJS/m47KzJ/noXuNs
         Xki9ljC2WbPZrTrZia3fdDJqmerSKblDSqlm7xXpM/1IBVkxJ+7uIEKGQcm9Z7vAqtvI
         XoDYHOLDMXYBp/zMeY/M53GCH6x1ZotNoi0kMCv48vgSFwK00C4MV2ZoDOeUUrorRorH
         /sGQ==
X-Gm-Message-State: AOAM531oAWbMRRMPBEWBElEx/CJEDBFcwyYky9BQkXlFINjHFBnotFO/
        Wprl94umkajFLgltNjDIxpCJDL93qFbfbA==
X-Google-Smtp-Source: ABdhPJwcyY2ICa6gvfpuOEfzL2oMz+nHLsW65PJDRCast+YxmAhuLmmgBoyB8IEdMS/2aX9qF+KfLg==
X-Received: by 2002:a05:6402:22a5:: with SMTP id cx5mr16846304edb.334.1638447908712;
        Thu, 02 Dec 2021 04:25:08 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 00/20] Trace file version 7 - compression
Date:   Thu,  2 Dec 2021 14:24:47 +0200
Message-Id: <20211202122507.43572-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduced compression of the metadata and trace data in trace files version
7. The compression is optional and disabled by default. A new parameter of
"trace-cmd record" is introduced, which can be used to configure the trace
file compression:
 --compression < none / any / name of the desired algorithm >

This patch-set depends on:
 "[PATCH v6 00/23] Trace file version 7 - sections" patch set.
  https://lore.kernel.org/linux-trace-devel/20211202122152.43275-1-tz.stoyanov@gmail.com/

v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (20):
  trace-cmd library: Add support for compression algorithms
  trace-cmd library: Internal helpers for compressing data
  trace-cmd library: Internal helpers for uncompressing data
  trace-cmd library: Inherit compression algorithm from input file
  trace-cmd library: New API to configure compression on an output
    handler
  trace-cmd library: Write compression header in the trace file
  trace-cmd library: Compress part of the trace file
  trace-cmd library: Add local helper function for data compression
  trace-cmd library: Compress the trace data
  trace-cmd library: Decompress the options section, if it is compressed
  trace-cmd library: Read compression header
  trace-cmd library: Extend the input handler with trace data
    decompression context
  trace-cmd library: Initialize CPU data decompression logic
  trace-cmd library: Add logic for in-memory decompression
  trace-cmd library: Read compressed latency data
  trace-cmd library: Decompress file sections on reading
  trace-cmd library: Add zlib compression algorithm
  trace-cmd list: Show supported compression algorithms
  trace-cmd record: Add compression to the trace context
  trace-cmd report: Add new parameter for trace file compression

 Documentation/trace-cmd/trace-cmd-list.1.txt  |   3 +
 Makefile                                      |   7 +
 lib/trace-cmd/Makefile                        |   8 +
 .../include/private/trace-cmd-private.h       |  46 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  17 +
 lib/trace-cmd/trace-compress-zlib.c           | 109 +++
 lib/trace-cmd/trace-compress.c                | 910 ++++++++++++++++++
 lib/trace-cmd/trace-input.c                   | 469 ++++++++-
 lib/trace-cmd/trace-output.c                  | 317 +++++-
 lib/trace-cmd/trace-util.c                    |  10 +
 tracecmd/Makefile                             |   4 +
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-record.c                       |  34 +-
 tracecmd/trace-usage.c                        |   6 +
 14 files changed, 1893 insertions(+), 73 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.33.1

