Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6D8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jan 2022 18:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240342AbiA1SVQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jan 2022 13:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbiA1SVQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jan 2022 13:21:16 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39721C061714
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 10:21:15 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id f17so12514722wrx.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 10:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r9SO+KWA+M8CEmbTSIZaHHanMP3iH5baoJvllTdSBDU=;
        b=SezBTCJG3mOdQ/uVJnaSDRNz+75newrYLAwdrI6JqEiQETOSxrMQfN/dGKRInTgOcN
         KxQqpybAomKYMwKfpKxlw27oDQP+uJ68KFN28wig5B3+LKJ+KCSVGfE0XWqSBlwwJiqt
         WRo/1DRzYAZQ3EhpQj1lNWcAWq1yn8T0HD8FMzErw7EgDeMRTC+Exua7MSzU6dZng/f5
         LmXY2zMgsp6mQW8HEZx2nUNbK8DhM5/ZZLyu6lM7rv2RMYz+P+gM1kfiDA84XJjHJc5z
         +ujFVDInjb0L2PgGPr6YvcO5xRMpdwULC+FhrY4d0P0XR4N/L+5F1CaIQ061mZdvcnh1
         jhyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r9SO+KWA+M8CEmbTSIZaHHanMP3iH5baoJvllTdSBDU=;
        b=m7Ue2iTSzHb8uvqEO9A5EkSErzLYFGsBU+p0EuEpiR87JHx2Slm5NCxehoL8oVr2Bd
         ZE3uSq7r/yUzUkx4shAiOsB9EkC0rmhh5Zj02A7KkDEt/G5M97xO2O7RuUo9wRx2bXv2
         xzOZR4n+uxGnzzo2TRlQtBW3W0jL3/8z+29+vePM4ulxcLhADtAMHyOoqDlI6dkZ0SE8
         jV/MMsNPTsAFFB8mdz4/d+0r0m4RoP5iFc6/bXdcqRh5eNhv4Mhfn3Jqk08bEqggJ5e9
         IQPW12euzVu2xH3oxVSpev/ogJ4tRmMK90ASV+omQzquTHzIgRGbgXwqici5X1gQgW2V
         Y0Ig==
X-Gm-Message-State: AOAM532ALdjK9YW2vArNOaQDgn1lMmvBee+q8AkSVVCrOg5T5MbjDujZ
        wHXPtEgdOG+iMSQFBdUKft+L4DQj8nM=
X-Google-Smtp-Source: ABdhPJyB7A39TiMe2uAfUU1F9pOq+rP6bM0/NihcDKQq4TTcbsJb3ddmDeLvHWoQ9mhSpGUpW+vj5g==
X-Received: by 2002:a5d:584a:: with SMTP id i10mr8080138wrf.305.1643394073558;
        Fri, 28 Jan 2022 10:21:13 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id o14sm6220698wry.104.2022.01.28.10.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 10:21:13 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/2] SysCall tracing
Date:   Fri, 28 Jan 2022 20:21:00 +0200
Message-Id: <20220128182102.8672-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Now, when we have the necessary APIs for working with 'eprobes' and
'synthetic' events, we can combine the two and trace system calls.

Yordan Karadzhov (VMware) (2):
  trace-cruncher: Add (un)register methods for dynamic events
  trace-cruncher: Add example of tracing systemcalls

 examples/syscall_trace.py                     | 66 ++++++++++++++
 src/ftracepy-utils.c                          | 90 ++++++++++++++-----
 src/ftracepy-utils.h                          |  4 +
 src/ftracepy.c                                | 15 +++-
 tracecruncher/ft_utils.py                     |  2 +
 .../tests/1_unit/test_01_ftracepy_unit.py     |  7 +-
 6 files changed, 159 insertions(+), 25 deletions(-)
 create mode 100755 examples/syscall_trace.py

-- 
2.33.1

