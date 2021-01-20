Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C43CC433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D880023382
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390562AbhATPXV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Jan 2021 10:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731979AbhATPNk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jan 2021 10:13:40 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E193DC061575
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 07:12:59 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a9so19993362wrt.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 07:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2kxfSpDYk2sen79XjCTwOwgdnHvcOdx2p2IG6Jrt6S4=;
        b=YNqKZzdhv2oHo27ngrlBD4vTL/E3L7PwTv2MVr1LIul93Na2qSabRwfLhkl8tLi4PE
         XWamR/2RAciMIzLtwhbsYG3xRwPQ3xMf/ab0QFMSq6N14LXfd9TN/+eq8LnKL0P7NlU3
         XBK7vqpy0PJtutPb4HMHlWw/C92Cedr3wBFhvZdDbg52z8KGz3ey0K3WbUMKlYrgN9hM
         k28mOWeinWkx+9DYiVkjx/BDDoJsL1yGtkUBBvsZj1IzjQiCQsn/SzjaY8k2tSyXjO9F
         snO78XTK8w6Ghx7fsgkyp/cFSicIbDhmnvjJWESHt4+lhZfX4Pyg02YJtsLRR52yyXEk
         dA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2kxfSpDYk2sen79XjCTwOwgdnHvcOdx2p2IG6Jrt6S4=;
        b=niqaLxWgGWBM5z1Pp9pbRwUwgMa2O6myH/37i18lOGC4BUILF9VEVmTPma0Dhx0Z0H
         vpYIe6LoB6KchEJ7Rl9kc87cQRhks9XNB+9JShTifG70UX2++jWNeYr3lcLdw7IM0mRV
         YjD2Rklk9hHpVuwsdMOt2/O55LK0xaXhNUzNMboYmBLzXi8Cp3jQw9XASpuUWttJ9g+1
         gQQ1vMsokOxqDK0n5FOWxoLoIA4aNj1O3i14fq3Qfg/oQ6f/BnwbhnKyQGBDMY1Vg/k8
         Y7i7wITCsZLM6BZ3ymfmHZihDnpKbdt3NvA1TLFq3YQvrSwyE63QsQJTd+xQwUiua2qx
         dbHg==
X-Gm-Message-State: AOAM5324f9B/b9P/vg0uWONorK7ISzTZfPTFPHTEv3PTbj5loXzO9kWV
        TvWC87wMMHBdwSk0R7jUs91Ckm3Md8ZheQ65
X-Google-Smtp-Source: ABdhPJyTLekuuJkVJrluT728ufioAyHWbgo3z6bv1NM8+W9vFNR7OxKLp6lfnuDOz/KdHGE0pM97og==
X-Received: by 2002:adf:d1ce:: with SMTP id b14mr9701842wrd.329.1611155578611;
        Wed, 20 Jan 2021 07:12:58 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c11sm4571106wmd.36.2021.01.20.07.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 07:12:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/5] New libtracefs APIs for trace options and trace dir
Date:   Wed, 20 Jan 2021 17:12:51 +0200
Message-Id: <20210120151256.43075-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new set of tracefs library APIs for:
 - Working with trace options.
 - Working with non default tracing directory.

v2 changes:
 - Changed the trace options IDs from bitmask to enum.
 - Abstracted trace options bitmap structure.
 - Removed test_nop_refuse and test_nop_accept options from the library.
 - Renamed tracefs_instance_get() to tracefs_instance_alloc().
 
Tzvetomir Stoyanov (VMware) (5):
  libtracefs: New APIs for trace options
  libtracefs: Unit tests for tracing options APIs
  libtracefs: Add information about top tracing directory in instance
    structure
  libtracefs: New APIs for getting existing trace instance
  libtracefs: Unit tests for working with non default tracing dir

 include/tracefs.h      |  64 ++++++
 src/tracefs-instance.c | 137 ++++++++++---
 src/tracefs-tools.c    | 244 +++++++++++++++++++++++
 utest/tracefs-utest.c  | 431 +++++++++++++++++++++++++++++++++++------
 4 files changed, 786 insertions(+), 90 deletions(-)

-- 
2.29.2

