Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8312C433FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 08:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9079021783
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 08:06:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hcwJz0V3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405395AbfHIIGi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 04:06:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37461 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfHIIGi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 04:06:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id b3so4983715wro.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Aug 2019 01:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QjPjtfpGa9vJnC5ZpCQIzKniDlaU+a7d035BTPbTwaQ=;
        b=hcwJz0V3jBwnJqbRL2asc7iUfJXX7KNkiqDwFSDDuoMFfbJRv/W3DLbd9mlIfUDIFM
         FaSN+L9Tq3t74Q3/XdPjS9eQmnMSbckvC7qobwmGX2JOzNTOFrM12sP5BvhrkMc/fnU3
         +aBw/VGLyRHntzAjgMSndwdXfHlFC/w5FBei3I0F2MkEn0r3nPmCSuSykVDq5m1C8Qh6
         kG/twum2ZDeVZTrKYbUUP35grwdOyRJt9VYJiuulLVgluiLVVYCADsdQV+0UAk4R5B2x
         5+LvRKhgRWSdeTDrZu4xxHKJUfwYCgD70NRjZFo7SgGFPwhcgUY1798e2qFYmGvI/BZ6
         VaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QjPjtfpGa9vJnC5ZpCQIzKniDlaU+a7d035BTPbTwaQ=;
        b=jL6qnEQobNtedZmdaUf3YKkP7fqPGS3vkUAy2GBg+J4m+njYYqI5y60eqawm/ZpMza
         ta0cHLpaomKdsExrJPR85qYEHIS8EWfzqNpSkog6j/TWm26y9Kjf4eNtjAFvVIOltLDD
         EfAIriK+XLeKin5Z8O+iIGnhCgLfKPlTWS6p1TrMjhamcxv2Y+NwosQxpl/au+Vo7eSI
         x8hD/aAHUbAqPQiT6MX9tN5uxcu29KQKhce7EwJXL+lzUMA37yHLwaan4eJJJDyqMQ6f
         MPap65JsvBieNCnZg0M0gchQEULGkIsfJOXck4gv7/I3TMkyQZ7iaPjzAi5H9Ry9ejwt
         GDzQ==
X-Gm-Message-State: APjAAAU2jS1kjWS9piMy9X43+SCazzzo1hBDGBtkz/TWP9MUmdwau2dQ
        bkKc5nGC1+o8XhziH9NzaXQ=
X-Google-Smtp-Source: APXvYqyHQN7LwBdneNZvjsHTbaTwfCViIH88+6OwgdrBh8uZ6TaRsBGHQ40Ro1I3xZetR54DXDlZ2A==
X-Received: by 2002:a5d:4cca:: with SMTP id c10mr21315967wrt.233.1565337996436;
        Fri, 09 Aug 2019 01:06:36 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q124sm6964302wma.33.2019.08.09.01.06.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 01:06:35 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/3] Handle the case when KernelShark is started as Root
Date:   Fri,  9 Aug 2019 11:06:20 +0300
Message-Id: <20190809080623.7548-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A patch set implementing the improvements suggested here:

https://bugzilla.kernel.org/show_bug.cgi?id=204475

Yordan Karadzhov (VMware) (3):
  kernel-shark: Show warning message when running as Root
  kernel-shark: Don't use pkexec when running as Root
  kernel-shark: Use standart error message in KsMainWindow::_record()

 kernel-shark/src/KsMainWindow.cpp | 73 ++++++++++++++++++++++++-------
 kernel-shark/src/KsMainWindow.hpp |  2 +
 2 files changed, 60 insertions(+), 15 deletions(-)

-- 
2.20.1

