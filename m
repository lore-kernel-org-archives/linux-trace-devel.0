Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86EAC61DD8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 11:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75BA122228
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 11:53:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ABC7L6Gp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgKLLx3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 06:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgKLLwR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 06:52:17 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0449C0613D4
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 03:52:11 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id j7so5710618wrp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 03:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6v5cHQ9sW2/6YcKY/ozLc3qoUErBo5hD7qiE5hIcvMg=;
        b=ABC7L6Gp2YC1jFGVcEejatgCCYl6UK7sNlgwv0TApL7gpm7PfvuXKVLAPUMDLgeknq
         AlhPIlSwzkdtuEcQ/wVl2vZi3kQXav7XcJax5UpcYi/6bfXvt/MgnzgFVY2tHDbiu4R5
         rOKVwBPhPM34J18r6eRJodP/4/iC1bnd2K42u4toq3bcClKZz4dM2UGi/6NZi7lZsGq/
         3wdxwYgvtMoJopdXllvmFkDHl5UqYfDwLiXPgAT9GIZPjmWhEodyGzyFwYRJe0mKP6qf
         zdu4AJLmTVdwy6dMt8px/fT2QQJw7f4z7363NQbaUsu7fYTqwulQSTqlr+8ZgQ2uEdMQ
         H/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6v5cHQ9sW2/6YcKY/ozLc3qoUErBo5hD7qiE5hIcvMg=;
        b=rLzcbKPen4zSKFmJmEaM4cVYIA0o/x8DPgwXkdFXnVKpQTE9iBPFboxelb4e4Lxfor
         diUbebLuR2btu0J5KkSZ6qBWycIqfmmNf2gV7+IuCMFshZfcnvx+ZiNDcoTXN0mxjZ0B
         Tk+ENWfUm3296pmWj8I3nbD1NfQ0TFcrOM6IUFr0vl9XC+TxTz9vs1aVOyiEO+xyzRo+
         eMmmi07edYIBHqr1+J0CzzK327KH5kBgZgXBHdTnCSQa3Ykh1iHl1nILTtK6mUlMrnC7
         ntkogoeZDPMRWLJPJK/SnobNT4gBYotyEoMdL8jVyGTYD+J+s7V0cZce+q6wy499sKVM
         hsMA==
X-Gm-Message-State: AOAM531XeP4pNlFfnnrU/vyPLSw2Wha06ORy9ZroSurEpkb5Wkogpd/A
        /ddBxj50ULicziPGJPjnd93Q6y4BYt5H4bUw
X-Google-Smtp-Source: ABdhPJxDul7qJAl0HqgCiwnmUt4JAD8H9p2xZAA7S1tCsiZ2e/GJuJOXzcuOvCkgjN4kxJnluMAL9A==
X-Received: by 2002:adf:91c6:: with SMTP id 64mr34017961wri.192.1605181930591;
        Thu, 12 Nov 2020 03:52:10 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d2sm1258657wra.73.2020.11.12.03.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:52:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] tracecmd library API cleanup
Date:   Thu, 12 Nov 2020 13:52:06 +0200
Message-Id: <20201112115208.1250789-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove (temporary) all libtracecmd APIs, except those used by
KernelShark.

Tzvetomir Stoyanov (VMware) (2):
  libtraceevent: Remove plugins dependencies of libtracecmd
  trace-cmd: libtracecmd API cleanup

 Makefile                                      |   2 +-
 include/trace-cmd/trace-cmd.h                 | 488 +-----------------
 .../include/private/trace-cmd-private.h       | 480 +++++++++++++++++
 .../include/private}/trace-filter-hash.h      |   0
 .../trace-cmd/include/private}/trace-hash.h   |   0
 .../trace-cmd/include/private}/trace-msg.h    |   0
 lib/trace-cmd/include/trace-cmd-local.h       |   2 +
 lib/trace-cmd/trace-ftrace.c                  |   2 +-
 lib/trace-cmd/trace-hooks.c                   |   2 +-
 lib/trace-cmd/trace-recorder.c                |   2 +-
 lib/trace-cmd/trace-timesync.c                |   2 +-
 lib/trace-cmd/trace-util.c                    |   2 +-
 lib/traceevent/plugins/plugin_blk.c           |  10 +-
 lib/traceevent/plugins/plugin_function.c      |   2 +-
 lib/traceevent/plugins/plugin_futex.c         |   6 +-
 lib/traceevent/plugins/plugin_kmem.c          |   2 +-
 lib/traceevent/plugins/plugin_python_loader.c |   3 +-
 lib/traceevent/plugins/plugin_sched_switch.c  |   2 +-
 python/ctracecmd.i                            |   1 +
 tracecmd/include/trace-local.h                |   2 +-
 20 files changed, 518 insertions(+), 492 deletions(-)
 create mode 100644 lib/trace-cmd/include/private/trace-cmd-private.h
 rename {include/trace-cmd => lib/trace-cmd/include/private}/trace-filter-hash.h (100%)
 rename {include/trace-cmd => lib/trace-cmd/include/private}/trace-hash.h (100%)
 rename {include/trace-cmd => lib/trace-cmd/include/private}/trace-msg.h (100%)

-- 
2.28.0

