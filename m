Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFA8C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E951F6145B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhENMT5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 08:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbhENMTx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 08:19:53 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96861C061760
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:42 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b17so34484634ede.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pIzHPXqbiAaEKSLBqogK8Sd1h6M0//+4RUcFlBIV+uU=;
        b=IJyuMQW5JN40BxY4pvL/yVjStmi+5qdW4BR6xH1ZgccKkiOPz+9QA7u77RsWvmivTb
         0LesLbamvAzvwDcaDqAxXFHTprH1qvRoSzqeZDEuUG/zTotkpHzq/ssFw9s6NvY59KOp
         def5x3N0eM31A1EOD7zqK09+Z2uwaacf2sugPDVTcjA3ENpr8SxI7DCxe6itu/ycDQW0
         XfvgJD/Pi8htjP7qsvueVrj7oB/CkGvYt8u+/Et2AlP4T+5sq7j95xs26RgJC5swroKD
         erUGdmRP/HqEifA0+ES/Syts5hK3EBCnNpSdBUN1i1xtt3EwaS3S/rsQNTIzqsppzvDu
         K3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pIzHPXqbiAaEKSLBqogK8Sd1h6M0//+4RUcFlBIV+uU=;
        b=mlwNFeBoB1GIWzHxK2aprb7aH75FJtdgYS3fO8mrg/j717mr6ef9KvJyeORu+xdid1
         AVZAx4o7gqTLyVOIca7XjARZDVnDS52kQXeavz5/oGm/TsZeAGIU1iQHE/B6Y5Wtx0ea
         5ppx/xwg02IR+rg0O7YcEns2AmvqYnxsmE52FedzVBonBe+eiW33Omkbp6lqHEIf0btw
         1/CxWiCiXFkayzhm1noWDPgWPNvf/TQ+/TF/85MRBxfPM5XY+wRx2XOyf4Ql9M+dt97E
         6RrUkO8gujr6eLzDNuxeBhvkisY8Q8NplzjlvHKecvaghzR+K7YpfA8Rs+M7wZ1Oaqwt
         endg==
X-Gm-Message-State: AOAM533i2PFoPo/iLCPXC7FVKxuIna9GvmjePv4/HZpKipp7K8CjQ3W+
        EGlxauDXugChZxUhU41zhX0hz2qVjFk=
X-Google-Smtp-Source: ABdhPJxbNefFdsyOyExAoyaO8YGu6i7A0qV6HdPsF4yCU3Rv0eNe+/+lx49xCkHpCGsK/mSplRY8/A==
X-Received: by 2002:a05:6402:19b9:: with SMTP id o25mr50621553edz.192.1620994721167;
        Fri, 14 May 2021 05:18:41 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id cr21sm3435157ejc.2.2021.05.14.05.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:18:40 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/7] kernel-shark: Do draw the combo point of the mark
Date:   Fri, 14 May 2021 15:18:24 +0300
Message-Id: <20210514121826.161749-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210514121826.161749-1-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The lines of the code that initialize and plot the combo point
are missing in the original commit.

Fixing: fc14e40 (kernel-shark: Add combo point to Mark)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index abef5f8..1d63a9b 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -680,6 +680,8 @@ Mark::Mark()
 	_cpu._size = 5.5f;
 	_task._color = Color(0, 255, 0);
 	_task._size = 5.5f;
+	_combo._color = Color(100, 150, 255);
+	_combo._size = 5.5f;
 }
 
 void Mark::_draw(const Color &col, float size) const
@@ -691,6 +693,7 @@ void Mark::_draw(const Color &col, float size) const
 
 	_cpu.draw();
 	_task.draw();
+	_combo.draw();
 }
 
 /**
-- 
2.27.0

