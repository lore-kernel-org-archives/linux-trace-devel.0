Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD98C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E3A261932
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhC2M61 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 08:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhC2M6Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 08:58:25 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD79EC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:24 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w18so14189314edc.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5OIgt2H2yNLDx9EGETExUxPby/QK79jMrfQyzj0fZ3g=;
        b=hoqcjyURhWqFXcNGuytAzrdGkdUTxhU3j9f/dOOti7bm8nq+3KNx7fbHzo+7mVWYxc
         +4q5pxzXAD+d14wTnpAIjOZPsnOG/nFP/CICO99w//C+DOvJor2B0LwDfl1tYKmdTdiM
         U3T/7zWM1/jK0oyg3TO8/n3YYsmNmuo61N4LRGcfIy5hN1KjUEc70BuiSAhfqaEOW8l6
         Xeeh8IZZ2HxSZEaJjnE/DGPIIJA58ExifiUsBQyUOtIumzOp97lqN81hMVuu9C2eNomD
         FHUwvTihweuwBmM6A4TZ0HiJt0fNX4N7KabDq1+nELH6dkap1/YO65C7MFgKfByGU9fJ
         gGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5OIgt2H2yNLDx9EGETExUxPby/QK79jMrfQyzj0fZ3g=;
        b=VcqMQ+DC+VD88areMnTaALY+iHnZPQYmoHxiSazvYkPDP6HZNBw0hY5inpKpmsUc0g
         RIiAia+CKtEvQ+bMd0a/2UiwP+0GEm3oCbVBoIkvNsG7jyGBMguRUWDf1B2wwjKXL9HJ
         Pu7hArg0/UXObLpYOV/ASwA0yRT0ViNx4Ol9LDyyHrN/XPgxnBeM3ZIahW9CFtdneRC+
         9kEpBrs3YYzE6cRKNPOLRwnJ6lMc0Sx23UXygphZeLGeH6gEPFg7pXgAikQ7W9kPHuoF
         /5N8NvPBr6uOOR185eD7w7Elt1tQd2dOAObP5HRwqoPuerQy/n1mvD5ZwoNXqj0XljwX
         PLCA==
X-Gm-Message-State: AOAM532DqbOpYjiht0pdD72wAIUU264rbveEFulbZx//6AGbX0lgC9wn
        +FwDoEuwqKr8tMNWWeZhHEZc5CjOZ9RpFw==
X-Google-Smtp-Source: ABdhPJwIVteps+PTGp3gZg3ZqqB0GbNOdOTiNMicQIQbdWoxmnx2nD6T/zj8fxabB+e+EKMMU2AeFg==
X-Received: by 2002:aa7:df86:: with SMTP id b6mr28416683edy.294.1617022703595;
        Mon, 29 Mar 2021 05:58:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d19sm8909075edr.45.2021.03.29.05.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 05:58:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] Documented new trace-cmd options
Date:   Mon, 29 Mar 2021 15:58:17 +0300
Message-Id: <20210329125821.97496-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented newly added trace-cmd options.
Extended trace-cmd list command to show new clock.

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Add internal API to check if tsc2nsec is supported
  trace-cmd: Add tsc2nsec clock to "list -C" command
  trace-cmd: Document --tsc2nsec option
  trace-cmd: Document --raw-ts option

 Documentation/trace-cmd/trace-cmd-record.1.txt |  5 +++++
 Documentation/trace-cmd/trace-cmd-report.1.txt |  3 +++
 tracecmd/include/trace-local.h                 |  2 ++
 tracecmd/trace-list.c                          | 16 +++++++++++++++-
 tracecmd/trace-record.c                        |  5 +++++
 tracecmd/trace-usage.c                         |  3 +++
 6 files changed, 33 insertions(+), 1 deletion(-)

-- 
2.30.2

