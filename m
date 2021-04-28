Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7281BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B612613AD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhD1M32 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 08:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbhD1M32 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 08:29:28 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCB7C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id e7so73878740edu.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=046wx2X/YK+VdhFQP6bWwB2kPPD9U1ZjLxbDr5rculs=;
        b=b1nWAc07fvF1uSRL+xe0EPbuixvp4yRuJLpUt6l0AD3hczFfdAa+RCO4tqtCDMgfRO
         hBcTmetwp4F4HtKpRIow8HaHv7XaO2a8I5SM6L0EjG7jQLfUUjod8rWA7nDRFk6ahfiO
         sxhEujO/EEz4Wfu+Fcdv+pD6TnnZ1rvfbzlE+qPGd/8q1qMFDfRhq89d+nwYHG5D1YBc
         ZRwkEa8cA7wQk93cbT9O3YXSP+Fq17UC6jP2vEqqUIgVm3P38fvzVwKqWnJ9C0S5j8pj
         QMHXmyxQJbwho7BYylKAbTuHYHY//+ZHMSW5XRBDfzmGbGuwJ2+946UDP9F1vB2OCF1Q
         SVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=046wx2X/YK+VdhFQP6bWwB2kPPD9U1ZjLxbDr5rculs=;
        b=gY0kbq6PKBJXrJuwz3d4JkJOlwxy4uqCu+4p69k29ecBNQ0PjqjmuYd2wrr58uCVzt
         cdgIKm9FPauMp+cG8vdRdbHXOB26CHFUvZ0HZ1+bF2L0LOtoGJxQWBxGM4TYMmdkb/nF
         mPAYzBeb7HQSVcovIjBx2cJftfOvrgLJFfQtvRD6Xn0upBRRcnsbTSl4oLa8ljjopP4S
         E8cX3WdxGVwTb9YZqFYhNkl/yqa4bmmJORP+wdS5X018ThmKd4REEDHFZy7iWCyWnBnM
         uG7ebZzdaVpiQEix7YoaXk4S+AUBb2nGnqbNqQm4EsqUAhDdu8ieEESQJSqpEggdwZj1
         2GHw==
X-Gm-Message-State: AOAM530hNLPCiF8v5ef+UdkwUX3eqFYg4yZMFxxGUHk5oHpS0neN9UzX
        eXKifxHxcuSmtjdjQqjV0QAA8Ar8yRtR4Q==
X-Google-Smtp-Source: ABdhPJy3hZRs6lrzH0nbhmg6eebjZ9KYkW7+hjsYHBhR0PX2VyP5ZI+YbIfIpxkwa9bWCpA3Tg2M8A==
X-Received: by 2002:aa7:d7d6:: with SMTP id e22mr8952803eds.161.1619612921950;
        Wed, 28 Apr 2021 05:28:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n10sm1846546ejg.124.2021.04.28.05.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 05:28:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: RFC [PATCH 0/5] tsc2nsec fixes
Date:   Wed, 28 Apr 2021 15:28:34 +0300
Message-Id: <20210428122839.805296-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Removed the not so stable logic for tsc2nsec offset and replaced it with
trace-cmd library APIs which can be used from the library users to achieve
the same functionality.
These changes ignore the offset, part of the tsc2nsec data written in the
trace file metadata. Is it save to completely remove the offset field and to
break the format of this trace file option?

This is a RFC patchset, additional updates are required in case the changes
are approved:
 - Update trace-cmd documentation.
 - Remove offset field from tsc2nsec structures.

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd: Remove ts offset from tsc2nsec conversion
  trace-cmd library: Remove useless check before applying ts offset
  trace-cmd library: Store the timestamp of the first event when reading
    a trace file
  trace-cmd library: New API for modifyning the timestamp offset
  trace-cmd report: New option --align-ts

 include/trace-cmd/trace-cmd.h |  2 ++
 lib/trace-cmd/trace-input.c   | 39 ++++++++++++++++++++--
 tracecmd/trace-read.c         | 25 ++++++++++++--
 tracecmd/trace-record.c       | 62 -----------------------------------
 tracecmd/trace-usage.c        |  1 +
 5 files changed, 61 insertions(+), 68 deletions(-)

-- 
2.30.2

