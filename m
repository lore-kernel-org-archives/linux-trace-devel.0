Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A15C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 944F2613B8
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhDFEUM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDFEUM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 00:20:12 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DD2C061574
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 21:20:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x15so3450947wrq.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 21:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mf0XccSfPAERBclMzU+b8TG3olONYfBjZXqw0afodNg=;
        b=rbN6itWWZzcrUgze03iPapJ9P/+PoLW2zu7ztPlN1oklJZBsoaA7zQp75sspM/jjcR
         Ux7lB2zSX8/cSAUBEsHuYhI1QlsqP1aeeVzm9WyFH8+3rwsAj2BeTcPxSdONaVMfPT0A
         C7oaGY6l0mo22vMSU9YnCekOpCkSxSEJcTgGfPsi6Q5sauUO8zoQho7HFyN3dnWBVaQw
         DAaZV6WbczRzQph1JdLNrJmjZOt2DzFtmcZwhvmbWjcQWt4goSKIblhr+Tw8Iv5YtbmX
         cMNOGF73KKETqLETiQ9hS58bJCZzCe0g6eKElQSf7/PkftwBenwRXCsfSDJzGMy3ID57
         i/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mf0XccSfPAERBclMzU+b8TG3olONYfBjZXqw0afodNg=;
        b=QCCV1cChItKn0WTbdOBjc8XGsDcr73eWnLE49lu8yOu3sk1eSDVGTz2biD+4HuzwS6
         LkB4XAn0mMxhnotKMA/5N4ZZl9/xmqJfTrTFhY1EdNqQHiqoyIuVnpAm5KmOfM5HOU/J
         DFGMG163Y6+j7/SS6mg7QX1XGLaUCSNaGgqQvtc16SI337yPzztFfwMVxz0aBWvziv97
         r/9YZc7nKWlTqMP+lVr0a79v0gmvjBFc4E+qtBPTnVju5cQZeZq4sGJXgK8subF/IvO7
         2zov/v7w+NYCfBBP68+3MjYm6m7V44YLB4ChLu98kqIRC30w8OmfK+qd6aHsyWw8tJW3
         8bMg==
X-Gm-Message-State: AOAM530fDW6q0UHTIJ11gouE7gcOfg6wgx7ZA7fbmNVMJkB5WDxXXoTG
        l+Leo96dq6sc4MFaT1h7anfjIQwPQkv72A==
X-Google-Smtp-Source: ABdhPJzt9gjNsMIJTGYquLqUEziMUKxgOWL+c/wQaEP+sA6IvnpqG6rHesRYA+65TJSN5Jupv7wjNA==
X-Received: by 2002:adf:83e3:: with SMTP id 90mr13809016wre.153.1617682803416;
        Mon, 05 Apr 2021 21:20:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j23sm1325337wmo.33.2021.04.05.21.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 21:20:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] Iterate over raw events in sorted order
Date:   Tue,  6 Apr 2021 07:19:57 +0300
Message-Id: <20210406042001.912544-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

tracefs_iterate_raw_events(): read oldest events first.
Updated the unit tests and documentation according to the new logic of
the function.

Tzvetomir Stoyanov (VMware) (4):
  libtracefs: Iterate over raw events in sorted order
  libtracefs: Unit test for iterate over raw events in sorted order
  libtracefs: Unit test for iterate over raw events in selected CPUs
  libtracefs: tracefs_iterate_raw_events() documentation update

 Documentation/libtracefs-events.txt |  14 +-
 src/tracefs-events.c                | 246 ++++++++++++++++++----------
 utest/tracefs-utest.c               |  31 +++-
 3 files changed, 190 insertions(+), 101 deletions(-)

-- 
2.30.2

