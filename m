Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F84C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71CC620685
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfDWN16 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:27:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36850 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfDWN16 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:27:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id h18so72455wml.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Apr 2019 06:27:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5xsusdCc44FO/TQ0Bik+Ownhfe7GA4PfHoepsf+exg=;
        b=TfnshMrqj/jGw2JH2VVeH8Vnj0DibRMJ8EuCYAEcVR0OnzimK59UMEb7ves8kpbPI5
         b6yLRDWh+ifG9OX6PufoMWqMP9Deu0jdqaO3i87TdSV1N/EW84G0YlCRY+qA9d/ktGKU
         if5cyQP9rufw5nMNUzBzrv2+zcbag6XEUgFPRAY7kF9XROnx+LPvff7rDy2z7sSadN+B
         L4iUXu/5xfdqN9qNX7m9Hso7Mafs2tSKKHsT7yZN7JTaX1kMMQ0fbFXShLj8NeXROUcA
         Zle4soVfLiZ+jUgYx8ZFVuuQ1DXguCNfQow1qZfuTKGT1ODQpOpAqr9/CAdN0Nmf3a4E
         NEuw==
X-Gm-Message-State: APjAAAUy5k2MR92a2n2dn7Wn8+RAHyB9yhbicA5IHT/o6wuQb1Ty+qyM
        UaQqL9WKGG6hEiLr2qlzga379O5f
X-Google-Smtp-Source: APXvYqxHAzqdOeW9W2SQiUGSayiyZbjEkBsfbYLBpjWIeaJBVl9juzIBdbe9+M2mfO92xb0oZlyTYw==
X-Received: by 2002:a05:600c:2118:: with SMTP id u24mr2346532wml.24.1556026076465;
        Tue, 23 Apr 2019 06:27:56 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w11sm31222231wre.15.2019.04.23.06.27.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 06:27:55 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/5] Modifications needed for KS 1.0
Date:   Tue, 23 Apr 2019 16:27:36 +0300
Message-Id: <20190423132741.17864-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains reimplementation (almost from scratch) of patches
that have been sent already. The aims is to optimize the workflow of the
user when running the application from its build (source code) location
or installation location.

Yordan Karadzhov (5):
  kernel-shark: Add INSTALL PREFIX to the Cmake-generated header file.
  kernel-shark: Add logic for the initial path of Open-File dialogs
  kernel-shark: Add logic for the plugins search path
  kernel-shark: Remove the definition of KS_DIR
  kernel-shark: Remember the paths used by the Open-File dialogs.

 kernel-shark/build/deff.h.cmake         |   4 +-
 kernel-shark/src/KsCaptureDialog.cpp    |  34 ++---
 kernel-shark/src/KsCaptureDialog.hpp    |   2 +
 kernel-shark/src/KsMainWindow.cpp       |  81 ++++++------
 kernel-shark/src/KsMainWindow.hpp       |   6 +-
 kernel-shark/src/KsUtils.cpp            | 161 ++++++++++++++++++++++--
 kernel-shark/src/KsUtils.hpp            |  19 +++
 kernel-shark/src/plugins/CMakeLists.txt |   2 +-
 8 files changed, 229 insertions(+), 80 deletions(-)

-- 
2.20.1

