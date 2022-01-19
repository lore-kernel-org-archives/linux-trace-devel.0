Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199BBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352434AbiASI1T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343541AbiASI1T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:19 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB543C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:18 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id j2so7537615edj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1QuYzLBbNxpushkp3Z1zSnXYNyVPe8+jT2pe9eFX2Vc=;
        b=SH+O06/+j/zI+J+jE+SsPOAdgHuluMYO45mh1WnUUD6khx6OTRTK4fEWZCrS2wUnCF
         nbPyoHi1HkmiNzsYl7xHAOoFUm8hRffqq7qubCxS2uU0SwMWxxRzlFpdOezEShzA9QqY
         L3WxHX4xl7JAPeS7FBuKPveE5Ms6IRmVAwvHxSTlfE3yh5wsZbnwBd0v/8O3O1rpkDvm
         Sb3SJlfrKQlcrd52E6PWPtK+At1Qt/HCu1kw9mc+PZxfzFuNF9vZv55pWFlUZneR9t5N
         5e4ekJtfTPy6azyi4kraAY7k7VUZfieXtzi9GVQNdCN1T8wqs/c6irbAK7IZvS2HCrd2
         rLlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1QuYzLBbNxpushkp3Z1zSnXYNyVPe8+jT2pe9eFX2Vc=;
        b=uyBTUIlOMPyto2qg1OVhtyiYkjFCEHreFOLVn9XBIQp7FnSV1uducb1Xqzzg8apdeI
         7hLKI9iG8BtiJnZ5RYWsFS+lnVndSTZcIF0S/LJuOdmf29EABNj8kNLCAuKHeBGBQGxk
         MTP9z3zaNHK1maOiSxQNvXkbnypthBMwiWCn8ktK/2l7hxpjFkaBhHQ6kSCaKzKnT5cx
         fJDenpZXkLg/YviMDBF6g8XdjA/eNJSoh1HwA6Ji7fepXsl7x8a8OZVwSpT9rKwNj+N7
         KjmVFukV85h12KgqywLx0RKylWsVr9eMh5EW3dB2H3BCliitgSjyKOsC0y9DscK0G8BR
         BJeg==
X-Gm-Message-State: AOAM533id/64tIFqqaCwxez9+5ur9h7fBTpFlkmcDvZ+DS5gRT+3MDRJ
        /nLNUc7wCJHZfpp6YEd74abEURGkkm0=
X-Google-Smtp-Source: ABdhPJy2zLnHw/fN9QzTJtkBRaCOSfIzq1frOxjxRLrJFnwqCJju1px9oEsdt9V8Yw4MGHlNLaqk7w==
X-Received: by 2002:a05:6402:1d93:: with SMTP id dk19mr14849475edb.253.1642580837565;
        Wed, 19 Jan 2022 00:27:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 00/20] Trace file version 7 - compression
Date:   Wed, 19 Jan 2022 10:26:55 +0200
Message-Id: <20220119082715.245846-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
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
 "[PATCH v8 00/25] Trace file version 7 - sections"
https://lore.kernel.org/linux-trace-devel/20220119082507.245600-1-tz.stoyanov@gmail.com/

v7 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.
v6 changes:
 - Rebased on top of the latest master.
 - Introduced new metadata strings section.
 - Use 8 bytes for section size.
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
 lib/trace-cmd/trace-compress.c                | 913 ++++++++++++++++++
 lib/trace-cmd/trace-input.c                   | 483 ++++++++-
 lib/trace-cmd/trace-output.c                  | 333 ++++++-
 lib/trace-cmd/trace-util.c                    |  10 +
 tracecmd/Makefile                             |   4 +
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-record.c                       |  34 +-
 tracecmd/trace-usage.c                        |   6 +
 14 files changed, 1921 insertions(+), 78 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.34.1

