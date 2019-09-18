Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6122C4CEC4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8E882067B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:24:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tCaim+02"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbfIROYG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Sep 2019 10:24:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35112 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfIROYG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Sep 2019 10:24:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id y21so301078wmi.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Sep 2019 07:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QPpjjb3QKFzZTS0gXKOzhf6q2tk/DzL3e4cAQoXzq28=;
        b=tCaim+02MAow0IzaobU9tlrPYKZzHJnPBYZM9asXG2Fr0yngybsR8s1wFOfrU1uhF2
         xM+5/ZM9NTS37a6JiGl5jqoaaqy86JtlVgSgV4loWBorv4RZeimnY2C2niGoDAyWK3qJ
         saZuCzOKuJqwmiAdaoydJQz0yj3FrK+XeJVbx0ZcJvjJanP57CtMP+gOCqDep1NJq4I5
         4SeLH8zYFftrYvB5Oc1pbFyt6x0T8ccdGVgYK12oMSucTzxgwB683fLBatWEQ7W/tjc4
         g83nWpRsykU+8DR6MgNcIjzybw9Rm4Zzqub1kI7nbQEhprJV4KVmwrV2Vt5FTCUO9s/x
         mylQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QPpjjb3QKFzZTS0gXKOzhf6q2tk/DzL3e4cAQoXzq28=;
        b=tOI1+6FzV45CIARNaB3mm4W7LPVQPq0w86j7kym4XdPPS417LcMbDSah4+Jo4WndJP
         YdE3pBLG7nHxGGKcmIccZ1P3zGIIobnfa5ocrL2+cbt6ocveGOnARcMSPnYvE3ke7uh2
         ZLJNn9Ie9ZSLdtpBzgPxStfTChh7kDLUN+h3EQX70hSYoSCb5+aEixi+7zxpbEJ5chOc
         HZVzwQkvt5m8fqPKhpjePnRVzjSn8b1Vd3+1+Au32cZGdZrEU2LI8hpyG376Xtdk9FZ4
         gS/pvD6DstL8kpXcZVmSwuZEpKUVtpckbnSEtlJNMI4QJh1A8GNwDOzz/Onq9JRla2RT
         wZgg==
X-Gm-Message-State: APjAAAU7WFp6FJjSUV/wLabTDYPbRFxuCPfrQI2ACDxmzroDhSn7aNHK
        /QCqSgZuchOft68KkRTnFb+i+J+v
X-Google-Smtp-Source: APXvYqxgwO/ToxNbpehGXKRbwQlzFefyPTrgsLG0GbCanJ+6GQYoPEnZUZKOTYdniLFkMFx6Ho34FA==
X-Received: by 2002:a7b:c766:: with SMTP id x6mr3403762wmk.51.1568816644496;
        Wed, 18 Sep 2019 07:24:04 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a10sm7526251wrv.64.2019.09.18.07.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 07:24:03 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, stephen@brennan.io,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/3] Support "shell quoting" in the Record dialog
Date:   Wed, 18 Sep 2019 17:23:16 +0300
Message-Id: <20190918142319.11821-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A patch set implementing the improvements suggested here:
https://bugzilla.kernel.org/show_bug.cgi?id=204679

v2 changes:
  - Handling of multiple quotations and multi-line command arguments in
    patch 1/3.
  - Patches 2/3 and 3/3 are new.
  
Yordan Karadzhov (VMware) (3):
  kernel-shark: Provide parsing for quotation marks in Record command
    line
  kernel-shark: give more space to the command field of the Record
    dialog
  kernel-shark: Add quotation marks parsing example/test

 kernel-shark/examples/CMakeLists.txt |  4 +++
 kernel-shark/examples/cmd_split.cpp  | 52 ++++++++++++++++++++++++++++
 kernel-shark/src/KsCaptureDialog.cpp | 37 +++++++++++++++++---
 kernel-shark/src/KsCaptureDialog.hpp | 18 +++++++++-
 kernel-shark/src/KsUtils.cpp         | 41 ++++++++++++++++++++++
 kernel-shark/src/KsUtils.hpp         |  2 ++
 6 files changed, 148 insertions(+), 6 deletions(-)
 create mode 100644 kernel-shark/examples/cmd_split.cpp

-- 
2.20.1

