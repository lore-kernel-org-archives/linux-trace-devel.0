Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F6EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Mar 2022 09:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbiC1JFd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 05:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiC1JFd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 05:05:33 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7F06151
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 02:03:51 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id j15so27176649eje.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 02:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UW/1y/xrWUJQKyvvgFaORYexB4VSL3fYQ+errdjzYAE=;
        b=h/oSPkkwYpsU1F5t2JDV7ztGP1EVT+N3mdhYVNzvFmDL5QYMgv2Otk7uCCifpgoDyY
         fV/ybbV4XrPKl6Pk6NPR/1mrl1l11Oh9W9pLCc5P4+Zqxso3IgLxZUmskaiuTbfXP8cy
         8qB7OqW9u6/wyMROrOC01/I2CENoWWRX1dsQ48up7gEdkSUJKKZ0IyNDVBSnIZYvUbAS
         t/O2HW2wbQaj28DcE0g9WVwd/ShU57+No9GK9Q2MDKq7NQQZpmJNZJNGpXQJ+/e9+4OQ
         od3wN0Bwhd3Jp282fQkTz99BNFiC1QYt2aKLxrEux0Pc2Pw+QrBoJuTNXvF5mpwkqBNu
         nbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UW/1y/xrWUJQKyvvgFaORYexB4VSL3fYQ+errdjzYAE=;
        b=GRETPj9OqnjY9JonmCT2bE+5ljpHSzeQt1JL0WhEV1YqHYKRf+Lzh+iPkmV+3DiGrO
         2K21aejnQuqcIJViD9V0b/TLd7SzdKcIdMQHMgy9HUlK5m/XQ804fNFIR+aT7nF918v6
         8gKAKCyuk0vQpVIolMjzlMBbGWNtFR+fKSEulQDssMkghAO0X8KpmR/O9YL7RoBMQCIb
         6vMN7fz+NJFv8VbRlnoQZu2teTpNYvZcX6whKwmtaVInN1scrjO9kXznuyTDdCxNWDnP
         ktvvCxozCAYcF1ORuu8l+lJ6z0fwof/YXcFtnsfoQosBUGSRMIOayWsCcCCskOy7nNqw
         Hrvg==
X-Gm-Message-State: AOAM531wD9vTyr7u8RYet7P5oJ33XLO1mPhSMEcUyXsE8G+R7jlGlXYZ
        antV2TJedOLoWzU36+ZITte/oKOQMLQ=
X-Google-Smtp-Source: ABdhPJxXWOmOP4unsFS+FTDjK+AekNmpKq2ZNM+vW1xGFBMLB/yQ07JniYvlOkXws7dvECz1M597rA==
X-Received: by 2002:a17:907:8690:b0:6da:8436:2b94 with SMTP id qa16-20020a170907869000b006da84362b94mr26575749ejc.33.1648458230123;
        Mon, 28 Mar 2022 02:03:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dm11-20020a170907948b00b006cf488e72e3sm5647973ejc.25.2022.03.28.02.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 02:03:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] libtracefs: Uprobe APIs
Date:   Mon, 28 Mar 2022 12:03:44 +0300
Message-Id: <20220328090347.107849-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace uprobe is the only dynamic event with no corresponding library API.
Add new APIs for allocating uprobes.

Tzvetomir Stoyanov (VMware) (3):
  libtracefs: New APIs for ftrace uprobes
  libtracefs: Document uprobes APIs
  libtracefs: Unit tests for uprobes APIs

 Documentation/libtracefs-uprobes.txt | 188 +++++++++++++++++++++++++++
 include/tracefs.h                    |   6 +
 src/Makefile                         |   1 +
 src/tracefs-uprobes.c                |  90 +++++++++++++
 utest/tracefs-utest.c                |  74 +++++++++++
 5 files changed, 359 insertions(+)
 create mode 100644 Documentation/libtracefs-uprobes.txt
 create mode 100644 src/tracefs-uprobes.c

-- 
2.35.1

