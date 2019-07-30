Return-Path: <SRS0=vd9q=V3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769A7C0650F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42E692089E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qqgfp9mv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbfG3Muc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:50:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36075 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfG3Muc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:50:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so52428131wme.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Jul 2019 05:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S5a2YVMRCW+Z+dw1wvxplsWvb46M/BUItEreJpaKKig=;
        b=Qqgfp9mvBT/BOrNCOyJ/oGCaeD4Lt5aRlfHP48UKihPbIksRGGEVISxfR27HwqwQS4
         WtRdTvQPa8HNobx9xMyRGpL4PuiwbRN6ARfoe1tiCNIpdi4KJ4k73tkd3EUKQbfxucHK
         Judm5Xe9jOY2Zm7HLVgTbpT4smaKEjQnL5gFc7d9W+OSXh0vSlZOvOLtrRRw7fBof2Bq
         qJX02gEj+aLzl1LqniT3+oJgnvskjF0leToKjv8bPPQ8nkm+PeF5KdcN0Ota9Gd13C0S
         PFN3wdyJzlZB1IGlpxxIu1UetHxuy+hLAVCzFBrbe19DGSI32CcUQh2S0zQ1w1hBd2pS
         MjGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S5a2YVMRCW+Z+dw1wvxplsWvb46M/BUItEreJpaKKig=;
        b=i0sgZaNG9Lvdyq/N9pFB7OJNLzvctyjXsg9iYAGmQZR5ADzh4fdi5rqPzW0EmpdWFL
         /jVOOrexpjTCoaEp7DFfB6VnJlnEFqJetk4iq53EbSP4lhUocFho3RkrsIuZffPgz89f
         SKrDSYliitvdUJAn0ODPvSy4f2ta1AUxPUTPpInMM6AC5gu+jw3VMv/tvFwNhOk41QeL
         9cupM7G+Z4ch2RHJZJPRksxcnEWDGEXSfjEk+n1Pyx9ouQJCAbA4T5O/CbdTIMxcBhUz
         Az+oktlr6f9yxJ3mdmwUp3caQ4/QBa0OjAfFfE7LFZo7xGAEuGPDhpiI9i+9N/OStxlw
         s01w==
X-Gm-Message-State: APjAAAUBtADqyPCau6xSYufZj7/LdOPOeJDjkutUowCTX8RzsVBU6+di
        5Wrr2tIAX3KTv+i2aKm9iPEQNwmzf3Y=
X-Google-Smtp-Source: APXvYqwyg3I+90mNgh6pd6LHRb6d0Wa5M2xQNVy5IrxP77aosz/GjwBi93YbhC/q0LT2GxCfON3FYQ==
X-Received: by 2002:a1c:720e:: with SMTP id n14mr24432046wmc.53.1564491031544;
        Tue, 30 Jul 2019 05:50:31 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n12sm67577012wmc.24.2019.07.30.05.50.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 05:50:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/3] Changes in few libtraceevent APIs
Date:   Tue, 30 Jul 2019 15:50:25 +0300
Message-Id: <20190730125028.24789-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Before releasing libtraceevent as a standalone library, few
APIs must be changed:
 - Event printing interface is redesigned, to be more simple
   and user friendly. Now the tep_print_event() API can be used 
   to print various event information. All other event print APIs
   are removed.
 - Changed the user's plugin directory to 
   ~/.local/lib/traceevent/plugins/ to be XDG compliant.

[
 v2 canges:
  - the user's plugin directory changed from 
 ~/.config/traceevent/plugins/ to ~/.local/lib/traceevent/plugins/, 
 as suggested by Patrick McLean.
]

Tzvetomir Stoyanov (3):
  tools/lib/traceevent, tools/perf: Changes in tep_print_event_* APIs
  tools/lib/traceevent: Remove tep_register_trace_clock()
  tools/lib/traceevent: Change user's plugin directory

 tools/lib/traceevent/Makefile            |   6 +-
 tools/lib/traceevent/event-parse-api.c   |  40 ---
 tools/lib/traceevent/event-parse-local.h |   6 -
 tools/lib/traceevent/event-parse.c       | 308 +++++++++++++----------
 tools/lib/traceevent/event-parse.h       |  29 +--
 tools/lib/traceevent/event-plugin.c      |   2 +-
 tools/perf/builtin-kmem.c                |   3 +-
 tools/perf/util/sort.c                   |   3 +-
 tools/perf/util/trace-event-parse.c      |   2 +-
 9 files changed, 197 insertions(+), 202 deletions(-)

-- 
2.21.0

