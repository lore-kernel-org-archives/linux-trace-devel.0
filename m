Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA35DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE62630EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbhKOKtH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbhKOKs5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:48:57 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E12BC061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:00 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id e3so33398652edu.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YxeEDFQv9z5J2zhE/uz+MfixrGPvEPbWGU/oLOa/RVw=;
        b=B9Y+FUOKeqZ//Upfw4xqP8OloNzXEuYxrjBcvCWr5DkB8N6DyKkt6frpnRj62oLTBZ
         5LTTDpe7H9o5PY5rSWKOWH2wqA2JQ3IWoqqYw8roXUqJDqcVIpGyj7wtGYvw/u5BDc7X
         JGZGhnnOU6lfVAPQjP5cIVOXbBqmmdt4PcJ0DPHecWqS4S1RbCHETsWe8Y87tWm7pYiy
         wFZFOy+MimCRS3koIRITk/0aTTMaMF9aQkwUr8rsCafeqlG4SkESoRzGQiW/2Jq/NqL5
         qbPpIerDeRasm9XBS9Z/fCwknuQ49iCrr0ghgTwTbcvB+lgIgYeTbiTsmI1oOD053HBc
         Yg1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YxeEDFQv9z5J2zhE/uz+MfixrGPvEPbWGU/oLOa/RVw=;
        b=kZ4/j53/fQRbDYMmT6fJ77f1vwJ4DGVFflFuEtjeiL7+ROPoovoxYsPSKXTpDCin5C
         1g6gCyE9IvXG3OUaQDw3CBwlHX1WE3buXNKlo/7Hm1P/b8r3gBOPTkctdFxCR4uDShtW
         dFOH5Rh0phyvC0OU+U4mApqHhPp/wbUhM65qW6r38mjOwnb6T2UMGLAG1U2ZuEb0vF47
         K6R4unolhZmgp+LwFgTH34d6wg7uxAydOWiUZPLHQbUxOv5ykYkCQkneMxyfVhKK1/Jk
         vq5UT4ktYrDf9+JBW1kv4VTNBDbobv0lhNx0zv40zIqfwMA0aM8Z2/cPWEldmDwcR2Ki
         atmQ==
X-Gm-Message-State: AOAM533diaov5XactNqP9TWrrEfxHrCnG01d20jzBdotMh9xfSuWDVcg
        C6Fiz+nEecrFftNnfkTe/bYebJ+GbuPF2A==
X-Google-Smtp-Source: ABdhPJxtgX564pix25H9kwH3mcx/vJ0zAtefC5+MmoBiaMug6M11t3PST+HXIrcYconFIykj/dAvuA==
X-Received: by 2002:a17:906:314e:: with SMTP id e14mr48178775eje.165.1636973158618;
        Mon, 15 Nov 2021 02:45:58 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:45:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 00/15] libtracefs dynamic events support
Date:   Mon, 15 Nov 2021 12:45:41 +0200
Message-Id: <20211115104556.121359-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtracefs logic that works with ftrace dynamic events is unified
and capsulated into a new set of dynamic events APIs. This change makes
the code more consistent and reusable. Also, adding future libtracefs
support for uprobes and eprobes dynamic events is simplified.
The existing library APIs for kprobes and synthetic events are
reimplemented using the new dynamic events helpers.

This patch sets depends on "[PATCH v2 0/4] Modifications of some 'hist' APIs":
 https://lore.kernel.org/linux-trace-devel/20210924095702.151826-1-y.karadz@gmail.com/

Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

v7 changes:
 - Introduced new eprobe API.
 - Changed allocation of a new dynamic event, to use old ftrace interface
   files by default without a check if they exist. That change allows to
   allocate a dynamic event even if the caller have no ftrace permissions.

v6 changes:
 - Removed "instance" parameter from synthetic event APIs, default instance
   is used.
 - Fixed "make doc_clean" to not remove the sources of sqlhist man page.
 - Coding style fixes.

v5 changes:
 - Improved parsing of dynamic events files - added ' \t' as delimiter.
 - Added TRACEFS_DYNEVENT_UNKNOWN in dynamic events enum, which is used as
   error return by the APIsi.
 - Renamed and moved tracefs_kprobe_info() to tracefs_dynevent_info(), as
   the API is more generic and not kprobe specific.
 - Added unit tests for synthetic events APIs.
 - Fixed bugs in synthetic events APIs, related to dynamic events.
 - Coding style fixes.
 - Man pages clean ups.

v4 changes:
 - Redefined the dynamic events enum, so the items can be used in a bitmask.
 - Reimplement the logic for parsing dynamic event strings from ftrace files.
 - Coding style fixes.
 - Added more comments.

v3 changes:
 - Exposed dynamic events API as official tracefs APIs.
 - Removed kprobe specific APIs, that duplicate corresponding dynamic events
   APIs.
 - Updated unit tests and man pages with the new dynamic events APIs.
 - Fixed typos, found by Yordan. 

v2 changes:
 - Removed triple pointer from the APIs.
 - Reimplement dynamic events parsing using strtok_r instead of strchr.
 - Coding style fixes.

Tzvetomir Stoyanov (VMware) (15):
  libtracefs: New APIs for dynamic events
  libtracefs: New APIs for kprobe allocation
  libtracefs: Remove redundant kprobes APIs
  libtracefs: Reimplement kprobe raw APIs
  libtracefs: Extend kprobes unit test
  libtracefs: Rename tracefs_synth_init API
  libtracefs: Use the internal dynamic events API when creating
    synthetic events
  libtracefs: Remove instance parameter from synthetic events APIs
  libtracefs: Add unit test for synthetic events
  libtracefs: Update kprobes man pages
  libtracefs: Document dynamic events APIs
  libtracefs: Do not clean sqlhist man page source
  libtracefs: Introduce eprobe API
  libtracefs: Add utest for event probes
  libtracefs: Document eprobe API

 Documentation/Makefile                 |   3 +-
 Documentation/libtracefs-dynevents.txt | 264 +++++++++
 Documentation/libtracefs-eprobes.txt   | 189 +++++++
 Documentation/libtracefs-kprobes.txt   |  94 ++--
 Documentation/libtracefs-sql.txt       |   4 +-
 Documentation/libtracefs-synth.txt     |  26 +-
 Documentation/libtracefs-synth2.txt    |  40 +-
 Documentation/libtracefs.txt           |  20 +
 include/tracefs-local.h                |  18 +
 include/tracefs.h                      |  68 ++-
 src/Makefile                           |   2 +
 src/tracefs-dynevents.c                | 709 +++++++++++++++++++++++++
 src/tracefs-eprobes.c                  |  56 ++
 src/tracefs-hist.c                     | 163 +++---
 src/tracefs-kprobes.c                  | 508 ++++--------------
 src/tracefs-sqlhist.c                  |   6 +-
 utest/tracefs-utest.c                  | 592 +++++++++++++++------
 17 files changed, 1980 insertions(+), 782 deletions(-)
 create mode 100644 Documentation/libtracefs-dynevents.txt
 create mode 100644 Documentation/libtracefs-eprobes.txt
 create mode 100644 src/tracefs-dynevents.c
 create mode 100644 src/tracefs-eprobes.c

-- 
2.33.1

