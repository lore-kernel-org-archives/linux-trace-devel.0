Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73752C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245077AbiASI2t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiASI2s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:28:48 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2377BC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:48 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id c71so7627139edf.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o5pi+k2oygauowVrHUpYDXLeoFKs0WCbwJ28StxNJjk=;
        b=LisbkHLZ+VHBngtmXHhfjk4vBohn4G+U7uHkTcPn1Lkxno6Vl1/3SkE2Dh9jdMOhFr
         DRIySzNfX2EJoW81z6CaS0HwsLdx4+EWBRHWqIJrYirxHj1V11CGks7r4N2f9cPvAaDL
         Z2kT3j5qQVG/Sx1xqR1MY+Vlh8SDIupUMxilVNBvFXd+y1ws/ETCSMeDGDQRY1qyIeYk
         TvCNmKixfe6k+X0trzG0GKKQY8JYUIaUYjSs6IWgKw15GVr5ZdIQvBMbOj9HmYhRvNy2
         o7Ke3SAVTqwHokJcstZqRwGV93GPRrzqdIF9H3jgYK3AfCeFGfI/bS/MfgT/srUmpq4K
         IZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o5pi+k2oygauowVrHUpYDXLeoFKs0WCbwJ28StxNJjk=;
        b=ivG297VT+//JeZBK8RBEykYW13AagFYBAJLnOhKLw2rC1yNvDNJjayL/OWIfnLlXTu
         VT7Ze2k/wgHlRVMT9DvRHWRbQBjWUlxiKMw3dR6/XPkz1RuDavTGZYKbCwRi3ONcOYF4
         yjO1dV5dCF9oPGf99vvfkBVl5FS7eugTYdBKv97EBFUpIxsjYjlAVqb4KCsj2oBGLD8D
         SB0oxw4G7qts1ji9fMftHNhxSSQyzbRVUtotu5Pa4T/hoPDtNC7O2lqgxBNJ1xzP5x1h
         FbDQjB06O4WOfsYAsbTj+aicBFwdLP4FpH5xuAJlNLpRA8u4xVLxhDx/28TCrgl/KiWi
         Cptg==
X-Gm-Message-State: AOAM530eRhRFfpdRy5bQha7oZwoKg3gmfJ6t1O1mjx70vv+nBhgH9KIe
        7ROHjo9613PNtMQKE9/R6HnpBMxRb+I=
X-Google-Smtp-Source: ABdhPJwD02StzKt9It89X9ezqyyX/UoLvaI5KuoV5e/4mdFqLaLX6TTAf7BuEfKAx62nLiui/Oa8pA==
X-Received: by 2002:a17:907:86ab:: with SMTP id qa43mr24032264ejc.119.1642580926767;
        Wed, 19 Jan 2022 00:28:46 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t14sm860838edq.24.2022.01.19.00.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:28:46 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 0/9] trace-cmd convert
Date:   Wed, 19 Jan 2022 10:28:36 +0200
Message-Id: <20220119082845.245993-1-tz.stoyanov@gmail.com>
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
 "[PATCH v7 00/20] Trace file version 7 - compression"
 https://lore.kernel.org/linux-trace-devel/20220119082715.245846-1-tz.stoyanov@gmail.com/
 
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
 lib/trace-cmd/trace-input.c                   | 698 +++++++++++++++---
 lib/trace-cmd/trace-output.c                  | 125 +++-
 lib/trace-cmd/trace-util.c                    |   8 +-
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.c                          |   1 +
 tracecmd/trace-convert.c                      | 106 +++
 tracecmd/trace-restore.c                      |   2 +-
 tracecmd/trace-split.c                        |   2 +-
 tracecmd/trace-usage.c                        |  13 +
 12 files changed, 881 insertions(+), 105 deletions(-)
 create mode 100644 tracecmd/trace-convert.c

-- 
2.34.1

