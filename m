Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DF2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F0761007
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhD1HdA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhD1HdA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:33:00 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D934AC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:32:15 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ja3so17233955ejc.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=auXP1lvrrbkL2I2Ga1zKd7erCs0T10dfK+dGnBYXLkw=;
        b=bpC91NTXi8BJNheo/VbRgYeQfobspqSnB/yQgZ5zdKWa0w1Sp3ewSnJ++6A8Dm2r9q
         EcngZ2nfmM23Y788mYwf6I1Gs75jq5MKrUMjTqfwNLn4tar2+qJFIoV7ftQwBKBCDtJS
         P7Ad9F0l0nIvmR0S96iPmQoqizhWIgDjzellvx2mZn5uMzT/Jo2PeOW+av8Napyc4PQm
         HvVGedmMAEZYPTz6G82mgicneYQpdlZ4eqZWbbv8x0tRAb53ETfd31AcZWgh3m8kFjCW
         DFX712FFeCMobVDmsgk1XrhmT6AdXz8EobISUjF9oLW+VBJMBfqDLtejKGVMCuygUQ6n
         vuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=auXP1lvrrbkL2I2Ga1zKd7erCs0T10dfK+dGnBYXLkw=;
        b=AYof0AKCgFiy0mwSfzIt/LGYj4boh1z+tDdjt3Sf8Drwz42+hkvjXqQC2MsBs/RR+G
         bZ+SDugrtKezHfH6I+340Fd1SbBlx99bE3iLZZNwg1WSxJzFGAMqqCpSPznrjObpkKUs
         WFi7psiAnt4H4Af992FlakaFia810RiRa29f9zhoh6WxOvCWK2gSLNTEAYJnG7auYayr
         bDExhtE1xKvb0mY9xB7YJwH4MbWyDOWqDhzZcPrBxyoUJktj5Ww9FelXN+MkekIf2e0Q
         4agappgNSrGNoW1hSj/gJgryOkFK0DBIHAs2kCu4OBUtWu9PSnelXMRmd6/h3WdygqwZ
         yjJQ==
X-Gm-Message-State: AOAM530ZVngp8tCfY9Ri1+KPbSZh2NElN8sRFz5UtLfHXiMEBj7j5Cmm
        vi693pG2goVxfFGzmSXDKjLCnIECfTDluQ==
X-Google-Smtp-Source: ABdhPJyNxgUqufdHS+PTgmu4ssNwn4K+9is6A5VOgssi0Mi7rnjBYtQmg7zOAelup6tg0yJayosnjg==
X-Received: by 2002:a17:907:3589:: with SMTP id ao9mr5480291ejc.171.1619595134645;
        Wed, 28 Apr 2021 00:32:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z26sm1363646ejd.52.2021.04.28.00.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:32:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Add API to set severity to tracefs library logs
Date:   Wed, 28 Apr 2021 10:32:10 +0300
Message-Id: <20210428073212.756329-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API to set the desired log level of the library.

These changes depend on "[PATCH 0/4] Add severity to library logs"
https://lore.kernel.org/linux-trace-devel/20210428073001.755905-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (2):
  libtracefs: Add API to set the log level
  libtracefs: Document new log functionality

 Documentation/libtracefs-log.txt | 76 ++++++++++++++++++++++++++++++++
 Documentation/libtracefs.txt     |  2 +
 include/tracefs.h                |  4 ++
 src/tracefs-utils.c              | 18 +++++++-
 4 files changed, 99 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/libtracefs-log.txt

-- 
2.30.2

