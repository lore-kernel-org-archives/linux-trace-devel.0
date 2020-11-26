Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4AFC63777
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51FE621D7F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nv0/ET6N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgKZH1X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 26 Nov 2020 02:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbgKZH1W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 26 Nov 2020 02:27:22 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E13DC0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:22 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r3so1017263wrt.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1jZMyiYXDVpE2b57fA2m4voUxgz5n5i6JgVLDNTClk=;
        b=Nv0/ET6NjhdrN8L9845voyoQCDWZjk4YY3w+lZOlSbA9ptUzW2l4697m0PlS/Q0bbj
         49ji0PMBtqBM5RbpzH2rpSOrpTP9tWkvphR0OBnuSIxgC45xJS4UudX+6ui5W3F1M7/A
         N4XYhbfuF+z0tyHcS79c2TnGsRryI6DMAy7on3zAT7fdGuUQ44PVtwrB16L9w/M+MJZ0
         5+eF+exy3EYcrRWQyiM693twEmMOSQWKvn9YpRyE9fThGPRmy/jyi6kBdDgYqVr3wVhh
         75vGpmmHXsFJo2TQo03iAb8C+gUHCafBcMV8Ml3QnD+VgtKkeKpByuReJLwXNKt5fnJw
         9FWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1jZMyiYXDVpE2b57fA2m4voUxgz5n5i6JgVLDNTClk=;
        b=NP5dDuDvIUE/lIrTuBxEYIxh51vNnh2/i4FsXNLVtkdO65Uc5Gmcm6Gl0qvAEPz+NV
         VcZot1/e+hRaGOEX0GHk3LZQZVpT3GAOEXABT4igN2Sm84H2kn9LidLGZqcy8xnyBmXO
         lYsmlmqaQ3u+1hj0hrwiofJWTB4f45+3IFm5aw05wVnhQy5C64KMi+6GFHk6TqCsRBz+
         cXA3mK4LZZNYOYYu9EH7AEYn/1IrTi1FCI+ORTLgOwJHmoyanx+xW6+iU8RUDfP5Wbi9
         TD8DmLQzjKNNxjrDiBP2JiY4rRQ7QSziAJN8EV8S0gEMUwY6vpetikahvS928VEMbAkt
         CM9g==
X-Gm-Message-State: AOAM5335oL4QqwOCD0nhVci4lJg3VztVe2MadZ7Bf9HSWqK0T5NGGwfa
        ZGDkNfu5C9j+ITMP8PK64lE=
X-Google-Smtp-Source: ABdhPJxK8UbIUgbLkxsp+xvVNO5d+CUgqUB1ak7mJ1Yc1Vmnu8LeanNZXHbjYdaGORUeh1qDjO8tKw==
X-Received: by 2002:adf:8284:: with SMTP id 4mr2011880wrc.386.1606375641325;
        Wed, 25 Nov 2020 23:27:21 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n4sm7269659wmc.30.2020.11.25.23.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 23:27:20 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] libtracefs install and test fixes
Date:   Thu, 26 Nov 2020 09:27:16 +0200
Message-Id: <20201126072719.906443-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>

Added support for pkg-config, used by library users.
Added library unit tests.
Made the installation consistent with libtraceevent.

Tzvetomir (VMware)  Stoyanov (3):
  libtracefs: Add support for pkg-config
  libtracefs: Add unit tests
  libtracefs: Do not install library in a subfolder

 Makefile               |  58 +++-
 libtracefs.pc.template |  10 +
 utest/Makefile         |  42 +++
 utest/README           |  15 ++
 utest/trace-utest.c    |  83 ++++++
 utest/trace-utest.h    |  11 +
 utest/tracefs-utest.c  | 588 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 797 insertions(+), 10 deletions(-)
 create mode 100644 libtracefs.pc.template
 create mode 100644 utest/Makefile
 create mode 100644 utest/README
 create mode 100644 utest/trace-utest.c
 create mode 100644 utest/trace-utest.h
 create mode 100644 utest/tracefs-utest.c

-- 
2.28.0

