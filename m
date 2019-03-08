Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85036C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6054220851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfCHRO3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:14:29 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45865 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbfCHRO3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:14:29 -0500
Received: by mail-wr1-f65.google.com with SMTP id o7so2067196wrp.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:14:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=22omjDEGl/gzjmEx4sGBG8cWgtZ469ytEFL62z1h4T0=;
        b=HaE9gY7LJIwGQHZsdUzgLH3q7iL3UQB49tQ5qcvxZASlMNrnCtncYnnlD8dSg5yR6y
         LX5Nx9auCmUM2eXi6WmPUrCIkzhWa+Bxg/jBFjytfi9JPwnIc5GVoMrTqGcIXqVyLnQo
         SkDb7DcK5OAzKSXNncZSe7ER8dpFQUm+ZXQI9mLMU7xCOhcHVc2w/i2NO4/B35UBLdgC
         OHNCEdgv09Cz14VmrkF8/9DO7TMLe8ZjFIY47SRyFRcssFLVZkNgXCIN1XDC4HJsaLON
         LAUZW+DFJZ6k04cxlEJ38xF87NQUP4K+YqLJHDQEGoPYru3MrYQmzuJHEzjccTfJUAgV
         TXFQ==
X-Gm-Message-State: APjAAAXPs11h/YRb3jObsOGiQNdaNwxnBemub0WE7u2gBU7ASlaE7sQH
        07KsfxcrtEjn94cxuVU2OTyRzlg5sbA=
X-Google-Smtp-Source: APXvYqy8Kue3692Rf4QLSJK7MeIFTBqIWVi0Kl3DkblqqPHckJoNXDkzg/x0rY2NF0+0gJf8ergXxA==
X-Received: by 2002:adf:f80c:: with SMTP id s12mr10026614wrp.150.1552065268101;
        Fri, 08 Mar 2019 09:14:28 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id o5sm6126796wmh.12.2019.03.08.09.14.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 09:14:27 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/4] Add dialog for loading user-defined plugins
Date:   Fri,  8 Mar 2019 19:14:01 +0200
Message-Id: <20190308171405.15266-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

So far loading user-defined plugins was possible only from the
command line

./kernelshark -p /path/to/your/plugin-lib.so

This patch set adds the possibility to load a plugin from the GUI
itself by using a dedicated dialog available in Tools


Yordan Karadzhov (4):
  kernel-shark: Define addPlugin method for KsPluginManager
  kernel-shark: Add dialog for user-defined plugin to the Tools menu
  kernel-shark: Rename the manu action for managing registered plugins
  kernel-shark: Add icons for "Add plugin" and "Manage plugins"

 kernel-shark/src/KsMainWindow.cpp | 32 ++++++++++++++++++++++++++-----
 kernel-shark/src/KsMainWindow.hpp |  6 +++++-
 kernel-shark/src/KsUtils.cpp      | 17 ++++++++++++++++
 kernel-shark/src/KsUtils.hpp      |  3 +++
 4 files changed, 52 insertions(+), 6 deletions(-)

-- 
2.19.1

