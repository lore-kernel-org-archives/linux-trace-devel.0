Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12E9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 04:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B52C261039
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 04:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhJKE2k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 00:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhJKE2j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 00:28:39 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A546C061570
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Oct 2021 21:26:40 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id a25so46634457edx.8
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Oct 2021 21:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ihY+SsJffCdgbv1t206oDDxl4mOAKyLODZx24XbhuWI=;
        b=YipGnRzSIpI/QxXm01hqBlzR9P/YGZsICTmWeW0YrmFxlenVk0lKJjY8ePoeXF4BmB
         7zVV69LCttzD2JeJW3vGbZ/nwhBdi4F6daRBDOTiJikat/Aoy/mck9UJgmmI3MHXsuu2
         Up+3fMmFE+ploiG5GE4otc4I1HyEiiEWDD31XPu/iaBvg7RQRuFTMH0DlFO1jzMiixWJ
         OMxrPtCm/aoaqws5ViyNA4cwJOG0dcLHxkJz4dSCdQsOQw9mvzUmK6Hq2Of4ZMcKfbjA
         r7P9xdQ7tH7wujK3pYms0zUoDClUuE3cdvLEox+7q/o5sWXTaro3LgRpC3qhaoRT96ds
         eOqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ihY+SsJffCdgbv1t206oDDxl4mOAKyLODZx24XbhuWI=;
        b=U9P32SLHfC6RLQ4qQzmNMXoYjVZDUMeD28Af3q2NDvEIqfsHONOarrewaAJX0Vfj1T
         mXJi7j4I9qBezIPPbnUvcwogWVuwA9t+Yx7ZG6sr+zru05gKEVGZuEhUzVVCGMG20rKL
         Y6s5NmO8b/pYOgr5OwSXklNK98PNn7FzFp6PBTcm5zwjIT7UN5vXkTRuM7PQNCL2UkJr
         xP+qCbj1OrQOgX3CCNR1XA5P65FZfkkYVFHBd7DWjEDBdeYp2qlNuG07o/OPacvKE+BR
         gITLh7IF0pDGKtDFM4j2br5CnBH+pvs+dYNRiDgmXWWvF1+YN7QcrZGnT0dalYiZeYTe
         Z37w==
X-Gm-Message-State: AOAM532T83kHHCV7ggM9cN0DCo3M7lGEu/dQQ7cwubydURoCh2J1zEmv
        b7CN8W0e9+ZT4naxBIF2fM7d1jg3kQXERg==
X-Google-Smtp-Source: ABdhPJzyjK9BeKdTJQhCW3O3h6EylTBjA0vl/YFWIlRsX8dDdHPHrxly3RhqNeQ29GcESoAA4nsePw==
X-Received: by 2002:a05:6402:21ef:: with SMTP id ce15mr37217856edb.19.1633926398622;
        Sun, 10 Oct 2021 21:26:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j21sm3406532edr.64.2021.10.10.21.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 21:26:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/4] Refactor the logic for writing trace data in the file
Date:   Mon, 11 Oct 2021 07:26:32 +0300
Message-Id: <20211011042636.1608374-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a trace buffer data are written in the trace file, the buffer
option in the file metadata is updated with the file offset of the
tracing data. Hide this logic into the trace-cmd library.
Added new APIs:
 tracecmd_add_buffer_info()
 tracecmd_write_buffer_info()
Changed APIs:
 tracecmd_append_buffer_cpu_data()
Removed APIs:
 tracecmd_add_buffer_option()

Refactored the internal logic of tracecmd_write_cpu_data() API to be
suitable for upcoming trace file format changes and data compression.
The size and the offset of the trace data is saved in the file right
after the data is written. The old logic calculates the size and offset
in advance, but when the trace data is compressed it is hard to use
that approach.

This patch-set depends on "[PATCH 00/10] Refactor APIs for creating output handler",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20211008041321.973755-1-tz.stoyanov@gmail.com/

v2 changes:
 - Fixed wrong calculations of trace page alignment.

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd library: Add internal database for trace buffers
  trace-cmd: Use the new trace buffers API
  trace-cmd library: Helper logic to update the trace buffer offset
  trace-cmd library: Refactor the logic for writing trace data in the
    file

 .../include/private/trace-cmd-private.h       |  10 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  19 ++
 lib/trace-cmd/trace-output.c                  | 319 ++++++++++++------
 tracecmd/trace-listen.c                       |   2 +-
 tracecmd/trace-record.c                       |  18 +-
 5 files changed, 250 insertions(+), 118 deletions(-)

-- 
2.31.1

