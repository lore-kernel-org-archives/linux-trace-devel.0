Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99008C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 08:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiBPI3m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 03:29:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiBPI3l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 03:29:41 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F367629C13A
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 00:29:29 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id p14so2804723ejf.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 00:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CjmcWPDHuiC89LeOh/JYxrFN9ZvG7Y3jzz34cp8NoJI=;
        b=AA+5sHcxsOkzkDfuEr8ke8/z2zUw9HkkCvx4vLmTXRjYkHy8lGXTHxkwGkhWf0x4iT
         CnG++ssXqI5BtY5l4wyZBqqfMvarudm+FEJ+hF5xkxH7Q8ves7IHMXfeV6LwQI7SQwYn
         tUb4ngaF8XaogpCQxUaDc0wnivjS7KTmDXo8kEWY2dPWs8W2vqR16fLxaqpwZS4onv0J
         qHevOgvu9yHzOVpzFt/FXcx8LwMZBJSLNjXA6tFpHY7OcsDp3TYdvBNvE93VHXUDN09j
         efMwmAFxlJzFyUGMElyub1edlRC58TXvNNCCiSbYzl2cMKK0jL8tZKdPXu9EhXFVQE9J
         W2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CjmcWPDHuiC89LeOh/JYxrFN9ZvG7Y3jzz34cp8NoJI=;
        b=FqxZU6ZUOxhx/Xw4eDHHYyEOvo1oXeYCiobAjxZLUaXtd5RZ3c0+tQQyqGFGvKVBI+
         M0MaU917j5eAHK6c+a1JhI7vKpquUdwketxBoyoOdF3JAzvd1/8VC6HIMRXpDRwska3A
         iVPN6Jf5+exR/O/LpcpFuQnPVYs6mGKJ6jLYT7He2upIBh161z7hRgf8c1yJfziy7a5i
         c+r8pnjHDXUnaCspUhauolu1lIIZYNmYZXjTt1tFvwsewExqJNBSNFDb3+1s4q0aY4pS
         J7k7GW0ECNQ72lHqmAZhO65zD32pS5HhWlxOCPr5XYdxPuu54vfeUYNM8p3AmuJO1HkV
         eUxw==
X-Gm-Message-State: AOAM531TxNZB5neO8qYq3Yr6rcPaIgXFPWjlMNcXOqqPAjYNuDVQlIfn
        JZJ2HHjeXeKp1NEvM+sOI05Uu8j0ja8=
X-Google-Smtp-Source: ABdhPJzb+fI5OSb6lMY2p6uhZtt81elftF9fosoQEyVvqpwMGHretba+40DnLDVzcV2zOBp8v74MPg==
X-Received: by 2002:a17:906:8549:b0:69f:25ee:b38e with SMTP id h9-20020a170906854900b0069f25eeb38emr1350022ejy.443.1645000168142;
        Wed, 16 Feb 2022 00:29:28 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id v18sm2592998ejk.125.2022.02.16.00.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 00:29:27 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     hongzhan.chen@intel.com, jan.kiszka@siemens.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/2] kernel-shark: Fixes needed by the Xenomai plugin
Date:   Wed, 16 Feb 2022 10:29:07 +0200
Message-Id: <20220216082909.614231-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (2):
  kernel-shark: Add KsPluginsGUI.hpp/.cpp
  kernel-shark: Load 'ctrl' interface for user plugins

 src/CMakeLists.txt   |  5 +++++
 src/KsPluginsGUI.cpp | 27 +++++++++++++++++++++++++++
 src/KsPluginsGUI.hpp | 22 ++++++++++++++++++++++
 src/KsUtils.cpp      | 35 +++++++++++++++++++++++++----------
 src/KsUtils.hpp      |  2 ++
 5 files changed, 81 insertions(+), 10 deletions(-)
 create mode 100644 src/KsPluginsGUI.cpp
 create mode 100644 src/KsPluginsGUI.hpp

-- 
2.32.0

