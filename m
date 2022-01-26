Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEA3C2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbiAZJv7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiAZJv7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:51:59 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4639BC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:51:59 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id d10so37734488eje.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jzmKkPlb1hJazJl9bfZvmQlEf1nZqRoI7PFKp+ByjzI=;
        b=TXTVXX9PWLUjubOLhKahZRw903c1+6xuRYyONl2SryzfvJGCiCVY304C9CBUHst051
         0hocrFdQmzc3/zzsLbEPPHv7+9lghuGL+Ft3ZSrJPaILTNEu+GfIxBAXyM0oEBTL/D9n
         /tMBHQqZdveA6dKvNvL1XU+y0yFpYTBetAJ217mYCJqtZuHsBq23cQ7qZsvkGHM5SCKD
         KqkHpgNRwdqFFM0hXMd1lQr4COx+MG/te5bDPxuzSAyL5pDavMyWK7NRQRYeOqdf9UI4
         FlTrz5Z0NxXVeoQ/YJubtikvamv7BL3CgB6/CrbLVGmAbPSq69U/3h6xuafmxbUshBR1
         T4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jzmKkPlb1hJazJl9bfZvmQlEf1nZqRoI7PFKp+ByjzI=;
        b=iA+v2KHXwpAsKsWPfhrSd/0MAtpT8vYTxjK5fbCgz7GfgXHQIHtfIafg9ZrlMuZxTG
         sRg5/9I1/eSRpVA4wD6e06ArmDjmJbktPS3ggZ5KLvb+H7YuZXtx5rH28nuL7rOP2Ndm
         bOR1YvH7hTX8q+UV477LE9Pwm9UhAKbvZCuOXvOTZpj3oY5BqEOTR5u4YIT7U74l0nCL
         8Ruaez54rJheDpw4zLnak5I0Xx3ourKopiak0LBXbcRIZSr/eBvxsRIe05p2/3EseBtv
         pPNCQa4TrQXJwIwHO3MADJuLHMgP6kCugfSmkeireSruSS44XEn80dk8yOj0tz6fDcx4
         BF9A==
X-Gm-Message-State: AOAM533ZZKAvAoXXNbd+4pdYHMXCIjJkwStRdyM3yLwZMqCw3Njlkl5Q
        vRX0y6epPvJirrefOzcUveycJFwy9fQ=
X-Google-Smtp-Source: ABdhPJyXoCuNHoUgc1OZ4VlqBEE7IbaxF71dEsNrT6qDQ4Z6qMSNcMkBqMpM05qlSp2eS8VDu3jSjQ==
X-Received: by 2002:a17:907:9494:: with SMTP id dm20mr18944476ejc.120.1643190717814;
        Wed, 26 Jan 2022 01:51:57 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id v15sm9529823edq.35.2022.01.26.01.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:51:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 0/9] *trace-cmd convert
Date:   Wed, 26 Jan 2022 11:51:45 +0200
Message-Id: <20220126095154.570700-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new trace-cmd subcommand is introduced:
 trace-cmd convert -i <input file> -o <output file>
The command converts trace file between different versions. There are two
parameters for controlling the type of the output file:
 --file-version < 6 / 7>
 --compression < none / any / name of the desired compression algorithm >

This patch-set depends on:
 "[PATCH v8 00/20] Trace file version 7 - compression"
 https://lore.kernel.org/linux-trace-devel/20220126094906.570451-1-tz.stoyanov@gmail.com/
 
v8 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.
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

Tzvetomir Stoyanov (VMware) (9):
  trace-cmd library: Use output handler when copying data from input
    file
  trace-cmd library: Handle version 7 files when copying headers between
    files
  trace-cmd library: Copy CPU count between trace files
  trace-cmd library: New API to copy buffer description between trace
    files
  trace-cmd library: New API to copy options between trace files
  trace-cmd library: New API to copy trace data between trace files
  trace-cmd library: Avoid memory leak when setting trace clock
  trace-cmd library: Extend tracecmd_copy() API
  trace-cmd: Add new subcommand "convert"

 .../include/private/trace-cmd-private.h       |  15 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  13 +
 lib/trace-cmd/trace-input.c                   | 733 +++++++++++++++---
 lib/trace-cmd/trace-output.c                  | 131 +++-
 lib/trace-cmd/trace-util.c                    |   9 +-
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.c                          |   1 +
 tracecmd/trace-convert.c                      | 109 +++
 tracecmd/trace-restore.c                      |   2 +-
 tracecmd/trace-split.c                        |   2 +-
 tracecmd/trace-usage.c                        |  13 +
 12 files changed, 929 insertions(+), 102 deletions(-)
 create mode 100644 tracecmd/trace-convert.c

-- 
2.34.1

