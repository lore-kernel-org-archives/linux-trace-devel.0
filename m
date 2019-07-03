Return-Path: <SRS0=Bo3z=VA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22F6C0650E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2611218A0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H6kqaVNq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfGCMKp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:10:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56317 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfGCMKp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:10:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so1946721wmj.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kJU0ySzYBsGop2UI3+fFAxAm5P7UbPVnh7nNyCtVx+M=;
        b=H6kqaVNqG8uGqqNvGo0/m4UG8BhvUFzuOhAgOqF/i8VVZ3upsIL43rLWQUXtLnDLOn
         vdAJwtUMiK77twARMjnvRfx9RmJw8I3xwJJT1kWsYhTPOysbQc1tFIBEvL8dWE+8kbtT
         NXr8Vvv7xti5qu83qWbv7zkNNTXU6NFduxA4BLNl10nsByDBNHZYQfN65f54Yy6Hh811
         acBCtA/Rtac5dTDiKPZughTIk88HJ5TMUYXoNibdoFxUXPzxAhBE2V/IPkfDRheuotU8
         COs5O6KzVe0t/Obwt29GtLRpHWDcwbyPsVZ16Uu3WTyhyQ0XlGs9aSYI/849ypJnJLDa
         S0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kJU0ySzYBsGop2UI3+fFAxAm5P7UbPVnh7nNyCtVx+M=;
        b=cez2hwUqh23lnGTrNsCV619J+HOT85JAFBVU7wb+wvmK3KARbYIQIIHLGuF0F9IYAu
         OcVkOx/pdIwN4zQHBj/Iuqzd6XSKjU53wcViwKONSb0vf2zEEynpdvIUqmlRMudRiwu1
         us/guL967UVSGr6elWx2OSjyuobshiTXQ52RGTCma0nSY9lqpDJpJTrzqVGilvIX13lD
         Kl+OCJzEnkaQACsdiHO/kiydsXbbmsX0+F3Lt78zYNL8nx640SER5ccn9/CYA5P9PQlP
         0mw6mbHvUMvPS5LNSYAEStS2eUi6WR+YMMEQCD7LmtpXQBH6RWLaKY/2S+h1BxrJdT4Z
         Lj+A==
X-Gm-Message-State: APjAAAVrRApTKbZ/jX+e4ON4qHN85u4XV/k7nDa2U5NmgSSBZy49495P
        9uUSYufttFOUE12iTbTnMvQ=
X-Google-Smtp-Source: APXvYqyKicaPsk6ledAkHT+QqTddWNoFFSYHf4QfmEfNoRLHcuNzLTGN2pdSKyKSuIpAgXs6AdV+MQ==
X-Received: by 2002:a7b:cbcb:: with SMTP id n11mr7632366wmi.146.1562155843556;
        Wed, 03 Jul 2019 05:10:43 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u18sm2321587wmd.19.2019.07.03.05.10.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 05:10:43 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH v2 0/5] Add support for text rendering
Date:   Wed,  3 Jul 2019 15:10:18 +0300
Message-Id: <20190703121023.16655-1-y.karadz@gmail.com>
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

v2 changes:
  - 2 new patches (patches 4/5 and 5/5).

  - Added a procedure for finding a font file (patch 2/5).

  - Addressed the comments made by Slavomir in his review of the previous
  version.

Yordan Karadzhov (VMware) (5):
  kernel-shark: Simplify the drawing of the Triangle Fan
  kernel-shark: Add support for drawing text
  kernel-shark: Add text rendering to the plotting example
  kernel-shark: Add hello_kernel plugin
  kernel-shark: Drop Freeglut as a compulsory dependency

 kernel-shark/build/deff.h.cmake      |    3 +
 kernel-shark/doc/dox_config          |    1 +
 kernel-shark/examples/CMakeLists.txt |   14 +-
 kernel-shark/examples/dataplot.cpp   |   11 +
 kernel-shark/examples/hello_kernel.c |   67 +
 kernel-shark/src/CMakeLists.txt      |    4 +-
 kernel-shark/src/KsGLWidget.cpp      |    4 -
 kernel-shark/src/KsPlotTools.cpp     |    4 -
 kernel-shark/src/libkshark-plot.c    |  239 +-
 kernel-shark/src/libkshark-plot.h    |   46 +
 kernel-shark/src/libkshark-plugin.h  |    3 +
 kernel-shark/src/stb_truetype.h      | 4882 ++++++++++++++++++++++++++
 12 files changed, 5243 insertions(+), 35 deletions(-)
 create mode 100644 kernel-shark/examples/hello_kernel.c
 create mode 100644 kernel-shark/src/stb_truetype.h

-- 
2.20.1

