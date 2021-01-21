Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD48CC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 12:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73FD723A00
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 12:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbhAUKpS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 05:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbhAUKgt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 05:36:49 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A468AC061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:08 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id a9so1204881wrt.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w05g1564tnf2FhZcWPcRa4z86nLSXBx5nrxrObbw3iU=;
        b=Q8lpmWtp0/alBd2drt1DTPdYazqo06OAA7UKgbMFG/neKe7sZ5lVVHtu6Wy/8U2nym
         CZxF3rfMJflYyF8KE+JMtfTCWWBr2dVwupoNNRnAZiwLv9h0rzCAcD4VPWtLqtBcfyvd
         9NIcFqoI/YJ5uAurpfJ7vbI1V9hPbLmMyYkshcc+Pa8Kdjt2nJlFEVW+Lq7Gy37a8bSD
         NTQSMfe/hjo2XSUEFbhhGzxxfzS9rP6oiwzvYIK0LgEc16Mg3yfA+VcUAmXQwvYNaq3h
         rY8CR/RBNlQZXP7ac9B1NzkD30RWBoS2wxTT2WSzePIFYD82ZtztnTf8banutoBo7CbX
         2m+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w05g1564tnf2FhZcWPcRa4z86nLSXBx5nrxrObbw3iU=;
        b=o6xmwjS0cMrebo0M7Bs1WzAbjGhZLzPGs3y+ptBC0Rf0HfOWAOFWs3uPM2GmXB9i3n
         RPhSlFuM+BXsOqO5Rwq/HYiXT46Aj4Ee4sfH+f6h1WaUS/3vr4V8202+ZvMjsP5ZcHCB
         3emgL5SzJni1DMt0GgFiQpp/RjNNTcxI6NnDEp/8DaftlD4BEjdJbCe87pj8uP8MLP1W
         p6PQUnT2XywP7tW8Q4TDKIKwdHlNodt64j6NSLwUvM8DkMUSx22Lmn9aNiMrJEeGPOtb
         6rRqJJ9sXu2Dbdlur7m4GCzubl7kT81xQzSPfSYv2Vx5qX0t0ILuBRBn/j9cvGOt0Zlx
         1fyA==
X-Gm-Message-State: AOAM533SaaGYj28Y/3SXDEOu/M/NnGE4mMq31HZhQSM780KGTDUb/tLS
        QBHJHBBrU6chyA8Otyt7koqgHJ41fuWCQ3kn
X-Google-Smtp-Source: ABdhPJwfgCtGeMl2bKjHm61bft4T5WhrKSaC5xqwPZD0zOKw9ONAbQmwsBDLsRSAIZtFZ0YFaMSs3w==
X-Received: by 2002:adf:decf:: with SMTP id i15mr11026058wrn.405.1611225367471;
        Thu, 21 Jan 2021 02:36:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm7294123wme.37.2021.01.21.02.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 02:36:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] trace-cmd libaray APIs and man pages
Date:   Thu, 21 Jan 2021 12:36:01 +0200
Message-Id: <20210121103605.224108-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a few more trace-cmd library APIs and improved examples in the man
pages.

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd library: Export 2 APIs for opening trace file
  trace-cmd: Remove tracecmd_unpair_peer() from internal header
  trace-cmd library man pages: Documented APIs for opening trace file
  trace-cmd library man pages: Extend the examples of reading host-guest
    trace data

 .../libtracecmd/libtracecmd-files.3.txt       | 89 +++++++++++++++++--
 .../libtracecmd/libtracecmd-peer.3.txt        | 56 ++++++++----
 .../libtracecmd/libtracecmd-record.3.txt      | 22 +----
 include/trace-cmd/trace-cmd.h                 |  2 +
 .../include/private/trace-cmd-private.h       |  3 -
 5 files changed, 123 insertions(+), 49 deletions(-)

-- 
2.29.2

