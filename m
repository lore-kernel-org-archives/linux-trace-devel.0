Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46790C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E94661448
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240388AbhDUOw1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbhDUOw1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 10:52:27 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAEAC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:53 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id sd23so55280915ejb.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5rwA5gSAZYc9QvGeEIZsoD7zKcBz3wqY7xubrttjbZQ=;
        b=uWYQTvLzAhbKIK48yy/mU5/giZoumA6Dbgnud3P0tSHngQvVJvTnp5ZtE1PiEOU6oT
         /2o5wPr4mgnilDUcjtdzeBuRZSBapfWKPgUzy0WD35j11SpaZJhkUlKumQ83IGaEnFvM
         FPvNuFHvmoS7mrjpWT0H3eDdSK4Ntd25+S5YdHh81Ckkp/32lIjbl5M/LbEm2KGv/3ao
         EEcqeR3fzQEdLeaG+6XOSlM9AVkRN8M8+qYhnvAiGjSViUyPGj0nfjvIcL2egta38epJ
         IBfNQ3atMbA4VOjz1IjkJtJUMRgMRkSYcXCy5a3G2aAaalFNF9WIRI/axX8EFB3OvANa
         lwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5rwA5gSAZYc9QvGeEIZsoD7zKcBz3wqY7xubrttjbZQ=;
        b=e7Zje39OtQKFrBBFhQfbTL/SN6uoA8EyADWNpgEtny6xhviZKTYdXhklTOBgytFVLl
         9hP9wipptWHw2v5a0ToRTnroRIdcYz9tJlBW4Mw7kgrctBFu2+LskieR3VBu8jE7E3+y
         Vu8/zZYhUSe4bsDfulmgQHqkH2k55UlxLBtyQDOTqdwNO4KdUSL5oIzCjLSS74zZrXZ2
         flCdGm1yuZvFaEkd9AklpAsHwUm4DdATaKcnFCyESocBIcxpWl6Cvd6TFNa8ozjETwsQ
         4X1lIbBq0v8A8e8poYCeuxLtJYACmtGo2tisk9OrhtTFkAdd2HWGNqFdjOIW818CKUK2
         eqvA==
X-Gm-Message-State: AOAM5306w0pqUn48/yBpXkfGqroLlVvGXIzf1yMNPf8zmXPam/0NS4pR
        n6ovhQej4iQTc/5fCR3C/huuE0dXJmo=
X-Google-Smtp-Source: ABdhPJwOCoDineB+Zfa8EBu6M2CU6RzIPq7Y2WkeIsrh7YkZ7SVcOS+tvMjHPQFfRNBes2EADclA/Q==
X-Received: by 2002:a17:906:6a41:: with SMTP id n1mr32517140ejs.401.1619016712342;
        Wed, 21 Apr 2021 07:51:52 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id ke14sm2730325ejc.1.2021.04.21.07.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 07:51:51 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/4] Various minor modifications and fixes toward KS 2.0
Date:   Wed, 21 Apr 2021 17:51:36 +0300
Message-Id: <20210421145140.95517-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (4):
  kernel-shark: Fix warnings from deprecated Qt APIs
  kernel-shark: Polish the README file
  kernel-shark: Exclude libkshark-plot from libkshark-devel
  kernel-shark: Integrate install_libkshark-devel.sh

 README                           | 42 ++++++++++++++++++++------------
 build/install_libkshark-devel.sh |  6 ++++-
 src/CMakeLists.txt               | 13 ++--------
 src/KsTraceGraph.cpp             |  9 +++++--
 src/KsWidgetsLib.cpp             | 14 +++++------
 5 files changed, 48 insertions(+), 36 deletions(-)

-- 
2.27.0

