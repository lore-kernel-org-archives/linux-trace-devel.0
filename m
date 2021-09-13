Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AAEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7B8560FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbhIMMnW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbhIMMnW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F389C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:06 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q26so14475127wrc.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XwvHQ15w4ZrtW0kbb2j9OcEtIHyPpR40LVjqCogHcuo=;
        b=W+DPL3cV31O6MO5CANevQ6LvCkArZr6AFg7HP8am3lQQr9g0LGjCqmjF3nqkkkgNYa
         t7Qxd2hQOUtwpJbmNCT5eaIdi5zKteJ75inifzL+1jLecHyuIXk1j8thJrl88Znm3Asl
         Ez5hOWZ9+pdL+/2YMwXtOvHxRvwD+Ym69yKJWGXe4Yr21SOMAcLvWo30rfuq5ij7d+0O
         hRiOvobpXa+XkF/4VKY1NmOvJzpnZgMjxKJqrJuxvkVccO8u+8jmF1RuiNlRrKlgO5rJ
         7HTbeABGrXNkzUsrOMNGYF2BSuDglwHpF9i7w7YCd4Jgykew3znr5z7H50On23A319rk
         r/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XwvHQ15w4ZrtW0kbb2j9OcEtIHyPpR40LVjqCogHcuo=;
        b=0/zp0e1u+7YWfJOJDs3GSrRcPEh94iKZgVR4vd5Tt7PjvXfAy+YgRZNt1YHXtWqtQZ
         YOPpAbb4tS9C3Fd3YRyVcrsGDN+/Jge/Loi0O0DPAym86ZwVA0n30vg+ytxjswEwPIYg
         C16RaqBMhhEIm8wFe4AsxiUCKexBBWDReUj64/StHJtoPaK7+xr6/9om+h3bXiyD5woA
         31YjYggyFVKjXaCo2DmB+U+6N215BNhR2pVw731k7YQsHD6FLezf1JfhM5RhKsGvqWBT
         42qBWYxsGRyfvuUrd0GBC8ANxWDZ0pgidajKq6ATjqyX0wYylp0dquUra4vn91EXMGe/
         IaBw==
X-Gm-Message-State: AOAM531Zzs2Z/uXvyH8VzQLTMBKw4IQ7l+GqFpMAA0Vd8cVY5pg+z8zQ
        sMMazfc0+yZ8/3/aLApRFfA=
X-Google-Smtp-Source: ABdhPJzHdr9dyEHcz3/Q6OEh6pxqxToW/68jybDSHzrkfCFhqGBjPZ3RuyCO8wnAUyibBfJY1t1+kw==
X-Received: by 2002:adf:df0d:: with SMTP id y13mr12262520wrl.335.1631536924960;
        Mon, 13 Sep 2021 05:42:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/20] Trace file version 7 - compression
Date:   Mon, 13 Sep 2021 15:41:43 +0300
Message-Id: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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

This patch-set depends on "[PATCH v2 00/25] Trace file version 7 - sections",
should be applied on top of it:
  https://lore.kernel.org/linux-trace-devel/20210913122947.3673239-1-tz.stoyanov@gmail.com/

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
 lib/trace-cmd/trace-output.c                  | 314 +++++-
 lib/trace-cmd/trace-util.c                    |  10 +
 tracecmd/Makefile                             |   4 +
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-record.c                       |  34 +-
 tracecmd/trace-usage.c                        |   6 +
 14 files changed, 1887 insertions(+), 72 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.31.1

