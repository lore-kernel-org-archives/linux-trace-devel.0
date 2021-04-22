Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2956C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB6F161462
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhDVHjl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbhDVHjk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:40 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEA2C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:05 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id j12so27211723edy.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SZdwDEFg8DCWdjAQnX/xaEBH0x74xHmJZaIBal9kCuE=;
        b=HLPMxIndM2YRa/kUh2XSi/57dbhaX1KqNam4LqHIupoyrCYIjF2tyyPOUH8WbwCO3H
         hO1FPuAJPpC9xt72w3lRSIhu5EVMKRegQi3YzEYtNXDyMHettEK2DFUVfiKyCVgjZ89O
         yzbUjNMuwmUwbKkD6sMSH1Chd7WBwVGI9lXbK+upgSBzPoyuzVg8BCnTsAANeg8YXHka
         DCr2dOvj8GXsW/nZ7m06Av+Ol/OOrKotMuVrCWvdOS47hjNlw9nrmnNEzF6jLgUAY1IH
         VMEEJrgcPGj80tTvFo+qPr+e5vytWSHv7rf+gipQ7jwjQiS8OASbquqtpOZ+WEzHsgqr
         l01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SZdwDEFg8DCWdjAQnX/xaEBH0x74xHmJZaIBal9kCuE=;
        b=VqY1O5Wz0hoGMwJ69u3AU8mT2TRqKwoW9JkzO73syrzBk8MEMc95vduRwQAlSJFDXi
         NevgAdaBuu/Xr/38xEH8gKMT25Y3XPSY+H6Jydx77E5mBwuiRT5QcOmIQjnSNQ/ckaBR
         ywucxGGz3fr/xvbpPsZR6RENUUOJubND/UKPy9F3OOqUszFTQ5I5SKHK+T1ceU+AqUNu
         g+pP66gmcGtRBGSlsRRLn61hi5fre+ZTlSmnRYoBSODrLhzUdiHpYm6K8X7YkMeVETJd
         Xo0H5g5XqxfbFDBUuVlO0tr5SgGvnV98vYyXfEOEnyhPAHckcv7fJ7Ky2/Y/AbFIASbv
         okAw==
X-Gm-Message-State: AOAM533mKhZJMUrHd7NCdeR9kn6UV9y6DdCD6ReroJ2XU7Jb+TLr05MP
        NihQAf7zBV5KYZYLsjGyF3gO3JSBRbiprQ==
X-Google-Smtp-Source: ABdhPJxRk2PFRNeICk53+0sZyR6gf8ktGF76e+2cEYl5k7bM+H5Fus8FX7Mzswpaivq0G6P27uMcKg==
X-Received: by 2002:a05:6402:1056:: with SMTP id e22mr2078395edu.279.1619077144101;
        Thu, 22 Apr 2021 00:39:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [POC PATCH 00/10] Add trace file compression
Date:   Thu, 22 Apr 2021 10:38:52 +0300
Message-Id: <20210422073902.484953-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new PoC implementation for adding a compression to trace file version 7.
A basic infrastructure for compression support is added into the trace-cmd
library. The zlib is used for compression, but more libraries and algorithms
can be added. Only part of the trace file metadata is compressed: 
 - ftrace events format
 - format of recorded events
 - information about the mapping of function addresses to the function names
 - trace_printk() format strings
 - information of the mapping a PID to a process name

Note: not all trace-cmd commands are tested with these changes. These are
verified to work with compressed trace files:
 trace-cmd record
 trace-cmd report
 trace-cmd dump

Todo list, in order to have complete trace file compression:
 - Compress trace file options.
 - Compress trace data.
 - Add support for more compression libraries.
 - Add new trace-cmd command to convert trace files from version 6 to
   version 7 and vise versa.
 - Add compression support to all trace-cmd commands.
 - Update trace-cmd documentation.

This patch set depends on "[PATCH 0/6] Bump trace file version"
and should be applied on top of it.
https://lore.kernel.org/linux-trace-devel/20210422071718.483383-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (10):
  trace-cmd: Add APIs for library initialization and free
  trace-cmd library: Add support for compression algorithms
  trace-cmd library: Compress part of the trace file
  trace-cmd library: Read compressed trace file
  trace-cmd library: Add new API to get compression of input handler
  trace-cmd library: Inherit compression algorithm from input file
  trace-cmd library: Extend the create file APIs to support different
    compression
  trace-cmd record: Add new parameter --compression
  trace-cmd dump: Add support for trace files version 7
  trace-cmd library: Add support for zlib compression library

 lib/trace-cmd/Makefile                        |  11 +
 .../include/private/trace-cmd-private.h       |  42 ++-
 lib/trace-cmd/include/trace-cmd-local.h       |   7 +
 lib/trace-cmd/trace-compress-zlib.c           | 172 ++++++++++
 lib/trace-cmd/trace-compress.c                | 289 +++++++++++++++++
 lib/trace-cmd/trace-input.c                   | 304 +++++++++++++-----
 lib/trace-cmd/trace-output.c                  | 268 ++++++++++++---
 lib/trace-cmd/trace-util.c                    |  12 +
 tracecmd/trace-cmd.c                          |  11 +-
 tracecmd/trace-dump.c                         | 164 ++++++++--
 tracecmd/trace-record.c                       |  18 +-
 tracecmd/trace-restore.c                      |   4 +-
 tracecmd/trace-usage.c                        |   1 +
 13 files changed, 1152 insertions(+), 151 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.30.2

