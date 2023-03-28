Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE062C761AF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 15:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbjC1PEp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 11:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbjC1PEo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 11:04:44 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C00E1B4
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:27 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ew6so50924040edb.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680015802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6BGEGp2ht0iCCKVGzR68+2oG2iQ2A196lCDyJUNAnh4=;
        b=EsNZS4J1Czslx6df4sjdlSKfSWDTwZSFJBFi6UtLSTBx/RdJzVTUeJ3zzHLIg8gHol
         rzx1tH/2WA3YawtX4THY0dbgQYKj6kCj6moddSX8imK3kpCRy1RBHCLQhLFnigGubyNj
         abUzsVEdHZAjjY3zPJPmWgwFy8i7mbifJcdYL0LJ0Tx+3cWKEZUgZq63teJeRJ7712f/
         SVNPsoD2hrqgQ9GXcJwqhOxOiIdR3nd2YVenFS6kq0TjX65GBj63kPpQxnLPyOJDGuCb
         MDvha7dIchllnuVxjzCjD33dUxy0XSG68BXsw0pSvGfOloT2+xRFHujTdL9uFbUGIISo
         TziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015803;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6BGEGp2ht0iCCKVGzR68+2oG2iQ2A196lCDyJUNAnh4=;
        b=eSylTgbSnJVpbyC/HuBOwENDDs4fWxtJfX/FpgglIjmIwYcFhufJbVFsEpUPpUVU8x
         cpE0wGUSB4NDH9Vsqsy/TJcx6jExUHG1rJVBU/f53KNUyqU9xFHMvc61AlF4zGXhG4XQ
         GGjaJBlg+tmJsbAqC2dFV5Qhkyq9CuJNdIm+KjtmjWiRI4PRbMhtovdVX7N4FxLf9ddu
         Cz/RzuOABlW9wn5UF2Pe9aMQedXYVzcMA7IM8Lvfq8Dpv0TrirtJKaPAmGSt+AvgIZWu
         EKUv1eMFG03phOvJhRb9qrjGe7K9wP8QCOipqwtW0L1NXvo/rQMwrg2Pnc5VlD4BamLS
         SX9w==
X-Gm-Message-State: AAQBX9fPZzGdMIWGbADUc3F9rr21fLDm5rq4+MgEbvNpDUBREZBHAK6T
        /oRbcOzKGae+WNuVsWyQ9bPtBsYmnxM=
X-Google-Smtp-Source: AKy350Zas2q1gLm5wDx0SDph4WbyTeoJYl/pX7qTThA9ylDi+Adb+XZMDSdDXM2pdHxw8RSd5tJxrw==
X-Received: by 2002:a17:907:9725:b0:93f:9594:d97d with SMTP id jg37-20020a170907972500b0093f9594d97dmr11692772ejc.14.1680015802647;
        Tue, 28 Mar 2023 08:03:22 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id q5-20020a50cc85000000b005024aff3bb5sm1440100edi.80.2023.03.28.08.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:03:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Introduce new API to set synthetic event instance
Date:   Tue, 28 Mar 2023 18:03:19 +0300
Message-Id: <20230328150321.34808-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API tracefs_synth_set_instance() to set the trace instance, where the
synthetic event is created - the trigger files of the start and end events.

Tzvetomir Stoyanov (VMware) (2):
  libtracefs: New API to set synthetic event instance
  libtracefs: Documentation for tracefs_synth_set_instance

 Documentation/libtracefs-synth2.txt | 15 +++++++++++----
 Documentation/libtracefs.txt        |  1 +
 include/tracefs.h                   |  1 +
 src/tracefs-hist.c                  | 19 +++++++++++++++++++
 4 files changed, 32 insertions(+), 4 deletions(-)

-- 
2.39.2

