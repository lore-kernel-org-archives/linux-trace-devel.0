Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C29AC4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E3CD61378
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhHWJ5P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 05:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbhHWJ5O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 05:57:14 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6400C061575
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:31 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u3so35816416ejz.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xZn49mSufTslY0v2J1Fo7WRFYQWepKmKT0IHBhSndBc=;
        b=PpyA97kqaWaQCFGAFazU76FTDC2KTdDp26CXp33DPKIy0UfSurr0du1MwiLD6lj0f6
         YGNapt30ta9RFuqrYJOv+4H5vD8gyyNlOAk2YfkhJwI/UXe+1U/C4xOX7reQ32HfsfE4
         TitsqxnSUdwFC9Q7tYFmBHF7/+eWV8MRnjDdQJL7SoY+Epip25eI7NgaxY1Ne8aavqWD
         afTf/QUejx5HD9DARyn/aOetZxfYRUpTlVc+mYE10DDCmoJpoC4tb8q1/2ZYxuBrUtdO
         B+mcM/a3Udr41OS2rD+ayH5ddAflYUIuxlBAX23hTmRrjNmn2WMdlwdzmJMVJlmLxA4R
         VqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xZn49mSufTslY0v2J1Fo7WRFYQWepKmKT0IHBhSndBc=;
        b=jEmVJQA2iTuSXnEWyXBSWVcUjNz1d5UqTWBKnskZd9mHBEkaHRtSMzGJAS6rWyv9cx
         zsNRil/Rp1nstr5NjoWqYmf5uVbMbOxRD9bRWehvUvhgJybM38jdm8RTugSbazqkwkkU
         DoAa5cf8AKs6rXZ5h7+jo4BRNHh5mR6hVVlynoMPhkd9MbdS/prFq1G2//hwaX0BnLHo
         va2vribuMBTcNYUfZ/lfP/OIwAnejwRHwrJ3ormq5K75H143AGFfZPJpb3j2NhW9/PyC
         /xfTFvJ1UAmR+++ajkP9Ow3x2PhWbOOqRJD6IV9/yFvHm1lMXD7QIey3ng0pSq+YVnyU
         Nrpw==
X-Gm-Message-State: AOAM533sAmvwftEJMIYvBg7S2AKqeArwzOH8jPefi2ZjBzF/kFyc4W7Y
        NTsINwXubLW1ayQayGBXEyo=
X-Google-Smtp-Source: ABdhPJyhjvCKhSXvIPeatb/oqfufuvxJIXfI1/4jlni5LODTYUz1v0V7jxXlXxeuOc0Mbcbg2Ayxdg==
X-Received: by 2002:a17:906:5d6:: with SMTP id t22mr34118901ejt.98.1629712590267;
        Mon, 23 Aug 2021 02:56:30 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id y23sm7047831ejp.115.2021.08.23.02.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 02:56:29 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 0/4] libtraceevent: Optimize the print of tep fields
Date:   Mon, 23 Aug 2021 12:56:14 +0300
Message-Id: <20210823095618.138887-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Provide new capabilities for printing the content of the individual
fields of the event.

Changes in v7:
 - Proper naming (without 'tep' prefix) of the static methods defined
 in the patches.
 - Fixing the 'for' loop in print_selected_fields()
 - 'tep_print_selected_fields()' was renamed to 
 'tep_record_print_selected_fields()'. 'tep_record_print_fields()' was
 added.
 - Adding documentation for the new APIs.

Changes in v6:
 - Cleanup in [PATCH 1/5].
 - Protection against infinite loop in _tep_print_field()
 ([PATCH 4/5]).

Changes in v5:
 - The loop over the tokens in _tep_print_field() is made circular
 in order to support the corner case when the fields and the tokens
 are listed in different order.
 - _tep_print_field() and print_selected_fields() are made "inline"
 in order to help the compiler to optimize out the unused variables
 (suggested by Steven).

Changes in v4:
 - Directly applying the modification in tep_print_field() suggested
 by Steven.
 - Optimizing the loop over the tokens in tep_print_fields().
 

Yordan Karadzhov (VMware) (4):
  libtraceevent: Improve tep_print_field()
  libtraceevent: Optimize tep_print_fields()
  libtraceevent: Add APIs for printing the fields of a record
  libtraceevent: Add documentation for the new printing APIs

 Documentation/libtraceevent-field_print.txt |  11 +-
 Documentation/libtraceevent.txt             |   2 +
 src/event-parse.c                           | 184 ++++++++++++++++----
 src/event-parse.h                           |   7 +
 4 files changed, 170 insertions(+), 34 deletions(-)

-- 
2.30.2

