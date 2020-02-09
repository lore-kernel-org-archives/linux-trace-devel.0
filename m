Return-Path: <SRS0=G/7s=35=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D49C2BA83
	for <linux-trace-devel@archiver.kernel.org>; Sun,  9 Feb 2020 03:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3911320820
	for <linux-trace-devel@archiver.kernel.org>; Sun,  9 Feb 2020 03:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qpLLQ+Db"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgBIDml (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 8 Feb 2020 22:42:41 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34129 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgBIDml (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 8 Feb 2020 22:42:41 -0500
Received: by mail-qt1-f195.google.com with SMTP id h12so2650486qtu.1
        for <linux-trace-devel@vger.kernel.org>; Sat, 08 Feb 2020 19:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=apjqy2QubtDM5jUE1XuGAc0LVbiX0+IbYiE4FOCB1Q0=;
        b=qpLLQ+DbA2DuFCEiwP7Axd9cVPVmd62Fnrp5OpURcckXvC5vNsw6PxX27svP2N3EsY
         X0g9fCcsadQ5uJjSkYO01bmTdDzZsUSHIdlJvehuPTcZXhrBCpdAPKBs8at3KGqYVReY
         Q4B+FGy3zQhohR2MtlVLf+bxZGLkKj0DXkftnVLSoZhIG3GBvrq05ozzS2PUZFwutcvS
         tXrUK614HcPf+qB/zPIs3JE3lMY/DsnGSnJvXoS0PF0xMqquLeG7j4wSljvcLVAVlYVj
         YQKatziYrwsLXK8q1jrDJw5L0Dcpmtv5UT723YtIhHwgN7Nm8MUXlwoqAURe6PncyHsY
         fRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=apjqy2QubtDM5jUE1XuGAc0LVbiX0+IbYiE4FOCB1Q0=;
        b=gqTwBX5kfWoHWwYsqHlPLTiyzyc2Kz4yxxfIIfrh4hH6/BGGwN6lRwB85d1RWa51wr
         XY/tiQ9z3sr5yZS4/E0ayhZcAzK9zhVfp8CxRFCZQcHEu464tXs6ynUEHE1lP38RBH9D
         Vry9CQ2IBSWLStTpSZm+ZKfHmAPreI0tpYyq98iRjN+JxDisPKv3fP0pffyF0wAiJ6Jv
         6llcBKz4Q7yRt6uYm8VWP7DRyilA14ikiPSqSrK4ytNY4lb0rW/sFZgxqoUOPtvM4/lt
         riIwnJkadSLHzJ7TZOAqN+eFPqcJwNKDCkgmjJjRStMkWKqTu01tpnWotBLf4olZg1IQ
         t3iQ==
X-Gm-Message-State: APjAAAXT9DDWrkyYATfsUcKa3LVHCqipqNg7kj5uVbU/MFA0fbXdCCZ9
        FAyEUy5RNZtnIcKP733cTOk=
X-Google-Smtp-Source: APXvYqzdzrByP7blzCrZ5xdWTj/NuOZivTQADxde4Ap34WwaBOIlE4OnBdGtf3LuJY1mtNUPzYiS0Q==
X-Received: by 2002:ac8:53c7:: with SMTP id c7mr3250938qtq.311.1581219760852;
        Sat, 08 Feb 2020 19:42:40 -0800 (PST)
Received: from i7.lan (whoami.aosc.io. [104.224.149.185])
        by smtp.gmail.com with ESMTPSA id g62sm3749947qkd.25.2020.02.08.19.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 19:42:40 -0800 (PST)
From:   sztsian@gmail.com
To:     tz.stoyanov@gmail.com, rostedt@goodmis.org
Cc:     sztsian@gmail.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/0] Two fixes for compiling
Date:   Sun,  9 Feb 2020 11:42:24 +0800
Message-Id: <20200209034226.287464-1-sztsian@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This contains two fixes of compiling.

The KernelShark one is to inherit libdir into kernelshark CMakeLists so
that the libdir parsed to Makefile is honored in kernelshark.

The trace-cmd one is to remove python-gui which depends on the obsoleted
gtk stuff.

In order to compile and test this change, the following patch from
Tzvetomir need to be applied.
[PATCH] kernel-shark: Fix search path for libtracefs
https://lore.kernel.org/linux-trace-devel/20200205070743.13836-1-tz.stoyanov@gmail.com/T/#u

Note: I always send email and git commits with signature "Zamir SUN"
before. However I see DCO requires to sign using real name, so I changed
to fulfill the DCO.


