Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBD5C07E99
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A7BA61004
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhGLMKQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 08:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhGLMKO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 08:10:14 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161E0C0613DD
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:07:25 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w14so15943352edc.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9uMiqwnd0zjp7/Ed/+z9qw/Nou0iiC6DmPRo+fHVeTc=;
        b=kCj80pPWRkaRjLpojDLc0U1xqdE248UCRHnWHURah5M+nqufFIAaLiNAUWun9mafAt
         AtuTPBQYmXGSVxsfsBaklT5zJLtR6Hp75h+ib3mWGGbM93XtbCIhP5wpKGw3FpiEy1d9
         jKRslPhTHjzZEGGzz2dl/qQs5Qwvs4ZLVZvhuG+kQGOsON0ua0Oxs5uvwQfUU8pDTiuG
         rcpCu7kJ2Ixe71Y+X+dgJ8evCFAWcdWQlxFhc1FAZV3VxbxI/CpFv5c//WSopFNacAi6
         6noabtSJmGBObGp8VzGSAMBdfJXCzpMvu95h85x91IUV1fhgO//ogeJmY+3QGGOTtZr3
         iELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9uMiqwnd0zjp7/Ed/+z9qw/Nou0iiC6DmPRo+fHVeTc=;
        b=KYGSYBVtAbPHF73OT60+uKP5C9BSYcgxLWY5ygFf5IUcNkj899iwpw/UEnjvQqwvOh
         l28YXM/DdB5ijNFUXDpKZjPhTzeRASgGbJWGgrUCapVFsm12KeqFzRF60bMI701gVoy4
         JxPg41vUi1jCIHZ7ISknKRh0ThnMfQ42zvtCzf4Fef1F/UF+Xp3xcdwflG3PYIdUvdJL
         1YSnbIY6npKiddjipQkhyuIWjisL+A7PDfQELtmUAI+LhNb+/vJ1TbB/QG5LE2YwufJP
         XLvU0j/3W20CJaJhat8gVjR/OI7H6aXpYoIGyTuN6B2hnDiDsnB2g7rKNwTfnW+DH2OG
         75hw==
X-Gm-Message-State: AOAM532PRz7lL6vRmyKe6jAivRYx1qLbQCSmG5f2cyjjd6ehX8GbHDqj
        f3I0g9nCXRGxeXPM3PvANF29jPSh0vQ=
X-Google-Smtp-Source: ABdhPJya0EP+3raHwRHWcB3pq9dqo22K5wEhy+1R9hjpOW8gLUVRUj83jFzztLYFLntk9YhF3xOOIg==
X-Received: by 2002:a05:6402:406:: with SMTP id q6mr64203573edv.149.1626091643285;
        Mon, 12 Jul 2021 05:07:23 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.98])
        by smtp.gmail.com with ESMTPSA id ee29sm2900809edb.39.2021.07.12.05.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:07:22 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/3] trace-cruncher: Add Kprobes
Date:   Mon, 12 Jul 2021 15:07:03 +0300
Message-Id: <20210712120706.221921-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This adds to trace-cruncher a basic support for Kprobes.

Changes in v2:
  - Fixed naming clash in ftracepy-utils
  - Fixed naming clash in tests

Yordan Karadzhov (VMware) (3):
  trace-cruncher: Add support for Kprobes
  trace-cruncher: Add events to utils
  trace-cruncher: Add Kprobe example

 examples/kprobe_open.py               |  44 ++++
 src/ftracepy-utils.c                  | 366 ++++++++++++++++++++++++--
 src/ftracepy-utils.h                  |  30 +++
 src/ftracepy.c                        |  55 ++++
 tests/1_unit/test_01_ftracepy_unit.py |  57 ++++
 tracecruncher/ft_utils.py             | 182 +++++++++++++
 6 files changed, 716 insertions(+), 18 deletions(-)
 create mode 100755 examples/kprobe_open.py

-- 
2.27.0

