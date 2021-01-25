Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8A6C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Jan 2021 14:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B53C229C6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Jan 2021 14:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbhAYOHE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Jan 2021 09:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728718AbhAYOGs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Jan 2021 09:06:48 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44099C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Jan 2021 06:06:04 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id dj23so15443513edb.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Jan 2021 06:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0PglxEliH1nESE5JIMEkXDd/D+tTmXPZDHUjUhwL6us=;
        b=OraVoGdO0i3hjsW/LLkLZSTaUi6MAWYqattly9inhr2cNf17hvXeWL5qbTf7tEvMtB
         C5jz+qCYNT4I0pCoKnETHtGd8AbQA067XIp5sLqMPRPLByaBhF2p0l1gu+4zl+uUkyM1
         /kz3swBAGF2OfVVeWCAeAZWiG+6Kfr6E8DVsylkhL8lbDni6QGz3hxEWHj3ieFMFvY7V
         wUXFPtwH+JNUuebwktTcgAiCCkmHC/Lb4ujqj9jONy/2Tedukjaj1KzTVFWv+C+tbFuA
         mjV9QgtUlboxNjy/XVDG6l8pzH7N1AMduryKU2MjVI4x5ZLIJCszbhI+rbU9Jr51z58i
         QXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0PglxEliH1nESE5JIMEkXDd/D+tTmXPZDHUjUhwL6us=;
        b=IbZtpH2hv02PJQjOv7sUJsFJN2sJwKUf9WLtI0yvV4gADtqefGQhXOP4soQG+Up7Hv
         fVGXhaXkj3opN91yO4Y9QC8nxRsCUQjTOMUkVY7WWdE/h+wBoHy/GT95ggc/3O8uo948
         WUEgJrrisgck/TxlI3Fjo21zFnWAeHwk2Aq50nsjwRlgPvm8sTcj2dWy+s5jtEZ79GEA
         BdET/AV43CvEjkmApjOz/FlcbNpK/Q4sJNWUO+LFK3UggCVj5qoMhwUpiyop5rMlKXsh
         PmmCUy9/qFw3qRPn+mtoYkAsaO9E0EgfnxvqDDzCyLAE+Y94jIChuQFpfrppLpkMnFDM
         HrIg==
X-Gm-Message-State: AOAM532uzb/eq93V3+tDi4ybMcaVCkldb6aQVOfo2QdORoI0eHDaUAFr
        nwRfrCHOhqEF/MdQ1aaZl2c=
X-Google-Smtp-Source: ABdhPJzphKgA/KasoCZOgr/6AM9rxKWKZC06/mWpuqMTXXU5+AdPRzbkSb4Om8N7BSvk10U/7d3YkA==
X-Received: by 2002:a05:6402:1682:: with SMTP id a2mr648901edv.30.1611583562981;
        Mon, 25 Jan 2021 06:06:02 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.252])
        by smtp.gmail.com with ESMTPSA id g10sm8333484ejp.37.2021.01.25.06.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 06:06:02 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/1] kernel-shark v1 changed.
Date:   Mon, 25 Jan 2021 16:05:38 +0200
Message-Id: <20210125140539.1029915-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a KernelShark v1 patch. To be applied to the trace-cmd repo.

Yordan Karadzhov (VMware) (1):
  kernel-shark: Use mouse wheel to scroll the graphs

 kernel-shark/src/KsGLWidget.cpp   | 3 ++-
 kernel-shark/src/KsTraceGraph.hpp | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.25.1

