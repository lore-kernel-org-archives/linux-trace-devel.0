Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535B5C31E40
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 05:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 286052147A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 05:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BwKRzZlW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbfHFF76 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 01:59:58 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38707 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFF76 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 01:59:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id z14so3743609pga.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Aug 2019 22:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f6t83IpzqQ8wV3A/FKAakyYRV5seE8bbEunzJxZ/3Ww=;
        b=BwKRzZlWOM0ffNuPdWesBMfrytz/B4DrVP+DE8XGTFXI+X5sGfSu54wO2CnkCoNxlN
         b8cxilSLSHwqiNl8AvbpDvrhjw0VmlUPCcKkuuw96Xhu+wu3bZjTKW5t9r41hrlnu3U1
         VXElrQgY+Q0C6KR/fMw9uaH0y8/l3qgmDBDfVZBtnYhoW6PML0qUO8iEwjD59dHYGKT3
         yICEnJGuIrk3PUkMqEv2iAEiBpzDdikTceGb8tbDoGGGQXaIsCOk8hH/2w5KjIJob2eV
         Qj1oQiOKxYSaNIRyX/egnP1IUlPDoPu9t8n0JAT868/3Z5pfqxcVuBjbLGnl3a2ubPaf
         InlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f6t83IpzqQ8wV3A/FKAakyYRV5seE8bbEunzJxZ/3Ww=;
        b=d9ewvthID71q22KTmSTQZrEPTE0wqe3S5sSBOzeQ5U6ulRTf6Zq5AbW7+YXYiIWNmw
         H1u6arv5iJaYECRrcChZHSf6bRT4UjBNpw+zbMDbHkyIP9Y1OZQyxr7MDYf3MccBzw4J
         jGm1I+G/VSfb/gD+CYZDyLspYfVSXv76cRgNb424gYdUWX9vNBL1CaZbSlN+RFShun5H
         0xf/0xPn1Pgahy1DAajC+B54WaITqYTCQxgqmFDonDbyXDFPMQmBJBvZl/PrH6LSMX1+
         Utjj8Mxym7Vb/UaQQwl5bNbPKRV2S5NIMwgzqx65uBVK9f+GY0z5D4qPZB6Yu/tmJfsC
         M/bg==
X-Gm-Message-State: APjAAAXLvLaoPRwCDc+xTN7xUBosgXQISI7NrxFpc1i1H5Gz6yejvAXr
        XQ68M1KvaktjCxNXKNaviqpQ1tNZ
X-Google-Smtp-Source: APXvYqzFdpTgksOPHjg4RPaororJG177wsxyz3Pd586pXEFx/G3vvCNXkBG8dlzrXQfwBs2ze8V7XQ==
X-Received: by 2002:a63:6d6:: with SMTP id 205mr1553113pgg.262.1565071197689;
        Mon, 05 Aug 2019 22:59:57 -0700 (PDT)
Received: from localhost.localdomain ([175.223.3.169])
        by smtp.gmail.com with ESMTPSA id ev3sm19934057pjb.3.2019.08.05.22.59.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 22:59:57 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 0/2] [RFC] several build fixes
Date:   Tue,  6 Aug 2019 14:59:48 +0900
Message-Id: <20190806055950.23842-1-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

	RFC

These patches fix v1.1.1 build on my system.

Sergey Senozhatsky (2):
  parse-event: rename filter_arg_boolean arg
  makefile: fix python SyntaxError

 Makefile       |  2 +-
 parse-events.h |  2 +-
 parse-filter.c | 32 ++++++++++++++++----------------
 3 files changed, 18 insertions(+), 18 deletions(-)

-- 
2.22.0

