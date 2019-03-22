Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0647C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A922213F2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbfCVNHp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:07:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33886 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbfCVNHo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 09:07:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so2312507wrq.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Mar 2019 06:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iaRvDBHqnZBW4e02/QyOJ9vffjRD5V0TZjqzEQAkTIo=;
        b=ZcD2e9ZGlDAOLitquEmLx1rTiCgr9uiJ6Edi3QIpqYR3+eCEedBykk39aaJ3qNe95g
         FguYy4TCZuWt50H8JcqCzKuU5L+ZwHqaIUVFzUKphe5yx4m/hWdru6WiGebP9L5HAC7Y
         Vus/TAQ6sR0bUDOGE+bW6PyBFt+pvXdl/3zg43agGASJV71/hAR9O1mx8rJ6CgzOzoGU
         cuBzy6/uwW5dKARTfANy0diqIMfs6/dRmueUDSwWjjH/vZDWTMLXwP6x2x55ggKbJCwR
         uzuIoUe1Hk7jo8HhcAm0lAphJk4axdxse6bUS7A+XMmlKWwbL6/klm1/GVt12xQc4qA7
         dv6g==
X-Gm-Message-State: APjAAAXLaVnh30Qk4qaUGL0UUssIjHNB5HMq+7JPfPcMZnYJRxm3lpOB
        CxmH8NQqEqo6CDd0tKe2VGTnyHOV
X-Google-Smtp-Source: APXvYqzZQAevnlf3J7CV2i6sS5OGz/gViNdhQlQPv1MGIlHPW2PkLYOIPsZ8cwa+usIdVRLxdwoNrQ==
X-Received: by 2002:adf:82c9:: with SMTP id 67mr6664721wrc.261.1553260063757;
        Fri, 22 Mar 2019 06:07:43 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 204sm13010466wmc.1.2019.03.22.06.07.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 06:07:43 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/3] Few patches, related to libtracevent APIs
Date:   Fri, 22 Mar 2019 15:07:39 +0200
Message-Id: <20190322130742.13753-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset introduces new libtracevent APIs, which can be used for
accessing struct tep_handler fields. It also changes the description
of few APIs, to match more closely their logic.
There are also fixes to coding style problems, introduced by previous patches.

Tzvetomir Stoyanov (3):
  tools/lib/traceevent: Change description of few APIs
  tools/lib/traceevent: Coding style fixes
  tools/lib/traceevent: Implement new traceevent APIs for accessing
    struct tep_handler fields

 tools/lib/traceevent/event-parse-api.c   | 184 +++++++++++++++++++----
 tools/lib/traceevent/event-parse-local.h |   2 +
 tools/lib/traceevent/event-parse.c       |   4 +-
 tools/lib/traceevent/event-parse.h       |   8 +
 4 files changed, 167 insertions(+), 31 deletions(-)

-- 
2.20.1

