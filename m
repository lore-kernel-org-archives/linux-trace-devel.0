Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C86C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357729AbhLBMXQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhLBMXP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:23:15 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13261C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:19:53 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id e3so115310017edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4gbfBHE4g4rR4WSNfYIy4tVunmvm140sFeh2Ms3th0=;
        b=q3O1KQxJb9ykAt3hiWMLVpFCvtKenhG0XLN7CE+J6mhJTG3TnHIfYEUtdmnl11bH8d
         gdVdy3s8Rvc90F7hpMOUm1I012qZ0/i5B3Cg3WvY0SeLg1uqxwGLjZtQ2T4KrtIWjUHW
         ZUepkRKoZxXcfd65OolVVMEsRx67vksMrAxRKUkQ0voKfl9LzPHdUI9G0qriPoVL/cg6
         mJ+bPrmz0C+UoYw+aO99XHKF3G+dcqMrqFzCaATBclZ/JGQbFLsZcz20tdA/I0UVBPFC
         f8xdk2cE9yJBDGA8PlMHhgpdjUCxxPDphQ0mluPjcDWES23Ab8eCKKecQrdIuaQAFfsG
         2yJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4gbfBHE4g4rR4WSNfYIy4tVunmvm140sFeh2Ms3th0=;
        b=P5IX2loRzpHqeIF+oXlcC0pT8B1PUwn+chsrPPPUOCl8aqGp1AOXDqVJG7FqZXXq4U
         /QCe9XKGB/qJN3z38sHJ+uBX56hSqXmTKlpulZL3neUED1q7QiqDsWSndDjPWYqE9zT3
         gnKJ1e9M+LEBA8b6N+j24w/WNBTUvshwI0yvwBu0LBShBb0Jt5qDArJZZfMtVqD9QEqe
         tS4JHXeADJQJu0ALN90JPyQURvbNAoeAa2KAoXZEt4va/KYcPOF64dXFsxUjS9/092uK
         RxwRuxDXHdWQEoSQxtxwwWVlqYUnKdTnyA9/wOKtU6jb3eT2II+p4fr1eXq4l/j5nAV2
         SllA==
X-Gm-Message-State: AOAM53327dTan9CZmMA0EDUxzB7Kje9Xj9EbKxdLbC21OVOWvlENVbqQ
        rHAA0OkibhXWdrpjxzvx56++3Teu/e7UkQ==
X-Google-Smtp-Source: ABdhPJwweTywP9Qw7kIo8b1iRASCQ7SubLMr7pLE1TJbRnHqp8ZS65xvEri/UtTpltJ82Bd+TJItgg==
X-Received: by 2002:a17:906:e85:: with SMTP id p5mr14738647ejf.159.1638447591318;
        Thu, 02 Dec 2021 04:19:51 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm2229019eda.13.2021.12.02.04.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:19:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] Cleanups of tracecmd_output_ APIs
Date:   Thu,  2 Dec 2021 14:19:44 +0200
Message-Id: <20211202121949.43084-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Reduced the APIs for creating output handle to a trace file. Capsulated the
logic for creating the file inside the library. 

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd library: Fix typo in tracecmd_output_set_msg()
  trace-cmd library: New API for creating an output trace handle
  trace-cmd library: Rename tracecmd_output_allocate()
  trace-cmd library: Remove APIs for create and init output handle
  trace-cmd library: Make tracecmd_output_write_init static

 .../include/private/trace-cmd-private.h       |  6 +-
 lib/trace-cmd/trace-output.c                  | 86 ++++++++-----------
 tracecmd/trace-record.c                       | 14 ++-
 tracecmd/trace-restore.c                      | 16 ++--
 tracecmd/trace-stream.c                       |  3 +-
 5 files changed, 50 insertions(+), 75 deletions(-)

-- 
2.33.1

