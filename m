Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D543DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 14:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbhLGObz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 09:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbhLGOby (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 09:31:54 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3618AC061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 06:28:24 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso1892520wml.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Dec 2021 06:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OCre06G035wk5g1k4l4RXHc7ygzrV8//BpmCk99wP8U=;
        b=eHbkObiMo+qL2TIm8zNpivIGOv5FOkK0ALeXq/5aSRCLGIV5uG4HV63fisnMruVULO
         IKu3p9zAKY0DhsoYg2SBG0I4Yja/FNaBSj83df3kx7GFOubUYZ4rP/Axc9iP7Wyxg8RA
         ftOzGzbnYzscrnSdHWAixdoortHdRARg+Lf8Egp0uv11m0fyv/owvogH7eMaEGSwDoGG
         ab2ATxAGy33CFe25FPZBxXynJQrQoWHJ3WelnePQ96LARkIdAji2XTdefdnksgsmTdEM
         ONXbFrDMuuq8dghfxiOEVe8HE0aRWRWbaq1jhp4gkb9omFV3Ozt4C0+CCqhHLOsE8L0U
         UWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OCre06G035wk5g1k4l4RXHc7ygzrV8//BpmCk99wP8U=;
        b=Wr1RGPEKHL8PawNoHvuIKAnkm+fp56lfQNVmcqXIM6Mnd933BKBqrdB4lhuTCalwn4
         IPgr30pm94279rSt7dP/vbo9lyUmBeDbBnlFBS3WlIAux3qc81WZ8K0KaMKfgiZYUL2i
         9xLTT6d91rASdfb3AF7iFBfw9YaKQr1O4oyb/AiroI/I8pbMHIekrppcgx+XKtYdNLg7
         sgG1lyUd9C69s6HPt+yfeYaUNIOdph8W3oSBOVxPlbZLM06dQnx5Ye3qOkcY+ob5qOMU
         s9pNPi6r8Z0WPFaKVipaW34+qthPCcg/J9t6Rxb/uHHHPW6PcpKZK5NYi3SBsscyxCw9
         ceOQ==
X-Gm-Message-State: AOAM533JT8aeBZe2mwd9IMZpZuv8yWe7Rv1gIPJifKIJY+xjf5VDH20T
        450mE7IXam1AB5LcxXoBmZ+ZrbRvCmA=
X-Google-Smtp-Source: ABdhPJyaLBFlj+XAyS5LXY/G/rxpoDuXTc4OKbAK1nQ7OYFfnNbnJ84WDXYvDsAKjrIvsUF1KFNbNA==
X-Received: by 2002:a05:600c:3586:: with SMTP id p6mr7447129wmq.34.1638887302709;
        Tue, 07 Dec 2021 06:28:22 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l4sm14301428wrv.94.2021.12.07.06.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:28:22 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/5] trace-cruncher: Kernel histograms
Date:   Tue,  7 Dec 2021 16:28:06 +0200
Message-Id: <20211207142811.398929-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adding support for trace histograms. Only the low level wrapper of
the libtracefs APIs is added here.


Yordan Karadzhov (VMware) (5):
  trace-cruncher: Define Python type for trace histograms
  trace-cruncher: Define constructor for trace histograms
  trace-cruncher: Add APIs to setup a histogram
  trace-cruncher: Add APIs for histogram control
  trace-cruncher: Add kernel histogram example

 examples/hist.py     |  66 ++++++
 src/common.h         |  10 +-
 src/ftracepy-utils.c | 526 +++++++++++++++++++++++++++++++++++++++----
 src/ftracepy-utils.h |  32 +++
 src/ftracepy.c       |  63 +++++-
 5 files changed, 650 insertions(+), 47 deletions(-)
 create mode 100755 examples/hist.py

-- 
2.32.0

