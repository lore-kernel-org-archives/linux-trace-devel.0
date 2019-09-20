Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB374C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB732086A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VwAApKpF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403909AbfITK3N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:29:13 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:38499 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391072AbfITK3M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:29:12 -0400
Received: by mail-wr1-f43.google.com with SMTP id l11so6204407wrx.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NhU1z+L7ceZexQ6Y7QeA+F7a7qYchRpUtPh+QNb3ZFM=;
        b=VwAApKpFtFSDlz64bthfCPzULOXoQvpF+8v3voQoPl0nUth3kz4XAjTr8Auv8WcIoQ
         aUgCAILYU+nUs8qRjws5ur6ZYa0KQfHgBew7UnuocbFIkIbcj7eTQ7IcDiL79dPbZnuS
         HzYFOoqErX8nktOPn/o3MYbxNO0yxmSr2/030Q9p/gTq8P1yjkhFPe/74/Ai6W38kiY2
         E7uwUp+AgGSZfxDlJ0q3UWIdW0FoBmV2yil7412N39vVMBf7vMTeS1U2sikwuzW1Tywo
         52nFBV1EEjP7ZKgzO1evjs78mTPffErTIXjaJHjdEHvK7bez3CwYMsmC08SpaZmEe7U7
         QZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NhU1z+L7ceZexQ6Y7QeA+F7a7qYchRpUtPh+QNb3ZFM=;
        b=KfhlFj111XwqTI29O2/jWPb/pmrLGcKZ6cDRKOSiqyLI2IniJAZjEr5tWfeaTxnB1Z
         V3FwKZ1pwphUUE3UpxACcidq/CJpB1qcKWL5SHHS11T2q62bml6zrOPvDR4p8Et8yC8i
         6nqDgyqFyf8AwvumIA2tnIw7Qev2901Q4UYeTlOr73icXgC5oEBpz0ygxFUeIuyMkmuw
         XmprC5a9xotfIgoHRca8yD0o2atsYekj0kIPk6unvx+m5zFk5Tvdcl2ocC/ZgywQNvGI
         mYOg3N8pNSAM0jzuV/wdqefc+b+zqBCR0GmSG/hRuaZYng1H37x5TydXGI58QTYAFHB0
         7GOg==
X-Gm-Message-State: APjAAAXkQQHSme8rCeqKi8/dS+J73Lv3/qsJrZc62LYJa5f94xoS9LXM
        ayXiRDm6QeQWwuXDJHzSArle/LDZ
X-Google-Smtp-Source: APXvYqwCFoYpmtEKfiI+y074r8YAcUCv2PZ6/97eWliMjvO9SukNVAi8D+3fwp8RYHW2DA865krCuA==
X-Received: by 2002:a5d:49cb:: with SMTP id t11mr3797321wrs.158.1568975350972;
        Fri, 20 Sep 2019 03:29:10 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k26sm1480136wmj.33.2019.09.20.03.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 03:29:10 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 0/5] Handle the case when KernelShark is started as Root
Date:   Fri, 20 Sep 2019 13:28:47 +0300
Message-Id: <20190920102852.22769-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A patch set implementing the improvements suggested here:

https://bugzilla.kernel.org/show_bug.cgi?id=204475

Plus a minor improvements of the error messages printed when something
goes wrong withe the "Record" dialog.  

v2 changes:
  - Correcting typos in patch 1/5
  - Fixing a bug in patch 2/5. trace-cmd now gets correctly formatted list
  of command line arguments.
  - Patches 4/5 and 5/5 are new.

v3 changes:
  - Polishing the text of the warning/error messages in patches 1/5 and
  5/5. The modifications have been suggested by Steven.

Yordan Karadzhov (VMware) (5):
  kernel-shark: Show warning message when running as Root
  kernel-shark: Don't use pkexec when running as Root
  kernel-shark: Use standart error message in KsMainWindow::_record()
  kernel-shark: Optimize the error messages when "Record" fails to start
  kernel-shark: Better formatting of the error messages from "Record"

 kernel-shark/src/KsMainWindow.cpp | 90 +++++++++++++++++++++++--------
 kernel-shark/src/KsMainWindow.hpp |  4 ++
 2 files changed, 71 insertions(+), 23 deletions(-)

-- 
2.20.1

