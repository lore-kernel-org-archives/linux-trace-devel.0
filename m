Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFA6C46499
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1403E20828
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:11:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ma3pPMtF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfGEOLC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:11:02 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:55088 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEOLC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 10:11:02 -0400
Received: by mail-wm1-f54.google.com with SMTP id p74so5974541wme.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jul 2019 07:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ws5xUz5TI+TzSfAX0IHafyjymLBer0W8RL9aoynCK3E=;
        b=Ma3pPMtFEYJ2YdFDDaT6rDEt7CLPPkvqQwNGDwbkt2Oh4Mm0EgTQonVs4brGDPsmZc
         WS0nunKyn0QR5YP5KCWdr6FSjxFKdl7rWn5lfU3zBeX5Xbw+zfSndQNR+W/nJf7NmX1n
         Z+GuqSI9ciauEC1HindePMpkOnylGCWp8QsnjABjfxG0ua2x5JlxKRaCRCsv9WQVWNhN
         3Gn5FGVyTS8QACOiIKIdvEetC7bDtZY+F9T2af3yxxainp3GABKOEWQrq01pVN8aITDt
         RkytdQgPwDyda8NoTi3bDuktP5EjlC2TJgVj7p+nPIGEJIA47kDhngN7oWakUqvz2tmQ
         uUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ws5xUz5TI+TzSfAX0IHafyjymLBer0W8RL9aoynCK3E=;
        b=Dsaucfaur6tdVkFzufERwGDL0czFWW2aHCc5EvNcsebOJoO0aOi+BhrFFIutGxYqQx
         JP6O6yxxgpg9mB/wf+Hze7yD2VYFMWDaVKe6GascKkGnHt/g8BSftWEE8jsagK97Cqmk
         3HQ1udhymVM7y80yC56pI1yqdBr9cf1BhWfyJDAN8Oulu6/f0YbgyI7S0N41ATCdznZQ
         Zi0sZO+78eIKl3DdCJuCH+u/qhvYNPn+sDAPWRUWkHcHS02+aeIgkZj/PmdiSc4rTqON
         o7KYO+UZUDVLIwv7Rmo2P4CslVy0LK82PQbzLMI9knizD5+E9DxRw4og7DQjUXSqXn+1
         rTqw==
X-Gm-Message-State: APjAAAXv84ZEbKnS7NmrSuL5Ma/ouuq48airYBEsisgj9C0xgscMfOEB
        3Z5RVYbHMxf+HHAEipy88HIef4seLTw=
X-Google-Smtp-Source: APXvYqxZt/Dj10OGppopcLwVxgVEZyond+gDs/vBCd8VE86dHhTBkSdVRlhbKQW44O0P/H3pbrWD3A==
X-Received: by 2002:a1c:cb0a:: with SMTP id b10mr3688717wmg.41.1562335860446;
        Fri, 05 Jul 2019 07:11:00 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f192sm1893715wmg.30.2019.07.05.07.10.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 07:10:59 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/2] Fixes needed befor KS 1.0
Date:   Fri,  5 Jul 2019 17:10:29 +0300
Message-Id: <20190705141031.20239-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (2):
  kernel-shark: Line up the table of the loaded Advanced filters
  kernel-shark: Separate the target instalation instructions

 kernel-shark/src/CMakeLists.txt           | 6 +++++-
 kernel-shark/src/KsAdvFilteringDialog.cpp | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.20.1

