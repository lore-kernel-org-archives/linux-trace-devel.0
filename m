Return-Path: <SRS0=mM2H=U6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B32C0650E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 12:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B005C20B7C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 12:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="czCf8s2W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfGAMRp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 08:17:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51401 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfGAMRp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 08:17:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so15602333wma.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Jul 2019 05:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LXv5hoCzWonx66UzAg38JBZH1Hd4WAbCCkPMxV6obu8=;
        b=czCf8s2WcBFsNhu7MqTnHW83lgxxgpUUQnLfS+Aqzand/P+q3dsEUOYchAQ0F8af+N
         WlF5kHSMSvpYmHYpkdYyXXWoCzk+QrkTckclkoCCadNp1dDtkavGZQSiDpZLfOgsh6OJ
         ZcVUyGAozcItle5oGa1dNVYvJcFbtIPWjHU6G44l5a1JweVYoKFn0ZQQBP81zMoETxD1
         B/XQYaDSXMbfR0MI4/Ngc0Uiazmr2nCXDzehBdP9atX4jWLSzV/jrIg6WTRVsx8rYPNE
         gqQIgSTdIAh46C1mbgTlEIXUYbZc2Zd3m3NuOpAJ7f+/e8wlkVxnYgw9hAX7V5h4q+88
         c9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LXv5hoCzWonx66UzAg38JBZH1Hd4WAbCCkPMxV6obu8=;
        b=JWTxrx5TSp5kcPufadg0zPWr9WNLq8AiPFpq8dCbWQ0Oby2NISEiJGiaaT4dLiJfpo
         mToT7U54i+WHDZ0rD9e5+2FfazX6wKZeOOIwVwx9Nu3DAUM9xCcfpKF5irOgd7ZsK4I4
         T4Np6UzWCj3xR5iDQRH5Fu12rXXd6X0h305xgSAbThnX4DU3rgqy77wGKm8DEhB6sokI
         NJcm/aLKxKjnZIFxdO9ZSDLzF2bdzCnKBCIE231sCLF4mgp+c5Ns2cm2arT3l1kGSeQn
         IObFivoql6agspMVE0fC8rQ53QemvkW0mNLIespEa20pf0NhEV7G0EvsfDPc0iFhIsu8
         Edkw==
X-Gm-Message-State: APjAAAWKD6joG+SzVu0ElBVsju7vO8lXO8QsL5xRem5CHD1OZfaBYZxa
        C/+Ndt+H7MhEAbPf/lZmT0G1onwZD8s=
X-Google-Smtp-Source: APXvYqyajP0G71M6U1QJ3tn8A11bUAVFE9EVJkpzky3IuhC3vAOeh6y9wtxkE4lJErEpknoRl/xeQw==
X-Received: by 2002:a1c:1a88:: with SMTP id a130mr16890545wma.149.1561983463137;
        Mon, 01 Jul 2019 05:17:43 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g11sm8382520wru.24.2019.07.01.05.17.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 05:17:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH 0/3] Add support for text rendering
Date:   Mon,  1 Jul 2019 15:17:17 +0300
Message-Id: <20190701121720.18009-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Implemented using the single-file public domain library "stb_truetype":
https://github.com/nothings/stb/blob/master/stb_truetype.h

PS: Patch 1/3 is a simple fix suggested by Slavomir which strictly
speaking is independent from the other two patches.

Yordan Karadzhov (VMware) (3):
  kernel-shark: Simplify the drawing of the Triangle Fan
  kernel-shark: Add support for drawing text
  kernel-shark: Add text rendering to the plotting example

 kernel-shark/examples/dataplot.cpp |    8 +
 kernel-shark/src/libkshark-plot.c  |  164 +-
 kernel-shark/src/libkshark-plot.h  |   35 +
 kernel-shark/src/stb_truetype.h    | 4882 ++++++++++++++++++++++++++++
 4 files changed, 5076 insertions(+), 13 deletions(-)
 create mode 100644 kernel-shark/src/stb_truetype.h

-- 
2.20.1

