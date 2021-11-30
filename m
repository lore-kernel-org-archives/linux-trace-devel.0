Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E981C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Nov 2021 14:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhK3OjL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 09:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbhK3OjI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 09:39:08 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3F5C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Nov 2021 06:35:47 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r25so22240652edq.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Nov 2021 06:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n+t7Ue6wICUgtFKhem2z0TXGHcx1fJ0BLEL+F4MpOiQ=;
        b=bM7ioqDpODiJgfvdb4FUWZObsPZem7zih8FvXK2FzrKLwS4eC1KUM+pezvytQuTW6B
         yCVIPeCk6lDIwrLBlHMNjZ7Lk/p+slCAEHQsnz2Jqh6gzYmW2pGklUKWdu6fqHMtEg0C
         92t9jX1dUauJ9iv3108gdvYIYI8BbOSSojsmaaps5twu5gmugkrlZMt895lpgDmxB+E6
         dHmqyWpItBjkYUyz9N7W+rxcdejlWlEEikVomueIXsDCBFiFbh+vGoJ5SubJ9YQv9EQi
         XL+XoEF25O2Fj758FyhZEm7+IJvIN6UKKaQv+Wuii3txmFB+lKmjEl4wWsPwX0Hyr+zs
         tWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n+t7Ue6wICUgtFKhem2z0TXGHcx1fJ0BLEL+F4MpOiQ=;
        b=JTA/Exfm5GvPa8kGEKi0kFtKTaQOlAK+dNmvwVpdh+lccoEag/PZqovaS5pBEnPaxy
         4C1+AGxQ1tZAvi39qVcq0Kl+GjQu3LMFMOAoLM800mgV4qHFs5JhTxFt3tWTI2UE9LPd
         BQ9Jsp/Ck4LLNHxmK7Fu6WHlrTA01j45DJ/+OfhqzRM+xYcD0XyTsmzEhJrAMPC+pg/y
         TaR+EyaJ4RgnsU834MCwljsTJIPHgk8DCrJIIsWrY32nkHJGt4T5GTSVxd7KvJWzHAo5
         Jm+ZtLxpQSPzVx4CiuvQWPUGlghEO/mxwArO3Ge+nqg4zlG+gLBgxq1mwhldaCe+xBPN
         rv8g==
X-Gm-Message-State: AOAM533ZVG/SnJfIDfciPtgTJdXHqKn56eh3jPachR8loDXb4we8mHIR
        RzZUTdQhRMRbr9meCGS/HPIGrGVPMY4=
X-Google-Smtp-Source: ABdhPJzQLWlPnFECyUagncblLKaI4CAs1fUa/cXfLhOOL5SeopA14eNfIR47PhY1+fTYU7gMM5IIaA==
X-Received: by 2002:a17:907:94c6:: with SMTP id dn6mr68069390ejc.490.1638282945474;
        Tue, 30 Nov 2021 06:35:45 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id de15sm9105940ejc.70.2021.11.30.06.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 06:35:45 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/1] libtracefs: New API for clearing filters
Date:   Tue, 30 Nov 2021 16:34:21 +0200
Message-Id: <20211130143422.127433-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch applys on tom of the 'New tracefs APIs' patch-set.

Yordan Karadzhov (VMware) (1):
  libtracefs: New API for clearing filter on event

 Documentation/libtracefs-filter.txt |  7 ++++++-
 include/tracefs.h                   |  2 ++
 src/tracefs-filter.c                | 14 ++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

-- 
2.32.0

