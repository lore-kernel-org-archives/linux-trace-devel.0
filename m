Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D15DC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 367D822513
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgLUGDu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgLUGDu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:03:50 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5F6C0613D3
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:44 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b73so8428278edf.13
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8aPRRv/6AMRVzh9VKabf4Pg55al4OpnfX6yUIarTVm4=;
        b=oJXC/Km6qGHIjdgDQX5rCo64Hly4LkArKXgLwwzDUY80IDzOj9hu3qOkIR/8CL5Hzo
         two48Fv4YUORRvPefHkFOCPtB3arW8tAXO9iUimbJ3Bd2rLXTeRN8xiejqFhKajRx4Ai
         L88DdwbW6JCOxJg9nQS/9Mk6TOAzGIfM6zgezR2WIhZTvctDmGo0fq27NNaXhp6hUWUH
         tzGKijNAsh5MbeGAKy9Ae4P9IaMHSpP/uL3lJD0C2RCg4EQRE4TtMjcPZIJ+u15DZwlk
         oT0bHWIbp1lMtBVbaMvvTU9b8kRY3TABgys7alsw4HayVtjgD+rTm8qr84WBBgG5ZFIy
         wdgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8aPRRv/6AMRVzh9VKabf4Pg55al4OpnfX6yUIarTVm4=;
        b=gIU97OmRTK8lzRyDah6i0zWf+Iqft0I/2CCzoEcR0bTCo+aUSnwOSwAUeB+CzRRNjE
         pFtFpHC/LPLGqPWiXoGsgxSJj1ImqdU/CblKHto1ZxN9GA/qkMyfuYFJP0Qu+Ow4vB1R
         R/yaJA3VtarBau4FWmOHDJ7LptVQQ5jPNcW9sOFRk4bWDD/PGvJUN/RSTnr2CXQOx2mh
         aWygdFw3L9muqldq19k3mp+0SIwWeiPcTlLm126LPF3R/Y+dMw9zrjjONaaMZGGiFHMk
         EFitjCtR8/cURLH/e2KD8n7eegv2v+t60HH5l2iwOvClBCDERgDA3/3TWMRWjU8CNQBe
         nXAA==
X-Gm-Message-State: AOAM5309qLaMxlZbcB1ibKHQgrwVP5EwGs2MhBCFn6LCImb6LbJC14AU
        mxHfzaetod0HTr8H1eQBAV1pp51lvzP7M19E
X-Google-Smtp-Source: ABdhPJwm8/eu4V5YWw7AtEtRzYTk0tyXKWI4rFXLN+ncPT8ti5Z4gvlysqeKQZEcelpJixccLsdqBA==
X-Received: by 2002:a50:d484:: with SMTP id s4mr14527605edi.13.1608530563325;
        Sun, 20 Dec 2020 22:02:43 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm27706247eds.72.2020.12.20.22.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:02:42 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Consolidate APIs to locate tracefs mount point.
Date:   Mon, 21 Dec 2020 08:02:39 +0200
Message-Id: <20201221060241.177767-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The two APIs to get the tracefs mount point 
tracefs_get_tracing_dir() and tracefs_find_tracing_dir()
are replaced by single one, tracefs_tracing_dir()

Tzvetomir Stoyanov (VMware) (2):
  libtracefs: Remove tracefs_find_tracing_dir() API
  libtracefs: Rename tracefs_get_tracing_dir() to tracefs_tracing_dir()

 include/tracefs-local.h |  2 ++
 include/tracefs.h       |  7 ++-----
 src/tracefs-events.c    |  8 ++++----
 src/tracefs-instance.c  |  2 +-
 src/tracefs-utils.c     | 14 +++++++-------
 test.c                  |  2 +-
 utest/tracefs-utest.c   | 23 +++++++----------------
 7 files changed, 24 insertions(+), 34 deletions(-)

-- 
2.28.0

