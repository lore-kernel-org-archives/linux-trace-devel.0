Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78603C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A002611EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhKDLN3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhKDLN3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 07:13:29 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9D3C061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 04:10:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u1so7948694wru.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 04:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCk5mlw9gOQ3UDUYQ6cDz720kfs4w9mmZW8S/cVgRoc=;
        b=Gcmrl+wmxxYwzvWgljIFZYpjVKAtg0YLtvrco8sNdIyI1fEk67d5Kq9weX9QWI9cBn
         v4BvfxdS57xI0zeO4Ot7MmeX1Xwny2qDsHMJHTJlkh1vEOwTLoBgABnT0D8oNcrysZ2i
         pl7FJoNp8i3SQAZJ7DOMCzPOmhODfS1/Ck544DjUEXJgL2++2hmQ6dtoB8/DjtmUx+Xb
         saiprHkUI39SyQX1T0g/DOMKGwlUxbuXJoa7u6+EZBtn7kb9maCNC/pjFXAd+/BYciL6
         6SppXI7aA3R/jytopO6rxpoDI3uWfY9lLkTrQqxSbyUdIbXQr3TFqqP6oAP9yYfRNBKl
         oH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCk5mlw9gOQ3UDUYQ6cDz720kfs4w9mmZW8S/cVgRoc=;
        b=zoz/MmIL48x4O40MPiisL/kg4z0ADBy5HVvidACEF2ZeFulOlKIzzL14T1oJAyygIH
         vEf1/bMukBpa0iCm9HbvsRAydfqI6nkbHQ5qLyFPDcIGwMVBybNHgOYSGqlqwwoBVf28
         +kZy3Dz6iTRwEJ31ruYUJ5l8lNL56M7PcRmDpCl8ubcW2xHIaZLfVSNMzUXBFSqsL10E
         kEbda05ZdcP3MjAc/ORUqMNjuZw6MGwk26glRoZgKmFCow9Cp5XRp7IWctrPpXHigeS4
         Ok3SnvhRteFkKrm6WXPE4zFHlDJ8+vTFrEYga+BVnnGp7HoZ1atkl2rnnBbHO1o5ERRM
         tF5w==
X-Gm-Message-State: AOAM532bFBLRtGNtdssDGlPms3h21wnf5Me+FNCKrfPjL7Wr2736Bl0G
        tccqxoRZOFHhR+5mGkbZ+HM=
X-Google-Smtp-Source: ABdhPJxVGZD4AHApdQtduU3lYiTT+W6N2POj0vOYSkG75xRiVu5MQFVNV5/sG4WMCRnj7uUlNHdWug==
X-Received: by 2002:adf:f54c:: with SMTP id j12mr10176973wrp.20.1636024249734;
        Thu, 04 Nov 2021 04:10:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm5080843wrt.81.2021.11.04.04.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:10:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 00/10] libtracefs dynamic events support
Date:   Thu,  4 Nov 2021 13:10:37 +0200
Message-Id: <20211104111047.302660-1-tz.stoyanov@gmail.com>
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


Tzvetomir Stoyanov (VMware) (10):
  libtracefs: New APIs for dynamic events
  libtracefs: New APIs for kprobe allocation
  libtracefs: Remove redundant kprobes APIs
  libtracefs: Change tracefs_kprobe_info API
  libtracefs: Reimplement kprobe raw APIs
  libtracefs: Extend kprobes unit test
  libtracefs: Rename tracefs_synth_init API
  libtracefs: Use the internal dynamic events API when creating
    synthetic events
  libtracefs: Update kprobes man pages
  libtracefs: Document dynamic events APIs

 Documentation/libtracefs-dynevents.txt | 251 +++++++++
 Documentation/libtracefs-kprobes.txt   | 111 ++--
 Documentation/libtracefs-synth.txt     |  20 +-
 Documentation/libtracefs-synth2.txt    |  10 +-
 Documentation/libtracefs.txt           |  17 +
 include/tracefs-local.h                |  18 +
 include/tracefs.h                      |  54 +-
 src/Makefile                           |   1 +
 src/tracefs-dynevents.c                | 689 +++++++++++++++++++++++++
 src/tracefs-hist.c                     | 125 +++--
 src/tracefs-kprobes.c                  | 530 ++++++-------------
 src/tracefs-sqlhist.c                  |   6 +-
 utest/tracefs-utest.c                  | 412 +++++++++------
 13 files changed, 1535 insertions(+), 709 deletions(-)
 create mode 100644 Documentation/libtracefs-dynevents.txt
 create mode 100644 src/tracefs-dynevents.c

-- 
2.31.1

