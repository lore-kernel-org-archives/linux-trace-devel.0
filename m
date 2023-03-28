Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A15C6FD18
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 15:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbjC1PEg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 11:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbjC1PEf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 11:04:35 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D81BDBE1
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:18 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i5so51200519eda.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680015790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mmrW6mOjcWQcWsaREDo3IE8G5i4OCfpxfnni2DbVodc=;
        b=Tfv4m+mn1J1u3Bky3eiAKFFH4Gy+Pde5NajH+5KYrA31Aez38/VvgbZ2V6CE7coXkb
         6UoB4HZB+0JnFEtFuZfG/mZf0VJH0JVuj4YNEzBN+u0Blc+qbKhQnk/Hv7CMjsgFiL5I
         gEPVEIyuvyVmEjIQnLbhK2VFRE5xQukJU23wPxTv5Lyu0m7LWTueWkQ1FnKnKhNAZ0S3
         4HA/V42r+7gcr3GAE+k8iDGIcoA3YltP/ebKVRU/Xzp5ubYP3gjvtYiFk1FQJKbL31hp
         s+vqXjooy8m5C1iSXzCoAWJ3gyAnQeMaSS5iAKNQlIO+Hj2OOCUWn1oba4FV+0K+7H7p
         ydbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mmrW6mOjcWQcWsaREDo3IE8G5i4OCfpxfnni2DbVodc=;
        b=JnEw0QgFT9ycOffrjr2dqT7VH4cUNUisx8e4teSxjofUBkVqtC8Q8rgDoER4rxS/lk
         Sjb7U73pVkedQIYqCklijAPcICpL9K3XCZuBMIdQY1p+6XH44MoWEzfsrY8i1getAcfz
         ZKY1gOw4DUlx2DvyfMJLILWVjtNZ7pgVyBdzrk01P2NshYl9jCs1s7srTKZF/AEk6kTm
         xkJ7Ix3X9qn/ws1ZSLvABvgjvImWuXmk/LIMDGnkZaeSV5eyZM5aG47+1/8KvZE6r5mV
         bybIV7Ro+OEcdlk7rgcumL7Xw+/C3g+EcLWvMqJUwDyBRyLNuQzOUO5JgWG0P1UWweB1
         /GmQ==
X-Gm-Message-State: AAQBX9cWOVs6qX2bS26leCZ643loKUY3oFef4Q2mqMqLkf18xeVhtkEK
        7zqLk1p/GzBN/wNVwx7GvR0i/dY0TKw=
X-Google-Smtp-Source: AKy350ZD5uxhu/Wej/OUxuTXcJKwR1nBV+M5Tbm0EQlwY0IYGdEkIaH+9R/qXvjg/JOr5VeSvYQPvA==
X-Received: by 2002:a17:906:785:b0:92a:7178:ab56 with SMTP id l5-20020a170906078500b0092a7178ab56mr16619952ejc.39.1680015790408;
        Tue, 28 Mar 2023 08:03:10 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id c16-20020a170906925000b009327f9a397csm14799009ejx.145.2023.03.28.08.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:03:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] Introduce new API to reset ftrace instance
Date:   Tue, 28 Mar 2023 18:03:05 +0300
Message-Id: <20230328150308.34783-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API tracefs_instance_reset() for resetting instance to its default
state, based on the logic from "trace-cmd reset" command.

Tzvetomir Stoyanov (VMware) (3):
  libtracefs: New API to reset ftrace instance
  libtracefs: Documentation for tracefs_instance_reset()
  libtracefs: Unit test for tracefs_instance_reset()

 Documentation/libtracefs-instances-manage.txt |   7 +-
 Documentation/libtracefs.txt                  |   1 +
 include/tracefs-local.h                       |   1 +
 include/tracefs.h                             |   1 +
 src/tracefs-instance.c                        | 196 ++++++++++++++++++
 src/tracefs-utils.c                           |  20 ++
 utest/tracefs-utest.c                         | 183 ++++++++++++++++
 7 files changed, 407 insertions(+), 2 deletions(-)

-- 
2.39.2

