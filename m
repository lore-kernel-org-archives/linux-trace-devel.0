Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621F4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F9F661252
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhKEMTI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhKEMTH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 08:19:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1140C061714
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Nov 2021 05:16:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d3so13397708wrh.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Nov 2021 05:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2YZdjHAOK34RLo+HIUn5olfgK6tPosBRubU7CBHySs0=;
        b=fJ+OE80inUQO3LGat4b/sjH1M6nqVQIKKPIZ3vEuLH1a1iIDrKNi/tCrEAC5rYlUCa
         O8hzUpL8KZX8QISA1DXhpCE5YQAKWY2HWbmj8hYdUbBTKWnHadtwFDZXP4p9epePCh2u
         RDBjmHluDeOCKa2RjdpNxcPbvN8Htb2h5XxdNBBzuBeP/lHaXx5yCs/k1lgWPZxJ6IXz
         B2ATYbnFEdHIq6zgKO1CV+QMncazynQaNeS3KZekAzrGL9X0CtNPKxPyRUedxo/0pWPS
         yrBoWCp1w2HfL9VH8EAkNuS3LLZ6kZKKyFJuy37wY1p6maacVpj3LZjPX+MWGT2LoRMq
         LJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2YZdjHAOK34RLo+HIUn5olfgK6tPosBRubU7CBHySs0=;
        b=GiRMnwMyNlwwuABAd7r4GvIYOwvu7EOzKaBKTU+5Qhknw8Lm5m3rt49ufb9lRJzg8l
         d54dp4XxOTtBRUFQdYfv6JtV6Ufxlz/Lr5JdTs9xzIrpb7BB8L23krofcf+0kAJa3gUj
         MHFjyeWPGKJtkBbpE9V2jdYdd/oF8304xzDnCWmcO8JeuGSkAnBu/+/9Nbysu0nAazXV
         Zd0DkHCndX2WfFTS/E2JWX+2PEqWut7koIRzbZz31pnR6pWQvj9IB3lWkbI6xaRRGALc
         W3xUWqGcP5woO4vnQjz52WwJzrfYyV5G2PRRd6uQtRALk77ADQ+N6yVN14V+Y5tGl9Td
         LBqw==
X-Gm-Message-State: AOAM531ZuHBzwmZJHay7AvbhtSdQB9tTlx3VmA1rd0WeL/tATS2yjLKv
        zwzYtvEkNXBxbbxgxMEIWpo=
X-Google-Smtp-Source: ABdhPJyFrSvBrzO2c5t0AISYYeB8VdD/78PmP8QMZxV/Md0CZJcOjArK9ylVkMKM605XOLC7nIuxJA==
X-Received: by 2002:adf:f551:: with SMTP id j17mr71465878wrp.392.1636114586350;
        Fri, 05 Nov 2021 05:16:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x13sm7936531wrr.47.2021.11.05.05.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 05:16:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 00/12] libtracefs dynamic events support
Date:   Fri,  5 Nov 2021 14:16:12 +0200
Message-Id: <20211105121624.398717-1-tz.stoyanov@gmail.com>
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
  libtracefs: Add unit test for synthetic events
  libtracefs: Update kprobes man pages
  libtracefs: Document dynamic events APIs
  libtracefs: Remove man page compile artifact
  libtracefs: Fix duplication in synthetic events man page

 Documentation/libtracefs-dynevents.txt | 266 +++++++++
 Documentation/libtracefs-kprobes.txt   |  94 ++--
 Documentation/libtracefs-sqlhist.txt.1 | 351 ------------
 Documentation/libtracefs-synth.txt     |  20 +-
 Documentation/libtracefs-synth2.txt    |  14 +-
 Documentation/libtracefs.txt           |  17 +
 include/tracefs-local.h                |  18 +
 include/tracefs.h                      |  55 +-
 src/Makefile                           |   1 +
 src/tracefs-dynevents.c                | 718 +++++++++++++++++++++++++
 src/tracefs-hist.c                     | 127 +++--
 src/tracefs-kprobes.c                  | 508 ++++-------------
 src/tracefs-sqlhist.c                  |   6 +-
 utest/tracefs-utest.c                  | 518 ++++++++++++------
 14 files changed, 1634 insertions(+), 1079 deletions(-)
 create mode 100644 Documentation/libtracefs-dynevents.txt
 delete mode 100644 Documentation/libtracefs-sqlhist.txt.1
 create mode 100644 src/tracefs-dynevents.c

-- 
2.31.1

