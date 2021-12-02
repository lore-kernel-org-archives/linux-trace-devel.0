Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98908C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240046AbhLBMaw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhLBMaw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:30:52 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FC4C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:27:29 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so115227082eda.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+42sHj0ARe+piVzs5zfqcqVn6Lg9rgOee31Nf2Nb4sU=;
        b=b3+YTXk2yA+1ovq2esu0oweff2AmUWXXyKdCC5z+A8aAkglT1FWgOKxt6FwFwIErGX
         qrfrqSvsKeHaBCJz4WUkWthRzj//5lWCZz05sqBEm6g0L4p8L5zxUxEUT531/Yb8LMAJ
         nzCngl0ELKtdtFKXPJmaybthoKIEwZGhmifdZPbFAAjPoRRAFXNlcZa763N+y9CtntQQ
         INPeDINCW166NUjNR/T4iQCSh25XSgppj28KHxcHWnzrPXA1JjXEEN6GTgn0iE/AVrVp
         jORgnHVoTHY82Zwsw4S/Hf78AIaHqtw3PTsuyylKzXKoyLYJLMjYPqr5s9wsMIc6B78s
         bvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+42sHj0ARe+piVzs5zfqcqVn6Lg9rgOee31Nf2Nb4sU=;
        b=C4c5Zzp/j1IjGigGoQSVR53nU1uVPKxnFKJKi4LBSRHHDltYqprFqKahTCGLYDw/My
         afza1W1ldws6nrbooD7S4CN86iIhvTRxpR7QJ1mePCGzcGVqNab/x8igy93vcbxLYowT
         D2eQizfd2Ra3WGiC7F65/ehx0o/zNkRdLXx6LZ4OSRggBTo7+rBvmGylHeSnnUOqvnfP
         r+G80mHKPzyjvh9bu7js2hvKLqGNJxAivfmifOfKJgcguw+OJvVTvNhX4BC3n58oodcb
         b0q3/PX+ZsVVDj+6Zm1q5zkwjOZQbFLgm723uB0uFht5mq4vZjbBwiLX1A8d6dXkpUkJ
         5hVA==
X-Gm-Message-State: AOAM533gmR7JEWgPJHsq0ycRaDzINa98yj9J0T3ap5YauJ81ItmLXmiq
        YTdlaF3MZdmCFKlWWMKkCXI=
X-Google-Smtp-Source: ABdhPJyy7z8Ede6HgnCoj/VEtZAQj20+fRnE0LfDcF8p3ozzYrV4BrlB6AXgdxqHDDUVqq+zeBNP1Q==
X-Received: by 2002:a17:907:a088:: with SMTP id hu8mr15406051ejc.234.1638448048199;
        Thu, 02 Dec 2021 04:27:28 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u16sm2073403edr.43.2021.12.02.04.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:27:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 0/8] trace-cmd convert
Date:   Thu,  2 Dec 2021 14:27:18 +0200
Message-Id: <20211202122726.43775-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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
 "[PATCH v5 00/20] Trace file version 7 - compression" patch set.
  https://lore.kernel.org/linux-trace-devel/20211202122507.43572-1-tz.stoyanov@gmail.com/ 
 
v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
- Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (8):
  trace-cmd library: Use output handler when copying data from input
    file
  trace-cmd library: Handle version 7 files when copying headers between
    files
  trace-cmd library: Copy CPU count between trace files
  trace-cmd library: New API to copy buffer description between trace
    files
  trace-cmd library: New API to copy options between trace files
  trace-cmd library: New API to copy trace data between trace files
  trace-cmd library: Extend tracecmd_copy() API
  trace-cmd: Add new subcommand "convert"

 .../include/private/trace-cmd-private.h       |  15 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  13 +
 lib/trace-cmd/trace-input.c                   | 698 +++++++++++++++---
 lib/trace-cmd/trace-output.c                  | 121 ++-
 lib/trace-cmd/trace-util.c                    |   8 +-
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.c                          |   1 +
 tracecmd/trace-convert.c                      | 106 +++
 tracecmd/trace-restore.c                      |   2 +-
 tracecmd/trace-split.c                        |   2 +-
 tracecmd/trace-usage.c                        |  13 +
 12 files changed, 878 insertions(+), 104 deletions(-)
 create mode 100644 tracecmd/trace-convert.c

-- 
2.33.1

