Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C7FC7618B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E135821901
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:51:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iRc/weyn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfGWMvy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 08:51:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39092 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732432AbfGWMvy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 08:51:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id u25so28033537wmc.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2019 05:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AsEJYJWNyMJ/oFzA/W2qQuknJbA7roq/9D9tF7MwPjE=;
        b=iRc/weynAcJGYkIaZtNboCD9kBlRslnftcKjWwIFMUNmKaqW568uE8tkw5FUAkBHxf
         SNRDl2KwgqPJv4oQNWEpH10UmGTGpPambpYmqQwcdAXfzlvfWGPU+O5gGj7DJOaqtKll
         waUFxet5VnW38cKddPGE6hrY30tRnlTseHtd0Ka1z60Y1SmxpopHI22DwbWIRRO+SVhE
         lZR6yNTC5KfcIh1WxNnUdHzptX3Snk88xFokVnJSGn1jiWNrmiDBlAKSUistmZ8DsnOc
         LMgpJANbh5JjoiPYUfzijFqT7fvI4peAo6hRJUmnlvXboNdy64zdSj9RlB6Np2/IAaTf
         BT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AsEJYJWNyMJ/oFzA/W2qQuknJbA7roq/9D9tF7MwPjE=;
        b=Fz/+Lucgw5lEqejHZURGhPTGdhrSlVFmtJGRc0Yfro/lqIrPALKatRzC+e3motLTpY
         f4K8fqUC6VsauESg9w1KPjopWI0IEX9QxcDrGZCqyk3bNjVxHq+1us44cQ8JWEOoLoRH
         dVJVyTB4Jp+nN8OCPigG0s+b17RGvXHcWL9tdvbhpn9gy/L2DD0uJIUPmCtEQPg/0yIC
         tvH/cDw1y/FxMo1xjBxhpL6mgFGe//3xT5Nlct6SDesJSLfIjFaM1cq604Godg1/7mNi
         JdNbIU1kLigZ33atR5ws6k3G5J1v+1Aur+Rj4s6b16jD1sZsJVHGM9krw9Owvc/YnDBl
         IBcQ==
X-Gm-Message-State: APjAAAXeYQvoAiqnQa0pvatTFyGAIDf5pt29tKIYPyTZYCnGDnjVaRrz
        bHwYn4IX3NbCKXVdeYdECYs=
X-Google-Smtp-Source: APXvYqxnn4YRD0pmiM6EXuQAaEROXnymUS2e67QFWKR/maNcH271KVXHPiwST7XzIynBmxD0wxpJxg==
X-Received: by 2002:a7b:c215:: with SMTP id x21mr69295445wmi.38.1563886312621;
        Tue, 23 Jul 2019 05:51:52 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id e19sm57423320wra.71.2019.07.23.05.51.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 05:51:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, howaboutsynergy@pm.me,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/3] Fixes needed befor KS 1.0
Date:   Tue, 23 Jul 2019 15:52:01 +0300
Message-Id: <20190723125204.22799-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adderssing the issues reported by "howaboutsynergy" here:

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204277

Yordan Karadzhov (VMware) (3):
  kernel-shark: Make KsEventsCheckBoxWidget::removeSystem more robust
  kernel-shark: Better error message for the constructor of
    KsCaptureControl
  kernel-shark: Disable Capture if trace-cmd can't function

 kernel-shark/src/KsCaptureDialog.cpp | 25 ++++++++++++++++++++++---
 kernel-shark/src/KsWidgetsLib.cpp    |  9 ++++++---
 2 files changed, 28 insertions(+), 6 deletions(-)

-- 
2.20.1

