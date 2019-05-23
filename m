Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257C6C282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C6C20856
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbfEWPKA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:10:00 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:39802 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730757AbfEWPKA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:10:00 -0400
Received: by mail-wr1-f54.google.com with SMTP id w8so6695327wrl.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KFXMBMF9Pfbf9z8zlKTJWxwIcWRJeoKrBHkuCWvrdgM=;
        b=iroRnkqbJFs7uzNQy8SvmyNm4cZQwuCQ8jhf0ODzz0DZNlKWna8Jpb9aB5b5Dpgc/h
         M/nqYwyJoxq0jGdIbpKNnvTui7zX1dmhTAEI9ZHLdKDrSd5CkxvxZ2anWiOKVfGtjEpA
         YyIfIxtfaVYLs/5M/i4NEYZr4O0khosffZLiHtDzuGa1nscNG/9KXi5HiqorVXHXgufn
         p96xaud7ZF8zTCvDoWzOfukjmfIEP8Zw7UMcF0MjJrBeAYWOdmEWzZZngSuPV4T7GpO6
         rTQl+gD1Ha24/D/S4CJBsoqceNu4iBa+96d2JyHLrKM/uP5ezzYvVOrX/p/3vBmK4g5D
         Byyw==
X-Gm-Message-State: APjAAAWd1V3BgT/czdKZ1ZGkSHRLA6gHHg7wPm065T/5/AhEZFy2Z4vK
        o3HTIrVhzD/0lHNSWErj8zU=
X-Google-Smtp-Source: APXvYqxC7ock9bheoc+BOiQM1FNxZrCUS+BR1+S/T1JD400LK61kVUvYAyznDXz4rLhY67x7xk3zlQ==
X-Received: by 2002:adf:efc8:: with SMTP id i8mr10409801wrp.111.1558624199068;
        Thu, 23 May 2019 08:09:59 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k63sm10721996wmf.35.2019.05.23.08.09.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:09:58 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/3] Fixes toward KS 1.0
Date:   Thu, 23 May 2019 18:09:43 +0300
Message-Id: <20190523150946.30769-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (3):
  kernel-shark: Add Doxygen documentation for KsGLWidget::update()
  kernel-shark: Handle properly the negative error codes when loading
    data
  kernel-shark: Correct memory management when data loading fails

 kernel-shark/examples/datafilter.c |  6 +++++-
 kernel-shark/examples/datahisto.c  |  6 +++++-
 kernel-shark/examples/dataload.c   |  6 +++++-
 kernel-shark/src/KsGLWidget.hpp    |  1 +
 kernel-shark/src/KsMainWindow.cpp  |  9 ++++-----
 kernel-shark/src/KsUtils.cpp       |  6 +++---
 kernel-shark/src/KsUtils.hpp       |  4 ++--
 kernel-shark/src/libkshark.c       | 30 ++++++++++++++----------------
 8 files changed, 39 insertions(+), 29 deletions(-)

-- 
2.20.1

