Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF29C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 488D161208
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhKHIGw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 03:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbhKHIGw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 03:06:52 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2721C061570
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Nov 2021 00:04:07 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g14so58380816edz.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RU6Gz7rgyvqRpMIG5dMfNOaQsif5nHVaqT0uy7j7+Jg=;
        b=UFnuoRrSihXdgDRGlQNMrEQY722r8YnIwsmaVWZoq+UtBiLoLFAuL9MBhoEMscHjc0
         lIAKNGNqT5PqJpusM/1crvmaPtiFsEYeQqgAJ3+fK71VDivln6R1cz0zQqiW3Bp3LgRH
         YuzZgoCq3uFgFMquQ4azt3QkOh57KS9ob7+5DD+sXAxSKzTs2hNAC44Gb7J27zS784AK
         3PAnHLl3X0QftXCJqVyojImj7AnwI6uWZjXgVBRaxRm9weIYXwj5oY9xbDhtmknNmamN
         uLtU5yzH3EOTFJhLsOlj+1asYqZ0j57tTDpwg3kp/9N2/R5hLc8H6ZWN3ZNQCTRzq9Rf
         9avQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RU6Gz7rgyvqRpMIG5dMfNOaQsif5nHVaqT0uy7j7+Jg=;
        b=S9OvlkzMyRFHmK+VkDqZqDNKpT4k3DGDfie6lqdiu1JT08SkJBPQfx8HNfl5cvFOSJ
         rSGHW3iiNfOrgrKOZG9EyxkBJaawgsEsoHXxKDKx3kp3jz6C0mffOTXLU/1EwoRMm4Ht
         JeVAcFHunzjWjKQZF1pYiE22m6pkdjcVPJ/oLL6PVgNBVPr0NdL9DiLKcAn1kPbHzJTI
         /OuiWS6N2sJKLkwrpQ32Rxe+Vg8Ukxe7OtdpbXdYopTTdYc+77jD24yhFTEH6Y5bcHdj
         a1Q1ukufvlRku5BxJz4iqzFWKABvQRrNG88HV44CEurjVHEEtGkYCtKPbH90J4U7Zkix
         D4tA==
X-Gm-Message-State: AOAM5308fWwyQrZRtZ0HPpbWGyZ2M4wQZ25dAIRboLJbEXPs6KOGwsp4
        EDD275OIveaHqUZdyVzkApY=
X-Google-Smtp-Source: ABdhPJyMaSOdzWvq6uqRH84WEgCURG8fBP28HapARlvU1489tZeuHsUFNaQO5yfD/dp3Ug2BiNVxOQ==
X-Received: by 2002:a17:906:bccc:: with SMTP id lw12mr27948466ejb.128.1636358646565;
        Mon, 08 Nov 2021 00:04:06 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id mp5sm7962309ejc.68.2021.11.08.00.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:04:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 00/12] libtracefs dynamic events support
Date:   Mon,  8 Nov 2021 10:03:52 +0200
Message-Id: <20211108080404.55814-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
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


Tzvetomir Stoyanov (VMware) (12):
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

 Documentation/Makefile                 |   3 +-
 Documentation/libtracefs-dynevents.txt | 266 +++++++++
 Documentation/libtracefs-kprobes.txt   |  94 ++--
 Documentation/libtracefs-sql.txt       |   4 +-
 Documentation/libtracefs-synth.txt     |  26 +-
 Documentation/libtracefs-synth2.txt    |  40 +-
 Documentation/libtracefs.txt           |  17 +
 include/tracefs-local.h                |  18 +
 include/tracefs.h                      |  64 ++-
 src/Makefile                           |   1 +
 src/tracefs-dynevents.c                | 720 +++++++++++++++++++++++++
 src/tracefs-hist.c                     | 163 +++---
 src/tracefs-kprobes.c                  | 508 ++++-------------
 src/tracefs-sqlhist.c                  |   6 +-
 utest/tracefs-utest.c                  | 528 ++++++++++++------
 15 files changed, 1676 insertions(+), 782 deletions(-)
 create mode 100644 Documentation/libtracefs-dynevents.txt
 create mode 100644 src/tracefs-dynevents.c

-- 
2.31.1

