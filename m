Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92188C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7813460C51
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhINNSG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbhINNSF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:05 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C54DC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:48 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q26so20150983wrc.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XTdcjARGtvtpVMNNFPDDdeR9kfnbFTmygENj/PM3CFg=;
        b=jF/ZNAlFvxZqxiZeMK5rSWr7DEIsfJtomCxUV9PFezcN894IbVYdxKsBUD/ncynFno
         Nvp7Y43mg2gVChgyS3IHJvOMWQjj1TeqNeH4I5NY18eIOwpovYzzIWqmjaFV+KUuXjnH
         80e2oz8ycPSKbwpj5rZYW4MvAhK7F91tsZ26YlkOIrNXV5nKHFf7Mf8Tfj6sk3hqG+ww
         TWaBUqgS11nHoX+dkJgSiiYHzz1pm2Yh/ej/zzCsQWVsBKBjoT0oL+0M3BCG1Np0zAmy
         9f1wNYBQEpl3EbxILDSYk0AzYeOdMCNj3awcr/uQiQhk8Snn2UQrvD5+NDG/u3hhOePa
         fh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XTdcjARGtvtpVMNNFPDDdeR9kfnbFTmygENj/PM3CFg=;
        b=f8EwOwslA0jdHawKzKVhU2Zze+vp1p1xE5WgSpkwCnG1fx1KjBbYYOrtn1K9ZadNfU
         6qkJnpROaOk/8ICqR9a4UnFLlW13VJo5ckfC+FcvwHqD9sM+WE2ziXD4GLh+03ADLjWv
         zFUT9MohaIaJ9AW3RtQbF4I18H/CCfiZSkeAUULIUj37vN0wcjJylphxIbkuSl3l8IZ7
         ZJAoMXyAfTXCirLHwijQ0jiDjO2MHGEwm5TAJu+zNpcT+7W51Si3vci8yf33pNiMMb0Z
         ueUXVGMujkawGF1RkPOAhee4IJxJT8KpQpUUv0sx5TiC2Mv0yOLtEfhLZFpqngHgWvT6
         0rwg==
X-Gm-Message-State: AOAM531V4jQ757Rqj3+IaIiC9hKHNAPl61wmu6kdCK1S2IGx0aEWblui
        UBs+EWuHAfGJM8181b7Yl5PBOEl5+n0=
X-Google-Smtp-Source: ABdhPJy8nsfokuKXTSnLH+F2JYUv43RuiYI+OEKtO1EC0d8qcUunjFLC6dpGLm84jg6cVQm5MJmUuw==
X-Received: by 2002:a05:6000:1627:: with SMTP id v7mr19243042wrb.54.1631625407016;
        Tue, 14 Sep 2021 06:16:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 00/20] Trace file version 7 - compression
Date:   Tue, 14 Sep 2021 16:16:25 +0300
Message-Id: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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

This patch-set depends on "[PATCH v3 00/25] Trace file version 7 - sections",
should be applied on top of it:
  https://lore.kernel.org/linux-trace-devel/20210914131438.3965484-1-tz.stoyanov@gmail.com/T/#m0bbabef80646526afe855fbd7c5f1d7a717dd2da

v3 changes:
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
 lib/trace-cmd/trace-input.c                   | 465 ++++++++-
 lib/trace-cmd/trace-output.c                  | 315 +++++-
 lib/trace-cmd/trace-util.c                    |  10 +
 tracecmd/Makefile                             |   4 +
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-record.c                       |  34 +-
 tracecmd/trace-usage.c                        |   6 +
 14 files changed, 1888 insertions(+), 72 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.31.1

