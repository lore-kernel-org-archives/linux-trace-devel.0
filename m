Return-Path: <SRS0=pvIb=6I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521C5C54FCB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 13:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1829F20736
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 13:26:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNJ4PhrI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgDXN0O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbgDXN0O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 09:26:14 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41562C09B045
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 06:26:02 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id a21so7051895ljj.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 06:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HztWeIi6ksfi8RapQGabj+5liNr4Fa7k0pQzvFAMBJ8=;
        b=eNJ4PhrIvkklQ60DVkfTFObCmcB7NMUog58t9LtBaScS8iaEcsKAuVI3j6ZW9kOmaK
         T6Ex/D/HHN9Md5gGL4VdkpA6yna2tV+MVgmAHbZ8Pepj7viqbgqcLlGj9lew6gqJQG+5
         Wrn0k1fIGNdmAoDMoru6aVFbBp1mZ/uEfKOCPc+/tIihwDznP6DAi0fwISLX8EQlUzbD
         J6aPky2ROCksvTXv+wIxwnQbS/oxlPwOg9z/VPXNx7sXoIvv8bLVng9xT0DQwsGoaaiM
         M8IDzUHc2vMFm307xnOjLO1nfsHACn0PtdDD0JBWdqHCXyeNxSe27nzfRR+6xoWDQ4NI
         7G7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HztWeIi6ksfi8RapQGabj+5liNr4Fa7k0pQzvFAMBJ8=;
        b=s2cngKYzyUixEal64rZyigvav+GoJTYwQAFm+KTPeNrEo274PLKy/o04Q/UkrZT3Xb
         BzV7OgW/kJ69XjNhONoVQsdQKdgwlsrU7WTCfBrq5NS3RlkIrrJe7XXlvkw3Ja9QFxyl
         KuLwSDas+ki52SnVt3tB5AvwLCTkpLBK29Ee3bdX5kvi/wxq8DosOC7bxNxnYxmw2FGw
         RTekkQaTACT4KoPYXRJbkkqrAGskHmzTaISfQNMOhBcraS7BLwHtq7Pi7+8pYn0QlB3Q
         ZrDhbGr1PYuwesCHlNKkjBIl7aiPZFLq88CVXaroUqReY1gEsV/vH2/OZaphIWg4jL0z
         DDQw==
X-Gm-Message-State: AGi0PuZQIa4zjlYej9ScgH+rCI21QY7FF7mROErdblt3cFsaKL0i7CTd
        UtkejFlnbFomoUjmBvGKlL0=
X-Google-Smtp-Source: APiQypKSN6iK8ipwjURRnrFIOiz7JY3T5/nVW3dOjYWC1ZOjPTPnuy3oLTtpBRUch15HdlPMLlzeaQ==
X-Received: by 2002:a2e:8549:: with SMTP id u9mr5570393ljj.24.1587734760693;
        Fri, 24 Apr 2020 06:26:00 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.94])
        by smtp.gmail.com with ESMTPSA id p14sm4302287lfe.87.2020.04.24.06.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 06:26:00 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, julia.lawall@inria.fr,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/2] Command line options for selecting plots
Date:   Fri, 24 Apr 2020 16:25:40 +0300
Message-Id: <20200424132542.1620-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set implements new commandline options for KernelShark that
can be used to pre-select the CPU and Task plots to be shown, before
opening the GUI. The idea was suggested by Julia Lawall.


Yordan Karadzhov (VMware) (2):
  kernel-shark: Add methods for selecting the plots to be shown
  kernel-shark: Add command line options for selecting plots to be shown

 kernel-shark/src/KsGLWidget.cpp   |  6 ++---
 kernel-shark/src/KsMainWindow.cpp | 39 +++++++++++++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  4 ++++
 kernel-shark/src/KsUtils.cpp      | 24 +++++++++++++++++++
 kernel-shark/src/KsUtils.hpp      |  2 ++
 kernel-shark/src/kernelshark.cpp  | 32 ++++++++++++++++++++++---
 6 files changed, 101 insertions(+), 6 deletions(-)

-- 
2.20.1

