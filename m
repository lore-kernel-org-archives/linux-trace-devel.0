Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38ECC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 12:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B38A64F0D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 12:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhBZMNy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Feb 2021 07:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhBZMNt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Feb 2021 07:13:49 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD6AC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Feb 2021 04:13:09 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id d13so5651601edp.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Feb 2021 04:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oYL3YpPMLESPBoIMza67CnCifj6Kr4kFJ/lhVPVJL2w=;
        b=f1xGdHgJVY2mYyBoxg/BhF/tjbIRtIsWNh8FBm9J30knwMT+nLk7V+1PX9GgUuhxJf
         pgsJyZGl/7XMdm9Jf9Y47cMxFLFB1coFu9zTFFq+tUgoO8C9BZfi1dkR3+3u9Fq6iiiA
         7et0ZdSd/Rrwk1/Pv0WHUcLb7/jQFtHex3biWuWdtx7mY3hz8P1rybvrXrJ4NrcfZ13W
         smH4uCMoMItnm29nXavqrMhi2K3QkwSzyqya3zGMPPN26SVcKZXjpz3X58JnEXNGNNre
         2T7lwyBErOn+xWYz6pyG1njJtwxxxmQFFyjqlnBT3w5t9LPLPgvltrQJ4z4MnVjDM6PP
         My5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oYL3YpPMLESPBoIMza67CnCifj6Kr4kFJ/lhVPVJL2w=;
        b=YgVLcpMalJFO89WVVgdXhf2g1Jewj18WWQzGfLU+I83K+Nc5amzSOy4l7+tbm3jCGU
         2smzXBonWYrUyCOEwg+914emGzi2lfpsyMgoOkU6DRg4n9+my5xjYxpBa9jHRySXP317
         HFXXSgB7198kNOyc8jaMZnmmlc+E5MTmRlOEnB0uOd1JsjoK597xoVzmgY5SqF4zSvtI
         7BHQNiY2jqVYqSwQEbLEHUGFAqhfmY+ZgxXxF6I8AQrbxTOLbY/F87xAJ36gpiva2jdg
         eWtC+4NyUfiLxQRUAd86RV4L7OaIHyLLK/oFbCYadQeSZVDsNJ+SOzRHwVRfaKO/JP+K
         X21g==
X-Gm-Message-State: AOAM532SIL+bWwcifvxf55ztr26PxhCjVPlOcRnAEa5LQAizSvSYHxHH
        MyRkg/5q6xYekNVDRNbvtMeUGK5TNaJY1Q==
X-Google-Smtp-Source: ABdhPJzq6wFqjlHvNKscgfdbInESIUKyO79Pt2co7TRtN/XeR4Mv+HDtlsKaDv8h+wyMYFTuX1yi5A==
X-Received: by 2002:aa7:cf02:: with SMTP id a2mr1450965edy.59.1614341587902;
        Fri, 26 Feb 2021 04:13:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n2sm5266773ejl.1.2021.02.26.04.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 04:13:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/5] Fix listener and add trace file validation
Date:   Fri, 26 Feb 2021 14:13:01 +0200
Message-Id: <20210226121306.216757-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added checks for trace file consistency when reading and writing it.
Fixed broken trace-cmd listener.

v4 changes:
 - Split the changes in more patches.
v3 changes:
 - Fixed a comment to be in the Linux style.
 - Moved the optimization for disabling trace plugins in its own patch.
v2 changes:
 - Converted file states from bitmask to enum
 - Added return value of collect_metadata_from_client() to track any errors


Tzvetomir Stoyanov (VMware) (5):
  trace-cmd Add API to save command lines in trace file
  trace-cmd: Update long size in the tep handler right after it is read
    from the trace file
  trace-cmd: Do not use trace plugins when reading partial trace files
  trace-cmd: Add validation for reading and writing trace.dat files
  trace-cmd: Fix broken listener and add error checks

 .../include/private/trace-cmd-private.h       |  23 ++-
 lib/trace-cmd/trace-input.c                   |  27 +++-
 lib/trace-cmd/trace-output.c                  | 139 +++++++++++++++---
 tracecmd/trace-listen.c                       |  30 ++--
 tracecmd/trace-record.c                       |  33 ++++-
 tracecmd/trace-split.c                        |   2 +-
 6 files changed, 202 insertions(+), 52 deletions(-)

-- 
2.29.2

