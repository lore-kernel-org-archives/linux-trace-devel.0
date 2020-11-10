Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05EAC4742C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 588CE206E3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oyKRGYZ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgKJMWx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Nov 2020 07:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgKJMWx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:22:53 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6156CC0613CF
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:22:53 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id q3so12492204edr.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aeNC6ZK5ZqmTfb90sOApfhAKTUV1AAA8c4iODyIhIw0=;
        b=oyKRGYZ792tE7hCG2/Y0iB4om4Anuu8OS1/s15CdRlyfvFobTsT7Pjocy72mQCKpED
         ZdaYdSal+2wrNRHeDryXI5v81NIGo6GxV0ksVB/MX8EcW8uhhB7Dtw6g3NiGoSYfk7uZ
         wz/EtPxSdkyXIpctgCbzakfNutdwR3g+JGUtArIGeeXv6nPJV3yEt/YlQoih6o8Mvpek
         7KzR7+kR+9+Vp1GK0RQgiAYGFtF+xRYZBXjz18HegYgR/DEfRXP2rNK15JGBbPC6HOat
         vB7xwNTqo/j0lgYNG/CNDXb881mMTbq3qT4MLTdOuBG8RSOXfhkfnttOf+dWYWgWCJMI
         Sk/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aeNC6ZK5ZqmTfb90sOApfhAKTUV1AAA8c4iODyIhIw0=;
        b=KIwbo5c/yqO1GP8lEsw6jSzWK+hsr0XAYEuamTVMwKmj++687mZBLSgYHXqt1iYnTQ
         AhDfnXgXpx2buqPUIcWyoTFnszzI06YDRh+asx57YukR0Qz/1t+hn8ONXGzzQKgS1mht
         hTm/gmLK288Kwv3Of9V/rVNeYnJInaAY7pwzEG2Ba54gO4CHEr55ZDZbqwd0dt7w2jtV
         0hAemfEo5aSSg2qcWnHFgyTFN0wm+J9DQ7g9+3/zKZUd6EPPNVLV77R5KURIzVDQLyHo
         2C2DN8PMWetbRUKIDb3RXzy3a7S+wZQKZBOyqM0ZUFfSK0mqaWhgtIFqdLTRtk9bbEFL
         /AnQ==
X-Gm-Message-State: AOAM5322T7Bf2K1BiESnRzVdpVzXE1mHxAv1Fre7vn1VpxWG4nzaXeU6
        ffKRuspAg1F+d5VGJqEd2F94T63+0xObHQkv
X-Google-Smtp-Source: ABdhPJwDWfAy3DzlzC06q29jx1wfxYzzNGfhU4a6a+aL21YhOB1RN9Q/YbnzxZU80dmNrVyBsLyngg==
X-Received: by 2002:a05:6402:cb4:: with SMTP id cn20mr16659249edb.186.1605010972040;
        Tue, 10 Nov 2020 04:22:52 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h9sm10204156ejk.118.2020.11.10.04.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 04:22:51 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/6] libtracefs fixes and improvements
Date:   Tue, 10 Nov 2020 14:22:43 +0200
Message-Id: <20201110122249.911664-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A few final tracefs library fixes and improvements, before releasing it as
an official library.

v2 changes:
 - Change tracefs_instance_create() to return pointer to allocated trace
   instance structure
 - Add new API: tracefs_instance_is_new() to check if the trace instance is
   newly created by the library.

Tzvetomir Stoyanov (VMware) (6):
  trace-cmd: Change tracefs.h include path
  libtracefs: Change APIs to work with constant strings
  libtracefs: Add new API to check if instance exists
  libtracefs: Combine allocate and create APIs into one
  libtracefs: Add new tracefs API tracefs_instances_walk()
  trace-cmd: Add new libtrasefs API to get the current trace clock

 include/trace-cmd/trace-cmd.h       |   1 +
 include/tracefs/tracefs.h           |  18 +--
 lib/trace-cmd/trace-timesync.c      |   5 +-
 lib/tracefs/include/tracefs-local.h |   1 +
 lib/tracefs/tracefs-events.c        |  61 +++++-----
 lib/tracefs/tracefs-instance.c      | 172 +++++++++++++++++++++++++---
 tracecmd/include/trace-local.h      |   4 +-
 tracecmd/trace-record.c             |  72 ++++++------
 tracecmd/trace-show.c               |   2 +-
 tracecmd/trace-stat.c               |  83 ++++----------
 utest/tracefs-utest.c               | 127 ++++++++++++++++----
 11 files changed, 357 insertions(+), 189 deletions(-)

-- 
2.28.0

