Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE483C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 10:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhLBLCx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 06:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbhLBLCw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 06:02:52 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82972C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 02:59:30 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x6so113968315edr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 02:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wHfy/23Vp0zKO0QB+NljeS/xqAJo4SgOBJ0UeSehJGU=;
        b=a9ATiyXRt8tS1pUcmJaVYsmcPeGqpgjpxwSBqrYdG611Ore5hgExGFYsTFSaq1tDZo
         jflwDqLsCXFVVOJ28tQGNFgSrDqql6mYKVUGDmb9HsLhdZ3G6q72bruGCNmeXt0R2MzG
         MAybmVyV8VXJGLc0NJPV9sZpDMWrKSjbmgRtS4hCVZGkA4uYaV1N9v7xHLWfg3UuAb6V
         ysQi3nd+6VWX03BQeM/VaSM2mNUrmWHrHbRRxbmpYFQ6l1ljq1humaWlzbudw49FAotK
         maechfD1tTDQmluF+Pnk2qsXODlZsXe8tlaEZCF4BRPNKrJixzISoq1ST5oYuoyzZ9rB
         AOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wHfy/23Vp0zKO0QB+NljeS/xqAJo4SgOBJ0UeSehJGU=;
        b=UZpDB3t7eA2r/K0jr90H+WXjai+SQJocouH6dOVaFXSryTC6qKrtYEC4Kk9Cek7VX0
         TF2+VoOAXW9RB1e40AvB7IVvE/JyGJtxztY2i+A/7esKn4p4fyKA0zrJhCtYbvJkSObW
         up8gj4lbv5Z9Ro/KF3AC9dGa5U4Tm8r6+DB8XuA1jpBHxPXDlJAha7ecaPDyMRrz0ZFa
         v9cwEkP0YfYXPsTptCXS3wyvFQg87aaaBOErhXTua1rB8wGTwvnKuP+OXaseNfkN5fmA
         MS1lcjHKWPg2MuOnXMq9H6EI7FaatqhLgD/yOCxQCj4FkiCRlUN79QLiF4IWt0D4i9AT
         8rnw==
X-Gm-Message-State: AOAM530rP7phvMqhrf5WspJu0WZJEwom69plCEbaZWb2tB4aOgFBy9JM
        s9fxvZcQDuiB2+9M5KfKdzyGsAL51TKOFw==
X-Google-Smtp-Source: ABdhPJwwQfuz0m9Z9U+hGLQNVXf91pOSjQiyhbVzl58C0XotMa9cXCVCXbJW5b7H3O56wDRgQTBaew==
X-Received: by 2002:a05:6402:2026:: with SMTP id ay6mr16647798edb.202.1638442769142;
        Thu, 02 Dec 2021 02:59:29 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e19sm1852930edu.47.2021.12.02.02.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 02:59:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/4] New tracefs APIs
Date:   Thu,  2 Dec 2021 12:59:22 +0200
Message-Id: <20211202105926.32581-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Two new library APIs are proposed, to provide a missing functionality:
 tracefs_dynevent_get_event()
 tracefs_event_apply_filter()

v2 changes:
 - Typo and coding style fixes.
 - Improved logic for dynamic events loading into tep handle - avoid
   duplications.
 - Added a check to tracefs_dynevent_get_event() to not return tep event for
   removed dynamic events.

Tzvetomir Stoyanov (VMware) (4):
  libtracefs: Reuse logic for loading events inside the library
  libtracefs: New API for getting dynamic event
  libtracefs: Unit test for tracefs_dynevent_get_event()
  libtracefs: New API for applying filter on event

 Documentation/libtracefs-dynevents.txt | 13 +++++-
 Documentation/libtracefs-filter.txt    | 12 +++++-
 include/tracefs-local.h                |  5 +++
 include/tracefs.h                      |  7 +++
 src/tracefs-dynevents.c                | 33 ++++++++++++++
 src/tracefs-events.c                   | 26 +++++++++--
 src/tracefs-filter.c                   | 18 ++++++++
 utest/tracefs-utest.c                  | 60 ++++++++++++++++++--------
 8 files changed, 148 insertions(+), 26 deletions(-)

-- 
2.33.1

