Return-Path: <SRS0=wCVW=VV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACBAC7618B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6283722387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mogmrnXX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbfGXPkx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 11:40:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38028 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387394AbfGXPkx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 11:40:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so20698784wmj.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2019 08:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7wYMGOwJp6GEu1XFcAYx+9Q0Pv+EQ1OsBz3nRddIFE=;
        b=mogmrnXX3IVpVreMm1rx3Sw6fy2TxwNUdzc+A7IjNwsaHBBF5DpiIs72SoPcxlRq4N
         JS6zKwC9VAzKcRDRG7CaDvk6eTss2r+vhJsosdl+GO1uWIQ59yk4unJmdHiS8kaNrrIt
         7z/tyfFjd94Yww0AmiOtDMX0Abvbmj+1qEOdzlZ9cHUyRKTsd8xjatKdPUE+eQqqA3fs
         01KbstBxW8jY/wPw8066JKdVXu5Rihj4LoEMFJ7Hnw43dFzGW/WBy2EvOcXHzBc4Zt3e
         IqTZ7EvY7LzqsU6QGsnzY4NoZiJME1sz1ylxV7oi/8jIQFQXT6BCgFTdMukeTNv53vtd
         JzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7wYMGOwJp6GEu1XFcAYx+9Q0Pv+EQ1OsBz3nRddIFE=;
        b=BEhO5EGXgmGmTomT6eO3ZHFMnIfgBDksfPG0KfFtfIsWnq9sKMWvc8eiBgiA8xm/tY
         TtJ7fdgBKHomT8jHy3ae5/PbyBt/ZlKlnTVI7itNXyX93SXCc40nohkJi0+cyIaec/FW
         HEbr572qV0aqdldmTxne5XI87t/tvDmc6gX7CsqMx1KiKppAf39IRFrbMmYT3uJEQmbB
         f4mm/zrjqR9LSVVsr+sJS9+mYly4thBS0EjYgcPJF0nKdjuq0Xjs9lgVH0XQe+RM7OLb
         jmUkhshvPvcoFueHLK2MpevyMJGUJiOj1GM+n0edMc36t6lARFd0NlmBcNVEMSlwhRdm
         5RCg==
X-Gm-Message-State: APjAAAUZC8QRL/xuFDK3aTuginQYhqhCOaWnlPbiNCc7li8y6ZKnFl1R
        FEi7iIe457mKL9h3azcu/tU=
X-Google-Smtp-Source: APXvYqx3Sv5P84281GCrsD+Flw+JDe1VuA0eqkesyGL7vRXU61rHI9C1zxZ4cDvnP3BULxY0BHuIPA==
X-Received: by 2002:a7b:c251:: with SMTP id b17mr253086wmj.143.1563982850853;
        Wed, 24 Jul 2019 08:40:50 -0700 (PDT)
Received: from localhost.localdomain ([95.87.223.238])
        by smtp.gmail.com with ESMTPSA id a64sm45510570wmf.1.2019.07.24.08.40.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 08:40:50 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/3] Fixes for Capture needed befor KS 1.0
Date:   Wed, 24 Jul 2019 18:40:35 +0300
Message-Id: <20190724154039.23705-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adderssing the issues reported by Steven here:

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204287


Yordan Karadzhov (VMware) (3):
  kernel-shark: kshark_import_event_filter() tolerate non-existing
    events
  kernel-shark: Allow KsCaptureControl widget to print text to the
    console
  kernel-shark: Handle errors when loading Capture configurations

 kernel-shark/src/KsCaptureDialog.cpp  | 29 +++++++++++++++++++++----
 kernel-shark/src/KsCaptureDialog.hpp  |  6 ++++++
 kernel-shark/src/libkshark-configio.c | 31 ++++++++++++++++-----------
 kernel-shark/src/libkshark.h          |  8 +++----
 4 files changed, 53 insertions(+), 21 deletions(-)

-- 
2.20.1

