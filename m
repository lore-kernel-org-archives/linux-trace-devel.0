Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200D8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Mar 2022 09:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbiCaJ50 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 05:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbiCaJ5Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 05:57:24 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55023DDD6
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:55:37 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id b19so32936790wrh.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ykUkoZ7bc0fHfZ6qta+t4ORJqStfOfgNtg7VDRpHHpc=;
        b=fBNmF/lGhQTpjIob1f6IBMAh7tuHXtGqzL2x3jLg4IAYI2pE2wFEro9FaAeD4X3605
         CSQ+adrWqpRx0VUIMFfGvQf0nVbEZUYaORfCB/EsrFm+qedJIRtsEHbkomvhm1uvoJPB
         RQZYKCMcDFVbVL8RisN2IDe6nQ9s8e6lxdTcOX51dDbB3eLNMx3v7HMTWXYm5/Rbws/F
         k5/Y02t15kvx5U9Uy56MVNPs1b+uyzZ21qllbvfxDvrbh37sJuWo8nbV7Tnh8mAWafZ1
         JQbYgXJN1ab6UGJw1vBKsmyR7xg/OCzpBEzUSAKHCynvotpSH52XHUpQpi85bEGx+jjd
         ATjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ykUkoZ7bc0fHfZ6qta+t4ORJqStfOfgNtg7VDRpHHpc=;
        b=g+mXlMJsWNVS+Q6RizKVxOjm62Ue3BMZDcQehnF6B/ljrXrCjJ8RORA0kad9FssWMg
         CeFqgysNjS2Egih+SZ7LOCwUfzd746Ltgp/tvqvsjHB0bzt9ghDRe6KCzNqxL3jadUsS
         YdHs/Er1dcPXtbg3kGkZrlnbfFUj5NtzSJhMEJyyPZ5bRdiS3j7Mf4y0vqMfL6iFdu89
         M080BmDKczhKgB+ULiAp9pzlkefGjQIFkA1FrDiNArpwfi1mJmAko0TU264ajv7ViFXi
         aZrJHy0px7o9dzaFtLq4jcBq8MZeRDQq8IvYvwTZGhbrDPtkJ0HKuJjK4f+gj3oOaedb
         OO2A==
X-Gm-Message-State: AOAM5318tK7fBhGxn89joGqHlYZsJ7bR/X9ruUpg6lj4G62k8IJMemVV
        p2YOeqTqZ0Fj2XAQ1m8W67iJID4wazw=
X-Google-Smtp-Source: ABdhPJwedEptb3pHGAtlSDV10vJ+tqOjSr+4pYMBj8rQvPlDYl3cdhF9uKNLOppuvbIab9aGFdC5oQ==
X-Received: by 2002:adf:eb4d:0:b0:1ed:c1f7:a951 with SMTP id u13-20020adfeb4d000000b001edc1f7a951mr3437186wrn.454.1648720536234;
        Thu, 31 Mar 2022 02:55:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm11807493wmq.27.2022.03.31.02.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 02:55:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH 0/4] trace-cruncher: ftrace uprobes support
Date:   Thu, 31 Mar 2022 12:55:29 +0300
Message-Id: <20220331095533.75289-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace uprobes can be used to create dynamic events for user functions.
Tracing user function can be very useful functionality for trace-cruncher.

The patch set depends on these libftrace changes, not yet accepted:
https://lore.kernel.org/linux-trace-devel/20220328090347.107849-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (4):
  trace-cruncher: Logic for resolving address to function name
  trace-cruncher: ftrace uprobe raw API
  trace-cruncher: High level wrappers for ftrace uprobes
  trace-cruncher: Example script for uprobes high level API

 examples/user_trace.py |  41 ++
 setup.py               |   4 +-
 src/ftracepy-utils.c   |  48 ++
 src/ftracepy-utils.h   |  21 +
 src/ftracepy.c         |  45 ++
 src/trace-obj-debug.c  | 978 +++++++++++++++++++++++++++++++++++++++++
 src/trace-obj-debug.h  |  53 +++
 src/utrace-utils.c     | 509 +++++++++++++++++++++
 8 files changed, 1697 insertions(+), 2 deletions(-)
 create mode 100755 examples/user_trace.py
 create mode 100644 src/trace-obj-debug.c
 create mode 100644 src/trace-obj-debug.h
 create mode 100644 src/utrace-utils.c

-- 
2.35.1

