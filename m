Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D77C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8985208C3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iS4TVBWX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408679AbfITKsh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:48:37 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:46721 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408704AbfITKsh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:48:37 -0400
Received: by mail-wr1-f41.google.com with SMTP id o18so6222588wrv.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9CXUDY3t2aCbqzO5+wDMayLiW8N+sflHNd7sVE0PA4=;
        b=iS4TVBWXPN5GFJHmzHbsqLzJkTrOKJICOXJ6T9duA6SbJoybNjLin6xYcPK1rIR0TH
         Z6HzegTSEFO+IYWq9ZpFgduATAuOmsYzBzVAm6DiQPiS4SJrgJw4L5osj7OBexwq1eeA
         BBL6edwPsb3KcWm+772oanV5CL4BKfC9CHiC9XAt2tw4cQOijijjDzGEs/g0I1tjjZ8n
         PZ8fs6Z5Nn3qZGQIhwMQZn4dUyPWWHLG4N6vkxZSGYZ9ANGsVykm8CVD5lGph73i/GjR
         7d10P4CSulgogDu1jPFfnWHHeMPVniDogjNnvr+ggjGDjb9/0S0YqLUi7pqg8lsUAlkz
         Hc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9CXUDY3t2aCbqzO5+wDMayLiW8N+sflHNd7sVE0PA4=;
        b=pJmYKFHWyh5U3xE/8bhV/EKpPTm0FxcfrDmSZsXnppPQIX7aYsITD8SvVECqRSKuZP
         eKMbg/kP8tOoCLcPdg7pKT9UChmIZsUeBHhWcEs57hSd9Xq6KMdKqCzC0k6vhhPpVGQK
         PUYco/5qgwxm/NfVGCW5jcyoDt3aHCPXvMpyc1EAzzLu7k4bhEh8++S/YwasI7vsgfrP
         +WfAJ9GpnfXfsdRM4n/HWSNXT06fpinF1Ns1Am+mYkMBZMTwGuTfzfZMo6241QN9voAp
         LY4QTJsRmmn7s841bLEajjJQP+FxPzHPGgGpBDa96sLvYPmPV0ABzNQe6v3M0wfMS+vv
         OLeA==
X-Gm-Message-State: APjAAAWV3WLj4hnVFqyMhi5COz5IfRXSMy+G6U5A/OZJZ/KVx8Lc0Za3
        WfY32vW5qS4ycMPNRc2ZYmKdIQyp
X-Google-Smtp-Source: APXvYqzQfF8ok5ORtoT85TpR3WLdfhMqmhNNlB04hkLRuLepQPoLMcwTaqR/rQjGUJUmo1udRN1PGQ==
X-Received: by 2002:a5d:6043:: with SMTP id j3mr11440564wrt.337.1568976515238;
        Fri, 20 Sep 2019 03:48:35 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t14sm1641978wrs.6.2019.09.20.03.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 03:48:34 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/4] Fixes needed for KS 1.1
Date:   Fri, 20 Sep 2019 13:48:27 +0300
Message-Id: <20190920104831.23475-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Yordan Karadzhov (VMware) (4):
  kernel-shark: Use correct order when linking all depenancies
  trace-cmd: Correct the install paths of traceevent and trace-cmd
    libraries
  kernel-shark: Fix the file paths used by Doxygen
  kernel-shark: Cleanup in KsCaptureDialog

 Makefile                                      |  8 +++----
 kernel-shark/Documentation/doxygen/dox_config |  4 ++--
 kernel-shark/src/CMakeLists.txt               | 16 +++++++-------
 kernel-shark/src/KsCaptureDialog.cpp          | 21 ++++++++++---------
 kernel-shark/src/KsCaptureDialog.hpp          |  2 --
 5 files changed, 25 insertions(+), 26 deletions(-)

-- 
2.20.1

