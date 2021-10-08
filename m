Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14728C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D808360F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhJHEYN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEYN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:13 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3AAC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:18 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id d9so7378382edh.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oSi9FUXFmjXQAeR6ELA6v/dafjx0JCy78lZFVsuu2Js=;
        b=DCFiDGgDBITtAu7zAVuNwVP1lNJ3sidwS1iTg19pk3cOgiGxXAvNoz7L8w2ECSOO77
         Rgtrkou5Vrqr9HdEbzwXEGPQSgVfWvrci/m2NlDjWnIWxHnGG+eSf6kIcY9PP4J/LziB
         XfWSPtr980Ec/S4HK0rLUJybIxKlDX+xCccKy9AMOuoVE1trEVStNaUcqhGilwS9dMAw
         D6j23WXmbYe/6VPqPSVlk02VRWOF2n+ht2VtbMYUe/YRtCS1cd3j1NWyNqlysk2oiZS+
         iqA9kXrdC87+I8+JxI1Ckm1Z63RXQq1TRZbTAGwHDyJe8ounTmLuxLeNGtTiepEVUNYk
         sAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oSi9FUXFmjXQAeR6ELA6v/dafjx0JCy78lZFVsuu2Js=;
        b=lZkCxYTDzYtDSDZcHEGb0UFmwTHHFXNoYeWObcTFWEsIQWPGejDnYrmDgjnM3XBZuc
         LyUzs+g6I9toN9huBnMAhhJrf5BVTe5ShRHcG18Jb4UiuOLq49LvowoDl1SyW0IuEwPQ
         fhgJtjl3P0cCAzMk6We18R9tONwjIrG0kffeO7wTvhUTXoMADkEjN6nJ34jB29LP7FMc
         a2A4CC9/Dem6Vf5eRHi6sU09yjWfwWlFHhyid2Wx2ChukhEC8rZfhmZR8DKPXXTmLzdl
         ApG1hBH3ZmQt7BTq8G6IaT2uK3YG2pjOLGPtW7PscUiGrrA5VYdCyTa/yBJZc730GArH
         GpLA==
X-Gm-Message-State: AOAM530AqUR1Rb+bmvAKjeBS3Pj4aFsXBoDFlWxBd/Bq2vkX+Gjsuv9d
        4+xaJBYxJT0UxWUTG+1A5oxER5dChL8ZEw==
X-Google-Smtp-Source: ABdhPJyN7pLPXP6/R90gbdbJ7W3EJOTBQVNLztOYultEqPWZhMIYuVrduEVtQcdM4MWRah48IUcoyg==
X-Received: by 2002:a05:6402:35c5:: with SMTP id z5mr11849509edc.388.1633666936829;
        Thu, 07 Oct 2021 21:22:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 00/20] Trace file version 7 - compression
Date:   Fri,  8 Oct 2021 07:21:54 +0300
Message-Id: <20211008042214.977193-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
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

This patch-set depends on "[PATCH v4 00/25] Trace file version 7 - sections",
should be applied on top of it:
  https://lore.kernel.org/linux-trace-devel/20211008041958.976309-1-tz.stoyanov@gmail.com/

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
 lib/trace-cmd/trace-output.c                  | 316 +++++-
 lib/trace-cmd/trace-util.c                    |  10 +
 tracecmd/Makefile                             |   4 +
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-record.c                       |  34 +-
 tracecmd/trace-usage.c                        |   6 +
 14 files changed, 1892 insertions(+), 73 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.31.1

