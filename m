Return-Path: <SRS0=5Z96=UG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3006C28CC3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C76F2208C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfFGJvI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 05:51:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46161 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfFGJvI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 05:51:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so1462595wrw.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Jun 2019 02:51:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zm6kjWxNkap/EWf7bfblRiL9QbyyFyr80H33fbaQl3k=;
        b=sgZbTAfd5QyU+DshvpAT+PDbnLgXcKAL0tnQi0wzxURz3bSIKdIAthf89Bif9tjNh+
         FxPyMm1vSdF8yeZMpqVthy8AwGtGTrSE18sfzHq3XVUgSdQt0ju5ISdNEl8T7kiB+rF+
         mCHlCLZECp45XGEPAI/30pX6IoMQ837CMHJlbcy0Fml/LBrbn/G68K3ijbv2UslNVuUI
         yl4fxtGzHSOMgIebcwstyMw3/M60Qszf3eMiS/jlxA2Eq3tvzT9KFaqYDtAEsEEPcQF5
         mvnLd00dc1l0tCJw5CQgiksixeJMy6G33MynYCSUUF8osUOi2PA6bOJGYYTM8Wz1JB6S
         vUhw==
X-Gm-Message-State: APjAAAUf9u+xAB1y14654B6+Ln5H3JGOXZEuWslEdvucIyAGANIiBquS
        0Gck4Zd4HHVsa5Nnc8wpXRc=
X-Google-Smtp-Source: APXvYqzXaQKfQUsu12clgb7d117CdHLDNZL7YfzFq/E3NyeZpJIAqIc8ddtmLZYYyKRVZYzuYKkiLA==
X-Received: by 2002:a5d:5302:: with SMTP id e2mr18832380wrv.347.1559901067132;
        Fri, 07 Jun 2019 02:51:07 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y5sm1606974wrs.63.2019.06.07.02.51.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 02:51:06 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        sstamenkova@vmware.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/3] New Logos and Icons for KernelShark
Date:   Fri,  7 Jun 2019 12:50:53 +0300
Message-Id: <20190607095056.14666-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

After having the KernelShark users voting for a new logo, the winner
is now introduced as an official logo of the project. We would like
to thank Stela Stamenkova (the designer of the logo) for her awesome
art work!

Yordan Karadzhov (3):
  kernel-shark: Add logo and icon files
  kernel-shark: Start using the new logo and icon
  kernel-shark: Delete the old test icon

 kernel-shark/CMakeLists.txt               |   6 +-
 kernel-shark/doc/dox_config               |   3 +-
 kernel-shark/icons/CC_BY-4.0              | 396 ++++++++++++++++++++++
 kernel-shark/icons/KS_icon_fin.svg        |   1 +
 kernel-shark/icons/KS_icon_shark.svg      |   1 +
 kernel-shark/icons/KS_logo_horizontal.svg |   1 +
 kernel-shark/icons/KS_logo_stacked.svg    |   1 +
 kernel-shark/icons/KS_logo_symbol.svg     |   1 +
 kernel-shark/icons/ksharkicon.png         | Bin 80474 -> 0 bytes
 kernel-shark/src/CMakeLists.txt           |   1 +
 10 files changed, 409 insertions(+), 2 deletions(-)
 create mode 100644 kernel-shark/icons/CC_BY-4.0
 create mode 100644 kernel-shark/icons/KS_icon_fin.svg
 create mode 100644 kernel-shark/icons/KS_icon_shark.svg
 create mode 100644 kernel-shark/icons/KS_logo_horizontal.svg
 create mode 100644 kernel-shark/icons/KS_logo_stacked.svg
 create mode 100644 kernel-shark/icons/KS_logo_symbol.svg
 delete mode 100644 kernel-shark/icons/ksharkicon.png

-- 
2.20.1

