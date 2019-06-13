Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A666EC31E45
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F567206BB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbfFMPg5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:36:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39106 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFMKPH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 06:15:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so9478727wma.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jun 2019 03:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qsGd/QPHNBtkqNjchfgpG47zipCbmywrv3Xk/NDERaM=;
        b=a9Vzi1cTlLLZg9FCMjJblSopWRUrt0BnINT+hTTNs+PoOBJSPJQcbmuluzfniofd8p
         I6gbXibrW304/CE3GQJIiYWMG8ujl8HevsAYGXuQdJYlDyDFQyYIk2QT8MAPSBfbKoLP
         E49aFxuPqhJetaZGDvy+hlKX8D045kDwY5Mo6fkCXXM0zcd659Cb+M4jY4GnjdmpVVUw
         LxEjY1N+/RPkW+kPZEEeiMwmbx2ZL/laS1MGd7NwQxJEkgw1GxF7UbDrxT7Q1tzGiYfO
         t/EIcIwG7hBBWwSpRTrFzkl5Pm5YiUFRWLco4aCq2WVq/1D+VQobTlGnYLYhZs+NT3Zu
         0Dcg==
X-Gm-Message-State: APjAAAVR79pJ/rEV2zAGMw7AeFk8QacRSPmzmbEPqvxkFmY7jGGdWAf1
        0gPJaW+OTxWcm4uFgHm74Qf7FZyY
X-Google-Smtp-Source: APXvYqxPliwXuJxbazTf4W+PtgFwXM8mD/7tqrVBCb8/faQQ6dbVL2SLEYjg6Y8ccXOBcaH3VIAigA==
X-Received: by 2002:a1c:67c2:: with SMTP id b185mr2923821wmc.98.1560420904807;
        Thu, 13 Jun 2019 03:15:04 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t63sm3106418wmt.6.2019.06.13.03.15.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 03:15:04 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] Changes in few libtraceevent APIs
Date:   Thu, 13 Jun 2019 13:15:00 +0300
Message-Id: <20190613101503.22105-1-tstoyanov@vmware.com>
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
   ~/.config/traceevent/plugins/ to be XDG compliant.
 
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

