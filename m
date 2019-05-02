Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDD6C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC7F52075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfEBMk2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:40:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34782 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEBMk2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:40:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id e9so3174916wrc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:40:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PwgDKaIaXsXBlqdKn+3P0Ap80x40NV6EXzHG2NUufuw=;
        b=YRm+h3ADH6DPwiPLE6/oyq9imnN+TPzGQjNVoGdZBQjPVNccrTZGvz+CKQqhvsac0g
         xjYMDJ4nWgFZfnUeqx/1G1HP8Cur+SQKohCTPRlnPQnWPQsfxnZSEQQpDp+ahi6RInhM
         /an1BjOHIlyIsoev8U44yNKwcvH5Cu1vdBP01cRHSAcQ2jqbm9Uyy3wpSTol60tqn0jo
         OtT/e0naTtoDS2rJnvPDPpNLf67i0ce0U7br0QanKrVacywbh6cGQNXgODtXIDt+5R7t
         MBAMIIAQ9pfCO6J9zOmJ/k1fyG3SGwVBO5pTzb/F06EZyGiwYe6gGiJEYoQOCmub/5X1
         ZO7g==
X-Gm-Message-State: APjAAAVd8lIt1H8mLpJWZ5GtYolZMLaY6N19dUQ23UiJlonIHZxcywa8
        0ZVBH1AL6xRuhYDHccW+fuyaA0lt
X-Google-Smtp-Source: APXvYqyx2uFqyGAsR6Yj+nEPP6hri52Eyhh2WfDAo2J1uIZb9TPLmnsUM8HMgYbHgewOMVklJD0t+A==
X-Received: by 2002:a5d:5108:: with SMTP id s8mr2416008wrt.99.1556800826804;
        Thu, 02 May 2019 05:40:26 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d11sm7511008wmb.39.2019.05.02.05.40.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:40:26 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 0/8] Modifications needed for KS 1.0
Date:   Thu,  2 May 2019 15:40:01 +0300
Message-Id: <20190502124009.32208-1-ykaradzhov@vmware.com>
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

Changes in v2:
 - Patches 6, 7 and 8 are new and are based on the suggestions made by
   Troy Engel in his review of v1.

Yordan Karadzhov (8):
  kernel-shark: Add INSTALL PREFIX to the Cmake-generated header file.
  kernel-shark: Add logic for the initial path of Open-File dialogs
  kernel-shark: Add logic for the plugins search path
  kernel-shark: Remove the definition of KS_DIR
  kernel-shark: Remember the paths used by the Open-File dialogs.
  kernel-shark: Add logic for selecting the trace-cmd executable used
  kernel-shark: Remove hard-coded install paths for libraries and
    plugins
  kernel-shark: Use XDG compliant path when saving cached data

 kernel-shark/CMakeLists.txt             |   7 +-
 kernel-shark/build/deff.h.cmake         |   7 +-
 kernel-shark/src/CMakeLists.txt         |  12 +-
 kernel-shark/src/KsCaptureDialog.cpp    |  41 +++---
 kernel-shark/src/KsCaptureDialog.hpp    |   2 +
 kernel-shark/src/KsMainWindow.cpp       |  87 ++++++-------
 kernel-shark/src/KsMainWindow.hpp       |   6 +-
 kernel-shark/src/KsUtils.cpp            | 161 ++++++++++++++++++++++--
 kernel-shark/src/KsUtils.hpp            |  21 ++++
 kernel-shark/src/plugins/CMakeLists.txt |   3 +-
 10 files changed, 255 insertions(+), 92 deletions(-)

-- 
2.20.1

