Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98517C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44C8E61103
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhDBNUE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 09:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBNUE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 09:20:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F199C0613E6
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Apr 2021 06:20:03 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id b7so7445669ejv.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Apr 2021 06:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K77OhDLrrU6ee0dSiLVwz3cnXW9/qsZ7C2MN8wWonNE=;
        b=t1mE/U0zuRPYcVXlTx4E5xEbjvRexk6EhulMfVxofFmSEUnxAs4/AtE5p6Tcf7/IRu
         UiFHfybk4tiXTq6t7RO0Rk8t9GXKeRAHdmTbunH9AD0ABva3VOoRQq0kAjm6e+5+Mz7N
         g+0WgJinKgMViKJWcSHAQc4DFpOXwUXoZaN5MH6dJ7DGsBmv35dGYOvdnWfy8hLJ+EV0
         uaaK7rNsv+O1eKhr4mpNqzAKrMUehYvBMMODBSa8BdbroMaP7uu+KkDsGyL/7kyS+YpV
         dK+/dnSqAplddJh39beWUj4PdZH97pOCwTG/fM/dD5SGUn1cpFO78ggq7E3gOMamx7d3
         g4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K77OhDLrrU6ee0dSiLVwz3cnXW9/qsZ7C2MN8wWonNE=;
        b=GH4mQjoPZJhZAM4mDRyYBohiXuYbZNUBeYweLZ+4FGDDY/mVjF5AVt0yU/q5ibo2Lm
         7fZqm4NCbaOX+mIR/wEGOe66bwcsnYjTnXU3RxAlgJFTMmfN4O/OZN7l3hEK2kYzMO0s
         BqsCTVcubCpDkI9nHcC8K3pdnEnm/6uvigEVoYzo3pW1c7U6fbkpmnWjLLrz0/TdCkbC
         vVAVg64iefv/AEFh3MedSXjIi0k6anHUFT9Kn3iHxt0FQ4bFRy78JZVKivWD61zbTTIi
         ucuojHg6VwLpOVO5SQgZTmHLVu7bngzNHRYbnOrs56txmvbzszZzOZOUvtKKil/33tWP
         cldw==
X-Gm-Message-State: AOAM532FLz9xeEiCxUausz7h5JzYUMZyg3t5VWQh1ivHAWMFVR1hEPNe
        doG2WewnUYHWWinzv6jXbn8=
X-Google-Smtp-Source: ABdhPJx/1xNgCQnMxSiC1lKsU9u4bFCRStsKBxyfNUVzVj9IZB4y00OVL6ZhztMibRIRsCA+BYMSTg==
X-Received: by 2002:a17:906:8447:: with SMTP id e7mr14195953ejy.523.1617369601168;
        Fri, 02 Apr 2021 06:20:01 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id n3sm4120476ejj.113.2021.04.02.06.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 06:20:00 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/6] Refactor the APIs for tracing options
Date:   Fri,  2 Apr 2021 16:19:41 +0300
Message-Id: <20210402131947.346235-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (6):
  libtracefs: Fix issues with tracefs_option_id()
  libtracefs: Modify the arguments of tracefs_option_is_set()
  libtracefs: Encapsulate "struct tracefs_options_mask"
  libtracefs: Move the "options" code to  tracefs-instance.c
  libtracefs: Option's bit masks to be owned by the instance
  libtracefs: Rename tracefs_option_is_set()

 Documentation/libtracefs-option-get.txt |   4 +-
 include/tracefs.h                       |  15 +-
 src/tracefs-instance.c                  | 266 +++++++++++++++++++++++
 src/tracefs-tools.c                     | 276 ------------------------
 4 files changed, 273 insertions(+), 288 deletions(-)

-- 
2.27.0

