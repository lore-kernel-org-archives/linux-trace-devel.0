Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D335FC73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4453216C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PeLgvq93"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfGIP5Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:57:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40260 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIP5Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:57:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so3786636wmj.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c7l9Tc9XTL1NeJ5oED2GKot+/vk05HNw2gxRnLRgGk4=;
        b=PeLgvq93TNly4FuQJchc8THulxazWtqea1bQBRGHsDpIc0m27psPQklHTFQMPeCvZA
         bV7v7yZpdtmDnBMutfveKDVAdwN9t0jRH8+TdhRfO1qAO+ZSfjJDn0K8dhumgs/Iu9qC
         BRkq5Fh/JqRGkOLmYkaDhr1M2v+qKOFz4JGe8Nc+9uo6uTvB0wt3KGI17AxuJL32E2QX
         txDusA8LrY24Ew+vLx9L23qQQOOlcquLhH66z7MJ8UwdskdQDy1nTXjiGf1Dr16GstVO
         mxTsn1jsQoAiPVRxkIPs/MBPcAH6LjLJDqZtp53iRW3Rb+Pfo0QeVt3ia8bZ7ouvcHgt
         G2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c7l9Tc9XTL1NeJ5oED2GKot+/vk05HNw2gxRnLRgGk4=;
        b=fQS9Uz/qB6t0mXCSNuVdaGqZBIBJUxykt2lKA80cRCci9cuMvzoKE9oAHN02O3OiKs
         pgVizmEPWliLZR/C7VEMKd5E9sJUEFO0ymHK8OtuFRNo7aQDN0TWHocsZChTmOWKzzuD
         2P329Sfb1XFaLPFHn7CdMLIlW9mXYOj5dT1ESXrd1AjguYZAEJEXTdRSeFZZANemFJMv
         362JKadMk2VxNHiKPqg+Sy1Iozhu0B8pm0zZs0daazbj7YZ/QY7/i6NE02OSsIXiEgVX
         3T9Q3y718M0CCXW2H9ut6dQOCQcV9rH14JtRpd74DCozpU41WRw/FrEMhwxpC52tuGNr
         2wZw==
X-Gm-Message-State: APjAAAUKaByyjH3/11NrqIPelvemCii+wpRxfaPTA/JTuLJm9RHsgUFC
        iYYvQ89YMG/oANiPtkAHe9E=
X-Google-Smtp-Source: APXvYqx8ug/BhsCRbBuohUrVIrluPEm0tVMEtja0pOe478IeT7vLCYbZH359q38lOlCfd2f9/M3Nig==
X-Received: by 2002:a1c:6504:: with SMTP id z4mr572661wmb.172.1562687834262;
        Tue, 09 Jul 2019 08:57:14 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v5sm24313746wre.50.2019.07.09.08.57.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:57:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/8]Fixes needed befor KS 1.0
Date:   Tue,  9 Jul 2019 18:56:42 +0300
Message-Id: <20190709155650.2345-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Bug fixes and optimizations for the Capture dialog of KernelShark.

Yordan Karadzhov (VMware) (8):
  kernel-shark: Don't free the string field of KS_CONFIG_STRING document
  kernel-shark: Add method for getting all selected events
  kernel-shark: Optimize the command line options used by the capture
    dialog
  kernel-shark: Don't try to open data file if recording failed
  kernel-shark: Remove a duplicate error message
  kernel-shark: remove the "make install" suggestion for capture errors
  kernel-shark: Disconnect "capture errors" before closing KernelShark
    GUI
  kernel-shark: Less scary error message from Capture dialog

 kernel-shark/src/KsCaptureDialog.cpp  | 36 +++++++++++-----------
 kernel-shark/src/KsCaptureDialog.hpp  |  2 ++
 kernel-shark/src/KsMainWindow.cpp     | 43 ++++++++-------------------
 kernel-shark/src/KsMainWindow.hpp     |  2 ++
 kernel-shark/src/KsWidgetsLib.cpp     | 41 +++++++++++++++++++++++++
 kernel-shark/src/KsWidgetsLib.hpp     |  2 ++
 kernel-shark/src/libkshark-configio.c |  1 -
 7 files changed, 79 insertions(+), 48 deletions(-)

-- 
2.20.1

