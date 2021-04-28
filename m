Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370BEC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1C68600D4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhD1Hmh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1Hmh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:42:37 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D98C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:52 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id h10so72977185edt.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GycZAsvhJQ64dMMNxMlZl5hCXKkw8+g2+fKrO+76xvA=;
        b=hx6nokkH0+vsDOmFtRarWgZNldDe71+8COAXsHoFY54Mdb2LNu1wKOUZ9K5ld/Fh48
         quNJQ6NZz3twuR7GcaL4LDYAbDHapLc1mNa2JWscrSoHVy2Pf8yRuv5nOlVmwwnc2muF
         Y3A7190Q/74dt2+YyumpW1/1e51PrgcOPlIZpONa0dEx3mA8LZCuyOvmVVwVSwGK/J5b
         Qd4Jlo7cLM6o+9w+kowVdrJqWJsa3pQw6plfQNY4Cte8AGvlbzjERuobfCRzKpos/EWZ
         tgtAOp/YMsG1/w6lNde5sk+QCWdQimzCN9cvygYIC5uJV9fiard5Gu8MV+0WsQJD1Qol
         QZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GycZAsvhJQ64dMMNxMlZl5hCXKkw8+g2+fKrO+76xvA=;
        b=RjhpXCz88dkJQLwNJpXzBlJRYlQbHm64X2fDmNEKrYYZOcyrGUOpXmN/yiZQrH51nL
         wrApdD+eGEALCKkaNZQPz6sNPKbHAahDz08c/9CdjTvMLgpOZfiRsKfXi8RyaGqOapVf
         WqLJSGfK3SfDkJOguASgqKQSF7Ng23vrsokYDlajyV7iz4GpsVJLP+QM0CNkZHnMSEW+
         xiHCMt9lE78CNk2PX6ozkn9eitghmkwgjqYxZNQ6vIAT0F9Jk5ka+OIaXvGu084MCTQ1
         Blpgel/B8x1W5JRRhYd9cmXyNiUpr3KZF5nvMZ+3R6sj1ag+bE4Dc7whOWH9tYwRKVWN
         w5lQ==
X-Gm-Message-State: AOAM530Ag/zGuUd8p1PQrOe29YsAojdwYeknw319jY99RelHFAAxLWAR
        KYNEYVZw9Sca5oePkpYrpbLRnTgVXPp+Yg==
X-Google-Smtp-Source: ABdhPJxt76hjWcjGUh/PAUBvYgEsKan5zDc5P0XRmA7khpNqUd58VrToDSkqr2fGn3uu6Ucq91/LOA==
X-Received: by 2002:a05:6402:35d3:: with SMTP id z19mr9206620edc.143.1619595711741;
        Wed, 28 Apr 2021 00:41:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k5sm4530504edk.46.2021.04.28.00.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:41:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/8] Changes to trace-cmd logs
Date:   Wed, 28 Apr 2021 10:41:41 +0300
Message-Id: <20210428074149.757163-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Recently changes in traceevent and tracefs libraries were introduced: log
levels and new APIs to modify them. As trace-cmd library uses traceevent
and tracefs libraries, those changes affect trace-cmd as well.

These changes depend on "[PATCH 0/2] Add API to set severity to tracefs
library logs"
https://lore.kernel.org/linux-trace-devel/20210428073212.756329-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (8):
  trace-cmd library: Use tep_vprint() for logs
  trace-cmd library: Add tracecmd_info() log function
  trace-cmd library: Add log levels
  trace-cmd library: Document the API for log levels
  trace-cmd library: Renamed tracecmd_fatal() to tracecmd_critical()
  trace-cmd library: Set debug log level in debug mode
  trace-cmd report: Set the log level with -V and -q options
  trace-cmd: Add new function to set log level

 Documentation/libtracecmd/libtracecmd-log.txt | 78 +++++++++++++++++++
 Documentation/libtracecmd/libtracecmd.txt     |  3 +
 include/trace-cmd/trace-cmd.h                 |  2 +
 lib/trace-cmd/include/trace-cmd-local.h       |  4 +-
 lib/trace-cmd/trace-input.c                   | 14 ++--
 lib/trace-cmd/trace-plugin.c                  |  2 +-
 lib/trace-cmd/trace-util.c                    | 47 +++++++++--
 python/ctracecmd.i                            | 13 +---
 tracecmd/include/trace-local.h                |  2 +
 tracecmd/trace-cmd.c                          | 55 +++++++++----
 tracecmd/trace-read.c                         |  2 +
 tracecmd/trace-record.c                       | 14 ++++
 12 files changed, 194 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/libtracecmd/libtracecmd-log.txt

-- 
2.30.2

