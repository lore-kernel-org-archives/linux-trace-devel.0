Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA359C001DD
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jun 2023 09:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjFZJUP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 05:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjFZJTa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 05:19:30 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD755211B
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:16:54 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-98df69cacd1so117293566b.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687771013; x=1690363013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/wUpvZwm27ZpqdZyID38n7ouqHAluCTcRPmDriQZiU=;
        b=L17Fn7TVXz4AI5KN16I9FEVprWSy8XCnxS1RV6QcTlJZGy74hjvhmG9lEj2NnoftnM
         JwmBcQp9XX0QDgyj5ZHURVs3R0Wci7RC9I5dfW6QGRKMj0S1LDbKen03oZDdb0n1wowE
         H0/04TgPqfwb3UW0+FTt+BzWn9nWcKLADNnWH8wmBjtEwmE7DffvyXFPGXOXsSHSPrj7
         2JLeum8KcAwsbREvrSEGaFA8izq52KhLQPTmJdssnEvE41cMpcthrQ9ooHesCWkBqs0Y
         +Ggu03cmu4wU7Qfrlmd6wM0Xd2fDm70D60JFdxDXNrPE5CRHR/3VHYJMI1LR4oDP7bKd
         Yqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687771013; x=1690363013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/wUpvZwm27ZpqdZyID38n7ouqHAluCTcRPmDriQZiU=;
        b=W98XXUP2ZOYaZGez4+Gh0i3USarA+iqOLu112N9sUrl8+K/GTRWGC2P7FWckdz71kK
         h6WCfI6KcTz3ktm3YSnGLD9U+glZCaRo3niBO/PQg7GTF6uamyZJKW5zTDpfXPScenZo
         Lmf5HzI4vdrH6hCJNRU2OB7TxX1/kUyGa7gbmQbEY/YISmbjnNZprdPtr2isev95D0gz
         qF8V0wxZ56Dp+g71sWqAziLc+4ziWV0hiw5ZUoFR/q+NTSzG4YghgjGHICbkqAUfEJUa
         sBkSHptElMnGZqPN+G2fKfgWkKVJ4ZOwtnhp+4vH/wsC/tBG8D9CD2e744MwpN7R4Pjt
         rYcw==
X-Gm-Message-State: AC+VfDxpKTY5ebDnAFIBDVdONXVKnfdv5DPpWZ3AKxKXyr84/CGhSWrY
        jtoWjlqaSue27MXX1Jbvi85Zx9x1bS9AUQ==
X-Google-Smtp-Source: ACHHUZ537GnnX6p7DyAzB9cHGuOfMHZI1bRX8IlS25ZV+sV83zKGtG9TAncZ1DIZIHq1i+7hFysiqQ==
X-Received: by 2002:a17:907:a411:b0:991:7875:454c with SMTP id sg17-20020a170907a41100b009917875454cmr2280085ejc.1.1687771013021;
        Mon, 26 Jun 2023 02:16:53 -0700 (PDT)
Received: from dante731.cslcs.technion.ac.il ([132.68.206.91])
        by smtp.gmail.com with ESMTPSA id lc1-20020a170906f90100b00988e953a586sm3061414ejb.61.2023.06.26.02.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 02:16:52 -0700 (PDT)
From:   avidanborisov@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, avidanborisov@gmail.com
Subject: [PATCH v2 0/4] trace-cmd record: Improvements to --daemonize option
Date:   Mon, 26 Jun 2023 12:16:31 +0300
Message-Id: <20230626091635.3002827-1-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530045119.30c8d973@rorschach.local.home>
References: <20230530045119.30c8d973@rorschach.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Avidan Borisov <avidanborisov@gmail.com>

Hi Steven,

This is the second version of my patch series for adding the --daemonize option to trace-cmd record, incorporating your feedback.

Changes since v1:
- Replaced all instances of "he" with "the user".
- Fixed the issue with the `break` statement in the switch case.
- Added a usage example of --daemonize to the man page.

Let me know if there are any further changes required.

Thanks,
Avidan

Avidan Borisov (4):
  trace-cmd record: Add --daemonize
  trace-cmd: export pidfile functions from trace-listen.c
  trace-cmd record: Create a pidfile when using --daemonize
  trace-cmd record: Add --daemonize example to man page

 .../trace-cmd/trace-cmd-record.1.txt          |  33 ++++
 tracecmd/include/trace-local.h                |   4 +
 tracecmd/trace-listen.c                       |  32 ++--
 tracecmd/trace-record.c                       | 142 +++++++++++++++++-
 tracecmd/trace-usage.c                        |   3 +
 5 files changed, 194 insertions(+), 20 deletions(-)

-- 
2.25.1

