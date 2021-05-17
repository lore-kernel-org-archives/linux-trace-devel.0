Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C52BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 025D4611BD
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhEQNlZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 09:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhEQNlY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 09:41:24 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EC4C061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:08 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t3so6938192edc.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BcJItM63Wc3hhr0fcXpp8cgXco/PSLMe4N1quB2qqZk=;
        b=eCBteHyq59xBjC6dh4wt+FJqMBB+K6uMMZaOqmED9XY7bQkEcDHZ8W3i7FD6lSWGT9
         xx7oIk5Dh3u83DJ7YIMPQh+GlhfuFMr6UMSZKwbMen6DieFolk19ztmWV8k1VxWI26Ud
         zjXFnss2IRdXYmUNjsqfZSgk4zuxUOOqBH8OzHHNlhOFXvVSXdxqRlEGEntknvC/T85G
         Aao2XyYOO1u+6rf+nPnpZMh8uHUT8Izi67fTbi7dAI0+f6Motu7G0AmWr4Yi06akkgXB
         ZLF7RihxNmMJfFumYN30ltQFhvsIUFC1TzB4d7u7Qiv3SgV3sjOxpNDJYWwp4B8cOQG3
         Wy7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BcJItM63Wc3hhr0fcXpp8cgXco/PSLMe4N1quB2qqZk=;
        b=GtRUQdIPWIOxxAn8bSp4/Qqx16aLmkAftgPkRI9J7Bxkw6zNqj12afoBf94LPkk8SG
         X5uZLstSnuXsqTkQ8UhdS2vc+1LejNkDw76IUy5FXhYM+qlGSbvYI7WqP/H17xQ6m+RO
         0/vd1ct5hWo2I9O6itsNk3Oa5oggcEcWhvh1EINcas4l0nVTqVb1RNfyqQILB8mWy+Vv
         RDX+LD08WJ3tkK2z6SWEq7rzaOIDe0uqK29IW1W8AJrh0Bh39qnlQ2tl8x59m0UCPudb
         T+kPrRTIH0JHlqznJ9oJw8yUIIzi9NEOWAfxG7SXEa8dvtjGAyEnAbX81wBWQSG30+5v
         kmSQ==
X-Gm-Message-State: AOAM5337rajqghCtlu8d0GPL1ojR6UJ3c+7OufaBwYlTSlzMvFGo95+h
        Ve864oj95vXxFLLQ2ubZ82E2ANEo0yEZOw==
X-Google-Smtp-Source: ABdhPJx4BWz3Kscfoyi28wgN9QD5Jf6tF54jkj+Hhb7husLc6HPEbfQThogCXozLuu07RfI1a8/BBQ==
X-Received: by 2002:aa7:c7d3:: with SMTP id o19mr100111eds.142.1621258807173;
        Mon, 17 May 2021 06:40:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r25sm10961799edv.78.2021.05.17.06.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:40:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/6] Changes to trace-cmd logs
Date:   Mon, 17 May 2021 16:39:59 +0300
Message-Id: <20210517134005.611251-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Recently changes in traceevent and tracefs libraries were introduced: log
levels and new APIs to modify them. As trace-cmd library uses traceevent
and tracefs libraries, those changes affect trace-cmd as well.

v2 changes:
 - Reverted back the weak definitions of log functions.
 - Fixed a typo in a variable name.

Tzvetomir Stoyanov (VMware) (6):
  trace-cmd library: Add log levels
  trace-cmd library: Document the API for log levels
  trace-cmd library: Renamed tracecmd_fatal() to tracecmd_critical()
  trace-cmd library: Set debug log level in debug mode
  trace-cmd report: Set the log level with -V and -q options
  trace-cmd: Add new function to set log level

 Documentation/libtracecmd/libtracecmd-log.txt | 78 +++++++++++++++++++
 Documentation/libtracecmd/libtracecmd.txt     |  3 +
 include/trace-cmd/trace-cmd.h                 |  2 +
 lib/trace-cmd/include/trace-cmd-local.h       |  2 +-
 lib/trace-cmd/trace-input.c                   | 12 +--
 lib/trace-cmd/trace-util.c                    | 34 ++++++--
 tracecmd/include/trace-local.h                |  2 +
 tracecmd/trace-cmd.c                          | 40 ++++++++++
 tracecmd/trace-read.c                         |  2 +
 9 files changed, 163 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/libtracecmd/libtracecmd-log.txt

-- 
2.31.1

